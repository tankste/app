import 'package:station/repository/station_repository.dart';
import 'package:station/station_model.dart';

abstract class GetStationUseCase {

  Future<StationModel> invoke(String stationId);
}

class GetStationUseCaseImpl extends GetStationUseCase {

  final StationRepository _stationRepository;

  GetStationUseCaseImpl(this._stationRepository);

  @override
  Future<StationModel> invoke(String stationId) {
    return _stationRepository.get(stationId);
  }
}