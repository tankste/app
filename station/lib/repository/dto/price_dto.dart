import 'package:station/model/price_model.dart';

class PriceDto {
  final int? id;
  final int? originId;
  final String? type;
  final double? price;
  final String? lastChangedDate;

  PriceDto({
    required this.id,
    required this.originId,
    required this.type,
    required this.price,
    required this.lastChangedDate,
  });

  factory PriceDto.fromJson(Map<String, dynamic> parsedJson) {
    return PriceDto(
      id: parsedJson['id'],
      originId: parsedJson['originId'],
      type: parsedJson['type'],
      price: parsedJson['price'],
      lastChangedDate: parsedJson['lastChangesAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originId': originId,
      'type': type,
      'price': price,
      'lastChangedDate': lastChangedDate,
    };
  }

  factory PriceDto.fromModel(PriceModel model) {
    return PriceDto(
      id: model.id,
      originId: model.originId,
      type: _fuelTypeToJson(model.fuelType),
      price: model.price,
      lastChangedDate: model.lastChangedDate?.toIso8601String(),
    );
  }

  PriceModel toModel() {
    return PriceModel(
      id: id ?? -1,
      originId: originId ?? -1,
      fuelType: _parseFuelType(type),
      price: price ?? -1,
      lastChangedDate:
          lastChangedDate != null ? DateTime.parse(lastChangedDate!) : null,
    );
  }

  FuelType _parseFuelType(String? type) {
    switch (type) {
      case 'e5':
        return FuelType.e5;
      case 'e10':
        return FuelType.e10;
      case 'diesel':
        return FuelType.diesel;
      default:
        return FuelType.unknown;
    }
  }

  static String _fuelTypeToJson(FuelType fuelType) {
    switch (fuelType) {
      case FuelType.e5:
        return 'e5';
      case FuelType.e10:
        return 'e10';
      case FuelType.diesel:
        return 'diesel';
      default:
        return 'unknown';
    }
  }

  @override
  String toString() {
    return 'PriceDto{id: $id, type: $type, price: $price, lastChangedDate: $lastChangedDate}';
  }
}
