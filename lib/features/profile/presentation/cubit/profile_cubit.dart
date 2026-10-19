import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/profile_summary.dart';
import '../../domain/usecases/get_profile_summary.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfileSummary) : super(const ProfileState());

  final GetProfileSummary _getProfileSummary;

  Future<void> load() async {
    emit(const ProfileState());
    final result = await _getProfileSummary(const NoParams());
    if (isClosed) return;
    result.fold(
          (failure) => emit(ProfileState(status: ProfileStatus.failure, errorMessage: failure.message)),
          (summary) => emit(ProfileState(status: ProfileStatus.loaded, summary: summary)),
    );
  }
}
