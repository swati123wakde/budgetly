part of 'add_transaction_cubit.dart';

class AddTransactionState extends Equatable {
  const AddTransactionState({
    required this.date,
    this.type = TransactionType.expense,
    this.amountText = '',
    this.category,
    this.note = '',
    this.isSaving = false,
    this.isSaved = false,
    this.errorMessage,
  });

  final DateTime date;
  final TransactionType type;
  final String amountText;
  final TransactionCategory? category;
  final String note;
  final bool isSaving;
  final bool isSaved;
  final String? errorMessage;

  double get amount => double.tryParse(amountText) ?? 0;

  bool get canSave => amount > 0 && category != null && !isSaving;

  AddTransactionState copyWith({
    DateTime? date,
    TransactionType? type,
    String? amountText,
    TransactionCategory? category,
    String? note,
    bool? isSaving,
    bool? isSaved,
    String? errorMessage,
  }) {
    return AddTransactionState(
      date: date ?? this.date,
      type: type ?? this.type,
      amountText: amountText ?? this.amountText,
      category: category ?? this.category,
      note: note ?? this.note,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [date, type, amountText, category, note, isSaving, isSaved, errorMessage];
}