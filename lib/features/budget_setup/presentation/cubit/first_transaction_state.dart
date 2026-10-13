part of 'first_transaction_cubit.dart';

class FirstTransactionState extends Equatable {
  const FirstTransactionState({
    this.type = TransactionType.expense,
    this.amountText = '',
    this.category,
    this.isSaving = false,
    this.isSaved = false,
    this.errorMessage,
  });

  final TransactionType type;
  final String amountText;
  final TransactionCategory? category;
  final bool isSaving;
  final bool isSaved;
  final String? errorMessage;

  double get amount => double.tryParse(amountText) ?? 0;

  bool get canSave => amount > 0 && category != null && !isSaving;

  FirstTransactionState copyWith({
    TransactionType? type,
    String? amountText,
    TransactionCategory? category,
    bool? isSaving,
    bool? isSaved,
    String? errorMessage,
  }) {
    return FirstTransactionState(
      type: type ?? this.type,
      amountText: amountText ?? this.amountText,
      category: category ?? this.category,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [type, amountText, category, isSaving, isSaved, errorMessage];
}
