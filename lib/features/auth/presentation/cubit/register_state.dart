part of 'register_cubit.dart';

enum RegisterStatus { idle, submitting, googleSubmitting, success, failure }

class RegisterState extends Equatable {
  const RegisterState({
    this.email = '',
    this.password = '',
    this.confirm = '',
    this.emailError,
    this.passwordError,
    this.confirmError,
    this.obscurePassword = true,
    this.obscureConfirm = true,
    this.status = RegisterStatus.idle,
    this.errorMessage,
    this.user,
  });

  final String email;
  final String password;
  final String confirm;
  final String? emailError;
  final String? passwordError;
  final String? confirmError;
  final bool obscurePassword;
  final bool obscureConfirm;
  final RegisterStatus status;
  final String? errorMessage;
  final UserEntity? user;

  bool get isBusy =>
      status == RegisterStatus.submitting || status == RegisterStatus.googleSubmitting;
  bool get canSubmit =>
      email.isNotEmpty && password.isNotEmpty && confirm.isNotEmpty && !isBusy;

  /// Nullable fields take a getter so callers can explicitly clear them.
  RegisterState copyWith({
    String? email,
    String? password,
    String? confirm,
    String? Function()? emailError,
    String? Function()? passwordError,
    String? Function()? confirmError,
    bool? obscurePassword,
    bool? obscureConfirm,
    RegisterStatus? status,
    String? Function()? errorMessage,
    UserEntity? user,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirm: confirm ?? this.confirm,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError: passwordError != null ? passwordError() : this.passwordError,
      confirmError: confirmError != null ? confirmError() : this.confirmError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
    email, password, confirm, emailError, passwordError, confirmError,
    obscurePassword, obscureConfirm, status, errorMessage, user,
  ];
}
