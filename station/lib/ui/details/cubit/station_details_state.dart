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

  DetailStationDetailsState({required this.coordinate, required this.address, required super.title});

}
