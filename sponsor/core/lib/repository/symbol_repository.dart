import 'dart:async';

import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SymbolRepository {
  Stream<bool> isEnabled();

  Future<Unit> set(bool isEnabled);
}

class LocalSymbolRepository extends SymbolRepository {
  static final LocalSymbolRepository _singleton =
      LocalSymbolRepository._internal();

  factory LocalSymbolRepository() {
    return _singleton;
  }

  LocalSymbolRepository._internal();

  final String keyEnabled = "sponsor_symbol_enabled";
  final StreamController<bool> _isEnabledStream = StreamController.broadcast();

  @override
  Stream<bool> isEnabled() {
    _refresh();
    return _isEnabledStream.stream;
  }

  Future<bool> _isEnabledAsync() {
    return _getPreferences()
        .then((preferences) => preferences.getBool(keyEnabled) ?? true);
  }

  @override
  Future<Unit> set(bool isEnabled) {
    return _getPreferences()
        .then((preferences) => preferences.setBool(keyEnabled, isEnabled))
        .then((_) => _refresh())
        .then((_) => unit);
  }

  void _refresh() {
    _isEnabledAsync().then((isEnabled) => _isEnabledStream.add(isEnabled));
  }

  // TODO: while `getInstance()` is asynchronous, we can't inject this without trouble.
  //   Find solution
  Future<SharedPreferences> _getPreferences() {
    return SharedPreferences.getInstance();
  }
}
