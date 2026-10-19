part of 'home_cubit.dart';

enum HomeStatus { loading, loaded, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.loading,
    this.overview,
    this.customRange,
    this.errorMessage,
  });

  final HomeStatus status;

  /// Kept while reloading so the screen doesn't flash back to a skeleton.
  final HomeOverview? overview;
  final DateSpan? customRange;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    HomeOverview? overview,
    DateSpan? Function()? customRange,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      customRange: customRange != null ? customRange() : this.customRange,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, overview, customRange, errorMessage];
}
