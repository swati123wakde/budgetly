import '../error/failures.dart';

/// Lightweight Either replacement using Dart 3 sealed classes.
sealed class Result<T> {
  const Result();

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    return switch (this) {
      Ok<T>(:final data) => onSuccess(data),
      Err<T>(:final failure) => onFailure(failure),
    };
  }
}

final class Ok<T> extends Result<T> {
  const Ok(this.data);
  final T data;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}