import 'package:core/cubit/base_state.dart';
import 'package:station/station_model.dart';

class StationDetailsState extends BaseState {
  final StationModel? station;

  StationDetailsState(status, this.station, error): super(status, error);

  static StationDetailsState loading() {
    return StationDetailsState(Status.loading, null, null);
  }

  static StationDetailsState success(StationModel station) {
    return StationDetailsState(Status.success, station, null);
  }

  static StationDetailsState failure(Exception exception) {
    return StationDetailsState(Status.failure, null, exception);
  }
}
