class BalanceModel {
  double spent;
  double earned;

  BalanceModel({required this.spent, required this.earned});

  @override
  String toString() {
    return 'BalanceModel{spent: $spent, earned: $earned}';
  }
}
