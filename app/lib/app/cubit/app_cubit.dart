import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/repository/theme_repository.dart';
import 'package:tankste/app/cubit/app_state.dart';

class AppCubit extends Cubit<AppState> {
  final ThemeRepository themeRepository = LocalThemeRepository();

  AppCubit() : super(AppState.loading()) {
    _fetchTheme();
  }

  void _fetchTheme() {
    emit(AppState.loading());

    themeRepository.get().listen((theme) {
      if (isClosed) {
        return;
      }

      emit(AppState.success(theme));
    }).onError((error) => emit(AppState.failure(error)));
  }
}
