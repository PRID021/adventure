abstract class CatchError {
  final String? message;
  const CatchError([this.message]);
}

class UnknownError extends CatchError {
  const UnknownError([super.message]);
}
