import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mpesa_finance_tracker/features/auth/data/datasources/auth_data_source.dart';
import 'package:mpesa_finance_tracker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/usecases/get_auth_status_usecase.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/usecases/sign_up_usecase.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // Features - Auth

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthStatusUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<AuthDataSource>(
      () => AuthDataSourceImpl(sl()));

  // External
  final firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseAuth);
} 