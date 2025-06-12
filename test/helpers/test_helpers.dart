import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';

/// Creates a test Isar instance in a temporary directory
Future<Isar> createTestIsar() async {
  final dir = await getTemporaryDirectory();
  final testDir = Directory(path.join(dir.path, 'test_${DateTime.now().millisecondsSinceEpoch}'));
  await testDir.create(recursive: true);

  final isar = await Isar.open(
    [CategoryEntitySchema],
    directory: testDir.path,
  );

  return isar;
}

/// Closes the test Isar instance and cleans up the temporary directory
Future<void> closeTestIsar(Isar isar) async {
  await isar.close();
  final dir = Directory(path.dirname(isar.directory!));
  if (await dir.exists()) {
    await dir.delete(recursive: true);
  }
} 