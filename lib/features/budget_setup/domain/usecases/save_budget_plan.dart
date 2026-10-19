import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/budget_plan.dart';
import '../repositories/budget_setup_repository.dart';

class SaveBudgetPlan implements UseCase<void, BudgetPlan> {
  const SaveBudgetPlan(this._repository);
  final BudgetSetupRepository _repository;

  @override
  Future<Result<void>> call(BudgetPlan plan) => _repository.saveBudgetPlan(plan);
}
