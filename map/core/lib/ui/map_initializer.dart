
import 'package:flutter/material.dart';
import 'package:map_core/map_models.dart';

abstract class MapInitializer {
  Future<void> initialize();
}