import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/transaction_category.dart';
import '../repositories/budget_setup_repository.dart';

class CreateCategory implements UseCase<TransactionCategory, String> {
  const CreateCategory(this._repository);
  final BudgetSetupRepository _repository;

  @override
  Future<Result<TransactionCategory>> call(String name) => _repository.createCategory(name);
}
