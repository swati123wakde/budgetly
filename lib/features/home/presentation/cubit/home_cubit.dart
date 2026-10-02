import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entites/budget_summary.dart';
import '../../domain/usecases/get_budget_summary.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getBudgetSummary) : super(const HomeLoading());

  final GetBudgetSummary _getBudgetSummary;

  Future<void> load() async {
    emit(const HomeLoading());
    final result = await _getBudgetSummary(const NoParams());
    if (isClosed) return;
    result.fold(
          (failure) => emit(HomeError(failure.message)),
          (summary) => emit(HomeLoaded(summary)),
    );
  }
}