import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/budget_plan.dart';
import '../../domain/entities/new_transaction.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/repositories/budget_setup_repository.dart';
import '../datasources/budget_setup_local_data_source.dart';

class BudgetSetupRepositoryImpl implements BudgetSetupRepository {
  const BudgetSetupRepositoryImpl(this._local);
  final BudgetSetupLocalDataSource _local;

  @override
  Future<Result<void>> saveBudgetPlan(BudgetPlan plan) async {
    try {
      await _local.saveBudgetPlan(plan);
      return const Ok<void>(null);
    } catch (_) {
      return const Err<void>(CacheFailure('Could not save your budget cycle.'));
    }
  }

  @override
  Future<Result<List<TransactionCategory>>> getCategories() async {
    try {
      return Ok<List<TransactionCategory>>(await _local.getCategories());
    } catch (_) {
      return const Err<List<TransactionCategory>>(CacheFailure('Could not load categories.'));
    }
  }

  @override
  Future<Result<TransactionCategory>> createCategory(String name) async {
    try {
      return Ok<TransactionCategory>(await _local.createCategory(name));
    } catch (_) {
      return const Err<TransactionCategory>(CacheFailure('Could not create that category.'));
    }
  }

  @override
  Future<Result<void>> saveTransaction(NewTransaction transaction) async {
    try {
      await _local.saveTransaction(transaction);
      return const Ok<void>(null);
    } catch (_) {
      return const Err<void>(CacheFailure('Could not save the transaction. Try again.'));
    }
  }
}
