import '../../../../core/utils/result.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';

abstract interface class ProfileRepository {
  Future<Result<List<NewTransaction>>> getTransactions();
}
