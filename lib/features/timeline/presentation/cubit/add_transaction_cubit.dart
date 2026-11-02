
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_span.dart';
import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../../../budget_setup/domain/entities/transaction_category.dart';
import '../../../budget_setup/domain/usecases/get_categories.dart';
import '../../../budget_setup/domain/usecases/get_transactions.dart';
import '../../../budget_setup/domain/usecases/save_transaction.dart';

part 'add_transaction_state.dart';

/// Form state for the "Add transaction" screen.
class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit({
    required SaveTransaction saveTransaction,
    required GetTransactions getTransactions,
  })  : _saveTransaction = saveTransaction,
        _getTransactions = getTransactions,
        super(AddTransactionState(date: dateOnly(DateTime.now())));

  final SaveTransaction _saveTransaction;
  final GetTransactions _getTransactions;

  /// Pre-selects the category used most recently, if any.
  Future<void> init() async {
    final result = await _getTransactions();
    if (isClosed || state.category != null) return;
    result.fold((_) {}, (items) {
      if (items.isEmpty) return;
      final latest = items.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
      emit(state.copyWith(category: latest.category));
    });
  }

  void setType(TransactionType type) => emit(state.copyWith(type: type));

  void setAmount(String text) => emit(state.copyWith(amountText: text));

  void setCategory(TransactionCategory category) => emit(state.copyWith(category: category));

  void setDate(DateTime date) => emit(state.copyWith(date: dateOnly(date)));

  void setNote(String note) => emit(state.copyWith(note: note));

  Future<void> save() async {
    if (!state.canSave) return;
    emit(state.copyWith(isSaving: true));

    // Keep today's entries in the order they were added (newest on top).
    final now = DateTime.now();
    final d = state.date;
    final date = DateTime(d.year, d.month, d.day, now.hour, now.minute, now.second, now.millisecond);
    final note = state.note.trim();

    final result = await _saveTransaction(
      NewTransaction(
        type: state.type,
        amount: state.amount,
        category: state.category!,
        date: date,
        note: note.isEmpty ? null : note,
      ),
    );
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
          (_) => emit(state.copyWith(isSaving: false, isSaved: true)),
    );
  }
}