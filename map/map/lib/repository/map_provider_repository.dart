import 'dart:async';

import 'package:collection/collection.dart';
import 'package:core/config/config_repository.dart';
import 'package:core/log/log.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:map/model/map_provider_model.dart';
import 'package:map_core/map_availability.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MapProviderRepository {
  Stream<Result<List<MapProviderModel>, Exception>> listAvailable();

  Stream<Result<MapProviderModel, Exception>> get();

  Future<MapProviderModel> getDefault();

  Stream<Result<MapProviderModel, Exception>> update(
      MapProviderModel mapProvider);
}

class LocalMapProviderRepository extends MapProviderRepository {
  static final LocalMapProviderRepository _instance =
      LocalMapProviderRepository._internal();

  late MapAvailability _googleMapAvailability;
  late MapAvailability _appleMapAvailability;

  factory LocalMapProviderRepository(MapAvailability googleMapAvailability,
      MapAvailability appleMapAvailability) {
    _instance._googleMapAvailability = googleMapAvailability;
    _instance._appleMapAvailability = appleMapAvailability;
    return _instance;
  }

  LocalMapProviderRepository._internal();

  final MapProviderModel _systemProvider =
      MapProviderModel(tr('generic.system_default'), MapProvider.system);
  final MapProviderModel _maplibreProvider = MapProviderModel(
      tr('settings.app.map_provider.map_libre'), MapProvider.mapLibre);
  final MapProviderModel _googleProvider = MapProviderModel(
      tr('settings.app.map_provider.google_maps'), MapProvider.googleMaps);
  final MapProviderModel _appleProvider = MapProviderModel(
      tr('settings.app.map_provider.apple_maps'), MapProvider.appleMaps);

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

      availableProviders.add(_systemProvider);
      availableProviders.add(_maplibreProvider);

      if (_googleMapAvailability.isAvailable()) {
        availableProviders.add(_googleProvider);
      }

      if (_appleMapAvailability.isAvailable()) {
        availableProviders.add(_appleProvider);
      }

      return Result.success(availableProviders);
    } on Exception catch (e) {
      Log.exception(e);
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
        Exception error = availableResult.tryGetError()!;
        Log.exception(error);
        return Result.error(error);
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
            if (provider == null) {
              return Result.success(_systemProvider);
            }

            return Result.success(provider);
          });
    } on Exception catch (e) {
      Log.exception(e);
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
      Log.exception(e);
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

  @override
  Future<MapProviderModel> getDefault() async {
    if (await _googleMapAvailability.isDefault()) {
      return _googleProvider;
    } else if (await _appleMapAvailability.isDefault()) {
      return _appleProvider;
    } else {
      return _maplibreProvider;
    }
  }
}
