import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/register_cubit.dart';
import '../widgets/google_button.dart';
import '../widgets/or_divider.dart';

/// "Create login" — opened from the profile screen.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.status == RegisterStatus.success) {
          // Back to home, keeping the user's data.
          Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.home));
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text(AppStrings.loginCreated)));
        } else if (state.status == RegisterStatus.failure && state.errorMessage != null) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      const AppBackButton(),
                      const SizedBox(width: AppSpacing.md),
                      Text(AppStrings.createLogin, style: AppTextStyles.titleLarge),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    AppStrings.registerSubtitle,
                    style: AppTextStyles.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BlocSelector<RegisterCubit, RegisterState, bool>(
                    selector: (s) => s.status == RegisterStatus.googleSubmitting,
                    builder: (context, loading) =>
                        GoogleButton(isLoading: loading, onPressed: cubit.continueWithGoogle),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const OrDivider(),
                  const SizedBox(height: AppSpacing.lg),

                  BlocSelector<RegisterCubit, RegisterState, String?>(
                    selector: (s) => s.emailError,
                    builder: (context, error) => AppTextField(
                      label: AppStrings.email,
                      hint: AppStrings.emailHint,
                      prefixIcon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      errorText: error,
                      onChanged: cubit.emailChanged,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  BlocBuilder<RegisterCubit, RegisterState>(
                    buildWhen: (p, c) =>
                    p.passwordError != c.passwordError || p.obscurePassword != c.obscurePassword,
                    builder: (context, state) => AppTextField(
                      label: AppStrings.password,
                      hint: AppStrings.newPasswordHint,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: state.obscurePassword,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      errorText: state.passwordError,
                      onChanged: cubit.passwordChanged,
                      suffix: _EyeButton(
                        obscured: state.obscurePassword,
                        onPressed: cubit.togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  BlocBuilder<RegisterCubit, RegisterState>(
                    buildWhen: (p, c) =>
                    p.confirmError != c.confirmError || p.obscureConfirm != c.obscureConfirm,
                    builder: (context, state) => AppTextField(
                      label: AppStrings.confirmPassword,
                      hint: AppStrings.confirmPasswordHint,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: state.obscureConfirm,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      errorText: state.confirmError,
                      onChanged: cubit.confirmChanged,
                      onSubmitted: (_) => cubit.submit(),
                      suffix: _EyeButton(
                        obscured: state.obscureConfirm,
                        onPressed: cubit.toggleConfirmVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  BlocBuilder<RegisterCubit, RegisterState>(
                    buildWhen: (p, c) => p.canSubmit != c.canSubmit || p.status != c.status,
                    builder: (context, state) => PrimaryButton(
                      label: AppStrings.createLogin,
                      isLoading: state.status == RegisterStatus.submitting,
                      onPressed: state.canSubmit ? cubit.submit : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EyeButton extends StatelessWidget {
  const _EyeButton({required this.obscured, required this.onPressed});

  final bool obscured;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: obscured ? AppStrings.showPassword : AppStrings.hidePassword,
      icon: Icon(obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
    );
  }
}
