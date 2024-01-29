import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:core/device/model/device_model.dart';
import 'package:core/device/repository/device_repository.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor/model/config_model.dart';
import 'package:sponsor/repository/config_repository.dart';
import 'package:core/device/repository/dto/device_dto.dart';

abstract class TransactionDeviceRepository {
  Stream<Result<DeviceModel, Exception>> registerByAppleTransactionId(
      String transactionId);
}

class TanksteWebTransactionDeviceRepository
    extends TransactionDeviceRepository {
  static final TanksteWebTransactionDeviceRepository _instance =
      TanksteWebTransactionDeviceRepository._internal();

  late DeviceRepository _deviceRepository;
  late ConfigRepository _configRepository;

  factory TanksteWebTransactionDeviceRepository(
      DeviceRepository deviceRepository, ConfigRepository configRepository) {
    _instance._deviceRepository = deviceRepository;
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebTransactionDeviceRepository._internal();

  @override
  Stream<Result<DeviceModel, Exception>> registerByAppleTransactionId(
      String transactionId) {
    final StreamController<Result<DeviceModel, Exception>> streamController =
        StreamController.broadcast();

    _getByAppleTransactionIdAsync(transactionId).then((result) {
      return result.when((device) => _deviceRepository.update(device).first,
          (error) => Future.value(Result<DeviceModel, Exception>.error(error)));
    }).then((result) => streamController.add(result));

    return streamController.stream;
  }

  Future<Result<DeviceModel, Exception>> _getByAppleTransactionIdAsync(
      String transactionId) async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        return Result.error(configResult.tryGetError()!);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Uri url = Uri.parse(
          '${config.apiBaseUrl}//apple-payments/transactions/$transactionId/device');

      http.Response response = await http.get(url);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        DeviceDto deviceDto = DeviceDto.fromJson(jsonResponse);
        DeviceModel device = deviceDto.toModel();

        return Result.success(device);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
