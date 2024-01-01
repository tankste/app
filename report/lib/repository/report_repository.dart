import 'dart:convert';

import 'package:core/device/model/device_model.dart';
import 'package:core/device/repository/device_repository.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:report/model/config_model.dart';
import 'package:report/model/report_model.dart';
import 'package:report/repository/config_repository.dart';
import 'package:http/http.dart' as http;
import 'package:report/repository/dto/report_dto.dart';

abstract class ReportRepository {
  Stream<Result<ReportModel, Exception>> create(ReportModel report);
}

class TanksteWebReportRepository implements ReportRepository {
  static final TanksteWebReportRepository _instance =
      TanksteWebReportRepository._internal();

  late DeviceRepository _deviceRepository;
  late ConfigRepository _configRepository;

  factory TanksteWebReportRepository(
      DeviceRepository deviceRepository, ConfigRepository configRepository) {
    _instance._deviceRepository = deviceRepository;
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebReportRepository._internal();

  @override
  Stream<Result<ReportModel, Exception>> create(ReportModel report) {
    return Stream.fromFuture(_createAsync(report));
  }

  Future<Result<ReportModel, Exception>> _createAsync(
      ReportModel report) async {
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

      Uri url = Uri.parse('${config.apiBaseUrl}/reports');
      String body = jsonEncode(
          ReportDto.fromModel(report, device.id));
      http.Response response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
      }); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        ReportDto reportDto = ReportDto.fromJson(jsonResponse);
        ReportModel report = reportDto.toModel();

        return Result.success(report);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
