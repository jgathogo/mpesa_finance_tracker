import 'package:mpesa_finance_tracker/features/auth/domain/entities/auth_entity.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/repositories/auth_repository.dart';

class GetAuthStatusUseCase {
  final AuthRepository repository;

  GetAuthStatusUseCase(this.repository);

  Stream<AuthEntity?> call() {
    return repository.authStateChanges;
  }
} 