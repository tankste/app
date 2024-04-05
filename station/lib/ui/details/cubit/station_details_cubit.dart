import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/model/currency_model.dart';
import 'package:station/model/open_time.dart';
import 'package:station/model/price_model.dart';
import 'package:station/model/station_model.dart';
import 'package:station/repository/currency_repository.dart';
import 'package:station/repository/open_time_repository.dart';
import 'package:station/repository/origin_repository.dart';
import 'package:station/repository/price_repository.dart';
import 'package:station/ui/details/cubit/station_details_state.dart';
import 'package:station/repository/station_repository.dart';
import 'package:rxdart/streams.dart';
import 'package:collection/collection.dart';
import 'package:station/ui/price_format.dart';

class StationDetailsCubit extends Cubit<StationDetailsState> {
  final int stationId;
  final String markerLabel;
  final String activeGasPriceFilter; //TODO: use repository for filter storage

  final CurrencyRepository _currencyRepository =
      StationModuleFactory.createCurrencyRepository();

  final StationRepository stationRepository =
      StationModuleFactory.createStationRepository();

  final PriceRepository priceRepository =
      StationModuleFactory.createPriceRepository();

  final OpenTimeRepository openTimeRepository =
      StationModuleFactory.createOpenTimeRepository();

  final OriginRepository _originRepository =
      StationModuleFactory.createOriginRepository();

  StationDetailsCubit(
      this.stationId, this.markerLabel, this.activeGasPriceFilter)
      : super(LoadingStationDetailsState(title: markerLabel)) {
    _fetchStation();
  }

  void _fetchStation() {
    emit(LoadingStationDetailsState(title: markerLabel));

    CombineLatestStream.combine5(
            _currencyRepository.getSelected(),
            stationRepository.get(stationId),
            priceRepository.list(stationId),
            openTimeRepository.list(stationId),
            _originRepository.list(), (homeCurrencyResult, stationResult,
                priceResult, openTimesResult, originsResult) {
      return homeCurrencyResult.when((homeCurrency) {
        return stationResult.when((station) {
          return priceResult.when((prices) {
            return openTimesResult.when((openTimes) {
              return originsResult.when((origins) {
                return DetailStationDetailsState(
                  title: station.brand,
                  coordinate: station.coordinate,
                  address:
                      "${station.address.street} ${station.address.houseNumber}\n${station.address.postCode} ${station.address.city}\n${station.address.country}",
                  addressOriginIconUrl: origins
                          .firstWhereOrNull((o) => o.id == station.originId)
                          ?.iconImageUrl
                          .toString() ??
                      "",
                  prices: _genPricesList(station, homeCurrency, prices),
                  lastPriceUpdate: _genPriceUpdate(prices),
                  openTimes: _genOpenTimeList(openTimes),
                  openTimesOriginIconUrl: origins
                          .firstWhereOrNull(
                              (o) => o.id == openTimes.firstOrNull?.originId)
                          ?.iconImageUrl
                          .toString() ??
                      "",
                  origins: origins
                      .where((o) => ([station.originId] +
                              prices.map((p) => p.originId).toList() +
                              prices.map((ot) => ot.originId).toList())
                          .contains(o.id))
                      .map((o) => Origin(
                          iconUrl: o.iconImageUrl.toString(),
                          name: o.name,
                          websiteUrl: o.websiteUrl.toString()))
                      .toList(),
                );
              },
                  (error) => ErrorStationDetailsState(
                      errorDetails: error.toString(), title: markerLabel));
            },
                (error) => ErrorStationDetailsState(
                    errorDetails: error.toString(), title: markerLabel));
          },
              (error) => ErrorStationDetailsState(
                  errorDetails: error.toString(), title: markerLabel));
        },
            (error) => ErrorStationDetailsState(
                errorDetails: error.toString(), title: markerLabel));
      },
          (error) => ErrorStationDetailsState(
              errorDetails: error.toString(), title: markerLabel));
    })
        .first //TODO: use stream benefits
        .then((state) {
      if (isClosed) {
        return;
      }

      emit(state);
    });
  }

  void onRetryClicked() {
    _fetchStation();
  }

  void onRefreshAction() {
    _fetchStation();
  }

  List<Price> _genPricesList(StationModel station, CurrencyModel homeCurrency, List<PriceModel> prices) {
    List<Price?> items = [];

    items.add(_genPriceItem(station, homeCurrency, FuelType.e5, prices));
    items.add(_genPriceItem(station, homeCurrency, FuelType.e10, prices));
    items.add(_genPriceItem(station, homeCurrency, FuelType.diesel, prices));

    return items.whereNotNull().toList();
  }

  //TODO: should show not available prices, or hide completely?
  Price? _genPriceItem(StationModel station, CurrencyModel homeCurrency, FuelType fuelType, List<PriceModel> prices) {
    String fuelLabel = "";
    bool isSelected = false;
    switch (fuelType) {
      case FuelType.e5:
        fuelLabel = tr('station.gas.super_e5');
        isSelected = activeGasPriceFilter == "e5";
        break;
      case FuelType.e10:
        fuelLabel = tr('station.gas.super_e10');
        isSelected = activeGasPriceFilter == "e10";
        break;
      case FuelType.diesel:
        fuelLabel = tr('station.gas.diesel');
        isSelected = activeGasPriceFilter == "diesel";
        break;
      default:
        fuelLabel = tr('generic.unknown');
    }

    PriceModel? price = prices.firstWhereOrNull((p) => p.fuelType == fuelType);
    //TODO: change this, while closed station then will have NO PRICES
    if (price == null) {
      return null;
    }

    String? originalPriceText;
    String homePriceText = PriceFormat.format(
        station.currency.convertTo(price.price, homeCurrency.currency) ?? 0.0,
        homeCurrency,
        true);
    if (station.currency.currency != homeCurrency.currency) {
      homePriceText = "≈$homePriceText";

      originalPriceText = "(${PriceFormat.format(price.price, station.currency, true)})";
    }

    return Price(
        fuel: fuelLabel,
        isHighlighted: isSelected,
        originalPrice: originalPriceText,
        homePrice: homePriceText,
        originIconUrl: "");
  }

  List<OpenTime> _genOpenTimeList(List<OpenTimeModel> openTimes) {
    List<OpenTime?> items = [];

    items.add(_genOpenTimeItem(OpenTimeDay.monday,
        openTimes.where((ot) => ot.day == OpenTimeDay.monday).toList()));
    items.add(_genOpenTimeItem(OpenTimeDay.tuesday,
        openTimes.where((ot) => ot.day == OpenTimeDay.tuesday).toList()));
    items.add(_genOpenTimeItem(OpenTimeDay.wednesday,
        openTimes.where((ot) => ot.day == OpenTimeDay.wednesday).toList()));
    items.add(_genOpenTimeItem(OpenTimeDay.thursday,
        openTimes.where((ot) => ot.day == OpenTimeDay.thursday).toList()));
    items.add(_genOpenTimeItem(OpenTimeDay.friday,
        openTimes.where((ot) => ot.day == OpenTimeDay.friday).toList()));
    items.add(_genOpenTimeItem(OpenTimeDay.saturday,
        openTimes.where((ot) => ot.day == OpenTimeDay.saturday).toList()));
    items.add(_genOpenTimeItem(OpenTimeDay.sunday,
        openTimes.where((ot) => ot.day == OpenTimeDay.sunday).toList()));
    items.add(_genOpenTimeItem(OpenTimeDay.publicHoliday,
        openTimes.where((ot) => ot.day == OpenTimeDay.publicHoliday).toList()));

    return items.whereNotNull().toList();
  }

  OpenTime? _genOpenTimeItem(OpenTimeDay day, List<OpenTimeModel> openTimes) {
    DateTime now = DateTime.now();
    String dayLabel = "";
    bool isTodayFallback = false;
    switch (day) {
      case OpenTimeDay.monday:
        dayLabel = tr('station.open_times.monday');
        isTodayFallback = now.weekday == DateTime.monday;
        break;
      case OpenTimeDay.tuesday:
        dayLabel = tr('station.open_times.tuesday');
        isTodayFallback = now.weekday == DateTime.tuesday;
        break;
      case OpenTimeDay.wednesday:
        dayLabel = tr('station.open_times.wednesday');
        isTodayFallback = now.weekday == DateTime.wednesday;
        break;
      case OpenTimeDay.thursday:
        dayLabel = tr('station.open_times.thursday');
        isTodayFallback = now.weekday == DateTime.thursday;
        break;
      case OpenTimeDay.friday:
        dayLabel = tr('station.open_times.friday');
        isTodayFallback = now.weekday == DateTime.friday;
        break;
      case OpenTimeDay.saturday:
        dayLabel = tr('station.open_times.saturday');
        isTodayFallback = now.weekday == DateTime.saturday;
        break;
      case OpenTimeDay.sunday:
        dayLabel = tr('station.open_times.sunday');
        isTodayFallback = now.weekday == DateTime.sunday;
        break;
      case OpenTimeDay.publicHoliday:
        dayLabel = tr('station.open_times.public_holiday');
        isTodayFallback = false;
        break;
      default:
        dayLabel = tr('generic.unknown');
        isTodayFallback = false;
    }

    if (openTimes.isEmpty) {
      if (day == OpenTimeDay.publicHoliday) {
        return null;
      } else {
        return OpenTime(
            day: dayLabel, isHighlighted: isTodayFallback, time: "Geschlossen");
      }
    }

    DateFormat timeFormat = DateFormat('HH:mm');
    return OpenTime(
        day: dayLabel,
        isHighlighted: openTimes.first.isToday,
        time: openTimes
            .map((ot) =>
                "${timeFormat.format(ot.startTime)} - ${timeFormat.format(ot.endTime)}")
            .join("\n"));
  }

  String _genPriceUpdate(List<PriceModel> prices) {
    if (prices.isEmpty) {
      return "-";
    }

    List<DateTime> priceChangeDates =
        prices.map((price) => price.lastChangedDate).whereNotNull().toList();

    priceChangeDates.sort((dateA, dateB) =>
        dateA.millisecondsSinceEpoch.compareTo(dateB.microsecondsSinceEpoch));

    if (priceChangeDates.isEmpty) {
      return "-";
    }

    DateTime changeDate = priceChangeDates.first.toLocal();
    DateTime today = DateTime.now();
    if (changeDate.year == today.year &&
        changeDate.month == today.month &&
        changeDate.day == today.day) {
      DateFormat dateFormat = DateFormat(tr('generic.date.time.format'));
      return tr('generic.date.time.clock',
          args: [dateFormat.format(changeDate)]);
    } else {
      DateFormat dateFormat = DateFormat(tr('generic.date.date_time.format'));
      return tr('generic.date.time.clock',
          args: [dateFormat.format(changeDate)]);
    }
  }
}
