import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mpesa_finance_tracker/features/transactions/data/models/transaction_entity.dart';
import 'dart:io';

class IsarService {
  static Isar? _isar;

  /// Returns the singleton Isar instance, initializing it if necessary.
  static Future<Isar> getInstance() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TransactionEntitySchema],
      directory: dir.path,
    );
    return _isar!;
  }

  /// Closes the Isar instance (for cleanup/testing)
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
} 