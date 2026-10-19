import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_span.dart';
import '../../domain/entites/home_overview.dart';
import '../../domain/usecases/get_home_overview.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getHomeOverview) : super(const HomeState());

  final GetHomeOverview _getHomeOverview;

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await _getHomeOverview(HomeOverviewParams(range: state.customRange));
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(status: HomeStatus.failure, errorMessage: failure.message)),
          (overview) => emit(state.copyWith(status: HomeStatus.loaded, overview: overview)),
    );
  }

  /// Show a range the user picked in the calendar.
  Future<void> selectRange(DateSpan range) async {
    emit(state.copyWith(customRange: () => range));
    await load();
  }

  /// Go back to the current budget period.
  Future<void> resetRange() async {
    emit(state.copyWith(customRange: () => null));
    await load();
  }
}
