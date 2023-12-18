import 'package:navigation/coordinate_model.dart';

abstract class StationDetailsState {
  String title;

  StationDetailsState({required this.title});
}

class LoadingStationDetailsState extends StationDetailsState {
  LoadingStationDetailsState({required super.title});
}

class ErrorStationDetailsState extends StationDetailsState {
  final String errorDetails;

  ErrorStationDetailsState({required this.errorDetails, required super.title});
}

class DetailStationDetailsState extends StationDetailsState {
  final CoordinateModel coordinate;
  final String address;
  final List<Price> prices;
  final String lastPriceUpdate;
  final List<OpenTime> openTimes;

  DetailStationDetailsState(
      {required this.coordinate,
      required this.address,
      required this.prices,
      required this.lastPriceUpdate,
      required this.openTimes,
      required super.title});
}

class Price {
  final String fuel;
  final String price;

  Price({required this.fuel, required this.price});
}

class OpenTime {
  final String day;
  final String time;

  OpenTime({required this.day, required this.time});
}
