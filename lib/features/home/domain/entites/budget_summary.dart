import 'package:equatable/equatable.dart';

class BudgetSummary extends Equatable {
  const BudgetSummary({
    required this.balance,
    required this.monthlyBudget,
    required this.spent,
    required this.recent,
  });

  final double balance;
  final double monthlyBudget;
  final double spent;
  final List<Transaction> recent;

  double get spentRatio => monthlyBudget == 0 ? 0 : (spent / monthlyBudget).clamp(0.0, 1.0).toDouble();

  @override
  List<Object?> get props => [balance, monthlyBudget, spent, recent];
}

class Transaction extends Equatable {
  const Transaction({required this.title, required this.category, required this.amount});

  final String title;
  final String category;

  /// Negative = expense, positive = income.
  final double amount;

  @override
  List<Object?> get props => [title, category, amount];
}