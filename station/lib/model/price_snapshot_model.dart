import 'package:station/model/fuel_type.dart';

class PriceSnapshotModel {
  final int stationId;
  final DateTime date;
  final FuelType fuelType;
  final double price;

  PriceSnapshotModel({
    required this.stationId,
    required this.date,
    required this.fuelType,
    required this.price,
  });

  @override
  String toString() {
    return 'PriceSnapshotModel{stationId: $stationId, date: $date, fuelType: $fuelType, price: $price}';
  }
}
