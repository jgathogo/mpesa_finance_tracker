import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'features/permissions/presentation/pages/permission_page.dart';
import 'features/transactions/presentation/bloc/mpesa_messages_cubit.dart';
import 'features/transactions/domain/usecases/fetch_mpesa_messages.dart';
import 'features/transactions/data/sms_repository_impl.dart';
import 'features/transactions/data/sms_inbox_service.dart';
import 'core/services/isar_service.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/domain/usecases/update_transaction_category.dart';
import 'features/categories/data/models/category_entity.dart';
import 'features/categories/data/repositories/category_repository_impl.dart';
import 'features/categories/domain/usecases/save_category.dart';
import 'features/categories/domain/usecases/get_categories.dart';
import 'features/categories/domain/usecases/update_category.dart';
import 'features/categories/domain/usecases/delete_category.dart';
import 'features/categories/presentation/bloc/category_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sl.registerSingleton<IsarService>(IsarService());
  await sl<IsarService>().init();

  sl.registerLazySingleton<SmsInboxService>(() => SmsInboxService());
  sl.registerLazySingleton<SmsRepositoryImpl>(() => SmsRepositoryImpl(sl()));
  sl.registerLazySingleton<FetchMpesaMessages>(() => FetchMpesaMessages(sl()));
  sl.registerLazySingleton<TransactionRepositoryImpl>(() => TransactionRepositoryImpl());
  sl.registerLazySingleton<UpdateTransactionCategory>(() => UpdateTransactionCategory(sl()));

  sl.registerLazySingleton<CategoryRepositoryImpl>(() => CategoryRepositoryImpl(
        categoryCollection: sl<IsarService>().isar.categoryEntitys,
      ));
  sl.registerLazySingleton<SaveCategory>(() => SaveCategory(sl()));
  sl.registerLazySingleton<GetCategories>(() => GetCategories(sl()));
  sl.registerLazySingleton<UpdateCategory>(() => UpdateCategory(sl()));
  sl.registerLazySingleton<DeleteCategory>(() => DeleteCategory(sl()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MpesaMessagesCubit(
            sl(),
            sl(),
            sl(),
          )..fetchMessages(),
        ),
        BlocProvider(
          create: (_) => CategoryCubit(
            sl(),
            sl(),
            sl(),
            sl(),
          )..fetchCategories(),
        ),
      ],
      child: MaterialApp(
        title: 'M-Pesa Finance Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const PermissionPage(),
      ),
    );
  }
}
