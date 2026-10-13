import 'package:equatable/equatable.dart';

import 'transaction_category.dart';

enum TransactionType { expense, income }

/// A transaction the user is logging (not yet persisted).
class NewTransaction extends Equatable {
  const NewTransaction({
    required this.type,
    required this.amount,
    required this.category,
  });

  final TransactionType type;

  /// Always positive; [type] decides the sign.
  final double amount;
  final TransactionCategory category;

  @override
  List<Object?> get props => [type, amount, category];
}
