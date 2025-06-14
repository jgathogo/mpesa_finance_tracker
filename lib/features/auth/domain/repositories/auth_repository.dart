import 'package:mpesa_finance_tracker/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> signUp(String email, String password);
  Future<AuthEntity> signIn(String email, String password);
  Future<void> signOut();
  Stream<AuthEntity?> get authStateChanges;
} 