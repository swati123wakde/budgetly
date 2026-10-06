import '../../domain/entites/budget_summary.dart';

abstract interface class HomeDataSource {
  Future<BudgetSummary> getSummary();
}

/// Mock data; replace with your API / local DB.
class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<BudgetSummary> getSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    return const BudgetSummary(
      balance: 4820.50,

      monthlyBudget: 2480,
      spent: 1537.60,
      recent: [
        Transaction(title: 'Groceries', category: 'Food', amount: -86.40),
        Transaction(title: 'Salary', category: 'Income', amount: 3200),
        Transaction(title: 'Metro card', category: 'Transport', amount: -25),
        Transaction(title: 'Coffee', category: 'Food', amount: -4.80),
      ],
    );
  }
}