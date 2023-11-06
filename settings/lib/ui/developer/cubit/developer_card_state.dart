import 'package:core/cubit/base_state.dart';
import 'package:settings/model/developer_settings_model.dart';

class DeveloperCardState extends BaseState {
  final bool? isVisible;
  final DeveloperSettingsMapProvider? mapProvider;

  DeveloperCardState(status, this.isVisible, this.mapProvider, error) : super(status, error);

  static DeveloperCardState loading() {
    return DeveloperCardState(Status.loading, null, null, null);
  }

  static DeveloperCardState success(bool isVisible, DeveloperSettingsMapProvider mapProvider) {
    return DeveloperCardState(Status.success, isVisible, mapProvider, null);
  }

  static DeveloperCardState failure(Exception exception) {
    return DeveloperCardState(Status.failure, null, null, exception);
  }
}
