import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../../../budget_setup/domain/entities/transaction_category.dart';
import '../../../budget_setup/presentation/widgets/category_icon.dart';
import '../../../home/presentation/widgets/range_calendar_dialog.dart';
import '../cubit/add_transaction_cubit.dart';

/// Date, Expense/Income, amount, category and notes. Pops `true` once saved
/// so the caller can refresh its lists.
class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<AddTransactionCubit>();
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final picked = await showSingleDateCalendarDialog(
      context: context,
      initialDate: cubit.state.date,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (picked != null) cubit.setDate(picked);
  }

  Future<void> _pickCategory(BuildContext context) async {
    final cubit = context.read<AddTransactionCubit>();
    FocusScope.of(context).unfocus();
    final picked = await Navigator.of(context).pushNamed<TransactionCategory>(
      AppRoutes.categoryPicker,
      arguments: cubit.state.category,
    );
    if (picked != null) cubit.setCategory(picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTransactionCubit, AddTransactionState>(
      listenWhen: (p, c) => p.isSaved != c.isSaved || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.isSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.transactionAdded)),
          );
          Navigator.of(context).pop(true);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, AppSpacing.md, AppSpacing.screenPadding, AppSpacing.xl,
              ),
              children: [
                const _TopBar(),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<AddTransactionCubit, AddTransactionState>(
                  buildWhen: (p, c) => p.date != c.date,
                  builder: (context, state) => _DateButton(
                    date: state.date,
                    onTap: () => _pickDate(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<AddTransactionCubit, AddTransactionState>(
                  buildWhen: (p, c) => p.type != c.type,
                  builder: (context, state) => _TypeSelector(
                    value: state.type,
                    onChanged: context.read<AddTransactionCubit>().setType,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const _Label(AppStrings.amount),
                const _AmountField(),
                const SizedBox(height: AppSpacing.lg),
                const _Label(AppStrings.category),
                BlocBuilder<AddTransactionCubit, AddTransactionState>(
                  buildWhen: (p, c) => p.category != c.category,
                  builder: (context, state) => _CategoryField(
                    category: state.category,
                    onTap: () => _pickCategory(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const _Label(AppStrings.notesOptional),
                TextField(
                  onChanged: context.read<AddTransactionCubit>().setNote,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  minLines: 1,
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    fillColor: AppColors.surfaceHigh,
                    border: _fieldBorder,
                    enabledBorder: _fieldBorder,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: BlocBuilder<AddTransactionCubit, AddTransactionState>(
                    buildWhen: (p, c) => p.canSave != c.canSave || p.isSaving != c.isSaving,
                    builder: (context, state) => _SaveButton(
                      isSaving: state.isSaving,
                      onPressed: state.canSave ? context.read<AddTransactionCubit>().save : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _fieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(AppRadius.lg),
  borderSide: BorderSide.none,
);

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: AppColors.surfaceHigh,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).maybePop(),
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.chevron_left_rounded, size: 30, color: AppColors.matteRedLight),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            AppStrings.addTransaction,
            style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Placeholder actions (pending, reminder, tags, repeat) — not wired up yet.
        for (final icon in const [
          Icons.hourglass_bottom_rounded,
          Icons.notifications_rounded,
          Icons.sell_rounded,
          Icons.repeat_rounded,
        ])
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: Icon(icon, size: 26, color: AppColors.textSecondary),
          ),
      ],
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_month_rounded, size: 30, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _format(date),
                style: AppTextStyles.bodyLarge.copyWith(fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// "Mon 02 Nov 26"
  static String _format(DateTime d) {
    final weekday = DateFormatter.weekdayName(d.weekday).substring(0, 3);
    return '$weekday ${DateFormatter.dayMonthYear(d)}';
  }
}

/// Two big round radio buttons: Expense / Income.
class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.value, required this.onChanged});

  final TransactionType value;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (type, label) in const [
          (TransactionType.expense, 'Expense'),
          (TransactionType.income, 'Income'),
        ])
          Expanded(
            child: Semantics(
              inMutuallyExclusiveGroup: true,
              checked: value == type,
              button: true,
              child: InkWell(
                onTap: () => onChanged(type),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.textPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedContainer(
                          duration: AppDurations.fast,
                          width: value == type ? 26 : 0,
                          height: value == type ? 26 : 0,
                          decoration: const BoxDecoration(
                            color: AppColors.matteRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(label, style: AppTextStyles.bodyLarge.copyWith(fontSize: 17)),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.bodyLarge.copyWith(fontSize: 15)),
    );
  }
}

/// "₹ |" amount input with a calculator icon on the right.
class _AmountField extends StatelessWidget {
  const _AmountField();

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.titleLarge.copyWith(fontSize: 22);
    return TextField(
      onChanged: context.read<AddTransactionCubit>().setAmount,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      inputFormatters: [
        // Digits with at most one dot and two decimals; reject anything else.
        TextInputFormatter.withFunction(
              (oldValue, newValue) =>
          RegExp(r'^\d{0,9}(\.\d{0,2})?$').hasMatch(newValue.text) ? newValue : oldValue,
        ),
      ],
      style: style,
      decoration: InputDecoration(
        fillColor: AppColors.surfaceHigh,
        border: _fieldBorder,
        enabledBorder: _fieldBorder,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 24),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.md),
          child: Text('₹', style: style.copyWith(fontWeight: FontWeight.w700)),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: AppSpacing.md),
          child: Icon(Icons.calculate_rounded, size: 32, color: AppColors.textSecondary),
        ),
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
    final c = category;
    return Material(
      color: AppColors.surfaceHigh,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              if (c != null) ...[
                CategoryIcon(category: c, size: 40),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  c?.name ?? AppStrings.chooseCategory,
                  style: c != null
                      ? AppTextStyles.bodyLarge.copyWith(fontSize: 17)
                      : AppTextStyles.bodyLarge.copyWith(color: AppColors.textMuted),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 30, color: AppColors.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaving, required this.onPressed});

  final bool isSaving;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 64,
      child: FilledButton(
        onPressed: isSaving ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.matteRed,
          foregroundColor: AppColors.onRed,
          disabledBackgroundColor: AppColors.surfaceHigh,
          disabledForegroundColor: AppColors.textSecondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        ),
        child: isSaving
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.textPrimary),
        )
            : Text(AppStrings.save, style: AppTextStyles.button),
      ),
    );
  }
}