part of 'profile_cubit.dart';

enum ProfileStatus { loading, loaded, failure }

class ProfileState extends Equatable {
  const ProfileState({this.status = ProfileStatus.loading, this.summary, this.errorMessage});

  final ProfileStatus status;
  final ProfileSummary? summary;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, summary, errorMessage];
}
