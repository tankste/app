import 'package:settings/model/map_destination_model.dart';
import 'package:settings/repository/map_destination_repository.dart';

abstract class UpdateMapDestinationUseCase {
  Future<void> invoke(MapDestinationModel mapDestination);
}

class UpdateMapDestinationUseCaseImpl extends UpdateMapDestinationUseCase {
  final MapDestinationRepository _mapDestinationRepository;

  UpdateMapDestinationUseCaseImpl(this._mapDestinationRepository);

  @override
  Future<void> invoke(MapDestinationModel mapDestination) {
    return _mapDestinationRepository.update(mapDestination);
  }
}
