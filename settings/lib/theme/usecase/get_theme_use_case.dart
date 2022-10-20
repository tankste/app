import 'package:flutter/material.dart';
import 'package:settings/theme/repository/theme_repository.dart';

abstract class GetThemeUseCase {
  Future<ThemeMode> invoke();
}

class GetThemeUseCaseImpl extends GetThemeUseCase {
  final ThemeRepository _themeRepository;

  GetThemeUseCaseImpl(this._themeRepository);

  @override
  Future<ThemeMode> invoke() {
    return _themeRepository.get();
  }
}
