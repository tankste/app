import 'package:core/cubit/base_state.dart';
import 'package:settings/model/map_destination_model.dart';

class MapDestinationItemState extends BaseState {
  final String? valueLabel;
  final MapDestinationDestination? value;
  final List<MapDestinationModel>? availableDestinations;

  MapDestinationItemState(
      status, this.value, this.valueLabel, this.availableDestinations, error)
      : super(status, error);

  static MapDestinationItemState loading() {
    return MapDestinationItemState(Status.loading, null, null, null, null);
  }

  static MapDestinationItemState success(MapDestinationDestination value,
      String valueLabel, List<MapDestinationModel> availableDestinations) {
    return MapDestinationItemState(
        Status.success, value, valueLabel, availableDestinations, null);
  }

  static MapDestinationItemState failure(Exception exception) {
    return MapDestinationItemState(Status.failure, null, null, null, exception);
  }
}
