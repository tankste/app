abstract class OverviewState {}

class LoadingOverviewState extends OverviewState {}

class BalanceOverviewState extends OverviewState {
  int gaugePercentage;
  double earned;
  double spent;

  BalanceOverviewState({required this.gaugePercentage, required this.earned, required this.spent});
}

class ErrorOverviewState extends OverviewState {
  String errorDetails;

  ErrorOverviewState({required this.errorDetails});
}