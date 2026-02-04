import 'package:navigation_core/model/coordinate_model.dart';

class LocationModel {
  final CoordinateModel coordinate;

  LocationModel({required this.coordinate});

  @override
  String toString() {
    return 'LocationModel(coordinate: $coordinate)';
  }
}
