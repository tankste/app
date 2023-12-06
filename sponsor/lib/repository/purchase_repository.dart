import 'dart:async';
import 'dart:convert';

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

  factory TanksteWebPurchaseRepository(ConfigRepository configRepository) {
    _instance._configRepository = configRepository;
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
        return Result.error(configResult.tryGetError()!);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/purchases');

      String body = "";
      if (purchase is PlayPurchaseModel) {
        body = jsonEncode(PlayPurchaseDto.fromModel(purchase));
      } else if (purchase is ApplePurchaseModel) {
        body = jsonEncode(ApplePurchaseDto.fromModel(purchase));
      } else {
        return Result.error(Exception("Unsupported purchase type!"));
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
          return Result.error(Exception("Unsupported purchase type!"));
        }

        return Result.success(purchaseResult);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
