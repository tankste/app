import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeRepository {
  Stream<ThemeMode> get();

  Future<ThemeMode> set(ThemeMode theme);
}

class LocalThemeRepository extends ThemeRepository {
  static final LocalThemeRepository _singleton =
      LocalThemeRepository._internal();

  factory LocalThemeRepository() {
    return _singleton;
  }

  LocalThemeRepository._internal();

  final StreamController<ThemeMode> _themeStreamController =
      StreamController<ThemeMode>.broadcast();

  @override
  Stream<ThemeMode> get() {
    _fetchTheme();
    return _themeStreamController.stream;
  }

  @override
  Future<ThemeMode> set(ThemeMode theme) {
    return _getPreferences().then((preferences) {
      return preferences.setString("design", _getThemeModeKey(theme));
    }).then((_) => theme);
  }

  void _fetchTheme() {
    _getPreferences().then((preferences) {
      if (!preferences.containsKey("design")) {
        return null;
      }

      return preferences.getString("design");
    }).then((key) {
      switch (key) {
        case "light":
          return ThemeMode.light;
        case "dark":
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    }).then((theme) {
      _themeStreamController.add(theme);
    });
  }

  // TODO: while `getInstance()` is asynchronous, we can't inject this without trouble.
  //  Find solution
  Future<SharedPreferences> _getPreferences() {
    return SharedPreferences.getInstance();
  }

  String _getThemeModeKey(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return "light";
      case ThemeMode.dark:
        return "dark";
      default:
        return "system";
    }
  }
}
