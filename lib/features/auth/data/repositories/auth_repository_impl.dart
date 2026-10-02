import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);
  final AuthRemoteDataSource _remote;

  @override
  Future<Result<UserEntity>> loginWithEmail({required String email, required String password}) =>
      _guard(() => _remote.loginWithEmail(email: email, password: password));

  @override
  Future<Result<UserEntity>> loginWithGoogle() => _guard(_remote.loginWithGoogle);

  Future<Result<UserEntity>> _guard(Future<UserEntity> Function() call) async {
    try {
      return Ok<UserEntity>(await call());
    } on AuthException catch (e) {
      return Err<UserEntity>(AuthFailure(e.message ?? 'Invalid email or password.'));
    } on ServerException catch (e) {
      return Err<UserEntity>(ServerFailure(e.message ?? 'Server error. Please try again.'));
    } catch (_) {
      return const Err<UserEntity>(ServerFailure());
    }
  }
}