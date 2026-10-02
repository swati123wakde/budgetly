part of 'login_cubit.dart';

enum LoginStatus { idle, submitting, googleSubmitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.obscurePassword = true,
    this.status = LoginStatus.idle,
    this.errorMessage,
    this.user,
  });

  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool obscurePassword;
  final LoginStatus status;
  final String? errorMessage;
  final UserEntity? user;

  bool get isBusy => status == LoginStatus.submitting || status == LoginStatus.googleSubmitting;
  bool get canSubmit => email.isNotEmpty && password.isNotEmpty && !isBusy;

  /// Nullable fields take a getter so callers can explicitly clear them.
  LoginState copyWith({
    String? email,
    String? password,
    String? Function()? emailError,
    String? Function()? passwordError,
    bool? obscurePassword,
    LoginStatus? status,
    String? Function()? errorMessage,
    UserEntity? user,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError: passwordError != null ? passwordError() : this.passwordError,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, emailError, passwordError, obscurePassword, status, errorMessage, user];
}