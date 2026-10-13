
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/step_header.dart';
import '../../../get_started/domain/entities/tracking_option.dart';
import '../../domain/entities/transaction_category.dart';
import '../cubit/first_transaction_cubit.dart';
import '../widgets/category_icon.dart';
import '../widgets/transaction_type_selector.dart';

/// Step 3: log one transaction (amount + category) or skip to home.
class FirstTransactionPage extends StatelessWidget {
  const FirstTransactionPage({super.key});

  void _goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
          (_) => false,
      arguments: TrackingMode.spendingOnly,
    );
  }

  Future<void> _pickCategory(BuildContext context) async {
    final cubit = context.read<FirstTransactionCubit>();
    FocusScope.of(context).unfocus();
    final picked = await Navigator.of(context).pushNamed<TransactionCategory>(
      AppRoutes.categoryPicker,
      arguments: cubit.state.category,
    );
    if (picked != null) cubit.setCategory(picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FirstTransactionCubit, FirstTransactionState>(
      listenWhen: (prev, curr) => prev.isSaved != curr.isSaved || prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.isSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.transactionSaved)),
          );
          _goHome(context);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  StepHeader(
                    step: 3,
                    totalSteps: 3,
                    trailing: TextButton(
                      onPressed: () => _goHome(context),
                      child: const Text(AppStrings.skip),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.firstTransactionTitle, style: AppTextStyles.headlineLarge),
                          const SizedBox(height: AppSpacing.sm),
                          Text(AppStrings.firstTransactionSubtitle, style: AppTextStyles.bodyMedium),
                          const SizedBox(height: AppSpacing.md),
                          const _XpChip(),
                          const SizedBox(height: AppSpacing.xl),
                          BlocBuilder<FirstTransactionCubit, FirstTransactionState>(
                            buildWhen: (p, c) => p.type != c.type,
                            builder: (context, state) => TransactionTypeSelector(
                              value: state.type,
                              onChanged: context.read<FirstTransactionCubit>().setType,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(AppStrings.amount, style: AppTextStyles.label),
                          const SizedBox(height: AppSpacing.xs),
                          const _AmountField(),
                          const SizedBox(height: AppSpacing.lg),
                          Text(AppStrings.category, style: AppTextStyles.label),
                          const SizedBox(height: AppSpacing.xs),
                          BlocBuilder<FirstTransactionCubit, FirstTransactionState>(
                            buildWhen: (p, c) => p.category != c.category,
                            builder: (context, state) => _CategoryField(
                              category: state.category,
                              onTap: () => _pickCategory(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<FirstTransactionCubit, FirstTransactionState>(
                    buildWhen: (p, c) => p.canSave != c.canSave || p.isSaving != c.isSaving,
                    builder: (context, state) => PrimaryButton(
                      label: AppStrings.save,
                      isLoading: state.isSaving,
                      onPressed: state.canSave ? context.read<FirstTransactionCubit>().save : null,
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

class _XpChip extends StatelessWidget {
  const _XpChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.matteRedTint,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.matteRedDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 16, color: AppColors.matteRedLight),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            AppStrings.earnXp,
            style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

/// Large "$ 0.00" amount input. Accepts up to two decimal places.
class _AmountField extends StatelessWidget {
  const _AmountField();

  @override
  Widget build(BuildContext context) {
    final amountStyle = AppTextStyles.headlineLarge.copyWith(fontSize: 34);
    return TextField(
      onChanged: context.read<FirstTransactionCubit>().setAmount,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      inputFormatters: [
        // Digits with at most one dot and two decimals; reject anything else.
        TextInputFormatter.withFunction(
              (oldValue, newValue) =>
          RegExp(r'^\d{0,9}(\.\d{0,2})?$').hasMatch(newValue.text) ? newValue : oldValue,
        ),
      ],
      style: amountStyle,
      cursorHeight: 34,
      decoration: InputDecoration(
        hintText: '0.00',
        hintStyle: amountStyle.copyWith(color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 22),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.xs),
          child: Text(r'$', style: amountStyle.copyWith(color: AppColors.matteRedLight)),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}

class _CategoryField extends StatelessWidget {
  const _CategoryField({required this.category, required this.onTap});

  final TransactionCategory? category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = category != null;
    return Material(
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
          child: Row(
            children: [
              if (hasValue) ...[
                CategoryIcon(category: category!, size: 40),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppDurations.fast,
                  child: Text(
                    hasValue ? category!.name : AppStrings.chooseCategory,
                    key: ValueKey(category?.id),
                    style: hasValue
                        ? AppTextStyles.titleMedium
                        : AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
