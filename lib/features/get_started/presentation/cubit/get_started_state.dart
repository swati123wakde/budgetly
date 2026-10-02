part of 'get_started_cubit.dart';

enum GetStartedStatus { loading, loaded, failure }

class GetStartedState extends Equatable {
  const GetStartedState({
    this.status = GetStartedStatus.loading,
    this.options = const [],
    this.selected,
    this.isSubmitting = false,
    this.errorMessage,
    this.completedMode,
  });

  final GetStartedStatus status;
  final List<TrackingOption> options;
  final TrackingMode? selected;
  final bool isSubmitting;
  final String? errorMessage;

  /// Set once the choice is saved — the page listens for this to navigate.
  final TrackingMode? completedMode;

  bool get canContinue => selected != null && !isSubmitting;

  GetStartedState copyWith({
    GetStartedStatus? status,
    List<TrackingOption>? options,
    TrackingMode? selected,
    bool? isSubmitting,
    String? errorMessage,
    TrackingMode? completedMode,
  }) {
    return GetStartedState(
      status: status ?? this.status,
      options: options ?? this.options,
      selected: selected ?? this.selected,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      completedMode: completedMode,
    );
  }

  @override
  List<Object?> get props => [status, options, selected, isSubmitting, errorMessage, completedMode];
}