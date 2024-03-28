import 'package:collection/collection.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:station/model/currency_model.dart';
import 'package:station/model/marker_model.dart';
import 'package:station/model/price_model.dart';

class MarkerDto {
  final int? id;
  final int? stationId;
  final String? label;
  final double? latitude;
  final double? longitude;
  final double? e5Price;
  final String? e5PriceState;
  final double? e10Price;
  final String? e10PriceState;
  final double? dieselPrice;
  final String? dieselPriceState;
  final String? currency;

  MarkerDto({
    this.id,
    this.stationId,
    this.label,
    this.latitude,
    this.longitude,
    this.e5Price,
    this.e5PriceState,
    this.e10Price,
    this.e10PriceState,
    this.dieselPrice,
    this.dieselPriceState,
    this.currency,
  });

  factory MarkerDto.fromJson(Map<String, dynamic> parsedJson) {
    return MarkerDto(
      id: parsedJson['id'],
      stationId: parsedJson['stationId'],
      label: parsedJson['label'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      e5Price: parsedJson['e5Price'],
      e5PriceState: parsedJson['e5PriceState'],
      e10Price: parsedJson['e10Price'],
      e10PriceState: parsedJson['e10PriceState'],
      dieselPrice: parsedJson['dieselPrice'],
      dieselPriceState: parsedJson['dieselPriceState'],
      currency: parsedJson['currency'],
    );
  }

  MarkerModel toModel(List<CurrencyModel> currencies) {
    return MarkerModel(
        id: id ?? -1,
        stationId: stationId ?? -1,
        label: label ?? "",
        coordinate: CoordinateModel(
          latitude: latitude ?? 0.0,
          longitude: longitude ?? 0.0,
        ),
        prices: [
          MarkerPrice(
              fuelType: FuelType.e5,
              price: e5Price ?? 0.0,
              state: _parsePriceState(e5PriceState)),
          MarkerPrice(
            fuelType: FuelType.e10,
            price: e10Price ?? 0.0,
            state: _parsePriceState(e10PriceState),
          ),
          MarkerPrice(
            fuelType: FuelType.diesel,
            price: dieselPrice ?? 0.0,
            state: _parsePriceState(dieselPriceState),
          ),
        ],
        currency:
            currencies.firstWhereOrNull((c) => c.currency.name == currency) ??
                CurrencyModel.unknown());
  }

  PriceState _parsePriceState(String? value) {
    switch (value) {
      case "not_available":
        return PriceState.notAvailable;
      case "expensive":
        return PriceState.expensive;
      case "medium":
        return PriceState.medium;
      case "cheap":
        return PriceState.cheap;
      default:
        return PriceState.unknown;
    }
  }

  @override
  String toString() {
    return 'MarkerDto{id: $id, stationId: $stationId, label: $label, latitude: $latitude, longitude: $longitude, e5Price: $e5Price, e5PriceState: $e5PriceState, e10Price: $e10Price, e10PriceState: $e10PriceState, dieselPrice: $dieselPrice, dieselPriceState: $dieselPriceState, currency: $currency}';
  }
}
