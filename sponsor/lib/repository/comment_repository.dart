import 'dart:async';
import 'dart:convert';
import 'package:core/device/model/device_model.dart';
import 'package:core/device/repository/device_repository.dart';
import 'package:core/log/log.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor/model/comment_model.dart';
import 'package:sponsor/model/config_model.dart';
import 'package:sponsor/repository/config_repository.dart';
import 'package:sponsor/repository/dto/comment_dto.dart';

abstract class CommentRepository {
  Stream<Result<List<CommentModel>, Exception>> list();

  Stream<Result<CommentModel, Exception>> getOwn();

  Stream<Result<CommentModel, Exception>> update(CommentModel comment);
}

class TanksteWebCommentRepository extends CommentRepository {
  static final TanksteWebCommentRepository _instance =
      TanksteWebCommentRepository._internal();

  late DeviceRepository _deviceRepository;
  late ConfigRepository _configRepository;

  factory TanksteWebCommentRepository(
      DeviceRepository deviceRepository, ConfigRepository configRepository) {
    _instance._deviceRepository = deviceRepository;
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebCommentRepository._internal();

  final StreamController<Result<List<CommentModel>, Exception>>
      _listStreamController = StreamController.broadcast();

  final StreamController<Result<CommentModel, Exception>> _getStreamController =
      StreamController.broadcast();

  @override
  Stream<Result<List<CommentModel>, Exception>> list() {
    _listAsync().then((result) => _listStreamController.add(result));

    return _listStreamController.stream;
  }

  Future<Result<List<CommentModel>, Exception>> _listAsync() async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        Exception error = configResult.tryGetError()!;
        Log.exception(error);
        return Result.error(error);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/comments');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonResponse = json.decode(response.body) as List<dynamic>;
        final comments = jsonResponse
            .map((i) => CommentDto.fromJson(i))
            .map((dto) => dto.toModel())
            .toList();

        return Result.success(comments);
      } else {
        Exception error = Exception("API Error!\n\n${response.body}");
        Log.exception(error);
        return Result.error(error);
      }
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  @override
  Stream<Result<CommentModel, Exception>> getOwn() {
    _getOwnAsync().then((result) => _getStreamController.add(result));

    return _getStreamController.stream;
  }

  Future<Result<CommentModel, Exception>> _getOwnAsync() async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        Exception error = configResult.tryGetError()!;
        Log.exception(error);
        return Result.error(error);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Result<DeviceModel, Exception> deviceResult =
          await _deviceRepository.get().first;
      if (deviceResult.isError()) {
        Exception error = deviceResult.tryGetError()!;
        Log.exception(error);
        return Result.error(error);
      }
      DeviceModel device = deviceResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/comments/${device.id}');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        CommentDto commentDto = CommentDto.fromJson(jsonResponse);
        CommentModel comment = commentDto.toModel();

        return Result.success(comment);
      } else {
        Exception error = Exception("API Error!\n\n${response.body}");
        Log.exception(error);
        return Result.error(error);
      }
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  @override
  Stream<Result<CommentModel, Exception>> update(CommentModel comment) {
    final StreamController<Result<CommentModel, Exception>> streamController =
        StreamController.broadcast();

    _updateAsync(comment)
        .then((result) => streamController.add(result))
        .then((_) => getOwn())
        .then((_) => list());

    return streamController.stream;
  }

  Future<Result<CommentModel, Exception>> _updateAsync(
      CommentModel comment) async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        Exception error = configResult.tryGetError()!;
        Log.exception(error);
        return Result.error(error);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Result<DeviceModel, Exception> deviceResult =
          await _deviceRepository.get().first;
      if (deviceResult.isError()) {
        Exception error = deviceResult.tryGetError()!;
        Log.exception(error);
        return Result.error(error);
      }
      DeviceModel device = deviceResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/comments/${device.id}');
      String body = jsonEncode(CommentDto.fromModel(comment));
      http.Response response = await http.put(url, body: body, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final commentDto = CommentDto.fromJson(jsonResponse);
        final CommentModel comment = commentDto.toModel();

        return Result.success(comment);
      } else {
        Exception error = Exception("API Error!\n\n${response.body}");
        Log.exception(error);
        return Result.error(error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
