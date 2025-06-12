import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

/// Abstract repository for SMS operations.
abstract class SmsRepository {
  /// Fetches all SMS messages from the inbox.
  Future<List<SmsMessage>> fetchAllMessages();

  /// Fetches only M-Pesa-related messages.
  Future<List<SmsMessage>> fetchMpesaMessages();
} 