import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithEmail implements UseCase<UserEntity, LoginParams> {
  const LoginWithEmail(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(LoginParams params) =>
      _repository.loginWithEmail(email: params.email.trim(), password: params.password);
}

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}