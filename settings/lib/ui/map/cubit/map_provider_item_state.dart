import 'package:settings/model/map_provider_model.dart';
import 'package:tuple/tuple.dart';

abstract class MapProviderItemState {}

class LoadingMapProviderItemState extends MapProviderItemState {}

class ProvidersMapProviderItemState extends MapProviderItemState {
  final Map<MapProvider, String> availableProviders;
  final Tuple2<MapProvider, String> selectedProvider;

  ProvidersMapProviderItemState(
      {required this.availableProviders, required this.selectedProvider});
}

class ErrorMapProviderItemState extends MapProviderItemState {
  final String errorDetails;

  ErrorMapProviderItemState({required this.errorDetails});
}

class SaveErrorMapProviderItemState extends LoadingMapProviderItemState {
  final String errorDetails;

  SaveErrorMapProviderItemState({required this.errorDetails});
}
