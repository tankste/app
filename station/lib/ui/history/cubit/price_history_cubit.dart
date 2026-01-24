import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/model/currency_model.dart';
import 'package:station/model/fuel_type.dart';
import 'package:station/repository/price_repository.dart';
import 'package:station/repository/price_snapshot_repository.dart';
import 'package:station/repository/station_repository.dart';
import 'package:station/ui/history/cubit/price_history_state.dart';

class PriceHistoryCubit extends Cubit<PriceHistoryState> {
  final StationRepository _stationRepository =
      StationModuleFactory.createStationRepository();

  final PriceRepository _priceRepository =
      StationModuleFactory.createPriceRepository();

  final PriceSnapshotRepository _priceSnapshotRepository =
      StationModuleFactory.createPriceSnapshotRepository();

  final int stationId;
  FuelType _selectedFuelType = FuelType.unknown;
  List<HistoryFuelType> _availableFuelTypes = [];
  int _selectedDays = 1;
  CurrencyModel? _currency;
  List<PricePoint> _pricePoints = [];

  PriceHistoryCubit(this.stationId, String? activateGasPriceFilter)
      : super(LoadingPriceHistoryState()) {
    if (activateGasPriceFilter == "e5") {
      _selectedFuelType = FuelType.petrolSuperE5;
    } else if (activateGasPriceFilter == "e10") {
      _selectedFuelType = FuelType.petrolSuperE10;
    } else if (activateGasPriceFilter == "diesel") {
      _selectedFuelType = FuelType.diesel;
    }

    _fetchCurrency();
  }

  void _fetchCurrency() {
    emit(LoadingPriceHistoryState());

    _stationRepository.get(stationId).first.then((result) {
      if (isClosed) {
        return;
      }

      result.when((station) {
        _currency = station.currency;
        _fetchPrices();
      },
          (error) =>
              emit(ErrorPriceHistoryState(errorDetails: error.toString())));
    });
  }

  void _fetchPrices() {
    emit(LoadingPriceHistoryState());

    _priceRepository.list(stationId).first.then((result) {
      if (isClosed) {
        return;
      }

      result.when((prices) {
        _availableFuelTypes = prices
            .map((p) => HistoryFuelType(fuelType: p.fuelType, label: p.label))
            .sortedBy<num>((p) => p.fuelType.index)
            .toList(growable: false);
        _fetchPriceHistory();
      },
          (error) =>
              emit(ErrorPriceHistoryState(errorDetails: error.toString())));
    });
  }

  void _fetchPriceHistory() {
    emit(LoadingPriceHistoryState());

    // TODO: ugly code x.x ; but first, refactor fuel type filter on map
    if (!_availableFuelTypes
        .map((p) => p.fuelType)
        .contains(_selectedFuelType)) {
      _selectedFuelType = _availableFuelTypes.first.fuelType;
    }

    _priceSnapshotRepository.list(stationId, _selectedFuelType).then((result) {
      emit(result.when((snapshots) {
        _pricePoints = snapshots
            .map((s) => PricePoint(date: s.date, price: s.price))
            .toList(growable: false);
        return _genDataState();
      }, (error) => ErrorPriceHistoryState(errorDetails: error.toString())));
    });
  }

  PriceHistoryState _genDataState() {
    if (_pricePoints.isEmpty) {
      return EmptyPriceHistoryState();
    }

    CurrencyModel? currency = _currency;
    if (currency == null) {
      return ErrorPriceHistoryState(errorDetails: "Currency has not loaded!");
    }

    List<double> prices =
        _pricePoints.map((s) => s.price).toList(growable: false);
    return DataPriceHistoryState(
        selectedFuelType: _selectedFuelType,
        availableFuelTypes: _availableFuelTypes,
        priceData: _getPriceData(),
        priceMinChart: (prices.min - 0.025).toDouble(),
        priceMaxChart: (prices.max + 0.025).toDouble(),
        selectedDays: _selectedDays,
        currency: currency);
  }

  List<PricePoint> _getPriceData() {
    DateTime startFilter =
        DateTime.now().subtract(Duration(days: _selectedDays));

    List<PricePoint> pricePoints = _pricePoints;
    if (_selectedDays >= 30) {
      // Show min-price for ranges of 12 hours
      pricePoints = _pricePoints
          .groupListsBy((point) => point.date
          .copyWith(hour: (point.date.hour ~/ 12) * 12, minute: 0, second: 0, millisecond: 0, microsecond: 0))
          .values
          .map((points) => points.reduce((a, b) => a.price < b.price ? a : b))
          .toList(growable: false);
    } else if (_selectedDays >= 14) {
      // Show min-price for ranges of 6 hours
      pricePoints = _pricePoints
          .groupListsBy((point) => point.date
          .copyWith(hour: (point.date.hour ~/ 6) * 6, minute: 0, second: 0, millisecond: 0, microsecond: 0))
          .values
          .map((points) => points.reduce((a, b) => a.price < b.price ? a : b))
          .toList(growable: false);
    } else if (_selectedDays >= 7) {
      // Show min-price for ranges of 3 hours
      pricePoints = _pricePoints
          .groupListsBy((point) => point.date
              .copyWith(hour: (point.date.hour ~/ 3) * 3, minute: 0, second: 0, millisecond: 0, microsecond: 0))
          .values
          .map((points) => points.reduce((a, b) => a.price < b.price ? a : b))
          .toList(growable: false);
    }

    return pricePoints
        .where((p) => p.date.isAfter(startFilter))
        .toList(growable: false);
  }

  void onDaysSelected(int selectedDays) {
    _selectedDays = selectedDays;
    emit(_genDataState());
  }

  void onFuelTypeSelected(FuelType fuelType) {
    _selectedFuelType = fuelType;
    _fetchPriceHistory();
  }

  void onRetryClicked() {
    _fetchCurrency();
  }
}
