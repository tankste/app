import 'dart:async';
import 'dart:io';

import 'package:multiple_result/multiple_result.dart';
import 'package:settings/model/map_provider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

abstract class MapProviderRepository {
  Stream<Result<List<MapProviderModel>, Exception>> listAvailable();

  Stream<Result<MapProviderModel, Exception>> get();

  Stream<Result<MapProviderModel, Exception>> update(
      MapProviderModel mapProvider);
}

class LocalMapProviderRepository extends MapProviderRepository {
  static final LocalMapProviderRepository _singleton =
      LocalMapProviderRepository._internal();

  factory LocalMapProviderRepository() {
    return _singleton;
  }

  LocalMapProviderRepository._internal();

  final MapProviderModel _sytemProvider =
      MapProviderModel("Systemstandard", MapProvider.system);

  final StreamController<Result<List<MapProviderModel>, Exception>>
      _listAvailableStreamController = StreamController.broadcast();

  final StreamController<Result<MapProviderModel, Exception>>
      _getStreamController = StreamController.broadcast();

  @override
  Stream<Result<List<MapProviderModel>, Exception>> listAvailable() {
    _listAvailableAsync()
        .then((value) => _listAvailableStreamController.add(value));
    return _listAvailableStreamController.stream;
  }

  Future<Result<List<MapProviderModel>, Exception>>
      _listAvailableAsync() async {
    try {
      List<MapProviderModel> availableProviders = [];

      availableProviders.add(_sytemProvider);
      availableProviders
          .add(MapProviderModel("MapLibre", MapProvider.mapLibre));

      //TODO: does Google Maps runs everywhere? (Android without Play Services, iOS without extra apps)
      //  If not, we should validate this before showing this option
      availableProviders
          .add(MapProviderModel("Google Maps", MapProvider.googleMaps));

      if (Platform.isIOS) {
        availableProviders
            .add(MapProviderModel("Apple Maps", MapProvider.appleMaps));
      }

      return Result.success(availableProviders);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<MapProviderModel, Exception>> get() {
    _getAsync().then((value) => _getStreamController.add(value));

    return _getStreamController.stream;
  }

  Future<Result<MapProviderModel, Exception>> _getAsync() async {
    try {
      Result<List<MapProviderModel>, Exception> availableResult =
          await listAvailable().first;
      if (availableResult.isError()) {
        return Result.error(availableResult.tryGetError()!);
      }

      List<MapProviderModel> availableProviders =
          availableResult.tryGetSuccess()!;
      return _getPreferences()
          .then((preferences) {
            if (!preferences.containsKey("map_provider")) {
              return null;
            }

            return preferences.getString("map_provider");
          })
          .then((key) => _keyToProvider(key))
          .then((provider) => availableProviders
              .firstWhereOrNull((p) => p.provider == provider))
          .then((provider) {
            print("AAA");
            if (provider == null) {
              return Result.success(_sytemProvider);
            }

            return Result.success(provider);
          });
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<MapProviderModel, Exception>> update(
      MapProviderModel mapProvider) {
    StreamController<Result<MapProviderModel, Exception>> streamController =
        StreamController.broadcast();

    _updateAsync(mapProvider)
        .then((result) => streamController.add(result))
        .then((_) => get());

    return streamController.stream;
  }

  Future<Result<MapProviderModel, Exception>> _updateAsync(
      MapProviderModel mapProvider) async {
    try {
      SharedPreferences preferences = await _getPreferences();
      preferences.setString(
          "map_provider", _providerToKey(mapProvider.provider));

      return Result.success(mapProvider);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // TODO: while `getInstance()` is asynchronous, we can't inject this without trouble.
  //  Find solution
  Future<SharedPreferences> _getPreferences() {
    return SharedPreferences.getInstance();
  }

  String _providerToKey(MapProvider mapProvider) {
    switch (mapProvider) {
      case MapProvider.appleMaps:
        return "appleMaps";
      case MapProvider.googleMaps:
        return "googleMaps";
      case MapProvider.mapLibre:
        return "mapLibre";
      default:
        return "system";
    }
  }

  MapProvider _keyToProvider(String? key) {
    switch (key) {
      case "appleMaps":
        return MapProvider.appleMaps;
      case "googleMaps":
        return MapProvider.googleMaps;
      case "mapLibre":
        return MapProvider.mapLibre;
      default:
        return MapProvider.system;
    }
  }
}
