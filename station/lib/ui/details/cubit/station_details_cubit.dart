import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/model/open_time.dart';
import 'package:station/model/price_model.dart';
import 'package:station/repository/open_time_repository.dart';
import 'package:station/repository/origin_repository.dart';
import 'package:station/repository/price_repository.dart';
import 'package:station/ui/details/cubit/station_details_state.dart';
import 'package:station/repository/station_repository.dart';
import 'package:rxdart/streams.dart';
import 'package:collection/collection.dart';

class StationDetailsCubit extends Cubit<StationDetailsState> {
  final int stationId;
  final String markerLabel;
  final String activeGasPriceFilter; //TODO: use repository for filter storage

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

    CombineLatestStream.combine4(
            stationRepository.get(stationId),
            priceRepository.list(stationId),
            openTimeRepository.list(stationId),
            _originRepository.list(),
            (stationResult, priceResult, openTimesResult, originsResult) {
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
                prices: _genPricesList(prices),
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

  List<Price> _genPricesList(List<PriceModel> prices) {
    List<Price?> items = [];

    items.add(_genPriceItem(FuelType.e5, prices));
    items.add(_genPriceItem(FuelType.e10, prices));
    items.add(_genPriceItem(FuelType.diesel, prices));

    return items.whereNotNull().toList();
  }

  //TODO: should show not available prices, or hide completely?
  Price? _genPriceItem(FuelType fuelType, List<PriceModel> prices) {
    if (prices.isEmpty) {
      return null;
    }

    String fuelLabel = "";
    bool isSelected = false;
    switch (fuelType) {
      case FuelType.e5:
        fuelLabel = "Super E5";
        isSelected = activeGasPriceFilter == "e5";
        break;
      case FuelType.e10:
        fuelLabel = "Super E10";
        isSelected = activeGasPriceFilter == "e10";
        break;
      case FuelType.diesel:
        fuelLabel = "Diesel";
        isSelected = activeGasPriceFilter == "diesel";
        break;
      default:
        fuelLabel = "Unbekannt";
    }

    return Price(
        fuel: fuelLabel,
        isHighlighted: isSelected,
        price: _priceText(
            prices.firstWhereOrNull((p) => p.fuelType == fuelType)?.price ?? 0),
        originIconUrl: "");
  }

  String _priceText(double price) {
    String priceText;
    if (price == 0) {
      priceText = "-,--\u{207B}";
    } else {
      priceText = price.toStringAsFixed(3).replaceAll('.', ',');
    }

    if (priceText.length == 5) {
      priceText = priceText
          .replaceFirst('0', '\u{2070}', 4)
          .replaceFirst('1', '\u{00B9}', 4)
          .replaceFirst('2', '\u{00B2}', 4)
          .replaceFirst('3', '\u{00B3}', 4)
          .replaceFirst('4', '\u{2074}', 4)
          .replaceFirst('5', '\u{2075}', 4)
          .replaceFirst('6', '\u{2076}', 4)
          .replaceFirst('7', '\u{2077}', 4)
          .replaceFirst('8', '\u{2078}', 4)
          .replaceFirst('9', '\u{2079}', 4);
    }

    return "$priceText €";
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
    bool isToday = false;
    switch (day) {
      case OpenTimeDay.monday:
        dayLabel = "Montag";
        isToday = now.weekday == DateTime.monday;
        break;
      case OpenTimeDay.tuesday:
        dayLabel = "Dienstag";
        isToday = now.weekday == DateTime.tuesday;
        break;
      case OpenTimeDay.wednesday:
        dayLabel = "Mittwoch";
        isToday = now.weekday == DateTime.wednesday;
        break;
      case OpenTimeDay.thursday:
        dayLabel = "Donnerstag";
        isToday = now.weekday == DateTime.thursday;
        break;
      case OpenTimeDay.friday:
        dayLabel = "Freitag";
        isToday = now.weekday == DateTime.friday;
        break;
      case OpenTimeDay.saturday:
        dayLabel = "Samstag";
        isToday = now.weekday == DateTime.saturday;
        break;
      case OpenTimeDay.sunday:
        dayLabel = "Sonntag";
        isToday = now.weekday == DateTime.sunday;
        break;
      case OpenTimeDay.publicHoliday:
        dayLabel = "Feiertag";
        isToday = false; //TODO: find holidays and highlight if match
        break;
      default:
        dayLabel = "Unbekannt";
        isToday = false;
    }

    if (openTimes.isEmpty) {
      if (day == OpenTimeDay.publicHoliday) {
        return null;
      } else {
        return OpenTime(
            day: dayLabel, isHighlighted: isToday, time: "Geschlossen");
      }
    }

    DateFormat timeFormat = DateFormat('HH:mm');
    return OpenTime(
        day: dayLabel,
        isHighlighted: isToday,
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
      DateFormat dateFormat = DateFormat('HH:mm');
      return "${dateFormat.format(changeDate)} Uhr";
    } else {
      DateFormat dateFormat = DateFormat('dd.MM.yyyy, HH:mm');
      return "${dateFormat.format(changeDate)} Uhr";
    }
  }
}
