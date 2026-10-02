import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogle implements UseCase<UserEntity, NoParams> {
  const LoginWithGoogle(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(NoParams params) => _repository.loginWithGoogle();
}