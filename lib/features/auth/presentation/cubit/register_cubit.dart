import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/register_with_email.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required RegisterWithEmail registerWithEmail,
    required LoginWithGoogle loginWithGoogle,
  })  : _registerWithEmail = registerWithEmail,
        _loginWithGoogle = loginWithGoogle,
        super(const RegisterState());

  final RegisterWithEmail _registerWithEmail;
  final LoginWithGoogle _loginWithGoogle;

  void emailChanged(String value) => emit(state.copyWith(
    email: value,
    emailError: () => null,
    status: RegisterStatus.idle,
  ));

  void passwordChanged(String value) => emit(state.copyWith(
    password: value,
    passwordError: () => null,
    status: RegisterStatus.idle,
  ));

  void confirmChanged(String value) => emit(state.copyWith(
    confirm: value,
    confirmError: () => null,
    status: RegisterStatus.idle,
  ));

  void togglePasswordVisibility() =>
      emit(state.copyWith(obscurePassword: !state.obscurePassword));

  void toggleConfirmVisibility() => emit(state.copyWith(obscureConfirm: !state.obscureConfirm));

  Future<void> submit() async {
    if (state.isBusy) return;

    final emailError = Validators.email(state.email);
    final passwordError = Validators.password(state.password);
    final confirmError = Validators.confirmPassword(state.password, state.confirm);
    if (emailError != null || passwordError != null || confirmError != null) {
      emit(state.copyWith(
        emailError: () => emailError,
        passwordError: () => passwordError,
        confirmError: () => confirmError,
      ));
      return;
    }

    emit(state.copyWith(status: RegisterStatus.submitting, errorMessage: () => null));
    _handle(await _registerWithEmail(RegisterParams(email: state.email, password: state.password)));
  }

  Future<void> continueWithGoogle() async {
    if (state.isBusy) return;
    emit(state.copyWith(status: RegisterStatus.googleSubmitting, errorMessage: () => null));
    _handle(await _loginWithGoogle(const NoParams()));
  }

  void _handle(Result<UserEntity> result) {
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: () => failure.message,
      )),
          (user) => emit(state.copyWith(status: RegisterStatus.success, user: user)),
    );
  }
}
