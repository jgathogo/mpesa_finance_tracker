import 'package:mpesa_finance_tracker/features/transactions/data/models/transaction_entity.dart';
import 'package:mpesa_finance_tracker/features/transactions/domain/entities/sort_option.dart';

abstract class TransactionRepository {
  Future<void> saveTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getTransactions(SortOption sortOption);
  Future<void> clearAllTransactions();
  Future<void> updateTransactionCategory(String transactionId, String? category);
} 