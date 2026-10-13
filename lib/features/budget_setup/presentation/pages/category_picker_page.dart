import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/transaction_category.dart';
import '../cubit/category_picker_cubit.dart';
import '../widgets/category_icon.dart';
import '../widgets/category_list_shimmer.dart';

/// Full-screen category list. Pops with the chosen [TransactionCategory].
class CategoryPickerPage extends StatelessWidget {
  const CategoryPickerPage({super.key});

  Future<void> _openCreateSheet(BuildContext context) async {
    final cubit = context.read<CategoryPickerCubit>();
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => const _NewCategorySheet(),
    );
    if (name != null && name.trim().isNotEmpty) await cubit.create(name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryPickerCubit, CategoryPickerState>(
      listenWhen: (prev, curr) =>
      prev.createdCategory != curr.createdCategory || prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.createdCategory != null) {
          Navigator.of(context).pop(state.createdCategory);
        } else if (state.errorMessage != null && state.status == CategoryPickerStatus.loaded) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openCreateSheet(context),
          tooltip: AppStrings.newCategory,
          backgroundColor: AppColors.matteRed,
          foregroundColor: AppColors.onRed,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),
                const _Header(),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: BlocBuilder<CategoryPickerCubit, CategoryPickerState>(
                    builder: (context, state) => AnimatedSwitcher(
                      duration: AppDurations.medium,
                      child: switch (state.status) {
                        CategoryPickerStatus.loading => const Align(
                          alignment: Alignment.topCenter,
                          child: CategoryListShimmer(),
                        ),
                        CategoryPickerStatus.failure => _ErrorView(
                          message: state.errorMessage ?? '',
                          onRetry: () => context
                              .read<CategoryPickerCubit>()
                              .load(selectedId: state.selectedId),
                        ),
                        CategoryPickerStatus.loaded => _CategoryList(
                          categories: state.sorted,
                          selectedId: state.selectedId,
                        ),
                      },
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

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppBackButton(),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(AppStrings.chooseCategory, style: AppTextStyles.titleLarge)),
        BlocBuilder<CategoryPickerCubit, CategoryPickerState>(
          buildWhen: (p, c) => p.sortAscending != c.sortAscending,
          builder: (context, state) => IconButton(
            onPressed: context.read<CategoryPickerCubit>().toggleSort,
            tooltip: state.sortAscending ? AppStrings.sortZtoA : AppStrings.sortAtoZ,
            icon: AnimatedRotation(
              turns: state.sortAscending ? 0 : 0.5,
              duration: AppDurations.medium,
              child: const Icon(Icons.sort_by_alpha_rounded, color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.categories, required this.selectedId});

  final List<TransactionCategory> categories;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Bottom space keeps the last row and the hint clear of the FAB.
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        for (final category in categories) ...[
          _CategoryRow(
            category: category,
            selected: category.id == selectedId,
            onTap: () => Navigator.of(context).pop(category),
          ),
          const Divider(height: 1),
        ],
        const SizedBox(height: AppSpacing.xl),
        const _CreateHint(),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.selected, required this.onTap});

  final TransactionCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            CategoryIcon(category: category, selected: selected),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                category.name,
                style: AppTextStyles.titleMedium,
              ),
            ),
            if (selected)
              const Icon(Icons.check_rounded, color: AppColors.matteRedLight, size: 26),
          ],
        ),
      ),
    );
  }
}

class _CreateHint extends StatelessWidget {
  const _CreateHint();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xxl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              AppStrings.categoryHint,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.south_east_rounded, size: 20, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _NewCategorySheet extends StatefulWidget {
  const _NewCategorySheet();

  @override
  State<_NewCategorySheet> createState() => _NewCategorySheetState();
}

class _NewCategorySheetState extends State<_NewCategorySheet> {
  String _name = '';

  void _submit() {
    if (_name.trim().isEmpty) return;
    Navigator.of(context).pop(_name.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppStrings.newCategory, style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: AppStrings.categoryName,
            hint: AppStrings.categoryNameHint,
            prefixIcon: Icons.sell_rounded,
            textInputAction: TextInputAction.done,
            onChanged: (v) => setState(() => _name = v),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: AppStrings.addCategory,
            onPressed: _name.trim().isEmpty ? null : _submit,
          ),
        ],
      ),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 40),
        const SizedBox(height: AppSpacing.sm),
        Text(message, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}
