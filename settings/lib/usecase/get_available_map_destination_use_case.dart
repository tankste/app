import 'package:settings/model/map_destination_model.dart';
import 'package:settings/repository/map_destination_repository.dart';

abstract class GetAvailableMapDestinationUseCase {
  Future<List<MapDestinationModel>> invoke();
}

class GetAvailableMapDestinationUseCaseImpl
    extends GetAvailableMapDestinationUseCase {
  final MapDestinationRepository _mapDestinationRepository;

  GetAvailableMapDestinationUseCaseImpl(this._mapDestinationRepository);

  @override
  Future<List<MapDestinationModel>> invoke() {
    return _mapDestinationRepository.listAvailable();
  }
}
