import 'package:station/model/fuel_type.dart';
import 'package:station/model/price_snapshot_model.dart';
import 'package:station/repository/dto/price_dto.dart';

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
      type: PriceDto.fuelTypeToJson(model.fuelType),
      price: model.price,
      snapshotDate: model.date.toIso8601String(),
    );
  }

  PriceSnapshotModel toModel() {
    return PriceSnapshotModel(
      stationId: stationId ?? -1,
      fuelType: PriceDto.parseFuelType(type),
      price: price ?? -1,
      date: snapshotDate != null ? DateTime.parse(snapshotDate!) : DateTime(0),
    );
  }

  @override
  String toString() {
    return 'PriceDto{stationId: $stationId, snapshotDate: $snapshotDate, type: $type, price: $price}';
  }
}
