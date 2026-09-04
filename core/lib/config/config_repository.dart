import 'dart:convert';

import 'package:core/config/model/configuration_model.dart';
import 'package:flutter/services.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ConfigRepository {
  Future<Result<List<ConfigurationModel>, Exception>> getAllEntries();

  Stream<String> getStringValue(String key);

  Stream<bool> getBoolValue(String key);

  Future<Result<void, Exception>> updateValue(String key, String? value);
}

class FileConfigRepository extends ConfigRepository {
  static const String _overridePreferencesKeyPrefix = "configuration_";

  final Map<String, BehaviorSubject<String>> _stringSubjects = {};
  final Map<String, BehaviorSubject<bool>> _boolSubjects = {};

  @override
  Future<Result<List<ConfigurationModel>, Exception>> getAllEntries() async {
    try {
      final String contents = await rootBundle.loadString('config.json');
      final List<dynamic> jsonResponse = json.decode(contents) as List<dynamic>;
      Iterable<ConfigurationModel> items = jsonResponse.map(
        (item) => ConfigurationModel.fromJson(item),
      );
      Iterable<ConfigurationModel> valuedItems = await Future.wait(
        items.map((item) async {
          if (item.value is bool) {
            final bool? customValue = await _fetchCustomBoolValueAsync(
              item.key,
            );
            return item.copyWith(value: customValue ?? item.defaultValue);
          } else if (item.value is String) {
            final String? customValue = await _fetchCustomStringValueAsync(
              item.key,
            );
            return item.copyWith(value: customValue ?? item.defaultValue);
          }

          return item;
        }),
      );

      return Result.success(valuedItems.toList(growable: false));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<String> getStringValue(String key) {
    final subject = _stringSubjects.putIfAbsent(key, () {
      final subject = BehaviorSubject<String>();
      _fetchStringValueAsync(
        key,
      ).then(subject.add).catchError(subject.addError);
      return subject;
    });

    return subject.stream;
  }

  Future<String> _fetchStringValueAsync(String key) async {
    final customValue = await _fetchCustomStringValueAsync(key);
    if (customValue != null) {
      return customValue;
    }

    return _getDefaultString(key);
  }

  @override
  Stream<bool> getBoolValue(String key) {
    final subject = _boolSubjects.putIfAbsent(key, () {
      final subject = BehaviorSubject<bool>();
      _fetchBoolValueAsync(key).then(subject.add).catchError(subject.addError);
      return subject;
    });

    return subject.stream;
  }

  Future<bool> _fetchBoolValueAsync(String key) async {
    final customValue = await _fetchCustomBoolValueAsync(key);
    if (customValue != null) {
      return customValue;
    }

    return _getDefaultBool(key);
  }

  @override
  Future<Result<void, Exception>> updateValue(String key, String? value) async {
    try {
      //TODO(fabi755): add support for booleans and other types
      final String defaultValue = await _getDefaultString(key);
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      if (value != null && value.isNotEmpty && value != defaultValue) {
        await preferences.setString(_getPreferencesKeyFor(key), value);
      } else {
        await preferences.remove(_getPreferencesKeyFor(key));
      }

      final stringSubject = _stringSubjects[key];
      if (stringSubject != null) {
        stringSubject.add(await _fetchStringValueAsync(key));
      }

      //TODO: not needed because booleans not supported yet.
      // final boolSubject = _boolSubjects[key];
      // if (boolSubject != null) {
      //   boolSubject.add(await _loadBoolValue(key));
      // }
      return Result.success(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<String> _getDefaultString(String key) async {
    final items = (await getAllEntries()).getOrThrow();
    for (ConfigurationModel item in items) {
      if (item.key == key) {
        return item.defaultValue as String;
      }
    }

    throw Exception("No config item found for key '$key'.");
  }

  Future<bool> _getDefaultBool(String key) async {
    final items = (await getAllEntries()).getOrThrow();
    for (ConfigurationModel item in items) {
      if (item.key == key) {
        return item.defaultValue as bool;
      }
    }

    throw Exception("No config item found for key '$key'.");
  }

  Future<String?> _fetchCustomStringValueAsync(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_getPreferencesKeyFor(key));
  }

  Future<bool?> _fetchCustomBoolValueAsync(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_getPreferencesKeyFor(key));
  }

  String _getPreferencesKeyFor(String key) {
    return "$_overridePreferencesKeyPrefix$key";
  }
}
