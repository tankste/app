import 'package:core/di/core_module_factory.dart';
import 'package:report/repository/config_repository.dart';
import 'package:report/repository/report_repository.dart';

class ReportModuleFactory {
  static ReportRepository createReportRepository() {
    return TanksteWebReportRepository(CoreModuleFactory.createDeviceRepository(), createConfigRepository());
  }

  static ConfigRepository createConfigRepository() {
    return LocalConfigRepository(CoreModuleFactory.createConfigRepository());
  }
}
