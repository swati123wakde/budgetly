import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/login_with_google.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required LoginWithEmail loginWithEmail,
    required LoginWithGoogle loginWithGoogle,
  })  : _loginWithEmail = loginWithEmail,
        _loginWithGoogle = loginWithGoogle,
        super(const LoginState());

  final LoginWithEmail _loginWithEmail;
  final LoginWithGoogle _loginWithGoogle;

  void emailChanged(String value) => emit(state.copyWith(
    email: value,
    emailError: () => null,
    status: LoginStatus.idle,
  ));

  void passwordChanged(String value) => emit(state.copyWith(
    password: value,
    passwordError: () => null,
    status: LoginStatus.idle,
  ));

  void togglePasswordVisibility() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));

  Future<void> submit() async {
    if (state.isBusy) return;

    final emailError = Validators.email(state.email);
    final passwordError = Validators.password(state.password);
    if (emailError != null || passwordError != null) {
      emit(state.copyWith(emailError: () => emailError, passwordError: () => passwordError));
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, errorMessage: () => null));
    final result = await _loginWithEmail(LoginParams(email: state.email, password: state.password));
    _handle(result);
  }

  Future<void> continueWithGoogle() async {
    if (state.isBusy) return;
    emit(state.copyWith(status: LoginStatus.googleSubmitting, errorMessage: () => null));
    _handle(await _loginWithGoogle(const NoParams()));
  }

  void _handle(Result<UserEntity> result) {
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: () => failure.message,
      )),
          (user) => emit(state.copyWith(status: LoginStatus.success, user: user)),
    );
  }
}