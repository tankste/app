import 'package:core/config/config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/ui/cubit/map_state.dart';
import 'package:map/usecase/get_map_provider_use_case.dart';
import 'package:settings/repository/developer_settings_repository.dart';

class MapCubit extends Cubit<MapState> {
  final GetMapProviderUseCase getMapProviderUseCase = GetMapProviderUseCaseImpl(
      FileConfigRepository(), LocalDeveloperSettingsRepository());

  final ConfigRepository configRepository = FileConfigRepository();

  MapCubit() : super(LoadingMapState()) {
    _fetchProvider();
  }

  void _fetchProvider() {
    emit(LoadingMapState());

    getMapProviderUseCase.invoke().listen((mapProvider) {
      if (isClosed) {
        return;
      }

      switch (mapProvider) {
        case MapProvider.mapLibre:
          configRepository.get().then((config) {
            emit(MapLibreMapState(
                styleUrlLight: config.mapLibreStyleUrlLight,
                styleUrlDark: config.mapLibreStyleUrlDark));
          });
          break;
        case MapProvider.google:
          emit(GoogleMapMapState());
          break;
        case MapProvider.apple:
          emit(AppleMapsMapState());
          break;
      }
    }).onError((error) => emit(ErrorMapState(error.toString())));
  }
}
