import 'package:mpesa_finance_tracker/features/auth/domain/entities/auth_entity.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<AuthEntity> call(String email, String password) {
    return repository.signIn(email, password);
  }
} 