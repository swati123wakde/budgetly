import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail({required String email, required String password});
  Future<UserModel> loginWithGoogle();
}

/// Fake backend so the flow works end to end.
/// Replace with Firebase Auth / your REST API — only this file changes.
///
/// Demo rule: any valid email works, except the password "wrongpass"
/// which returns an auth error so you can see the failure state.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> loginWithEmail({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (password == 'wrongpass') {
      throw const AuthException('Incorrect email or password.');
    }
    return UserModel(id: 'u_${email.hashCode}', email: email, name: email.split('@').first);
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    return const UserModel(id: 'u_google', email: 'demo@gmail.com', name: 'Demo');
  }
}