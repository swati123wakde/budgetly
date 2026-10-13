import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/transaction_category.dart';
import '../repositories/budget_setup_repository.dart';

class GetCategories implements UseCase<List<TransactionCategory>, NoParams> {
  const GetCategories(this._repository);
  final BudgetSetupRepository _repository;

  @override
  Future<Result<List<TransactionCategory>>> call(NoParams params) => _repository.getCategories();
}
