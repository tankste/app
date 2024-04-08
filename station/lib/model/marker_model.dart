import 'package:navigation/coordinate_model.dart';
import 'package:station/model/currency_model.dart';
import 'package:station/model/price_model.dart';

class MarkerModel {
  final int id;
  final int stationId;
  final String label;
  final CoordinateModel coordinate;
  final List<MarkerPrice> prices;
  final CurrencyModel currency;

  MarkerModel({
    required this.id,
    required this.stationId,
    required this.label,
    required this.coordinate,
    required this.prices,
    required this.currency,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkerModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          stationId == other.stationId &&
          label == other.label &&
          coordinate == other.coordinate &&
          prices == other.prices &&
          currency == other.currency;

  @override
  int get hashCode =>
      id.hashCode ^
      stationId.hashCode ^
      label.hashCode ^
      coordinate.hashCode ^
      prices.hashCode ^
      currency.hashCode;

  @override
  String toString() {
    return 'MarkerModel{id: $id, stationId: $stationId, label: $label, coordinate: $coordinate, prices: $prices, currency: $currency}';
  }
}

class MarkerPrice {
  FuelType fuelType;
  double price;
  PriceState state;

  MarkerPrice({
    required this.fuelType,
    required this.price,
    required this.state,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkerPrice &&
          runtimeType == other.runtimeType &&
          fuelType == other.fuelType &&
          price == other.price &&
          state == other.state;

  @override
  int get hashCode => fuelType.hashCode ^ price.hashCode ^ state.hashCode;

  @override
  String toString() {
    return 'MarkerPrice{fuelType: $fuelType, price: $price, state: $state}';
  }
}

enum PriceState {
  unknown,
  notAvailable,
  expensive,
  medium,
  cheap,
}
