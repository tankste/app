import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/repository/log_repository.dart';
import 'package:settings/ui/currency/cubit/currency_item_state.dart';
import 'package:settings/ui/support/cubit/support_card_state.dart';

class SupportCardCubit extends Cubit<SupportCardState> {
  final LogRepository _logRepository =
      SettingsModuleFactory.createLogRepository();

  SupportCardCubit() : super(LoadingSupportCardState()) {
    _loadLog();
  }

  void _loadLog() {
    emit(LoadingSupportCardState());

    _logRepository.get().listen((result) {
      if (isClosed) {
        return;
      }

      emit(result.when(
          (isEnabled) => DataSupportCardState(
              isLogEnabled: isEnabled, isViewLogsVisible: isEnabled),
          (error) => ErrorSupportCardState(errorDetails: error.toString())));
    });
  }

  void onLogEnabledChanged(bool isEnabled) {
    _logRepository.update(isEnabled);
  }
}
