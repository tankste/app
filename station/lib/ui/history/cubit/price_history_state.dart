import 'package:station/model/currency_model.dart';
import 'package:station/model/fuel_type.dart';
import 'package:station/model/price_snapshot_model.dart';

abstract class PriceHistoryState {}

class LoadingPriceHistoryState extends PriceHistoryState {}

class ErrorPriceHistoryState extends PriceHistoryState {
  final String errorDetails;

  ErrorPriceHistoryState({required this.errorDetails});
}

class EmptyPriceHistoryState extends PriceHistoryState {}

class DataPriceHistoryState extends PriceHistoryState {
  FuelType selectedFuelType;
  List<HistoryFuelType> availableFuelTypes;
  List<PricePoint> priceData;
  int selectedDays;
  CurrencyModel currency;
  double priceMinChart;
  double priceMaxChart;

  DataPriceHistoryState({
    required this.selectedFuelType,
    required this.availableFuelTypes,
    required this.priceData,
    required this.selectedDays,
    required this.currency,
    required this.priceMinChart,
    required this.priceMaxChart,
  });
}

class HistoryFuelType {
  FuelType fuelType;
  String label;

  HistoryFuelType({required this.fuelType, required this.label});
}

class PricePoint {
  DateTime date;
  double price;

  PricePoint({required this.date, required this.price});
}
