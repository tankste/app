import 'dart:async';
import 'dart:convert';

import 'package:core/device/model/device_model.dart';
import 'package:core/device/repository/device_repository.dart';
import 'package:core/log/log.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:http/http.dart' as http;
import 'package:sponsor/model/apple_purchase_model.dart';
import 'package:sponsor/model/config_model.dart';
import 'package:sponsor/model/play_purchase_model.dart';
import 'package:sponsor/model/purchase_model.dart';
import 'package:sponsor/repository/config_repository.dart';
import 'package:sponsor/repository/dto/apple_purchase_dto.dart';
import 'package:sponsor/repository/dto/play_purchase_dto.dart';

abstract class PurchaseRepository {
  Stream<Result<void, Exception>> create(PurchaseModel purchase);
}

class TanksteWebPurchaseRepository extends PurchaseRepository {
  static final TanksteWebPurchaseRepository _instance =
      TanksteWebPurchaseRepository._internal();

  late ConfigRepository _configRepository;
  late DeviceRepository _deviceRepository;

  factory TanksteWebPurchaseRepository(
      ConfigRepository configRepository, DeviceRepository deviceRepository) {
    _instance._configRepository = configRepository;
    _instance._deviceRepository = deviceRepository;
    return _instance;
  }

  TanksteWebPurchaseRepository._internal();

  @override
  Stream<Result<PurchaseModel, Exception>> create(PurchaseModel purchase) {
    StreamController<Result<PurchaseModel, Exception>> streamController =
        StreamController.broadcast();

    _createAsync(purchase).then((result) => streamController.add(result));

    return streamController.stream;
  }

  Future<Result<PurchaseModel, Exception>> _createAsync(
      PurchaseModel purchase) async {
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

      Uri url = Uri.parse('${config.apiBaseUrl}/purchases');

      String body = "";
      if (purchase is PlayPurchaseModel) {
        body = jsonEncode(PlayPurchaseDto.fromModel(purchase, device.id));
      } else if (purchase is ApplePurchaseModel) {
        body = jsonEncode(ApplePurchaseDto.fromModel(purchase, device.id));
      } else {
        Exception error = Exception("Unsupported purchase type!");
        Log.exception(error);
        return Result.error(error);
      }

      http.Response response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        PurchaseModel? purchaseResult;
        if (purchase is PlayPurchaseModel) {
          PlayPurchaseDto playPurchaseDto =
              PlayPurchaseDto.fromJson(jsonResponse);
          purchaseResult = playPurchaseDto.toModel();
        } else if (purchase is ApplePurchaseModel) {
          ApplePurchaseDto applePurchaseDto =
              ApplePurchaseDto.fromJson(jsonResponse);
          purchaseResult = applePurchaseDto.toModel();
        } else {
          Exception error = Exception("Unsupported purchase type!");
          Log.exception(error);
          return Result.error(error);
        }

        return Result.success(purchaseResult);
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
}
