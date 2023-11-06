import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/usecase/update_fetch_without_location_use_case.dart';
import 'package:settings/usecase/update_percentage_price_range_use_case.dart';
import 'package:settings/ui/feature/cubit/feature_settings_state.dart';

class FeatureSettingsCubit extends Cubit<FeatureSettingsState> {
  final DeveloperSettingsRepository developerSettingsRepository =
      LocalDeveloperSettingsRepository();

  final UpdateFetchWithoutLocationUseCase updateFetchWithoutLocationUseCase =
      UpdateFetchWithoutLocationUseCaseImpl(LocalDeveloperSettingsRepository());

  final UpdatePercentagePriceRangeUseCase updatePercentagePriceRangeUseCase =
      UpdatePercentagePriceRangeUseCaseImpl(LocalDeveloperSettingsRepository());

  FeatureSettingsCubit() : super(FeatureSettingsState.loading()) {
    _fetchDeveloperSettings();
  }

  void _fetchDeveloperSettings() {
    emit(FeatureSettingsState.loading());

    developerSettingsRepository.get().listen((developerSettings) {
      if (isClosed) {
        return;
      }

      emit(FeatureSettingsState.success(
          developerSettings.isFetchingWithoutLocationEnabled,
          developerSettings.isPercentagePriceRangesEnabled));
    }).onError((error) => emit(FeatureSettingsState.failure(error)));
  }

  void onRetryClicked() {
    _fetchDeveloperSettings();
  }

  void onFetchWithoutLocationChanged(bool isEnabled) {
    updateFetchWithoutLocationUseCase.invoke(isEnabled);
  }

  void onPercentagePriceRangesEnabled(bool isEnabled) {
    updatePercentagePriceRangeUseCase.invoke(isEnabled);
  }
}
