import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/budget_setup/domain/entities/budget_cycle.dart';
import '../../features/budget_setup/domain/entities/transaction_category.dart';
import '../../features/budget_setup/presentation/cubit/budget_cycle_cubit.dart';
import '../../features/budget_setup/presentation/cubit/category_picker_cubit.dart';
import '../../features/budget_setup/presentation/cubit/first_transaction_cubit.dart';
import '../../features/budget_setup/presentation/cubit/payday_cubit.dart';
import '../../features/budget_setup/presentation/pages/budget_cycle_page.dart';
import '../../features/budget_setup/presentation/pages/budget_setup_loading_page.dart';
import '../../features/budget_setup/presentation/pages/category_picker_page.dart';
import '../../features/budget_setup/presentation/pages/first_transaction_page.dart';
import '../../features/budget_setup/presentation/pages/payday_page.dart';
import '../../features/get_started/presentation/cubit/get_started_cubit.dart';
import '../../features/get_started/presentation/pages/get_started_page.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/pages/all_expenses_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
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
      AppRoutes.budgetCycle => _page(
        settings,
        BlocProvider(create: (_) => sl<BudgetCycleCubit>(), child: const BudgetCyclePage()),
      ),
      AppRoutes.payday => _page(
        settings,
        BlocProvider(
          create: (_) => sl<PaydayCubit>(
            param1: settings.arguments as BudgetCycle? ?? BudgetCycle.fortnightly,
          ),
          child: const PaydayPage(),
        ),
      ),
      AppRoutes.budgetSetupLoading => _fade(
        settings,
        BudgetSetupLoadingPage(cycle: settings.arguments as BudgetCycle? ?? BudgetCycle.monthly),
      ),
      AppRoutes.firstTransaction => _fade(
        settings,
        BlocProvider(
          create: (_) => sl<FirstTransactionCubit>(),
          child: const FirstTransactionPage(),
        ),
      ),
      AppRoutes.categoryPicker => MaterialPageRoute<TransactionCategory>(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => sl<CategoryPickerCubit>()
            ..load(selectedId: (settings.arguments as TransactionCategory?)?.id),
          child: const CategoryPickerPage(),
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
          child: const HomePage(),
        ),
      ),
      AppRoutes.allExpenses => _page(
        settings,
        AllExpensesPage(args: settings.arguments! as AllExpensesArgs),
      ),
      AppRoutes.profile => _page(
        settings,
        BlocProvider(create: (_) => sl<ProfileCubit>()..load(), child: const ProfilePage()),
      ),
      AppRoutes.register => _page(
        settings,
        BlocProvider(create: (_) => sl<RegisterCubit>(), child: const RegisterPage()),
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