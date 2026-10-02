import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/dollar_logo.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/card_stack_illustration.dart';

/// First screen after splash. "Let's get started" -> GetStarted,
/// "Already have an account? Log in" -> Login.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  Animation<double> _interval(double begin, double end) => CurvedAnimation(
    parent: _controller,
    curve: Interval(begin, end, curve: Curves.easeOutCubic),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const DollarLogo(size: 34),
                  const SizedBox(width: AppSpacing.sm),
                  Text(AppStrings.appName, style: AppTextStyles.titleLarge),
                ],
              ),
              Expanded(
                child: _FadeSlide(
                  animation: _interval(0, 0.6),
                  child: const Center(
                    child: FittedBox(fit: BoxFit.scaleDown, child: CardStackIllustration()),
                  ),
                ),
              ),
              _FadeSlide(
                animation: _interval(0.25, 0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.welcomeOverline, style: AppTextStyles.overline),
                    const SizedBox(height: AppSpacing.sm),
                    Text(AppStrings.welcomeTitleLine1, style: AppTextStyles.displayLarge),
                    Text(
                      AppStrings.welcomeTitleLine2,
                      style: AppTextStyles.displayLarge.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(AppStrings.welcomeSubtitle, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _FadeSlide(
                animation: _interval(0.45, 1),
                child: Column(
                  children: [
                    PrimaryButton(
                      label: AppStrings.getStarted,
                      trailingIcon: Icons.arrow_forward_rounded,
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.getStarted),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
                      child: Text.rich(
                        TextSpan(
                          text: '${AppStrings.alreadyHaveAccount} ',
                          children: [
                            TextSpan(
                              text: AppStrings.logIn,
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.matteRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.appVersion,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _FadeSlide extends StatelessWidget {
  const _FadeSlide({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }
}