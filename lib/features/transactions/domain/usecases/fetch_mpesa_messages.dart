import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../repositories/sms_repository.dart';

/// Use case for fetching M-Pesa messages from the SMS inbox.
class FetchMpesaMessages {
  final SmsRepository repository;

  FetchMpesaMessages(this.repository);

  /// Returns a list of M-Pesa-related SMS messages.
  Future<List<SmsMessage>> call() async {
    return await repository.fetchMpesaMessages();
  }
} 