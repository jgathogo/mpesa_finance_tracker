import 'package:mpesa_finance_tracker/features/auth/domain/entities/auth_entity.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<AuthEntity> call(String email, String password) {
    return repository.signUp(email, password);
  }
} 