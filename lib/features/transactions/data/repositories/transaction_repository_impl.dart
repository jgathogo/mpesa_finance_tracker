import 'package:isar/isar.dart';
import 'package:mpesa_finance_tracker/core/services/isar_service.dart';
import 'package:mpesa_finance_tracker/features/transactions/data/models/transaction_entity.dart';
import 'package:mpesa_finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final IsarService isarService;
  TransactionRepositoryImpl({required this.isarService});

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    await isarService.isar.writeTxn(() async {
      await isarService.isar.transactionEntitys.put(transaction);
    });
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    // Get all transactions and sort them by date in descending order
    final transactions = await isarService.isar.transactionEntitys.where().findAll();
    transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return transactions;
  }

  @override
  Future<void> clearAllTransactions() async {
    await isarService.isar.writeTxn(() async {
      await isarService.isar.transactionEntitys.clear();
    });
  }

  @override
  Future<void> updateTransactionCategory(String transactionId, String? category) async {
    await isarService.isar.writeTxn(() async {
      final transaction = await isarService.isar.transactionEntitys.where().transactionIdEqualTo(transactionId).findFirst();
      if (transaction != null) {
        transaction.category = category;
        await isarService.isar.transactionEntitys.put(transaction);
      }
    });
  }
} 