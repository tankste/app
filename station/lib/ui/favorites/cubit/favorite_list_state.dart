import 'dart:ui';

abstract class FavoriteListState {}

class LoadingFavoriteListState extends FavoriteListState {}

class ErrorFavoriteListState extends FavoriteListState {
  final String errorDetails;

  ErrorFavoriteListState({required this.errorDetails});
}

class EmptyFavoriteListState extends FavoriteListState {}

class DataFavoriteListState extends FavoriteListState {
  final List<FavoriteStationItem> stations;

  DataFavoriteListState({required this.stations});
}

class FavoriteStationItem {
  final int stationId;
  final String name;
  final String city;
  final StationPrice price;

  FavoriteStationItem({required this.stationId, required this.name, required this.city, required this.price});
}

class StationPrice {
  String value;
  Color color;

  StationPrice({required this.value, required this.color});
}
