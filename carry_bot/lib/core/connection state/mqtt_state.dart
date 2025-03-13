abstract class MQTTState<T> {
  final T? data;
  final String? error;
  const MQTTState({
    this.data,
    this.error,
  });

}


class MQTTSuccess<T> extends MQTTState<T> {
  const MQTTSuccess(T data) : super(data: data);
}

class MQTTFailed<T> extends MQTTState<T> {
  const MQTTFailed(String error) : super(error: error);
}