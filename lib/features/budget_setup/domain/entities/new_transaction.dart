import 'package:equatable/equatable.dart';

import 'transaction_category.dart';

enum TransactionType { expense, income }

/// A transaction the user logged.
class NewTransaction extends Equatable {
  const NewTransaction({
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  final TransactionType type;

  /// Always positive; [type] decides the sign.
  final double amount;
  final TransactionCategory category;
  final DateTime date;

  /// Optional free-text note the user typed.
  final String? note;

  bool get isExpense => type == TransactionType.expense;

  @override
  List<Object?> get props => [type, amount, category, date, note];
}