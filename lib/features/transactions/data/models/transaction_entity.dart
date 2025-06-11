import 'package:isar/isar.dart';

part 'transaction_entity.g.dart';

@collection
class TransactionEntity {
  /// Unique identifier for the transaction
  Id id = Isar.autoIncrement;

  /// M-Pesa transaction ID
  @Index()
  late String transactionId;

  /// Date and time of the transaction
  @Index()
  late DateTime dateTime;

  /// Transaction amount
  late double amount;

  /// Sender or recipient of the transaction
  late String senderRecipient;

  /// Type of transaction (e.g., Money In, Money Out, PayBill)
  @Enumerated(EnumType.name)
  late TransactionType transactionType;

  /// User-defined category for the transaction
  @Index()
  String? category;

  /// Raw SMS message content
  late String rawSmsMessage;

  /// Whether the transaction was manually entered
  late bool isManualEntry;

  /// Reference to the receipt image if available
  String? receiptImageRef;

  /// Constructor
  TransactionEntity({
    required this.transactionId,
    required this.dateTime,
    required this.amount,
    required this.senderRecipient,
    required this.transactionType,
    this.category,
    required this.rawSmsMessage,
    required this.isManualEntry,
    this.receiptImageRef,
  });
}

/// Enum representing different types of M-Pesa transactions
enum TransactionType {
  /// Money received
  moneyIn,

  /// Money sent
  moneyOut,

  /// Payment to a business
  payBill,

  /// Payment to a till number
  tillPayment,

  /// Withdrawal from agent
  withdrawal,

  /// Deposit to agent
  deposit,

  /// Unknown transaction type
  unknown,
} 