import 'package:navigation/coordinate_model.dart';
import 'package:station/model/marker_model.dart';

class MarkerDto {
  final int? id;
  final String? label;
  final double? latitude;
  final double? longitude;
  final double? e5Price;
  final String? e5PriceState;
  final double? e10Price;
  final String? e10PriceState;
  final double? dieselPrice;
  final String? dieselPriceState;

  MarkerDto({
    this.id,
    this.label,
    this.latitude,
    this.longitude,
    this.e5Price,
    this.e5PriceState,
    this.e10Price,
    this.e10PriceState,
    this.dieselPrice,
    this.dieselPriceState,
  });

  factory MarkerDto.fromJson(Map<String, dynamic> parsedJson) {
    return MarkerDto(
      id: parsedJson['id'],
      label: parsedJson['label'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      e5Price: parsedJson['e5Price'],
      e5PriceState: parsedJson['e5PriceState'],
      e10Price: parsedJson['e10Price'],
      e10PriceState: parsedJson['e10PriceState'],
      dieselPrice: parsedJson['dieselPrice'],
      dieselPriceState: parsedJson['dieselPriceState'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'latitude': latitude,
      'longitude': longitude,
      'e5Price': e5Price,
      'e5PriceState': e5PriceState,
      'e10Price': e10Price,
      'e10PriceState': e10PriceState,
      'dieselPrice': dieselPrice,
      'dieselPriceState': dieselPriceState,
    };
  }

  factory MarkerDto.fromModel(MarkerModel model) {
    return MarkerDto(
      id: model.id,
      label: model.label,
      latitude: model.coordinate.latitude,
      longitude: model.coordinate.longitude,
      e5Price: model.e5Price,
      e5PriceState: model.e5PriceState.toString(),
      e10Price: model.e10Price,
      e10PriceState: model.e10PriceState.toString(),
      dieselPrice: model.dieselPrice,
      dieselPriceState: model.dieselPriceState.toString(),
    );
  }

  MarkerModel toModel() {
    return MarkerModel(
      id: id ?? -1,
      label: label ?? "",
      coordinate: CoordinateModel(
        latitude: latitude ?? 0.0,
        longitude: longitude ?? 0.0,
      ),
      e5Price: e5Price ?? 0.0,
      e5PriceState: _parsePriceState(e5PriceState),
      e10Price: e10Price ?? 0.0,
      e10PriceState: _parsePriceState(e10PriceState),
      dieselPrice: dieselPrice ?? 0.0,
      dieselPriceState: _parsePriceState(dieselPriceState),
    );
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
    return 'MarkerDto{id: $id, label: $label, latitude: $latitude, longitude: $longitude, e5Price: $e5Price, e5PriceState: $e5PriceState, e10Price: $e10Price, e10PriceState: $e10PriceState, dieselPrice: $dieselPrice, dieselPriceState: $dieselPriceState}';
  }
}
