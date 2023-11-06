import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/repository/theme_repository.dart';
import 'package:settings/ui/theme/cubit/theme_item_state.dart';

class ThemeItemCubit extends Cubit<ThemeItemState> {
  final ThemeRepository themeRepository = LocalThemeRepository();

  ThemeItemCubit() : super(ThemeItemState.loading()) {
    _fetchTheme();
  }

  void _fetchTheme() {
    emit(ThemeItemState.loading());

    themeRepository.get().listen((theme) {
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
    themeRepository.update(theme).then((_) => _fetchTheme());
  }
}
