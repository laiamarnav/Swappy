enum AsyncStatus { idle, loading, success, error }

class AsyncState<T> {
  final AsyncStatus status;
  final T? data;
  final String? error;

  const AsyncState._(this.status, this.data, this.error);

  const AsyncState.idle() : this._(AsyncStatus.idle, null, null);
  const AsyncState.loading() : this._(AsyncStatus.loading, null, null);
  const AsyncState.success(T data) : this._(AsyncStatus.success, data, null);
  const AsyncState.error(String error) : this._(AsyncStatus.error, null, error);
}
