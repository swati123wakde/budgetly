import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../../budget_setup/data/datasources/budget_setup_local_data_source.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._store);
  final BudgetSetupLocalDataSource _store;

  @override
  Future<Result<List<NewTransaction>>> getTransactions() async {
    try {
      return Ok<List<NewTransaction>>(await _store.getTransactions());
    } catch (_) {
      return const Err<List<NewTransaction>>(CacheFailure('Could not load your progress.'));
    }
  }
}
