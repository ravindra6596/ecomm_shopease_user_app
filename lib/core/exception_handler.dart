sealed class Result<S, E extends Exception> {
  Result();
}

final  class Success<S, E extends Exception> extends Result<S, E> {
  final S data;

  Success(this.data);
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  final String error;

  Failure(this.error);
}
