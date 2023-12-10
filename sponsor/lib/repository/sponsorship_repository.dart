import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:core/device/model/device_model.dart';
import 'package:core/device/repository/device_repository.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor/model/config_model.dart';
import 'package:sponsor/model/sponsorship_model.dart';
import 'package:sponsor/repository/config_repository.dart';
import 'package:sponsor/repository/dto/sponsorship_dto.dart';

abstract class SponsorshipRepository {
  Stream<Result<SponsorshipModel, Exception>> get();
}

class TanksteWebSponsorshipRepository extends SponsorshipRepository {
  static final TanksteWebSponsorshipRepository _instance =
      TanksteWebSponsorshipRepository._internal();

  late DeviceRepository _deviceRepository;
  late ConfigRepository _configRepository;

  factory TanksteWebSponsorshipRepository(
      DeviceRepository deviceRepository, ConfigRepository configRepository) {
    _instance._deviceRepository = deviceRepository;
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebSponsorshipRepository._internal();

  final StreamController<Result<SponsorshipModel, Exception>>
      _getStreamController = StreamController.broadcast();

  @override
  Stream<Result<SponsorshipModel, Exception>> get() {
    _getAsync().then((result) => _getStreamController.add(result));

    return _getStreamController.stream;
  }

  Future<Result<SponsorshipModel, Exception>> _getAsync() async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        return Result.error(configResult.tryGetError()!);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Result<DeviceModel, Exception> deviceResult =
          await _deviceRepository.get().first;
      if (deviceResult.isError()) {
        return Result.error(deviceResult.tryGetError()!);
      }
      DeviceModel device = deviceResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/sponsorships/${device.id}');

      http.Response response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        SponsorshipDto sponsorshipDto = SponsorshipDto.fromJson(jsonResponse);
        SponsorshipModel sponsorship = sponsorshipDto.toModel();

        return Result.success(sponsorship);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
