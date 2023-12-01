import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor/model/balance_model.dart';
import 'package:sponsor/model/config_model.dart';
import 'package:sponsor/repository/config_repository.dart';
import 'package:sponsor/repository/dto/balance_dto.dart';

abstract class BalanceRepository {
  Stream<Result<BalanceModel, Exception>> get();
}

class TanksteWebBalanceRepository extends BalanceRepository {
  static final TanksteWebBalanceRepository _instance =
      TanksteWebBalanceRepository._internal();

  late ConfigRepository _configRepository;

  factory TanksteWebBalanceRepository(ConfigRepository configRepository) {
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebBalanceRepository._internal();

  @override
  Stream<Result<BalanceModel, Exception>> get() {
    //TODO: cache stream
    return _getAsync().asStream();
  }

  Future<Result<BalanceModel, Exception>> _getAsync() async {
    try {
      Result<ConfigModel, Exception> configResult =
      await _configRepository.get().first;
      if (configResult.isError()) {
        return Result.error(configResult.tryGetError()!);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/balance');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        BalanceDto balanceDto = BalanceDto.fromJson(jsonResponse);
        BalanceModel balance = balanceDto.toModel();

        return Result.success(balance);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
