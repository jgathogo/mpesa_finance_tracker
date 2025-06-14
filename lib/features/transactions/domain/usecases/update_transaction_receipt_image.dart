import 'package:mpesa_finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';

class UpdateTransactionReceiptImage {
  final TransactionRepository repository;

  UpdateTransactionReceiptImage(this.repository);

  Future<void> call(String transactionId, String? receiptImageRef) async {
    await repository.updateTransactionReceiptImage(transactionId, receiptImageRef);
  }
} 