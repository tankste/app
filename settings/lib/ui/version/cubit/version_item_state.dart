import 'package:core/cubit/base_state.dart';

class VersionItemState extends BaseState {
  final String? version;
  final bool? isDeveloperModeEnabledInfoVisible;

  VersionItemState(status, this.version, this.isDeveloperModeEnabledInfoVisible, error)
      : super(status, error);

  static VersionItemState loading() {
    return VersionItemState(Status.loading, null, null, null);
  }

  static VersionItemState success(String version, bool isDeveloperModeEnabledInfoVisible) {
    return VersionItemState(Status.success, version, isDeveloperModeEnabledInfoVisible, null);
  }

  static VersionItemState failure(Exception exception) {
    return VersionItemState(Status.failure, null, null, exception);
  }
}
