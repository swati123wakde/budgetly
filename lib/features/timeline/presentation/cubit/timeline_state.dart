part of 'timeline_cubit.dart';

enum TimelineStatus { initial, loading, loaded, failure }

class TimelineState extends Equatable {
  const TimelineState({
    this.status = TimelineStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  final TimelineStatus status;

  /// Newest first.
  final List<NewTransaction> transactions;
  final String? errorMessage;

  /// Income minus expenses across every transaction. 0 when there are none.
  double get balance => transactions.fold<double>(
    0,
        (sum, t) => t.isExpense ? sum - t.amount : sum + t.amount,
  );

  TimelineState copyWith({
    TimelineStatus? status,
    List<NewTransaction>? transactions,
    String? errorMessage,
  }) {
    return TimelineState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage];
}