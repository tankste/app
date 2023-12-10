import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/repository/map_provider_repository.dart';
import 'package:settings/ui/map/cubit/map_provider_item_state.dart';
import 'package:rxdart/streams.dart';

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
              selectedProvider: mapProvider.label,
              availableProviders:
                  availableProviders.map((p) => p.label).toList());
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

  void onRetryClicked() {
    _fetchMapProvider();
  }
}
