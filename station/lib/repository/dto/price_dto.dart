import 'package:station/model/fuel_type.dart';
import 'package:station/model/price_model.dart';

class PriceDto {
  final int? id;
  final int? originId;
  final String? type;
  final double? price;
  final String? label;
  final String? lastChangedDate;

  PriceDto({
    required this.id,
    required this.originId,
    required this.type,
    required this.price,
    required this.label,
    required this.lastChangedDate,
  });

  factory PriceDto.fromJson(Map<String, dynamic> parsedJson) {
    return PriceDto(
      id: parsedJson['id'],
      originId: parsedJson['originId'],
      type: parsedJson['type'],
      price: parsedJson['price'],
      label: parsedJson['label'],
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
      type: fuelTypeToJson(model.fuelType),
      price: model.price,
      label: model.label,
      lastChangedDate: model.lastChangedDate?.toIso8601String(),
    );
  }

  PriceModel toModel() {
    return PriceModel(
      id: id ?? -1,
      originId: originId ?? -1,
      fuelType: parseFuelType(type),
      price: price,
      label: label ?? "",
      lastChangedDate:
          lastChangedDate != null ? DateTime.parse(lastChangedDate!) : null,
    );
  }

  static FuelType parseFuelType(String? type) {
    switch (type) {
      case 'petrol':
        return FuelType.petrol;
      case 'e5': // Legacy fuel type
      case 'petrol_super_e5':
        return FuelType.petrolSuperE5;
      case 'petrol_super_e5_additive':
        return FuelType.petrolSuperE5Additive;
      case 'e10': // Legacy fuel type
      case 'petrol_super_e10':
        return FuelType.petrolSuperE10;
      case 'petrol_super_e10_additive':
        return FuelType.petrolSuperE10Additive;
      case 'petrol_super_plus':
        return FuelType.petrolSuperPlus;
      case 'petrol_super_plus_additive':
        return FuelType.petrolSuperPlusAdditive;
      case 'diesel':
        return FuelType.diesel;
      case 'diesel_additive':
        return FuelType.dieselAdditive;
      case 'diesel_hvo100':
        return FuelType.dieselHvo100;
      case 'diesel_hvo100_additive':
        return FuelType.dieselHvo100Additive;
      case 'diesel_truck':
        return FuelType.dieselTruck;
      case 'diesel_hvo100_truck':
        return FuelType.dieselHvo100Truck;
      case 'lpg':
        return FuelType.lpg;
      case 'adblue':
        return FuelType.adblue;
      default:
        return FuelType.unknown;
    }
  }

  static String fuelTypeToJson(FuelType fuelType) {
    switch (fuelType) {
      case FuelType.petrol:
        return 'petrol';
      case FuelType.petrolSuperE5:
        return 'petrol_super_e5';
      case FuelType.petrolSuperE5Additive:
        return 'petrol_super_e5_additive';
      case FuelType.petrolSuperE10:
        return 'petrol_super_e10';
      case FuelType.petrolSuperE10Additive:
        return 'petrol_super_e10_additive';
      case FuelType.petrolSuperPlus:
        return 'petrol_super_plus';
      case FuelType.petrolSuperPlusAdditive:
        return 'petrol_super_plus_additive';
      case FuelType.diesel:
        return 'diesel';
      case FuelType.dieselAdditive:
        return 'diesel_additive';
      case FuelType.dieselHvo100:
        return 'diesel_hvo100';
      case FuelType.dieselHvo100Additive:
        return 'diesel_hvo100_additive';
      case FuelType.dieselTruck:
        return 'diesel_truck';
      case FuelType.dieselHvo100Truck:
        return 'diesel_hvo100_truck';
      case FuelType.lpg:
        return 'lpg';
      case FuelType.adblue:
        return 'adblue';
      default:
        return 'unknown';
    }
  }

  @override
  String toString() {
    return 'PriceDto{id: $id, type: $type, price: $price, label: $label, lastChangedDate: $lastChangedDate}';
  }
}
