import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_with_email.dart';
import '../../features/auth/domain/usecases/login_with_google.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/budget_setup/data/datasources/budget_setup_local_data_source.dart';
import '../../features/budget_setup/data/repositories/budget_setup_repository_impl.dart';
import '../../features/budget_setup/domain/repositories/budget_setup_repository.dart';
import '../../features/budget_setup/domain/usecases/create_category.dart';
import '../../features/budget_setup/domain/usecases/get_categories.dart';
import '../../features/budget_setup/domain/usecases/save_budget_cycle.dart';
import '../../features/budget_setup/domain/usecases/save_transaction.dart';
import '../../features/budget_setup/presentation/cubit/budget_cycle_cubit.dart';
import '../../features/budget_setup/presentation/cubit/category_picker_cubit.dart';
import '../../features/budget_setup/presentation/cubit/first_transaction_cubit.dart';
import '../../features/get_started/data/datasources/tracking_option_local_data_source.dart';
import '../../features/get_started/data/repositories/tracking_option_repository_impl.dart';
import '../../features/get_started/domain/repositories/tracking_option_repository.dart';
import '../../features/get_started/domain/usecases/get_tracking_option.dart';
import '../../features/get_started/domain/usecases/save_tracking_option.dart';
import '../../features/get_started/presentation/cubit/get_started_cubit.dart';
import '../../features/home/data/datasources/home_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_budget_summary.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';

/// Service locator.
final GetIt sl = GetIt.instance;

/// Wiring order per feature: data source -> repository -> use cases -> cubit.
/// Cubits are factories (fresh per screen); everything else is a lazy singleton.
Future<void> initDependencies() async {
  // ---------- Splash ----------
  sl.registerFactory(SplashCubit.new);

  // ---------- Auth ----------
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl.new)
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton(() => LoginWithEmail(sl()))
    ..registerLazySingleton(() => LoginWithGoogle(sl()))
    ..registerFactory(() => LoginCubit(loginWithEmail: sl(), loginWithGoogle: sl()));

  // ---------- Get started ----------
  sl
    ..registerLazySingleton<TrackingOptionLocalDataSource>(TrackingOptionLocalDataSourceImpl.new)
    ..registerLazySingleton<TrackingOptionRepository>(() => TrackingOptionRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetTrackingOptions(sl()))
    ..registerLazySingleton(() => SaveTrackingMode(sl()))
    ..registerFactory(
          () => GetStartedCubit(getTrackingOptions: sl(), saveTrackingMode: sl()),
    );

  // ---------- Budget setup ----------
  sl
    ..registerLazySingleton<BudgetSetupLocalDataSource>(BudgetSetupLocalDataSourceImpl.new)
    ..registerLazySingleton<BudgetSetupRepository>(() => BudgetSetupRepositoryImpl(sl()))
    ..registerLazySingleton(() => SaveBudgetCycle(sl()))
    ..registerLazySingleton(() => GetCategories(sl()))
    ..registerLazySingleton(() => CreateCategory(sl()))
    ..registerLazySingleton(() => SaveTransaction(sl()))
    ..registerFactory(() => BudgetCycleCubit(sl()))
    ..registerFactory(() => FirstTransactionCubit(sl()))
    ..registerFactory(
          () => CategoryPickerCubit(getCategories: sl(), createCategory: sl()),
    );

  // ---------- Home ----------
  sl
    ..registerLazySingleton<HomeDataSource>(HomeDataSourceImpl.new)
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetBudgetSummary(sl()))
    ..registerFactory(() => HomeCubit(sl()));
}