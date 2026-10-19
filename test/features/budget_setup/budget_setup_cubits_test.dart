
import 'package:bloc_test/bloc_test.dart';
import 'package:budgetly/core/utils/date_span.dart';
import 'package:budgetly/features/budget_setup/data/datasources/budget_setup_local_data_source.dart';
import 'package:budgetly/features/budget_setup/data/repositories/budget_setup_repository_impl.dart';
import 'package:budgetly/features/budget_setup/domain/entities/budget_cycle.dart';
import 'package:budgetly/features/budget_setup/domain/entities/budget_plan.dart';
import 'package:budgetly/features/budget_setup/domain/entities/new_transaction.dart';
import 'package:budgetly/features/budget_setup/domain/entities/transaction_category.dart';
import 'package:budgetly/features/budget_setup/domain/usecases/create_category.dart';
import 'package:budgetly/features/budget_setup/domain/usecases/get_categories.dart';
import 'package:budgetly/features/budget_setup/domain/usecases/save_budget_plan.dart';
import 'package:budgetly/features/budget_setup/domain/usecases/save_transaction.dart';
import 'package:budgetly/features/budget_setup/presentation/cubit/budget_cycle_cubit.dart';
import 'package:budgetly/features/budget_setup/presentation/cubit/category_picker_cubit.dart';
import 'package:budgetly/features/budget_setup/presentation/cubit/first_transaction_cubit.dart';
import 'package:budgetly/features/budget_setup/presentation/cubit/payday_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BudgetSetupLocalDataSourceImpl local;
  late BudgetSetupRepositoryImpl repository;

  const housing = TransactionCategory(id: 'housing', name: 'Housing', iconKey: 'housing');

  setUp(() {
    local = BudgetSetupLocalDataSourceImpl();
    repository = BudgetSetupRepositoryImpl(local);
  });

  group('BudgetCycleCubit', () {
    blocTest<BudgetCycleCubit, BudgetCycleState>(
      'monthly saves a monthly plan and goes to the loader',
      build: () => BudgetCycleCubit(SaveBudgetPlan(repository)),
      act: (cubit) => cubit.choose(BudgetCycle.monthly),
      expect: () => const [
        BudgetCycleState(selected: BudgetCycle.monthly, isSubmitting: true),
        BudgetCycleState(selected: BudgetCycle.monthly, completedCycle: BudgetCycle.monthly),
      ],
      verify: (_) => expect(local.budgetPlan?.cycle, BudgetCycle.monthly),
    );

    blocTest<BudgetCycleCubit, BudgetCycleState>(
      'fortnightly asks for a payday instead of saving',
      build: () => BudgetCycleCubit(SaveBudgetPlan(repository)),
      act: (cubit) => cubit.choose(BudgetCycle.fortnightly),
      expect: () => const [
        BudgetCycleState(selected: BudgetCycle.fortnightly),
        BudgetCycleState(selected: BudgetCycle.fortnightly, paydayCycle: BudgetCycle.fortnightly),
      ],
      verify: (_) => expect(local.budgetPlan, isNull),
    );

    blocTest<BudgetCycleCubit, BudgetCycleState>(
      're-tapping weekly after coming back still navigates again',
      build: () => BudgetCycleCubit(SaveBudgetPlan(repository)),
      seed: () => const BudgetCycleState(
        selected: BudgetCycle.weekly,
        paydayCycle: BudgetCycle.weekly,
      ),
      act: (cubit) => cubit.choose(BudgetCycle.weekly),
      expect: () => const [
        BudgetCycleState(selected: BudgetCycle.weekly),
        BudgetCycleState(selected: BudgetCycle.weekly, paydayCycle: BudgetCycle.weekly),
      ],
    );
  });

  group('PaydayCubit', () {
    blocTest<PaydayCubit, PaydayState>(
      'fortnightly saves a plan anchored on the chosen payday',
      build: () => PaydayCubit(
        SaveBudgetPlan(repository),
        cycle: BudgetCycle.fortnightly,
        today: DateTime(2026, 10, 14),
      ),
      act: (cubit) async {
        cubit.setDate(DateTime(2026, 9, 27, 15, 30));
        await cubit.submit();
      },
      verify: (cubit) {
        expect(cubit.state.isCompleted, isTrue);
        expect(local.budgetPlan, BudgetPlan.fortnightly(DateTime(2026, 9, 27)));
      },
    );

    blocTest<PaydayCubit, PaydayState>(
      'weekly saves a plan on the chosen weekday',
      build: () => PaydayCubit(SaveBudgetPlan(repository), cycle: BudgetCycle.weekly),
      act: (cubit) async {
        cubit.setWeekday(DateTime.sunday);
        await cubit.submit();
      },
      verify: (cubit) {
        expect(cubit.state.isCompleted, isTrue);
        expect(local.budgetPlan?.cycle, BudgetCycle.weekly);
        expect(local.budgetPlan?.anchor.weekday, DateTime.sunday);
      },
    );
  });

  group('BudgetPlan.periodContaining', () {
    test('monthly runs from the 1st to the last day', () {
      expect(
        BudgetPlan.monthly().periodContaining(DateTime(2026, 9, 14)),
        DateSpan(DateTime(2026, 9, 1), DateTime(2026, 9, 30)),
      );
      expect(
        BudgetPlan.monthly().periodContaining(DateTime(2028, 2, 10)).end,
        DateTime(2028, 2, 29),
      );
    });

    test('fortnightly repeats every 14 days from the payday, forwards and back', () {
      final plan = BudgetPlan.fortnightly(DateTime(2026, 9, 27));
      expect(
        plan.periodContaining(DateTime(2026, 10, 5)),
        DateSpan(DateTime(2026, 9, 27), DateTime(2026, 10, 10)),
      );
      expect(
        plan.periodContaining(DateTime(2026, 10, 14)),
        DateSpan(DateTime(2026, 10, 11), DateTime(2026, 10, 24)),
      );
      expect(
        plan.periodContaining(DateTime(2026, 9, 26)),
        DateSpan(DateTime(2026, 9, 13), DateTime(2026, 9, 26)),
      );
    });

    test('weekly starts on the pay weekday', () {
      // 14 Oct 2026 is a Wednesday; pay day Sunday → Sun 11 Oct – Sat 17 Oct.
      final plan = BudgetPlan.weekly(DateTime.sunday, today: DateTime(2026, 10, 14));
      expect(
        plan.periodContaining(DateTime(2026, 10, 14)),
        DateSpan(DateTime(2026, 10, 11), DateTime(2026, 10, 17)),
      );
      expect(
        plan.periodContaining(DateTime(2026, 10, 11)),
        DateSpan(DateTime(2026, 10, 11), DateTime(2026, 10, 17)),
      );
    });
  });

  group('FirstTransactionCubit', () {
    test('cannot save until amount and category are set', () {
      final cubit = FirstTransactionCubit(SaveTransaction(repository));
      expect(cubit.state.canSave, isFalse);
      cubit.setAmount('5600');
      expect(cubit.state.canSave, isFalse);
      cubit.setCategory(housing);
      expect(cubit.state.canSave, isTrue);
      cubit.setAmount('0');
      expect(cubit.state.canSave, isFalse);
    });

    blocTest<FirstTransactionCubit, FirstTransactionState>(
      'saves a dated expense and marks the state saved',
      build: () => FirstTransactionCubit(SaveTransaction(repository)),
      seed: () => const FirstTransactionState(amountText: '5600', category: housing),
      act: (cubit) => cubit.save(),
      wait: const Duration(milliseconds: 600),
      expect: () => const [
        FirstTransactionState(amountText: '5600', category: housing, isSaving: true),
        FirstTransactionState(amountText: '5600', category: housing, isSaved: true),
      ],
      verify: (_) {
        final saved = local.transactions.single;
        expect(saved.type, TransactionType.expense);
        expect(saved.amount, 5600);
        expect(saved.category, housing);
        expect(DateSpan(DateTime.now(), DateTime.now()).contains(saved.date), isTrue);
      },
    );
  });

  group('CategoryPickerCubit', () {
    CategoryPickerCubit build() => CategoryPickerCubit(
      getCategories: GetCategories(repository),
      createCategory: CreateCategory(repository),
    );

    test('loads defaults sorted A to Z, and Z to A after toggling', () async {
      final cubit = build();
      await cubit.load(selectedId: 'housing');
      expect(cubit.state.status, CategoryPickerStatus.loaded);
      expect(cubit.state.selectedId, 'housing');
      expect(cubit.state.sorted.first.name, 'Dining Out');
      cubit.toggleSort();
      expect(cubit.state.sorted.first.name, 'Utilities');
    });

    test('creating a category selects it and exposes it for the page to return', () async {
      final cubit = build();
      await cubit.load();
      await cubit.create('Pet care');
      expect(cubit.state.createdCategory?.name, 'Pet care');
      expect(cubit.state.selectedId, cubit.state.createdCategory?.id);
      expect(cubit.state.categories.length, 8);
    });
  });
}
