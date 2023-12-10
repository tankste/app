import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/model/map_provider_model.dart';
import 'package:settings/repository/map_provider_repository.dart';
import 'package:settings/ui/map/cubit/map_provider_item_state.dart';
import 'package:rxdart/streams.dart';
import 'package:tuple/tuple.dart';

class MapProviderItemCubit extends Cubit<MapProviderItemState> {
  final MapProviderRepository _mapProviderRepository =
      SettingsModuleFactory.createMapProviderRepository();

  MapProviderItemCubit() : super(LoadingMapProviderItemState()) {
    _fetchMapProvider();
  }

  void _fetchMapProvider() {
    CombineLatestStream.combine2(
        _mapProviderRepository.listAvailable(), _mapProviderRepository.get(),
        (availableProviderResult, mapProviderResult) {
      return availableProviderResult.when((availableProviders) {
        return mapProviderResult.when((mapProvider) {
          return ProvidersMapProviderItemState(
              selectedProvider: Tuple2(mapProvider.provider, mapProvider.label),
              availableProviders: Map.fromEntries(availableProviders
                  .map((p) => MapEntry(p.provider, p.label))));
        },
            (error) =>
                ErrorMapProviderItemState(errorDetails: error.toString()));
      }, (error) => ErrorMapProviderItemState(errorDetails: error.toString()));
    }).listen((state) {
      if (isClosed) {
        return;
      }

      emit(state);
    });
  }

  void onProviderChanged(MapProvider provider) {
    emit(LoadingMapProviderItemState());

    _mapProviderRepository
        .update(MapProviderModel("", provider))
        .first
        .then((result) {
      if (isClosed) {
        return;
      }

      if (result.isError()) {
        emit(ErrorMapProviderItemState(
            errorDetails: result.tryGetError()!.toString()));
      }
    });
  }

  void onRetryClicked() {
    _fetchMapProvider();
  }
}
