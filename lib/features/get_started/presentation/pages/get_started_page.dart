import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../cubit/get_started_cubit.dart';
import '../widgets/tracking_option_card.dart';
import '../widgets/tracking_option_shimmer.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetStartedCubit, GetStartedState>(
      listenWhen: (prev, curr) =>
      prev.completedMode != curr.completedMode || prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.completedMode != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.home,
                (_) => false,
            arguments: state.completedMode,
          );
        } else if (state.errorMessage != null && state.status == GetStartedStatus.loaded) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                const _Header(),
                const SizedBox(height: AppSpacing.xl),
                Text(AppStrings.getStartedTitle, style: AppTextStyles.headlineLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(AppStrings.getStartedSubtitle, style: AppTextStyles.bodyMedium),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: BlocBuilder<GetStartedCubit, GetStartedState>(
                    builder: (context, state) => AnimatedSwitcher(
                      duration: AppDurations.medium,
                      child: switch (state.status) {
                        GetStartedStatus.loading => const TrackingOptionShimmer(),
                        GetStartedStatus.failure => _ErrorView(
                          message: state.errorMessage ?? '',
                          onRetry: context.read<GetStartedCubit>().loadOptions,
                        ),
                        GetStartedStatus.loaded => ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: state.options.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, i) {
                            final option = state.options[i];
                            return TrackingOptionCard(
                              option: option,
                              isSelected: state.selected == option.mode,
                              onTap: () => context.read<GetStartedCubit>().select(option.mode),
                            );
                          },
                        ),
                      },
                    ),
                  ),
                ),
                BlocBuilder<GetStartedCubit, GetStartedState>(
                  buildWhen: (p, c) => p.canContinue != c.canContinue || p.isSubmitting != c.isSubmitting,
                  builder: (context, state) => PrimaryButton(
                    label: AppStrings.continueText,
                    isLoading: state.isSubmitting,
                    onPressed: state.canContinue ? context.read<GetStartedCubit>().submit : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppBackButton(),
        const Spacer(),
        Text(AppStrings.getStartedOverline, style: AppTextStyles.overline),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 56,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: const LinearProgressIndicator(
              value: 0.5,
              minHeight: 4,
              backgroundColor: AppColors.surfaceHigh,
              color: AppColors.matteRed,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 40),
        const SizedBox(height: AppSpacing.sm),
        Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}