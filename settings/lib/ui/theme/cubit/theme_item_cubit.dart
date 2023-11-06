import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/repository/theme_repository.dart';
import 'package:settings/ui/theme/cubit/theme_item_state.dart';
import 'package:settings/usecase/get_theme_use_case.dart';
import 'package:settings/usecase/update_theme_use_case.dart';

class ThemeItemCubit extends Cubit<ThemeItemState> {
  final GetThemeUseCase getThemeUseCase =
      GetThemeUseCaseImpl(LocalThemeRepository());

  final UpdateThemeUseCase updateThemeUseCase =
      UpdateThemeUseCaseImpl(LocalThemeRepository());

  ThemeItemCubit() : super(ThemeItemState.loading()) {
    _fetchTheme();
  }

  void _fetchTheme() {
    emit(ThemeItemState.loading());

    getThemeUseCase.invoke().listen((theme) {
      if (isClosed) {
        return;
      }
      
      String label;
      if (theme == ThemeMode.light) {
        label = "Hell";
      } else if (theme == ThemeMode.dark) {
        label = "Dunkel";
      } else {
        label = "Systemstandard";
      }

      emit(ThemeItemState.success(theme, label));
    }).onError((error) => emit(ThemeItemState.failure(error)));
  }

  void onThemeChanged(ThemeMode theme) {
    updateThemeUseCase.invoke(theme).then((_) => _fetchTheme());
  }
}
