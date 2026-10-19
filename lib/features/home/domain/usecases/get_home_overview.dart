import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/date_span.dart';
import '../../../../core/utils/result.dart';
import '../../../budget_setup/domain/entities/budget_plan.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../entites/home_overview.dart';
import '../repositories/home_repository.dart';

class GetHomeOverview implements UseCase<HomeOverview, HomeOverviewParams> {
  const GetHomeOverview(this._repository);
  final HomeRepository _repository;

  @override
  Future<Result<HomeOverview>> call(HomeOverviewParams params) async {
    final planResult = await _repository.getBudgetPlan();
    final txResult = await _repository.getTransactions();

    return switch (planResult) {
      Err<BudgetPlan>(:final failure) => Err<HomeOverview>(failure),
      Ok<BudgetPlan>(data: final plan) => switch (txResult) {
        Err<List<NewTransaction>>(:final failure) => Err<HomeOverview>(failure),
        Ok<List<NewTransaction>>(data: final all) => Ok<HomeOverview>(build(plan, all, params)),
      },
    };
  }

  /// Pure aggregation, kept separate so it is easy to test.
  static HomeOverview build(BudgetPlan plan, List<NewTransaction> all, HomeOverviewParams params) {
    final period = params.range ?? plan.periodContaining(params.today ?? DateTime.now());
    final inPeriod = all.where((t) => period.contains(t.date)).toList();

    final expenses = inPeriod.where((t) => t.isExpense).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final incomeTotal =
    inPeriod.where((t) => !t.isExpense).fold<double>(0, (sum, t) => sum + t.amount);
    final expenseTotal = expenses.fold<double>(0, (sum, t) => sum + t.amount);

    final byCategory = <String, CategoryTotal>{};
    for (final t in expenses) {
      final prev = byCategory[t.category.id];
      byCategory[t.category.id] = CategoryTotal(
        category: t.category,
        total: (prev?.total ?? 0) + t.amount,
        count: (prev?.count ?? 0) + 1,
      );
    }

    return HomeOverview(
      period: period,
      cycle: plan.cycle,
      isCustomRange: params.range != null,
      expenses: expenses,
      expensesByCategory: byCategory.values.toList()..sort((a, b) => b.total.compareTo(a.total)),
      expenseTotal: expenseTotal,
      incomeTotal: incomeTotal,
      hasAnyTransactions: all.isNotEmpty,
    );
  }
}

class HomeOverviewParams {
  const HomeOverviewParams({this.range, this.today});

  /// A range the user picked; null means "the current budget period".
  final DateSpan? range;

  /// Injectable clock for tests.
  final DateTime? today;
}
