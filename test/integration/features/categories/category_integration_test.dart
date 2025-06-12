import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';
import 'package:mpesa_finance_tracker/features/categories/data/repositories/category_repository_impl.dart';
import 'package:mpesa_finance_tracker/features/categories/data/repositories/isar_category_data_source.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  late Isar isar;
  late IsarCategoryDataSource dataSource;
  late CategoryRepositoryImpl repository;

  setUp(() async {
    isar = await createTestIsar();
    dataSource = IsarCategoryDataSource(isar.categoryEntitys);
    repository = CategoryRepositoryImpl(dataSource: dataSource);
  });

  tearDown(() async {
    await closeTestIsar(isar);
  });

  group('Category Integration Tests', () {
    test('should save and retrieve a category', () async {
      // Arrange
      final category = CategoryEntity(name: 'Food');

      // Act
      await repository.saveCategory(category);
      final categories = await repository.getCategories();

      // Assert
      expect(categories.length, 1);
      expect(categories.first.name, 'Food');
      expect(categories.first.id, isNotNull);
    });

    test('should update an existing category', () async {
      // Arrange
      final category = CategoryEntity(name: 'Food');
      await repository.saveCategory(category);
      final savedCategory = (await repository.getCategories()).first;
      savedCategory.name = 'Updated Food';

      // Act
      await repository.updateCategory(savedCategory);
      final categories = await repository.getCategories();

      // Assert
      expect(categories.length, 1);
      expect(categories.first.name, 'Updated Food');
      expect(categories.first.id, savedCategory.id);
    });

    test('should delete a category', () async {
      // Arrange
      final category = CategoryEntity(name: 'Food');
      await repository.saveCategory(category);
      final savedCategory = (await repository.getCategories()).first;

      // Act
      await repository.deleteCategory(savedCategory.id);
      final categories = await repository.getCategories();

      // Assert
      expect(categories, isEmpty);
    });

    test('should maintain unique category names', () async {
      // Arrange
      final category1 = CategoryEntity(name: 'Food');
      final category2 = CategoryEntity(name: 'Food'); // Same name

      // Act & Assert
      await repository.saveCategory(category1);
      await expectLater(
        () => repository.saveCategory(category2),
        throwsA(isA<Exception>()),
      );
    });
  });
} 