import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'dart:async';

class MockSmsMessage implements SmsMessage {
  @override
  final int? id;
  @override
  final String? sender;
  @override
  final String? body;
  @override
  final DateTime? date;

  // Required by interface, but not used by parser
  @override
  String? address;
  @override
  String? subject;
  @override
  bool? read;
  @override
  String? status;
  @override
  String? type;
  @override
  DateTime? dateSent;
  @override
  String? serviceCenter;
  @override
  int? subId;
  @override
  String? creator;
  @override
  String? mStatus;
  @override
  int? threadId;
  @override
  SmsMessageKind? kind;

  // For state management (required by interface)
  final StreamController<SmsMessageState> _stateStreamController = StreamController<SmsMessageState>.broadcast();
  SmsMessageState _state = SmsMessageState.sending;

  MockSmsMessage({
    this.id,
    this.sender,
    this.body,
    this.date,
    this.address,
    this.subject,
    this.read,
    this.status,
    this.type,
    this.dateSent,
    this.serviceCenter,
    this.subId,
    this.creator,
    this.mStatus,
    this.threadId,
    this.kind,
  });

  @override
  bool? get isRead => read;

  @override
  Stream<SmsMessageState> get onStateChanged => _stateStreamController.stream;

  @override
  SmsMessageState get state => _state;

  @override
  set state(SmsMessageState state) {
    _state = state;
    _stateStreamController.add(state);
  }

  @override
  int compareTo(SmsMessage other) {
    // Simple comparison based on date, can be expanded if needed
    if (date == null || other.date == null) return 0;
    return date!.compareTo(other.date!);
  }

  @override
  Map get toMap {
    return {
      'id': id,
      'sender': sender,
      'body': body,
      'date': date?.toIso8601String(),
      // Add other properties if they are needed for serialization
    };
  }

  @override
  noSuchMethod(Invocation invocation) {
    // This can be used to catch unimplemented methods during development
    // For now, we'll just defer to the default behavior.
    super.noSuchMethod(invocation);
  }

  @override
  String toString() {
    return 'MockSmsMessage(id: $id, sender: $sender, body: $body, date: $date)';
  }
} 