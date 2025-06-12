import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

/// Service to query SMS inbox and filter for M-Pesa messages.
class SmsInboxService {
  final SmsQuery _query = SmsQuery();

  /// Fetches all SMS messages from the inbox.
  Future<List<SmsMessage>> fetchAllMessages() async {
    try {
      final messages = await _query.querySms();
      print('Fetched ${messages.length} total SMS messages.'); // Log total messages
      return messages;
    } catch (e) {
      // Reason: Catch and log errors for debugging
      print('Error fetching SMS: $e');
      return [];
    }
  }

  /// Filters messages that are likely M-Pesa transactions.
  /// This uses sender address and common M-Pesa keywords.
  Future<List<SmsMessage>> fetchMpesaMessages() async {
    final allMessages = await fetchAllMessages();
    print('Total messages fetched by SmsInboxService: ${allMessages.length}'); // Log all messages
    // Reason: M-Pesa messages typically come from 'MPESA' or similar senders
    final mpesaSenders = ['MPESA', 'M-PESA', 'MPESA1', 'MPESA2'];
    final mpesaKeywords = [
      'sent to', 'received', 'give', 'paybill', 'airtime', 'withdraw', 'buy goods', 'transaction', 'balance'
    ];
    final mpesaMessages = allMessages.where((msg) {
      final sender = msg.address?.toUpperCase() ?? '';
      final body = msg.body?.toLowerCase() ?? '';
      final isMpesaSender = mpesaSenders.any((s) => sender.contains(s));
      final hasMpesaKeyword = mpesaKeywords.any((k) => body.contains(k));
      return isMpesaSender || hasMpesaKeyword;
    }).toList();
    print('Filtered ${mpesaMessages.length} M-Pesa messages.'); // Log filtered messages
    return mpesaMessages;
  }
} 