import 'dart:io';

import 'package:core/config/config_repository.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:settings/model/map_provider_model.dart';
import 'package:settings/repository/map_provider_repository.dart';

abstract class GetMapProviderUseCase {
  Stream<Result<MapProvider, Exception>> invoke();
}

class DefaultGetMapProviderUseCase extends GetMapProviderUseCase {
  final MapProviderRepository _mapProviderRepository;
  final ConfigRepository _configRepository;

  DefaultGetMapProviderUseCase(
      this._mapProviderRepository, this._configRepository);

  @override
  Stream<Result<MapProvider, Exception>> invoke() {
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
            if (Platform.isIOS) {
              return Result.success(MapProvider.appleMaps);
            } else {
              return _configRepository.get().then((config) {
                if (config.useMapLibreMap) {
                  return Result.success(MapProvider.mapLibre);
                } else {
                  return Result.success(MapProvider.googleMaps);
                }
              });
            }
        }
      }, (error) => Result.error(error));
    });
  }
}
