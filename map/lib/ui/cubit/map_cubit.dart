import 'package:core/config/config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/di/map_module_factory.dart';
import 'package:map/ui/cubit/map_state.dart';
import 'package:map/usecase/get_map_provider_use_case.dart';
import 'package:rxdart/streams.dart';
import 'package:settings/model/map_provider_model.dart';

class MapCubit extends Cubit<MapState> {
  final GetMapProviderUseCase _getMapProviderUseCase =
      MapModuleFactory.createGetMapProviderUseCase();

  final ConfigRepository _configRepository = FileConfigRepository();

  MapCubit() : super(LoadingMapState()) {
    _fetchProvider();
  }

  void _fetchProvider() {
    emit(LoadingMapState());

    CombineLatestStream.combine2(
        _getMapProviderUseCase.invoke(), _configRepository.get().asStream(),
        (mapProviderResult, config) {
      return mapProviderResult.when((provider) {
        switch (provider) {
          case MapProvider.mapLibre:
            return MapLibreMapState(
                styleUrlLight: config.mapLibreStyleUrlLight,
                styleUrlDark: config.mapLibreStyleUrlDark);
          case MapProvider.googleMaps:
            return GoogleMapMapState();
          case MapProvider.appleMaps:
            return AppleMapsMapState();
          case MapProvider.system:
            return ErrorMapState(
                "Invalid map provider state. System can not be used on UI state.");
        }
      }, (error) => ErrorMapState(error.toString()));
    }).listen((state) {
      if (isClosed) {
        return;
      }

      emit(state);
    });
  }
}
