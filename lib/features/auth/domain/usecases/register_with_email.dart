import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterWithEmail implements UseCase<UserEntity, RegisterParams> {
  const RegisterWithEmail(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(RegisterParams params) =>
      _repository.registerWithEmail(email: params.email.trim(), password: params.password);
}

class RegisterParams extends Equatable {
  const RegisterParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
