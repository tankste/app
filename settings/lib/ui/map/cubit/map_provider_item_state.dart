
abstract class MapProviderItemState {}

class LoadingMapProviderItemState extends MapProviderItemState {}

class ProvidersMapProviderItemState extends MapProviderItemState {
  final List<String> availableProviders;
  final String selectedProvider;

  ProvidersMapProviderItemState(
      {required this.availableProviders, required this.selectedProvider});
}

class ErrorMapProviderItemState extends MapProviderItemState {
  final String errorDetails;

  ErrorMapProviderItemState(
      {required this.errorDetails});
}