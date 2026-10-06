import '../../../../core/error/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entites/budget_summary.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);
  final HomeDataSource _dataSource;


  @override
  Future<Result<BudgetSummary>> getSummary() async {
    try {
      return Ok<BudgetSummary>(await _dataSource.getSummary());
    } catch (_) {
      return const Err<BudgetSummary>(ServerFailure());
    }
  }
}