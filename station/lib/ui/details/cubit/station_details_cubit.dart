import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/repository/price_repository.dart';
import 'package:station/ui/details/cubit/station_details_state.dart';
import 'package:station/repository/station_repository.dart';
import 'package:rxdart/streams.dart';

class StationDetailsCubit extends Cubit<StationDetailsState> {
  final int stationId;
  final String markerLabel;

  final StationRepository stationRepository =
      StationModuleFactory.createStationRepository();

  final PriceRepository priceRepository =
      StationModuleFactory.createPriceRepository();

  StationDetailsCubit(this.stationId, this.markerLabel)
      : super(LoadingStationDetailsState(title: markerLabel)) {
    _fetchStation();
  }

  void _fetchStation() {
    emit(LoadingStationDetailsState(title: markerLabel));

    CombineLatestStream.combine2(
            stationRepository.get(stationId), priceRepository.get(stationId),
            (stationResult, priceResult) {
      return stationResult.when((station) {
        return priceResult.when((price) {
          return DetailStationDetailsState(
              title: station.name.isNotEmpty ? station.name : station.brand,
              coordinate: station.coordinate,
              address:
                  "${station.address.street} ${station.address.houseNumber}\n${station.address.postCode} ${station.address.city}\n${station.address.country}",
              e5Price: _priceText(price.e5Price),
              e10Price: _priceText(price.e10Price),
              dieselPrice: _priceText(price.dieselPrice));
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
}
