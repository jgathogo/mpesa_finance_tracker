import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart'; // Import intl for date parsing
import '../../transactions/data/models/transaction_entity.dart';

// TODO: Define TransactionType enum and Transaction model (if not already defined)

/// A utility class for parsing M-Pesa SMS messages.
class MpesaMessageParser {
  // Regex patterns for common M-Pesa message components
  static final RegExp _transactionIdRegex = RegExp(r'([A-Z0-9]{10}) Confirmed');
  static final RegExp _amountRegex = RegExp(r'Ksh([\d,]+\.\d{2})');
  
  // Date and time regex - updated for new format
  static final RegExp _dateRegex = RegExp(r'(\d{1,2}/\d{1,2}/\d{2}) at (\d{1,2}:\d{2} (?:AM|PM))');

  /// Parses an SMS message and extracts M-Pesa transaction details.
  TransactionEntity? parseMessage(SmsMessage message) {
    final body = message.body ?? '';
    final sender = message.sender ?? '';

    // Preprocess body for easier regex matching
    final lowerBody = body.toLowerCase();

    String? transactionId;
    double? amount;
    String? senderRecipient;
    DateTime? dateTime;
    TransactionType transactionType = TransactionType.unknown;

    // Extract common fields first
    final idMatch = _transactionIdRegex.firstMatch(body);
    if (idMatch != null && idMatch.groupCount >= 1) {
      transactionId = idMatch.group(1);
    }

    final amountMatch = _amountRegex.firstMatch(body);
    if (amountMatch != null && amountMatch.groupCount >= 1) {
      amount = double.tryParse(amountMatch.group(1)!.replaceAll(',', ''));
    }

    // Parse date and time using DateFormat
    final dateMatch = _dateRegex.firstMatch(body);
    if (dateMatch != null && dateMatch.groupCount >= 2) {
      try {
        final dateString = dateMatch.group(1)!; // e.g., "11/6/25"
        final timeString = dateMatch.group(2)!; // e.g., "11:10 AM"
        final fullDateTimeString = '$dateString $timeString';
        // Use a flexible date format for parsing
        dateTime = DateFormat('d/M/yy h:mm a').parse(fullDateTimeString);
      } catch (e) {
        print("Error parsing date: $e");
      }
    }

    // Determine transaction type and refine sender/recipient parsing
    if (lowerBody.contains('received') && lowerBody.contains('from')) {
      transactionType = TransactionType.moneyIn;
      // Updated regex to handle phone numbers and business accounts
      final senderRegex = RegExp(r'from (.+?)(?:\s+\d{10})?\s+on');
      final senderMatch = senderRegex.firstMatch(body);
      if (senderMatch != null && senderMatch.groupCount >= 1) {
        senderRecipient = senderMatch.group(1)?.trim();
      }
    } else if (lowerBody.contains('sent to')) {
      // Check if it's a paybill first
      if (lowerBody.contains('for account')) {
        transactionType = TransactionType.payBill;
        // Updated regex to handle account numbers and descriptions
        final paybillRegex = RegExp(r'to (.+?) for account (.+?)(?:\s+on|\s*$)');
        final paybillMatch = paybillRegex.firstMatch(body);
        if (paybillMatch != null && paybillMatch.groupCount >= 2) {
          final recipient = paybillMatch.group(1)?.trim();
          final account = paybillMatch.group(2)?.trim();
          senderRecipient = '$recipient ($account)';
        }
      } else {
        transactionType = TransactionType.moneyOut;
        // Updated regex to handle phone numbers
        final recipientRegex = RegExp(r'to (.+?)(?:\s+\d{10})?\s+on');
        final recipientMatch = recipientRegex.firstMatch(body);
        if (recipientMatch != null && recipientMatch.groupCount >= 1) {
          senderRecipient = recipientMatch.group(1)?.trim();
        }
      }
    } else if (lowerBody.contains('paid to')) {
      transactionType = TransactionType.tillPayment;
      // Updated regex to handle business names with periods
      final tillRegex = RegExp(r'to (.+?)(?:\.|\s+on)');
      final tillMatch = tillRegex.firstMatch(body);
      if (tillMatch != null && tillMatch.groupCount >= 1) {
        senderRecipient = tillMatch.group(1)?.trim();
      }
    } else {
      transactionType = TransactionType.unknown;
    }

    if (transactionId != null && amount != null && senderRecipient != null && dateTime != null) {
      return TransactionEntity(
        transactionId: transactionId,
        dateTime: dateTime,
        amount: amount,
        senderRecipient: senderRecipient!,
        transactionType: transactionType,
        rawSmsMessage: body,
        isManualEntry: false,
      );
    }

    return null; // Return null if essential parsing fails
  }

  // Example of a placeholder regex for a transaction ID
  // static final RegExp _transactionIdRegex = RegExp(r'[A-Z0-9]{10}');

  // Example of a placeholder function for parsing money in messages
  Map<String, dynamic>? _parseMoneyInMessage(String body) {
    // TODO: Implement regex for money in messages
    return null;
  }

  // Add more parsing methods for different transaction types (Money Out, PayBill, etc.)
} 