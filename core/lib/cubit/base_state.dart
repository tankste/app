abstract class BaseState {
  final Status status;
  final Exception? error;

  BaseState(this.status, this.error);
}

enum Status {
  init,
  loading,
  success,
  empty,
  failure
}
