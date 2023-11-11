import 'package:station/model/price_model.dart';
import 'package:station/model/station_model.dart';

class PriceDto {
  final int? id;
  final double? e5Price;
  final double? e10Price;
  final double? dieselPrice;

  PriceDto({
    required this.id,
    required this.e5Price,
    required this.e10Price,
    required this.dieselPrice,
  });

  factory PriceDto.fromJson(Map<String, dynamic> parsedJson) {
    return PriceDto(
      id: parsedJson['id'],
      e5Price: parsedJson['e5Price'],
      e10Price: parsedJson['e10Price'],
      dieselPrice: parsedJson['dieselPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'e5Price': e5Price,
      'e10Price': e10Price,
      'dieselPrice': dieselPrice,
    };
  }

  factory PriceDto.fromModel(PriceModel model) {
    return PriceDto(
      id: model.id,
      e5Price: model.e5Price,
      e10Price: model.e10Price,
      dieselPrice: model.dieselPrice,
    );
  }

  PriceModel toModel() {
    return PriceModel(
      id: id ?? -1,
      e5Price: e5Price ?? -1,
      e10Price: e10Price ?? -1,
      dieselPrice: dieselPrice ?? -1,
    );
  }

  @override
  String toString() {
    return 'PriceDto{id: $id, e5Price: $e5Price, e10Price: $e10Price, dieselPrice: $dieselPrice}';
  }
}