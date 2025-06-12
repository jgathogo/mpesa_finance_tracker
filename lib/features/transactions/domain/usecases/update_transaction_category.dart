import 'package:mpesa_finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';

class UpdateTransactionCategory {
  final TransactionRepository repository;

  UpdateTransactionCategory(this.repository);

  Future<void> call(String transactionId, String? category) async {
    await repository.updateTransactionCategory(transactionId, category);
  }
} 