import 'package:isar/isar.dart';
import 'package:mpesa_finance_tracker/core/services/isar_service.dart';
import 'package:mpesa_finance_tracker/features/transactions/data/models/transaction_entity.dart';
import 'package:mpesa_finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:mpesa_finance_tracker/features/transactions/domain/entities/sort_option.dart';

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
  Future<List<TransactionEntity>> getTransactions(SortOption sortOption) async {
    // Get all transactions first
    List<TransactionEntity> transactions = await isarService.isar.transactionEntitys.where().findAll();

    // Apply sorting based on the provided SortOption
    switch (sortOption) {
      case SortOption.dateNewestFirst:
        transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        break;
      case SortOption.dateOldestFirst:
        transactions.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        break;
      case SortOption.categoryAscending:
        transactions.sort((a, b) => (a.category ?? '').compareTo(b.category ?? ''));
        break;
      case SortOption.amountHighestFirst:
        transactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortOption.amountLowestFirst:
        transactions.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case SortOption.typeMoneyInFirst:
        transactions.sort((a, b) {
          if (a.transactionType == TransactionType.moneyIn && b.transactionType != TransactionType.moneyIn) return -1;
          if (a.transactionType != TransactionType.moneyIn && b.transactionType == TransactionType.moneyIn) return 1;
          return 0; // Maintain original order if both are moneyIn or neither are
        });
        break;
      case SortOption.typeMoneyOutFirst:
         transactions.sort((a, b) {
          if (a.transactionType == TransactionType.moneyOut && b.transactionType != TransactionType.moneyOut) return -1;
          if (a.transactionType != TransactionType.moneyOut && b.transactionType == TransactionType.moneyOut) return 1;
          return 0; // Maintain original order if both are moneyOut or neither are
        });
        break;
    }
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

  @override
  Future<void> updateTransactionReceiptImage(String transactionId, String? receiptImageRef) async {
    await isarService.isar.writeTxn(() async {
      final transaction = await isarService.isar.transactionEntitys.where().transactionIdEqualTo(transactionId).findFirst();
      if (transaction != null) {
        transaction.receiptImageRef = receiptImageRef;
        await isarService.isar.transactionEntitys.put(transaction);
      }
    });
  }
} 