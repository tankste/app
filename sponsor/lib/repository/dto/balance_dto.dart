import 'package:sponsor/model/balance_model.dart';

class BalanceDto {
  final double? earned;
  final double? spentFixed;
  final double? spentVariable;
  final double? balance;

  BalanceDto({
    required this.earned,
    required this.spentFixed,
    required this.spentVariable,
    required this.balance,
  });

  factory BalanceDto.fromJson(Map<String, dynamic> parsedJson) {
    return BalanceDto(
      earned: parsedJson['earned'],
      spentFixed: parsedJson['spentFixed'],
      spentVariable: parsedJson['spentVariable'],
      balance: parsedJson['balance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'earned': earned,
      'spentFixed': spentFixed,
      'spentVariable': spentVariable,
      'balance': balance,
    };
  }

  BalanceModel toModel() {
    return BalanceModel(
      earned: earned ?? 0.0,
      spent: (spentFixed ?? 0) + (spentVariable ?? 0),
    );
  }

  @override
  String toString() {
    return 'BalanceDto{earned: $earned, spentFixed: $spentFixed, spentVariable: $spentVariable, balance: $balance}';
  }
}
