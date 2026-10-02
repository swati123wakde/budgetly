import 'package:bloc_test/bloc_test.dart';
import 'package:budgetly/core/error/failures.dart';
import 'package:budgetly/core/utils/result.dart';
import 'package:budgetly/features/auth/domain/entities/user_entity.dart';
import 'package:budgetly/features/auth/domain/repositories/auth_repository.dart';
import 'package:budgetly/features/auth/domain/usecases/login_with_email.dart';
import 'package:budgetly/features/auth/domain/usecases/login_with_google.dart';
import 'package:budgetly/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.fail = false});
  final bool fail;

  static const user = UserEntity(id: '1', email: 'a@b.com');

  @override
  Future<Result<UserEntity>> loginWithEmail({required String email, required String password}) async =>
      fail ? const Err<UserEntity>(AuthFailure()) : const Ok<UserEntity>(user);

  @override
  Future<Result<UserEntity>> loginWithGoogle() async => const Ok<UserEntity>(user);
}

LoginCubit _cubit({bool fail = false}) {
  final repo = _FakeAuthRepository(fail: fail);
  return LoginCubit(loginWithEmail: LoginWithEmail(repo), loginWithGoogle: LoginWithGoogle(repo));
}

void main() {
  group('LoginCubit', () {
    blocTest<LoginCubit, LoginState>(
      'shows validation errors for bad input and does not submit',
      build: _cubit,
      act: (c) => c
        ..emailChanged('not-an-email')
        ..passwordChanged('123')
        ..submit(),
      verify: (c) {
        expect(c.state.emailError, isNotNull);
        expect(c.state.passwordError, isNotNull);
        expect(c.state.status, LoginStatus.idle);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits submitting then success for valid credentials',
      build: _cubit,
      seed: () => const LoginState(email: 'a@b.com', password: 'secret1'),
      act: (c) => c.submit(),
      expect: () => [
        isA<LoginState>().having((s) => s.status, 'status', LoginStatus.submitting),
        isA<LoginState>()
            .having((s) => s.status, 'status', LoginStatus.success)
            .having((s) => s.user, 'user', _FakeAuthRepository.user),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits failure with message when repository fails',
      build: () => _cubit(fail: true),
      seed: () => const LoginState(email: 'a@b.com', password: 'secret1'),
      act: (c) => c.submit(),
      verify: (c) {
        expect(c.state.status, LoginStatus.failure);
        expect(c.state.errorMessage, isNotNull);
      },
    );
  });
}