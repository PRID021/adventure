abstract class Result<F extends Object, S extends Object> {
  factory Result.failure(F f) => Failure(failure: f);

  factory Result.success(S s) => Success(success: s);

  bool isSuccess();

  bool isError();

  S getOrThrow();
}

class Failure<F extends Object, S extends Object> implements Result<F, S> {
  final F _failure;

  Failure({required F failure}) : _failure = failure;

  @override
  bool isSuccess() {
    return false;
  }

  @override
  bool isError() {
    return true;
  }

  @override
  S getOrThrow() {
    // TODO: implement getOrThrow
    throw UnimplementedError();
  }
}

class Success<F extends Object, S extends Object> implements Result<F, S> {
  final S _success;

  Success({required S success}) : _success = success;

  @override
  bool isSuccess() {
    return true;
  }

  @override
  bool isError() {
    return false;
  }

  @override
  S getOrThrow() {
    return _success;
  }
}
