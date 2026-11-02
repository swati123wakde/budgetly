import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../budget_setup/domain/entities/new_transaction.dart';
import '../../../budget_setup/domain/usecases/get_categories.dart';
import '../../../budget_setup/domain/usecases/get_transactions.dart';

part 'timeline_state.dart';

/// Loads every transaction for the Timeline tab, newest first.
class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit(this._getTransactions) : super(const TimelineState());

  final GetTransactions _getTransactions;

  Future<void> load() async {
    emit(state.copyWith(status: TimelineStatus.loading));
    final result = await _getTransactions();
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(status: TimelineStatus.failure, errorMessage: failure.message)),
          (items) {
        final sorted = List.of(items)..sort((a, b) => b.date.compareTo(a.date));
        emit(state.copyWith(status: TimelineStatus.loaded, transactions: sorted));
      },
    );
  }
}