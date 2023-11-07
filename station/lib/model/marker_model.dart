import 'package:navigation/coordinate_model.dart';

class MarkerModel {
  int id;
  String label;
  CoordinateModel coordinate;
  double e5Price;
  PriceState e5PriceState;
  double e10Price;
  PriceState e10PriceState;
  double dieselPrice;
  PriceState dieselPriceState;

  MarkerModel({
    required this.id,
    required this.label,
    required this.coordinate,
    required this.e5Price,
    required this.e5PriceState,
    required this.e10Price,
    required this.e10PriceState,
    required this.dieselPrice,
    required this.dieselPriceState,
  });

  @override
  String toString() {
    return 'MarkerModel(id: $id, label: $label, coordinate: $coordinate, e5Price: $e5Price, e5PriceState: $e5PriceState, e10Price: $e10Price, e10PriceState: $e10PriceState, dieselPrice: $dieselPrice, dieselPriceState: $dieselPriceState)';
  }
}

enum PriceState {
  unknown,
  notAvailable,
  expensive,
  medium,
  cheap,
}
