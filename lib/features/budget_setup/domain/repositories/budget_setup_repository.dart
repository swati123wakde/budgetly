import '../../../../core/utils/result.dart';
import '../entities/budget_cycle.dart';
import '../entities/new_transaction.dart';
import '../entities/transaction_category.dart';

abstract interface class BudgetSetupRepository {
  Future<Result<void>> saveBudgetCycle(BudgetCycle cycle);
  Future<Result<List<TransactionCategory>>> getCategories();
  Future<Result<TransactionCategory>> createCategory(String name);
  Future<Result<void>> saveTransaction(NewTransaction transaction);
}
