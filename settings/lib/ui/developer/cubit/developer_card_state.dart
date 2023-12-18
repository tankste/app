abstract class DeveloperCardState {}

class LoadingDeveloperCardState extends DeveloperCardState {}

class EnabledDeveloperCardState extends DeveloperCardState {}

class DisabledDeveloperCardState extends DeveloperCardState {}

class ErrorDeveloperCardState extends DeveloperCardState {
  final String errorDetails;

  ErrorDeveloperCardState({required this.errorDetails});
}

class SuccessDeleteCacheEnabledDeveloperCardState
    extends EnabledDeveloperCardState {}

class ErrorDeleteCacheEnabledDeveloperCardState
    extends EnabledDeveloperCardState {
  final String errorDetails;

  ErrorDeleteCacheEnabledDeveloperCardState({required this.errorDetails});
}
