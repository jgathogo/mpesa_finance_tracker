import 'package:isar/isar.dart';
import 'package:mpesa_finance_tracker/core/services/isar_service.dart';
import 'package:mpesa_finance_tracker/features/transactions/data/models/transaction_entity.dart';
import 'package:mpesa_finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  // No longer needs IsarService instance, directly uses static getInstance()
  // final IsarService _isarService;
  // TransactionRepositoryImpl(this._isarService);

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() async {
      await isar.transactionEntitys.put(transaction);
    });
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final isar = await IsarService.getInstance();
    return await isar.transactionEntitys.where().findAll();
  }

  @override
  Future<void> clearAllTransactions() async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() async {
      await isar.transactionEntitys.clear();
    });
  }

  @override
  Future<void> updateTransactionCategory(String transactionId, String? category) async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() async {
      final transaction = await isar.transactionEntitys.where().transactionIdEqualTo(transactionId).findFirst();
      if (transaction != null) {
        transaction.category = category;
        await isar.transactionEntitys.put(transaction);
      }
    });
  }
} 