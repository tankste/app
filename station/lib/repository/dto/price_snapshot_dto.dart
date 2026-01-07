import 'package:station/model/fuel_type.dart';
import 'package:station/model/price_snapshot_model.dart';

class PriceSnapshotDto {
  final int? stationId;
  final String? snapshotDate;
  final String? type;
  final double? price;

  PriceSnapshotDto({
    required this.stationId,
    required this.snapshotDate,
    required this.type,
    required this.price,
  });

  factory PriceSnapshotDto.fromJson(Map<String, dynamic> parsedJson) {
    return PriceSnapshotDto(
      stationId: parsedJson['stationId'],
      type: parsedJson['type'],
      price: parsedJson['price'],
      snapshotDate: parsedJson['snapshotDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'type': type,
      'price': price,
      'snapshotDate': snapshotDate,
    };
  }

  factory PriceSnapshotDto.fromModel(PriceSnapshotModel model) {
    return PriceSnapshotDto(
      stationId: model.stationId,
      type: fuelTypeToJsonKey(model.fuelType),
      price: model.price,
      snapshotDate: model.date.toIso8601String(),
    );
  }

  PriceSnapshotModel toModel() {
    return PriceSnapshotModel(
      stationId: stationId ?? -1,
      fuelType: _parseFuelType(type),
      price: price ?? -1,
      date: snapshotDate != null ? DateTime.parse(snapshotDate!) : DateTime(0),
    );
  }

  FuelType _parseFuelType(String? type) {
    switch (type) {
      case 'petrol':
        return FuelType.petrol;
      case 'petrol_super_e5':
        return FuelType.e5;
      case 'petrol_super_e10':
        return FuelType.e10;
      case 'petrol_super_plus':
        return FuelType.petrolSuperPlus;
      case 'petrol_shell_power':
        return FuelType.petrolShellPower;
      case 'petrol_aral_ultimate':
        return FuelType.petrolAralUltimate;
      case 'diesel':
        return FuelType.diesel;
      case 'diesel_hvo100':
        return FuelType.dieselHvo100;
      case 'diesel_truck':
        return FuelType.dieselTruck;
      case 'diesel_shell_power':
        return FuelType.dieselShellPower;
      case 'diesel_aral_ultimate':
        return FuelType.dieselAralUltimate;
      case 'lpg':
        return FuelType.lpg;
      default:
        return FuelType.unknown;
    }
  }

  static String fuelTypeToJsonKey(FuelType fuelType) {
    switch (fuelType) {
      case FuelType.petrol:
        return "petrol";
      case FuelType.e5:
        return "petrol_super_e5";
      case FuelType.e10:
        return "petrol_super_e10";
      case FuelType.petrolSuperPlus:
        return "petrol_super_plus";
      case FuelType.petrolShellPower:
        return "petrol_shell_power";
      case FuelType.petrolAralUltimate:
        return "petrol_aral_ultimate";
      case FuelType.diesel:
        return "diesel";
      case FuelType.dieselHvo100:
        return "diesel_hvo100";
      case FuelType.dieselTruck:
        return "diesel_truck";
      case FuelType.dieselShellPower:
        return "diesel_hell_power";
      case FuelType.dieselAralUltimate:
        return "diesel_aral_ultimate";
      case FuelType.lpg:
        return "lpg";
      default:
        return 'unknown';
    }
  }

  @override
  String toString() {
    return 'PriceDto{stationId: $stationId, snapshotDate: $snapshotDate, type: $type, price: $price}';
  }
}
