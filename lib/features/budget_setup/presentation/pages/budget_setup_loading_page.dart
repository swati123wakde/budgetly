import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/dollar_loader.dart';
import '../../domain/entities/budget_cycle.dart';

/// Short full-screen moment between picking a cycle and logging the first
/// transaction: the "$" mark spins while the budget is set up.
class BudgetSetupLoadingPage extends StatefulWidget {
  const BudgetSetupLoadingPage({super.key, required this.cycle});

  final BudgetCycle cycle;

  static const Duration duration = Duration(milliseconds: 2200);

  @override
  State<BudgetSetupLoadingPage> createState() => _BudgetSetupLoadingPageState();
}

class _BudgetSetupLoadingPageState extends State<BudgetSetupLoadingPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(BudgetSetupLoadingPage.duration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.firstTransaction);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DollarLoader(size: 160),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  AppStrings.setupLoadingTitle(widget.cycle.label),
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.setupLoadingSubtitle,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
