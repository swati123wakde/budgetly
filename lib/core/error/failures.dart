import 'package:equatable/equatable.dart';

/// Domain-level failure. Data layer maps exceptions into these.
sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Invalid email or password.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not load local data.']);
}