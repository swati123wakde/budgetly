import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Outlined "Continue with Google" button. The G mark is drawn in code so the
/// project needs no image assets; swap in the official asset if you prefer.
class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, required this.onPressed, this.isLoading = false});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textSecondary),
      )
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Text(
              'G',
              style: AppTextStyles.titleMedium.copyWith(
                color: const Color(0xFF4285F4),
                fontWeight: FontWeight.w800,
                fontSize: 15,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(AppStrings.continueWithGoogle),
        ],
      ),
    );
  }
}