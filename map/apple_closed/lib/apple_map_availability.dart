import 'dart:io';

import 'package:map_core/map_availability.dart';

class AppleMapAvailability extends MapAvailability {
  @override
  bool isAvailable() {
    return Platform.isIOS;
  }

  @override
  Future<bool> isDefault() {
    return Future.value(Platform.isIOS);
  }
}
