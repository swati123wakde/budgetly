import '../utils/result.dart';

/// Base contract for every use case in the domain layer.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Use when a use case takes no input.
class NoParams {
  const NoParams();
}