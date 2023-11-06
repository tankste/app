import 'package:core/config/config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:station/ui/details/cubit/station_details_state.dart';
import 'package:station/repository/station_repository.dart';
import 'package:station/usecase/get_station_use_case.dart';

class StationDetailsCubit extends Cubit<StationDetailsState> {
  final String stationId;

  final GetStationUseCase getStationUseCase = GetStationUseCaseImpl(
      TankerkoenigStationRepository(FileConfigRepository()));

  StationDetailsCubit(this.stationId) : super(StationDetailsState.loading()) {
    _fetchStation();
  }

  void _fetchStation() {
    emit(StationDetailsState.loading());

    getStationUseCase
        .invoke(stationId)
        .then((station) => emit(StationDetailsState.success(station)))
        .catchError((error) => emit(StationDetailsState.failure(error)));
  }

  void onRetryClicked() {
    _fetchStation();
  }
}
