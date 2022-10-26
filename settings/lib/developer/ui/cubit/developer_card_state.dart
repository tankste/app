import 'package:core/cubit/base_state.dart';

class DeveloperCardState extends BaseState {
  final bool? isVisible;

  DeveloperCardState(status, this.isVisible, error) : super(status, error);

  static DeveloperCardState loading() {
    return DeveloperCardState(Status.loading, null, null);
  }

  static DeveloperCardState success(bool isVisible) {
    return DeveloperCardState(Status.success, isVisible, null);
  }

  static DeveloperCardState failure(Exception exception) {
    return DeveloperCardState(Status.failure, null, exception);
  }
}
