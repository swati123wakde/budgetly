import '../../../budget_setup/data/datasources/budget_setup_local_data_source.dart';
import '../../../budget_setup/domain/entities/budget_plan.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';

abstract interface class HomeDataSource {
  Future<BudgetPlan> getBudgetPlan();
  Future<List<NewTransaction>> getTransactions();
}

/// Reads the plan and transactions saved during onboarding.
class HomeDataSourceImpl implements HomeDataSource {
  const HomeDataSourceImpl(this._store);
  final BudgetSetupLocalDataSource _store;

  @override
  Future<BudgetPlan> getBudgetPlan() => _store.getBudgetPlan();

  @override
  Future<List<NewTransaction>> getTransactions() async {
    // Simulated latency so the shimmer skeleton is visible.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _store.getTransactions();
  }
}
