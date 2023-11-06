import 'package:flutter/material.dart';
import 'package:settings/repository/theme_repository.dart';

abstract class UpdateThemeUseCase {
  Future<void> invoke(ThemeMode theme);
}

class UpdateThemeUseCaseImpl extends UpdateThemeUseCase {
  final ThemeRepository _themeRepository;

  UpdateThemeUseCaseImpl(this._themeRepository);

  @override
  Future<void> invoke(ThemeMode theme) {
    return _themeRepository.update(theme);
  }
}
