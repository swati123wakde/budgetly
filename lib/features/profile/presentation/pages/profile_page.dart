import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/profile_avatar.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_sections.dart';

/// Opened from the avatar on home. Only "Create login to personalise" is
/// tappable for now; the other controls are display-only.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, AppSpacing.md, AppSpacing.screenPadding, 0,
              ),
              child: _Header(),
            ),
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final summary = state.summary;
                  return ListView(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    children: [
                      const UpgradeCard(),
                      const SizedBox(height: AppSpacing.xl),
                      Center(child: ProfileAvatar(size: 120, level: summary?.level ?? 1)),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        AppStrings.profileName,
                        style: AppTextStyles.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppStrings.anonymous,
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Center(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                            backgroundColor: AppColors.surfaceElevated,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                          ),
                          child: const Text(AppStrings.createLoginToPersonalise),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (summary == null)
                        state.status == ProfileStatus.failure
                            ? Text(
                          state.errorMessage ?? '',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        )
                            : const AppShimmer(
                          child: Column(
                            children: [
                              ShimmerBox(height: 48),
                              SizedBox(height: AppSpacing.md),
                              ShimmerBox(height: 150, radius: AppRadius.lg),
                            ],
                          ),
                        )
                      else ...[
                        LevelProgress(summary: summary),
                        const SizedBox(height: AppSpacing.lg),
                        WeeklyBonusCard(summary: summary),
                        const SizedBox(height: AppSpacing.lg),
                        Text(AppStrings.dailyStreak, style: AppTextStyles.titleMedium),
                        const Divider(height: AppSpacing.lg),
                        StreakCard(days: summary.streakDays),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
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
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(AppStrings.profile, style: AppTextStyles.titleLarge)),
        // Display-only for now.
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_none_rounded, size: 26, color: AppColors.textSecondary),
            Positioned(
              right: 1,
              top: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.matteRedLight, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        const Icon(Icons.settings_outlined, size: 26, color: AppColors.textSecondary),
      ],
    );
  }
}
