import 'package:core/config/config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/ui/details/cubit/station_details_state.dart';
import 'package:station/repository/station_repository.dart';

class StationDetailsCubit extends Cubit<StationDetailsState> {
  final int stationId;
  final String markerLabel;

  final StationRepository stationRepository =
  StationModuleFactory.createStationRepository();

  StationDetailsCubit(this.stationId, this.markerLabel)
      : super(LoadingStationDetailsState(title: markerLabel)) {
    _fetchStation();
  }

  void _fetchStation() {
    emit(LoadingStationDetailsState(title: markerLabel));

    stationRepository
        .get(stationId)
        .first //TODO: use stream benefits
        .then((result) {
      if (isClosed) {
        return;
      }

      result.when(
            (station) {
          emit(DetailStationDetailsState(
              coordinate: station.coordinate,
              address: "${station.address.street} ${station.address
                  .houseNumber}\n${station.address.postCode} ${station.address
                  .city}\n${station.address.country}",
              title: station.name.isNotEmpty ? station.name : station.brand));
        },
            (error) =>
            emit(ErrorStationDetailsState(
                errorDetails: error.toString(), title: markerLabel)),
      );
    });
  }

  void onRetryClicked() {
    _fetchStation();
  }
}
