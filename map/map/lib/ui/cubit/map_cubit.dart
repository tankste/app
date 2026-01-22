import 'package:core/config/config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/di/map_module_factory.dart';
import 'package:map/model/map_provider_model.dart';
import 'package:map/repository/map_provider_repository.dart';
import 'package:map/ui/cubit/map_state.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:rxdart/rxdart.dart';

class MapCubit extends Cubit<MapState> {
  final MapProviderRepository _mapProviderRepository =
      MapModuleFactory.createMapProviderRepository();
  final ConfigRepository _configRepository = FileConfigRepository();

  MapCubit() : super(LoadingMapState()) {
    _fetchProvider();
  }

  void _fetchProvider() {
    emit(LoadingMapState());

    CombineLatestStream.combine2(
        _getCurrentMapProvider(), _configRepository.get().asStream(),
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

  Stream<Result<MapProvider, Exception>> _getCurrentMapProvider() {
    return _mapProviderRepository.get().asyncMap((mapProviderResult) {
      return mapProviderResult.when((mapProvider) {
        switch (mapProvider.provider) {
          case MapProvider.googleMaps:
            return Result.success(MapProvider.googleMaps);
          case MapProvider.mapLibre:
            return Result.success(MapProvider.mapLibre);
          case MapProvider.appleMaps:
            return Result.success(MapProvider.appleMaps);
          default:
            return _mapProviderRepository
                .getDefault()
                .then((p) => Result.success(p.provider));
        }
      }, (error) => Result.error(error));
    });
  }
}
