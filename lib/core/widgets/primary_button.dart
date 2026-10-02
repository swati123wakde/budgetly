import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

/// Full-width matte-red button with built-in loading state.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: AnimatedSwitcher(
        duration: AppDurations.fast,
        child: isLoading
            ? const SizedBox(
          key: ValueKey('loading'),
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.textPrimary),
        )
            : Row(
          key: const ValueKey('label'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (trailingIcon != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(trailingIcon, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}