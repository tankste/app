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
  final String addressOriginIconUrl;
  final List<Price> prices;
  final String lastPriceUpdate;
  final List<OpenTime> openTimes;
  final String openTimesOriginIconUrl;
  final List<Origin> origins;

  DetailStationDetailsState(
      {required this.coordinate,
      required this.address,
      required this.addressOriginIconUrl,
      required this.prices,
      required this.lastPriceUpdate,
      required this.openTimes,
      required this.openTimesOriginIconUrl,
      required this.origins,
      required super.title});
}

class Price {
  final String fuel;
  final String? originalPrice;
  final String homePrice;
  final bool isHighlighted;
  final String originIconUrl;

  Price(
      {required this.fuel,
      required this.originalPrice,
      required this.homePrice,
      required this.isHighlighted,
      required this.originIconUrl});
}

class OpenTime {
  final String day;
  final String time;
  final bool isHighlighted;

  OpenTime(
      {required this.day, required this.time, required this.isHighlighted});
}

class Origin {
  final String iconUrl;
  final String name;
  final String? websiteUrl;

  Origin({required this.iconUrl, required this.name, this.websiteUrl});
}
