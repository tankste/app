import 'package:core/cubit/base_state.dart';
import 'package:flutter/material.dart';

class ThemeItemState extends BaseState {
  final String? designLabel;
  final ThemeMode? designValue;

  ThemeItemState(status, this.designValue, this.designLabel, error)
      : super(status, error);

  static ThemeItemState loading() {
    return ThemeItemState(Status.loading, null, null, null);
  }

  static ThemeItemState success(ThemeMode designValue, String designLabel) {
    return ThemeItemState(Status.success, designValue, designLabel, null);
  }

  static ThemeItemState failure(Exception exception) {
    return ThemeItemState(Status.failure, null, null, exception);
  }
}
