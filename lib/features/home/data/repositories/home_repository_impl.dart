import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../../budget_setup/domain/entities/budget_plan.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);
  final HomeDataSource _dataSource;

  @override
  Future<Result<BudgetPlan>> getBudgetPlan() async {
    try {
      return Ok<BudgetPlan>(await _dataSource.getBudgetPlan());
    } catch (_) {
      return const Err<BudgetPlan>(CacheFailure('Could not load your budget.'));
    }
  }

  @override
  Future<Result<List<NewTransaction>>> getTransactions() async {
    try {
      return Ok<List<NewTransaction>>(await _dataSource.getTransactions());
    } catch (_) {
      return const Err<List<NewTransaction>>(CacheFailure('Could not load your transactions.'));
    }
  }
}
