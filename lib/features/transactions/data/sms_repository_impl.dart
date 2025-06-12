import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'sms_inbox_service.dart';
import '../domain/repositories/sms_repository.dart';

/// Implementation of SmsRepository using SmsInboxService.
class SmsRepositoryImpl implements SmsRepository {
  final SmsInboxService _service;

  SmsRepositoryImpl(this._service);

  @override
  Future<List<SmsMessage>> fetchAllMessages() async {
    return await _service.fetchAllMessages();
  }

  @override
  Future<List<SmsMessage>> fetchMpesaMessages() async {
    return await _service.fetchMpesaMessages();
  }
} 