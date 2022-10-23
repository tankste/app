import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/theme/repository/theme_repository.dart';
import 'package:settings/theme/usecase/get_theme_use_case.dart';
import 'package:tankste/app/cubit/app_state.dart';

class AppCubit extends Cubit<AppState> {
  final GetThemeUseCase getThemeUseCase =
      GetThemeUseCaseImpl(LocalThemeRepository());

  AppCubit() : super(AppState.loading()) {
    _fetchTheme();
  }

  void _fetchTheme() {
    emit(AppState.loading());

    getThemeUseCase.invoke().listen((theme) {
      emit(AppState.success(theme));
    }).onError((error) => emit(AppState.failure(error)));
  }
}