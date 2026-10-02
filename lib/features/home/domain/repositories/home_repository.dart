import '../../../../core/utils/result.dart';
import '../entites/budget_summary.dart';

abstract interface class HomeRepository {
  Future<Result<BudgetSummary>> getSummary();
}