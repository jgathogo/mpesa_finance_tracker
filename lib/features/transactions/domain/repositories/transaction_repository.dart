import 'package:mpesa_finance_tracker/features/transactions/data/models/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> saveTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getTransactions();
  Future<void> clearAllTransactions();
  Future<void> updateTransactionCategory(String transactionId, String? category);
} 