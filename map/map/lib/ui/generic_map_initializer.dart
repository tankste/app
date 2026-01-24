import 'dart:ffi';

import 'package:map_apple/di/apple_map_module_factory.dart';
import 'package:map_core/ui/map_initializer.dart';
import 'package:map_google/di/google_map_module_factory.dart';
import 'package:map_maplibre/di/maplibre_map_module_factory.dart';

class GenericMapInitializer {

  static final List<MapInitializer> _mapInitializers = [
    MapLibreMapModuleFactory.createMapInitializer(),
    GoogleMapModuleFactory.createMapInitializer(),
    AppleMapModuleFactory.createMapInitializer(),
  ].nonNulls.toList();

  static Future<void> initialize() async {
    return Future.wait(
        _mapInitializers.map((initializer) => initializer.initialize())
    ).then((_) => Void);
  }
}