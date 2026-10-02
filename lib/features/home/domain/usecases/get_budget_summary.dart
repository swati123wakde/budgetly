import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entites/budget_summary.dart';
import '../repositories/home_repository.dart';

class GetBudgetSummary implements UseCase<BudgetSummary, NoParams> {
  const GetBudgetSummary(this._repository);
  final HomeRepository _repository;

  @override
  Future<Result<BudgetSummary>> call(NoParams params) => _repository.getSummary();
}