import 'package:core/cubit/base_state.dart';
import 'package:map/usecase/get_map_provider_use_case.dart';

class MapState extends BaseState {
  final MapProvider? mapProvider;

  MapState(status, this.mapProvider, error) : super(status, error);

  static MapState loading() {
    return MapState(Status.loading, null, null);
  }

  static MapState success(MapProvider mapProvider) {
    return MapState(Status.success, mapProvider, null);
  }

  static MapState failure(Exception exception) {
    return MapState(Status.failure, null, exception);
  }
}
