abstract class SupportCardState {}

class LoadingSupportCardState extends SupportCardState {}

class ErrorSupportCardState extends SupportCardState {
  final String errorDetails;

  ErrorSupportCardState({required this.errorDetails});
}

class DataSupportCardState extends SupportCardState {
  final bool isLogEnabled;
  final bool isViewLogsVisible;

  DataSupportCardState({
    required this.isLogEnabled,
    required this.isViewLogsVisible,
  });
}