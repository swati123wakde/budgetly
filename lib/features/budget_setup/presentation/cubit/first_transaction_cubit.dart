import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/new_transaction.dart';
import '../../domain/entities/transaction_category.dart';
import '../../domain/usecases/save_transaction.dart';

part 'first_transaction_state.dart';

class FirstTransactionCubit extends Cubit<FirstTransactionState> {
  FirstTransactionCubit(this._saveTransaction) : super(const FirstTransactionState());

  final SaveTransaction _saveTransaction;

  void setType(TransactionType type) => emit(state.copyWith(type: type));

  void setAmount(String text) => emit(state.copyWith(amountText: text));

  void setCategory(TransactionCategory category) => emit(state.copyWith(category: category));

  Future<void> save() async {
    if (!state.canSave) return;
    emit(state.copyWith(isSaving: true));
    final result = await _saveTransaction(
      NewTransaction(type: state.type, amount: state.amount, category: state.category!),
    );
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
          (_) => emit(state.copyWith(isSaving: false, isSaved: true)),
    );
  }
}
