abstract class DeveloperCardState {}

class LoadingDeveloperCardState extends DeveloperCardState {}

class EnabledDeveloperCardState extends DeveloperCardState {}

class DisabledDeveloperCardState extends DeveloperCardState {}

class ErrorDeveloperCardState extends DeveloperCardState {
  final String errorDetails;

  ErrorDeveloperCardState({required this.errorDetails});
}

class SuccessRestLocationPermissionEnabledDeveloperCardState
    extends EnabledDeveloperCardState {}

class ErrorRestLocationPermissionEnabledDeveloperCardState
    extends EnabledDeveloperCardState {
  final String errorDetails;

  ErrorRestLocationPermissionEnabledDeveloperCardState(
      {required this.errorDetails});
}
