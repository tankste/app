import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/model/currency_model.dart';
import 'package:station/model/fuel_type.dart';
import 'package:station/model/marker_model.dart';
import 'package:station/model/station_model.dart';
import 'package:station/repository/currency_repository.dart';
import 'package:station/repository/favorite_repository.dart';
import 'package:station/repository/marker_repository.dart';
import 'package:station/ui/favorites/cubit/favorite_list_state.dart';
import 'package:station/ui/marker_ui.dart';
import 'package:station/ui/price_format.dart';

class FavoriteListCubit extends Cubit<FavoriteListState> {
  final FavoriteStationRepository _favoriteStationRepository =
      StationModuleFactory.createFavoriteStationRepository();
  final MarkerRepository _markerRepository =
      StationModuleFactory.createMarkerRepository();
  final CurrencyRepository _currencyRepository =
      StationModuleFactory.createCurrencyRepository();

  String filter;

  List<StationModel>? _stations;
  CurrencyModel? _homeCurrency;
  StreamSubscription? _favoriteSubscription;
  StreamSubscription? _priceSubscription;

  //TODO: move filter also to a repository
  FavoriteListCubit(this.filter) : super(LoadingFavoriteListState()) {
    _fetchFavorites();
  }

  void _fetchFavorites() {
    emit(LoadingFavoriteListState());

    _favoriteSubscription?.cancel();
    _priceSubscription?.cancel();

    _favoriteSubscription =
        CombineLatestStream.combine2(
          _currencyRepository.getSelected(),
          _favoriteStationRepository.list(),
          (currencyResult, favoriteStationsResult) => [
            currencyResult,
            favoriteStationsResult,
          ],
        ).listen((combinedResults) {
          if (isClosed) {
            return;
          }

          //TODO: I don't like the list solution. find a better one!
          final Result<CurrencyModel, Exception> currencyResult =
              combinedResults[0] as Result<CurrencyModel, Exception>;
          final Result<List<StationModel>, Exception> favoriteStationsResult =
              combinedResults[1] as Result<List<StationModel>, Exception>;

          currencyResult.when(
            (homeCurrency) {
              favoriteStationsResult.when(
                (stations) {
                  if (stations.isEmpty) {
                    emit(EmptyFavoriteListState());
                    return;
                  }

                  _fetchPrices(stations, homeCurrency);
                },
                (error) => emit(
                  ErrorFavoriteListState(errorDetails: error.toString()),
                ),
              );
            },
            (error) =>
                emit(ErrorFavoriteListState(errorDetails: error.toString())),
          );
        });
  }

  void _fetchPrices(List<StationModel> stations, CurrencyModel homeCurrency) {
    emit(
      DataFavoriteListState(
        stations: stations
            .map(
              (s) => FavoriteStationItem(
                stationId: s.id,
                name: "${s.brand} - ${s.address.street}",
                city: s.address.city,
                price: StationPrice(
                  value: PriceFormat.format(0, homeCurrency, false),
                  color: getMarkerStateColor(PriceState.unknown),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );

    _priceSubscription?.cancel();
    _priceSubscription =
        CombineLatestStream.list(
          stations.map((s) => _markerRepository.get(s.id)),
        ).listen((markerResults) {
          if (isClosed) {
            return;
          }

          emit(
            DataFavoriteListState(
              stations: stations.map((s) {
                MarkerModel? marker = markerResults
                    .map((mr) => mr.tryGetSuccess())
                    .nonNulls
                    .firstWhereOrNull((m) => m.stationId == s.id);

                MarkerPrice? markerPrice;
                if (filter == "e5") {
                  markerPrice = marker?.prices.firstWhereOrNull(
                    (p) => p.fuelType == FuelType.petrolSuperE5,
                  );
                } else if (filter == "e10") {
                  markerPrice = marker?.prices.firstWhereOrNull(
                    (p) => p.fuelType == FuelType.petrolSuperE10,
                  );
                } else if (filter == "diesel") {
                  markerPrice = marker?.prices.firstWhereOrNull(
                    (p) => p.fuelType == FuelType.diesel,
                  );
                }

                StationPrice price;
                if (marker != null && markerPrice != null) {
                  String priceText = PriceFormat.format(
                    marker.currency.convertTo(
                          markerPrice.price,
                          homeCurrency.currency,
                        ) ??
                        0.0,
                    homeCurrency,
                    false,
                  );
                  if (marker.currency.currency != homeCurrency.currency) {
                    priceText = "≈$priceText";
                  }

                  //TODO: from preferences!!
                  price = StationPrice(
                    value: priceText,
                    color: getMarkerStateColor(markerPrice.state),
                  );
                } else {
                  price = StationPrice(
                    value: "",
                    color: getMarkerStateColor(PriceState.unknown),
                  );
                }
                return FavoriteStationItem(
                  stationId: s.id,
                  name: "${s.brand} - ${s.address.street}",
                  city: s.address.city,
                  price: price,
                );
              }).toList(),
            ),
          );
        });
  }

  void onRetryClicked() {
    _fetchFavorites();
  }

  void onRefresh() {
    final List<StationModel>? stations = _stations;
    final CurrencyModel? homeCurrency = _homeCurrency;
    if (stations != null && homeCurrency != null) {
      _fetchPrices(stations, homeCurrency);
    }
  }
}
