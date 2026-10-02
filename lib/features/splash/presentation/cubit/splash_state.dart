part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

/// Splash is done; navigate to [route].
final class SplashCompleted extends SplashState {
  const SplashCompleted(this.route);
  final String route;

  @override
  List<Object?> get props => [route];
}