import 'dart:convert';
import 'package:core/config/model/config_model.dart';
import 'package:flutter/services.dart';

abstract class ConfigRepository {

  Future<ConfigModel> get();
}

class FileConfigRepository extends ConfigRepository {

  @override
  Future<ConfigModel> get() async {
    final contents = await rootBundle.loadString('config.json');
    final jsonResponse = json.decode(contents) as Map<String, dynamic>;
    return ConfigModel.fromJson(jsonResponse);
  }
}