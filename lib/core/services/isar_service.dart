import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mpesa_finance_tracker/features/transactions/data/models/transaction_entity.dart';
import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';
import 'dart:io';

class IsarService {
  Isar? _isar;

  Isar get isar => _isar!;

  IsarService(); // Public constructor

  /// Initializes the Isar instance.
  Future<void> init() async {
    if (_isar != null) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TransactionEntitySchema, CategoryEntitySchema],
      directory: dir.path,
    );
  }

  /// Closes the Isar instance (for cleanup/testing)
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
} 