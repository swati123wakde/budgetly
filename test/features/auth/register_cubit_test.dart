import 'package:bloc_test/bloc_test.dart';
import 'package:budgetly/core/error/failures.dart';
import 'package:budgetly/core/utils/result.dart';
import 'package:budgetly/features/auth/domain/entities/user_entity.dart';
import 'package:budgetly/features/auth/domain/repositories/auth_repository.dart';
import 'package:budgetly/features/auth/domain/usecases/login_with_google.dart';
import 'package:budgetly/features/auth/domain/usecases/register_with_email.dart';
import 'package:budgetly/features/auth/presentation/cubit/register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.fail = false});
  final bool fail;

  static const user = UserEntity(id: '1', email: 'a@b.com');

  @override
  Future<Result<UserEntity>> loginWithEmail({required String email, required String password}) async =>
      const Ok<UserEntity>(user);

  @override
  Future<Result<UserEntity>> loginWithGoogle() async => const Ok<UserEntity>(user);

  @override
  Future<Result<UserEntity>> registerWithEmail({required String email, required String password}) async =>
      fail ? const Err<UserEntity>(AuthFailure('Taken')) : const Ok<UserEntity>(user);
}

RegisterCubit _cubit({bool fail = false}) {
  final repo = _FakeAuthRepository(fail: fail);
  return RegisterCubit(
    registerWithEmail: RegisterWithEmail(repo),
    loginWithGoogle: LoginWithGoogle(repo),
  );
}

void main() {
  group('RegisterCubit', () {
    test('needs all three fields before the button enables', () {
      final cubit = _cubit();
      expect(cubit.state.canSubmit, isFalse);
      cubit
        ..emailChanged('a@b.com')
        ..passwordChanged('secret1');
      expect(cubit.state.canSubmit, isFalse);
      cubit.confirmChanged('secret1');
      expect(cubit.state.canSubmit, isTrue);
    });

    blocTest<RegisterCubit, RegisterState>(
      'flags mismatched passwords and does not submit',
      build: _cubit,
      seed: () => const RegisterState(email: 'a@b.com', password: 'secret1', confirm: 'secret2'),
      act: (c) => c.submit(),
      verify: (c) {
        expect(c.state.confirmError, isNotNull);
        expect(c.state.status, RegisterStatus.idle);
      },
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits submitting then success for valid input',
      build: _cubit,
      seed: () => const RegisterState(email: 'a@b.com', password: 'secret1', confirm: 'secret1'),
      act: (c) => c.submit(),
      expect: () => [
        isA<RegisterState>().having((s) => s.status, 'status', RegisterStatus.submitting),
        isA<RegisterState>()
            .having((s) => s.status, 'status', RegisterStatus.success)
            .having((s) => s.user, 'user', _FakeAuthRepository.user),
      ],
    );

    blocTest<RegisterCubit, RegisterState>(
      'shows the error when the email is already used',
      build: () => _cubit(fail: true),
      seed: () => const RegisterState(email: 'a@b.com', password: 'secret1', confirm: 'secret1'),
      act: (c) => c.submit(),
      verify: (c) {
        expect(c.state.status, RegisterStatus.failure);
        expect(c.state.errorMessage, 'Taken');
      },
    );
  });
}
