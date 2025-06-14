import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../../domain/usecases/fetch_mpesa_messages.dart';
import '../../data/models/transaction_entity.dart';
import '../../data/mpesa_message_parser.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/update_transaction_category.dart';
import '../../domain/entities/sort_option.dart';
import '../../domain/usecases/update_transaction_receipt_image.dart';

/// States for MpesaMessagesCubit.
abstract class MpesaMessagesState {}

class MpesaMessagesInitial extends MpesaMessagesState {
  final SortOption currentSortOption;
  MpesaMessagesInitial({this.currentSortOption = SortOption.dateNewestFirst});
}

class MpesaMessagesLoading extends MpesaMessagesState {
  final SortOption currentSortOption;
  MpesaMessagesLoading({this.currentSortOption = SortOption.dateNewestFirst});
}

class MpesaMessagesLoaded extends MpesaMessagesState {
  final List<TransactionEntity> messages;
  final SortOption currentSortOption;

  MpesaMessagesLoaded(this.messages, {this.currentSortOption = SortOption.dateNewestFirst});
}

class MpesaMessagesError extends MpesaMessagesState {
  final String message;
  final SortOption currentSortOption;

  MpesaMessagesError(this.message, {this.currentSortOption = SortOption.dateNewestFirst});
}

/// Cubit for managing M-Pesa SMS message state.
class MpesaMessagesCubit extends Cubit<MpesaMessagesState> {
  final FetchMpesaMessages _fetchMpesaMessages;
  final MpesaMessageParser _parser = MpesaMessageParser();
  final TransactionRepository _transactionRepository;
  final UpdateTransactionCategory _updateTransactionCategory;
  final UpdateTransactionReceiptImage _updateTransactionReceiptImage;

  MpesaMessagesCubit(
    this._fetchMpesaMessages,
    this._transactionRepository,
    this._updateTransactionCategory,
    this._updateTransactionReceiptImage,
  ) : super(MpesaMessagesInitial());

  /// Fetches M-Pesa messages and updates the state.
  Future<void> fetchMessages({SortOption? sortOption}) async {
    try {
      final currentSortOption = sortOption ?? (state is MpesaMessagesLoaded ? (state as MpesaMessagesLoaded).currentSortOption : SortOption.dateNewestFirst);
      emit(MpesaMessagesLoading(currentSortOption: currentSortOption));
      
      // First, get existing transactions to preserve their categories
      final existingTransactions = await _transactionRepository.getTransactions(currentSortOption);
      final existingTransactionsMap = {
        for (var t in existingTransactions) t.transactionId: t
      };

      // Fetch and parse new SMS messages
      final smsMessages = await _fetchMpesaMessages();
      final parsedTransactions = <TransactionEntity>[];

      for (var sms in smsMessages) {
        final transaction = _parser.parseMessage(sms);
        if (transaction != null) {
          // Check if this transaction already exists
          final existingTransaction = existingTransactionsMap[transaction.transactionId];
          if (existingTransaction != null) {
            // Preserve the category and crucially, set the Isar ID
            transaction.category = existingTransaction.category;
            transaction.id = existingTransaction.id;
            // Reason: Preserve the existing receipt image reference for persistence
            transaction.receiptImageRef = existingTransaction.receiptImageRef;
          }
          parsedTransactions.add(transaction);
        }
      }

      // Save parsed transactions to Isar (this will update existing or insert new)
      if (parsedTransactions.isNotEmpty) {
        for (var transaction in parsedTransactions) {
          await _transactionRepository.saveTransaction(transaction);
        }
      }

      // Fetch all transactions from Isar to display (ensures consistency and sorting)
      final storedTransactions = await _transactionRepository.getTransactions(currentSortOption);

      if (storedTransactions.isEmpty) {
        emit(MpesaMessagesLoaded([], currentSortOption: currentSortOption));
      } else {
        emit(MpesaMessagesLoaded(storedTransactions, currentSortOption: currentSortOption));
      }
    } catch (e) {
      emit(MpesaMessagesError(e.toString(), currentSortOption: SortOption.dateNewestFirst));
    }
  }

  /// Updates the category of a specific transaction.
  Future<void> updateCategory(String transactionId, String? category) async {
    try {
      // Get the current sort option from the state to maintain it after update
      final currentSortOption = (state is MpesaMessagesLoaded)
          ? (state as MpesaMessagesLoaded).currentSortOption
          : SortOption.dateNewestFirst;

      emit(MpesaMessagesLoading(currentSortOption: currentSortOption)); // Or a more specific state if needed
      await _updateTransactionCategory(transactionId, category);
      // After updating, re-fetch all messages to update the UI with the same sorting
      final storedTransactions = await _transactionRepository.getTransactions(currentSortOption);
      emit(MpesaMessagesLoaded(storedTransactions, currentSortOption: currentSortOption));
    } catch (e) {
      final currentSortOption = (state is MpesaMessagesLoaded)
          ? (state as MpesaMessagesLoaded).currentSortOption
          : SortOption.dateNewestFirst;
      emit(MpesaMessagesError('Failed to update category: $e', currentSortOption: currentSortOption));
    }
  }

  /// Updates the receipt image reference for a specific transaction.
  Future<void> updateReceiptImage(String transactionId, String? receiptImageRef) async {
    try {
      // Get the current sort option from the state to maintain it after update
      final currentSortOption = (state is MpesaMessagesLoaded)
          ? (state as MpesaMessagesLoaded).currentSortOption
          : SortOption.dateNewestFirst;

      emit(MpesaMessagesLoading(currentSortOption: currentSortOption));
      await _updateTransactionReceiptImage(transactionId, receiptImageRef);
      // After updating, re-fetch all messages to update the UI with the same sorting
      final storedTransactions = await _transactionRepository.getTransactions(currentSortOption);
      emit(MpesaMessagesLoaded(storedTransactions, currentSortOption: currentSortOption));
    } catch (e) {
      final currentSortOption = (state is MpesaMessagesLoaded)
          ? (state as MpesaMessagesLoaded).currentSortOption
          : SortOption.dateNewestFirst;
      emit(MpesaMessagesError('Failed to update receipt image: $e', currentSortOption: currentSortOption));
    }
  }
} 