import 'package:settings/map/model/map_destination_model.dart';
import 'package:settings/map/repository/map_destination_repository.dart';

abstract class GetMapDestinationUseCase {
  Future<MapDestinationModel> invoke();
}

class GetMapDestinationUseCaseImpl extends GetMapDestinationUseCase {
  final MapDestinationRepository _mapDestinationRepository;

  GetMapDestinationUseCaseImpl(this._mapDestinationRepository);

  @override
  Future<MapDestinationModel> invoke() {
    return _mapDestinationRepository.get();
  }
}