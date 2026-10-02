import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  static const Duration splashDuration = Duration(milliseconds: 2600);

  /// Waits for the intro animation, then decides where to go.
  /// Hook a "check saved session" use case in here when you add persistence.
  Future<void> start() async {
    await Future<void>.delayed(splashDuration);
    if (isClosed) return;
    emit(const SplashCompleted(AppRoutes.welcome));
  }
}