import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/new_transaction.dart';
import '../repositories/budget_setup_repository.dart';

class SaveTransaction implements UseCase<void, NewTransaction> {
  const SaveTransaction(this._repository);
  final BudgetSetupRepository _repository;

  @override
  Future<Result<void>> call(NewTransaction transaction) => _repository.saveTransaction(transaction);
}
