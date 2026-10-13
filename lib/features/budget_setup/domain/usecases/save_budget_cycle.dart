import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/budget_cycle.dart';
import '../repositories/budget_setup_repository.dart';

class SaveBudgetCycle implements UseCase<void, BudgetCycle> {
  const SaveBudgetCycle(this._repository);
  final BudgetSetupRepository _repository;

  @override
  Future<Result<void>> call(BudgetCycle cycle) => _repository.saveBudgetCycle(cycle);
}
