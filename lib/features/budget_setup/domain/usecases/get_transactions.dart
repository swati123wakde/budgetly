import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/new_transaction.dart';
import '../repositories/budget_setup_repository.dart';

/// Every transaction the user has logged (any order).
class GetTransactions implements UseCase<List<NewTransaction>, NoParams> {
  const GetTransactions(this._repository);
  final BudgetSetupRepository _repository;

  @override
  Future<Result<List<NewTransaction>>> call([NoParams params = const NoParams()]) =>
      _repository.getTransactions();
}