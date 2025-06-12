import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../../domain/usecases/fetch_mpesa_messages.dart';
import '../../data/models/transaction_entity.dart';
import '../../data/mpesa_message_parser.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/update_transaction_category.dart';

/// States for MpesaMessagesCubit.
abstract class MpesaMessagesState {}

class MpesaMessagesInitial extends MpesaMessagesState {}

class MpesaMessagesLoading extends MpesaMessagesState {}

class MpesaMessagesLoaded extends MpesaMessagesState {
  final List<TransactionEntity> messages;

  MpesaMessagesLoaded(this.messages);
}

class MpesaMessagesError extends MpesaMessagesState {
  final String message;

  MpesaMessagesError(this.message);
}

/// Cubit for managing M-Pesa SMS message state.
class MpesaMessagesCubit extends Cubit<MpesaMessagesState> {
  final FetchMpesaMessages _fetchMpesaMessages;
  final MpesaMessageParser _parser = MpesaMessageParser();
  final TransactionRepository _transactionRepository;
  final UpdateTransactionCategory _updateTransactionCategory;

  MpesaMessagesCubit(
    this._fetchMpesaMessages,
    this._transactionRepository,
    this._updateTransactionCategory,
  ) : super(MpesaMessagesInitial());

  /// Fetches M-Pesa messages and updates the state.
  Future<void> fetchMessages() async {
    try {
      emit(MpesaMessagesLoading());
      
      // First, get existing transactions to preserve their categories
      final existingTransactions = await _transactionRepository.getTransactions();
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
      final storedTransactions = await _transactionRepository.getTransactions();

      if (storedTransactions.isEmpty) {
        emit(MpesaMessagesLoaded([]));
      } else {
        emit(MpesaMessagesLoaded(storedTransactions));
      }
    } catch (e) {
      emit(MpesaMessagesError(e.toString()));
    }
  }

  /// Updates the category of a specific transaction.
  Future<void> updateCategory(String transactionId, String? category) async {
    try {
      emit(MpesaMessagesLoading()); // Or a more specific state if needed
      await _updateTransactionCategory(transactionId, category);
      // After updating, re-fetch all messages to update the UI
      final storedTransactions = await _transactionRepository.getTransactions();
      emit(MpesaMessagesLoaded(storedTransactions));
    } catch (e) {
      emit(MpesaMessagesError(e.toString()));
    }
  }
} 