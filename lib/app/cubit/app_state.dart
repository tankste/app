import 'package:core/cubit/base_state.dart';
import 'package:flutter/material.dart';

class AppState extends BaseState {
  final ThemeMode? theme;

  AppState(status, this.theme, error) : super(status, error);

  static AppState loading() {
    return AppState(Status.loading, null, null);
  }

  static AppState success(ThemeMode theme) {
    return AppState(Status.success, theme, null);
  }

  static AppState failure(Exception exception) {
    return AppState(Status.failure, null, exception);
  }
}
