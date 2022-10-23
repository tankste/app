import 'package:flutter/material.dart';
import 'package:settings/theme/repository/theme_repository.dart';

abstract class GetThemeUseCase {
  Stream<ThemeMode> invoke();
}

class GetThemeUseCaseImpl extends GetThemeUseCase {
  final ThemeRepository _themeRepository;

  GetThemeUseCaseImpl(this._themeRepository);

  @override
  Stream<ThemeMode> invoke() {
    return _themeRepository.get();
  }
}
