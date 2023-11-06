import 'dart:io';

import 'package:core/config/config_repository.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';

abstract class GetMapProviderUseCase {
  Stream<MapProvider> invoke();
}

class GetMapProviderUseCaseImpl extends GetMapProviderUseCase {
  final ConfigRepository _configRepository;
  final DeveloperSettingsRepository _developerSettingsRepository;

  GetMapProviderUseCaseImpl(
      this._configRepository, this._developerSettingsRepository);

  @override
  Stream<MapProvider> invoke() {
    return _developerSettingsRepository.get().asyncMap((settings) {
      switch (settings.mapProvider) {
        case DeveloperSettingsMapProvider.google:
          return MapProvider.google;
        case DeveloperSettingsMapProvider.openStreet:
          return MapProvider.openStreet;
        case DeveloperSettingsMapProvider.apple:
          return MapProvider.apple;
        default:
          if (Platform.isIOS) {
            return MapProvider.apple;
          } else {
            return _configRepository.get().then((config) {
              if (config.useOpenStreetMap) {
                return MapProvider.openStreet;
              } else {
                return MapProvider.google;
              }
            });
          }
      }
    });
  }
}

enum MapProvider { google, openStreet, apple }
