import 'package:mpesa_finance_tracker/features/auth/data/datasources/auth_data_source.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/entities/auth_entity.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthEntity> signIn(String email, String password) async {
    return await remoteDataSource.signIn(email, password);
  }

  @override
  Future<AuthEntity> signUp(String email, String password) async {
    return await remoteDataSource.signUp(email, password);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Stream<AuthEntity?> get authStateChanges => remoteDataSource.authStateChanges;
} 