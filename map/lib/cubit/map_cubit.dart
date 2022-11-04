import 'package:core/config/config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/cubit/map_state.dart';
import 'package:map/usecase/get_map_provider_use_case.dart';
import 'package:settings/developer/repository/developer_settings_repository.dart';

class MapCubit extends Cubit<MapState> {
  final GetMapProviderUseCase getMapProviderUseCase = GetMapProviderUseCaseImpl(
      FileConfigRepository(), LocalDeveloperSettingsRepository());

  MapCubit() : super(MapState.loading()) {
    _fetchProvider();
  }

  void _fetchProvider() {
    emit(MapState.loading());

    getMapProviderUseCase.invoke().listen((mapProvider) {
      emit(MapState.success(mapProvider));
    }).onError((error) => emit(MapState.failure(error)));
  }
}
