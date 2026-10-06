import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/tracking_option.dart';
import '../../domain/usecases/get_tracking_option.dart';
import '../../domain/usecases/save_tracking_option.dart';

part 'get_started_state.dart';

class GetStartedCubit extends Cubit<GetStartedState> {
  GetStartedCubit({
    required GetTrackingOptions getTrackingOptions,
    required SaveTrackingMode saveTrackingMode,
  })  : _getTrackingOptions = getTrackingOptions,
        _saveTrackingMode = saveTrackingMode,
        super(const GetStartedState());

  final GetTrackingOptions _getTrackingOptions;
  final SaveTrackingMode _saveTrackingMode;

  Future<void> loadOptions() async {
    emit(const GetStartedState(status: GetStartedStatus.loading));
    final result = await _getTrackingOptions(const NoParams());
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(
        status: GetStartedStatus.failure,
        errorMessage: failure.message,
      )),
          (options) => emit(state.copyWith(status: GetStartedStatus.loaded, options: options)),
    );
  }

  void select(TrackingMode mode) => emit(state.copyWith(selected: mode));

  Future<void> submit() async {

    final mode = state.selected;
    if (mode == null) return;
    emit(state.copyWith(isSubmitting: true));
    final result = await _saveTrackingMode(mode);
    if (isClosed) return;
    result.fold(
          (failure) => emit(state.copyWith(isSubmitting: false, errorMessage: failure.message)),
          (_) => emit(state.copyWith(isSubmitting: false, completedMode: mode)),
    );
  }
}