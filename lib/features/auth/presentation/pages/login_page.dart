import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/login_cubit.dart';
import '../widgets/google_button.dart';
import '../widgets/or_divider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
        } else if (state.status == LoginStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context)
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
                  const Align(alignment: Alignment.centerLeft, child: AppBackButton()),
                  const SizedBox(height: AppSpacing.xl),
                  Text(AppStrings.loginTitle, style: AppTextStyles.headlineLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text(AppStrings.loginSubtitle, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: AppSpacing.xl),

                  BlocSelector<LoginCubit, LoginState, bool>(
                    selector: (s) => s.status == LoginStatus.googleSubmitting,
                    builder: (context, loading) =>
                        GoogleButton(isLoading: loading, onPressed: cubit.continueWithGoogle),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const OrDivider(),
                  const SizedBox(height: AppSpacing.lg),

                  BlocSelector<LoginCubit, LoginState, String?>(
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

                  BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (p, c) =>
                    p.passwordError != c.passwordError || p.obscurePassword != c.obscurePassword,
                    builder: (context, state) => AppTextField(
                      label: AppStrings.password,
                      hint: AppStrings.passwordHint,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: state.obscurePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      errorText: state.passwordError,
                      onChanged: cubit.passwordChanged,
                      onSubmitted: (_) => cubit.submit(),
                      suffix: IconButton(
                        onPressed: cubit.togglePasswordVisibility,
                        icon: Icon(
                          state.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password reset is coming soon.')),
                      ),
                      child: const Text(AppStrings.forgotPassword),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (p, c) => p.canSubmit != c.canSubmit || p.status != c.status,
                    builder: (context, state) => PrimaryButton(
                      label: AppStrings.logIn,
                      isLoading: state.status == LoginStatus.submitting,
                      onPressed: state.canSubmit ? cubit.submit : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.noAccount, style: AppTextStyles.bodyMedium),
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pushReplacementNamed(AppRoutes.getStarted),
                        child: Text(
                          AppStrings.signUp,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.matteRedLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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