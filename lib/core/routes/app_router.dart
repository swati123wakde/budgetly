import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/get_started/domain/entities/tracking_option.dart';
import '../../features/get_started/presentation/cubit/get_started_cubit.dart';
import '../../features/get_started/presentation/pages/get_started_page.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../di/injection.dart';
import 'app_routes.dart';

/// Central route table. Each route gets its own Cubit, scoped to the page.
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.splash => _fade(
        settings,
        BlocProvider(create: (_) => sl<SplashCubit>(), child: const SplashPage()),
      ),
      AppRoutes.welcome => _fade(settings, const WelcomePage()),
      AppRoutes.getStarted => _page(
        settings,
        BlocProvider(
          create: (_) => sl<GetStartedCubit>()..loadOptions(),
          child: const GetStartedPage(),
        ),
      ),
      AppRoutes.login => _page(
        settings,
        BlocProvider(create: (_) => sl<LoginCubit>(), child: const LoginPage()),
      ),
      AppRoutes.home => _fade(
        settings,
        BlocProvider(
          create: (_) => sl<HomeCubit>()..load(),
          child: HomePage(mode: settings.arguments as TrackingMode?),
        ),
      ),
      _ => _page(settings, const _NotFoundPage()),
    };
  }

  static Route<dynamic> _page(RouteSettings settings, Widget child) =>
      MaterialPageRoute(settings: settings, builder: (_) => child);

  static Route<dynamic> _fade(RouteSettings settings, Widget child) => PageRouteBuilder(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) => child,
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Page not found')));
}