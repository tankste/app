
import 'package:sponsor/repository/balance_repository.dart';

class SponsorModuleFactory {

  static BalanceRepository createBalanceRepository() {
    return TanksteWebBalanceRepository();
  }
}