abstract class OverviewState {}

class LoadingOverviewState extends OverviewState {}

class BalanceOverviewState extends OverviewState {
  int gaugePercentage;
  String balance;

  BalanceOverviewState({required this.gaugePercentage, required this.balance});
}

class ErrorOverviewState extends OverviewState {
  String errorDetails;

  ErrorOverviewState({required this.errorDetails});
}