import 'package:core/cubit/base_state.dart';

class FeatureSettingsState extends BaseState {
  bool? isFetchingWithoutLocationSelected;
  bool? isPercentagePriceRangesSelected;

  FeatureSettingsState(status, this.isFetchingWithoutLocationSelected,
      this.isPercentagePriceRangesSelected, error)
      : super(status, error);

  static FeatureSettingsState loading() {
    return FeatureSettingsState(Status.loading, null, null, null);
  }

  static FeatureSettingsState success(bool isFetchingWithoutLocationSelected,
      bool isPercentagePriceRangesSelected) {
    return FeatureSettingsState(
        Status.success,
        isFetchingWithoutLocationSelected,
        isPercentagePriceRangesSelected,
        null);
  }

  static FeatureSettingsState failure(Exception exception) {
    return FeatureSettingsState(Status.failure, null, null, exception);
  }
}
