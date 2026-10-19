import '../../../../core/utils/result.dart';
import '../../../budget_setup/domain/entities/budget_plan.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';

abstract interface class HomeRepository {
  Future<Result<BudgetPlan>> getBudgetPlan();
  Future<Result<List<NewTransaction>>> getTransactions();
}
