import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';
import 'package:mpesa_finance_tracker/features/categories/data/repositories/category_repository_impl.dart';
import 'package:mpesa_finance_tracker/features/categories/data/repositories/category_data_source.dart';
import 'package:flutter/services.dart';

class MockCategoryDataSource extends Mock implements CategoryDataSource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CategoryRepositoryImpl repository;
  late MockCategoryDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(CategoryEntity(name: ''));
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return 'mock/app/documents/directory';
      }
      return null;
    });
  });

  setUp(() {
    mockDataSource = MockCategoryDataSource();
    repository = CategoryRepositoryImpl(dataSource: mockDataSource);
  });

  tearDown(() {
    resetMocktailState();
  });

  group('CategoryRepositoryImpl', () {
    test('saveCategory delegates to data source', () async {
      final category = CategoryEntity(name: 'Food');
      when(() => mockDataSource.saveCategory(category)).thenAnswer((_) async {});
      await repository.saveCategory(category);
      verify(() => mockDataSource.saveCategory(category)).called(1);
    });

    test('getCategories delegates to data source', () async {
      final categories = [
        CategoryEntity(name: 'Food'),
        CategoryEntity(name: 'Transport'),
      ];
      when(() => mockDataSource.getCategories()).thenAnswer((_) async => categories);
      final result = await repository.getCategories();
      expect(result, categories);
      verify(() => mockDataSource.getCategories()).called(1);
    });

    test('updateCategory delegates to data source', () async {
      final updatedCategory = CategoryEntity(name: 'New Name');
      when(() => mockDataSource.updateCategory(updatedCategory)).thenAnswer((_) async {});
      await repository.updateCategory(updatedCategory);
      verify(() => mockDataSource.updateCategory(updatedCategory)).called(1);
    });

    test('deleteCategory delegates to data source', () async {
      const categoryId = 1;
      when(() => mockDataSource.deleteCategory(categoryId)).thenAnswer((_) async {});
      await repository.deleteCategory(categoryId);
      verify(() => mockDataSource.deleteCategory(categoryId)).called(1);
    });
  });
} 