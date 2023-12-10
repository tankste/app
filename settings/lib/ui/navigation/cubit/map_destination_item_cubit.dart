import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/model/map_destination_model.dart';
import 'package:settings/repository/map_destination_repository.dart';
import 'package:settings/ui/navigation/cubit/map_destination_item_state.dart';
import 'package:core/common/future.dart';

class MapDestinationItemCubit extends Cubit<MapDestinationItemState> {
  final MapDestinationRepository mapDestinationRepository =
      LocalMapDestinationRepository();

  MapDestinationItemCubit() : super(MapDestinationItemState.loading()) {
    _fetchMapDestination();
  }

  void _fetchMapDestination() {
    emit(MapDestinationItemState.loading());

    waitConcurrently2(mapDestinationRepository.listAvailable(),
            mapDestinationRepository.get())
        .then((result) {
      List<MapDestinationModel> availableDestinations = result.item1;
      MapDestinationModel currentMapDestination = result.item2;

      if (isClosed) {
        return;
      }

      emit(MapDestinationItemState.success(currentMapDestination.destination,
          currentMapDestination.label, availableDestinations));
    }).catchError((error) => emit(MapDestinationItemState.failure(error)));
  }

  void onMapChanged(MapDestinationDestination mapDestination) {
    mapDestinationRepository
        .update(MapDestinationModel("", mapDestination))
        .then((_) => _fetchMapDestination());
  }
}
