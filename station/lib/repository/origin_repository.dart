import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:station/model/config_model.dart';
import 'package:station/model/origin_model.dart';
import 'package:station/repository/config_repository.dart';
import 'package:station/repository/dto/origin_dto.dart';

abstract class OriginRepository {
  Stream<Result<List<OriginModel>, Exception>> list();

  Stream<Result<OriginModel, Exception>> get(int id);
}

class TanksteWebOriginRepository extends OriginRepository {
  static final TanksteWebOriginRepository _instance =
      TanksteWebOriginRepository._internal();

  late ConfigRepository _configRepository;

  factory TanksteWebOriginRepository(ConfigRepository configRepository) {
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebOriginRepository._internal();

  @override
  Stream<Result<List<OriginModel>, Exception>> list() {
    //TODO: cache stream
    return _listAsync().asStream();
  }

  Future<Result<List<OriginModel>, Exception>> _listAsync() async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        return Result.error(configResult.tryGetError()!);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/origins');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonResponse =
            json.decode(response.body) as List<dynamic>;

        List<OriginModel> origins = jsonResponse
            .map((e) => OriginDto.fromJson(e))
            .map((dto) => dto.toModel())
            .toList();

        return Result.success(origins);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<OriginModel, Exception>> get(int id) {
    //TODO: cache stream
    return _getAsync(id).asStream();
  }

  Future<Result<OriginModel, Exception>> _getAsync(int id) async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        return Result.error(configResult.tryGetError()!);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/origins/$id');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        OriginDto originDto = OriginDto.fromJson(jsonResponse);
        OriginModel origin = originDto.toModel();

        return Result.success(origin);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
