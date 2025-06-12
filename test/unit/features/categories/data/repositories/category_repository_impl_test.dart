import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';
import 'package:mpesa_finance_tracker/features/categories/data/repositories/category_repository_impl.dart';
import 'package:flutter/services.dart'; // Import for MethodChannel

// Mock IsarCollection and also Query for chaining .where().findAll()
class MockIsarCollectionCategoryEntity extends Mock
    implements IsarCollection<CategoryEntity>, Query<CategoryEntity> {}

// Mock Isar
class MockIsar extends Mock implements Isar {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter binding for tests

  late CategoryRepositoryImpl repository;
  late MockIsarCollectionCategoryEntity mockCategoryCollection;
  late MockIsar mockIsar;

  setUpAll(() {
    // Register a fallback value for CategoryEntity if needed by mocktail
    registerFallbackValue(CategoryEntity(name: ''));

    // Mock path_provider's method channel
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return 'mock/app/documents/directory';
      }
      return null; // For any other method calls on this channel
    });
  });

  setUp(() {
    mockCategoryCollection = MockIsarCollectionCategoryEntity();
    mockIsar = MockIsar();

    // Stub the isar getter on the mock collection
    when(() => mockCategoryCollection.isar).thenReturn(mockIsar);

    // Stub where() to return the mockCategoryCollection itself, 
    // so that .findAll() can be called on it directly.
    when(() => mockCategoryCollection.where()).thenReturn(mockCategoryCollection);

    // Default stub for findAll()
    when(() => mockCategoryCollection.findAll()).thenAnswer((_) async => []);

    repository = CategoryRepositoryImpl(categoryCollection: mockCategoryCollection);
  });

  tearDown(() {
    // Clean up mocks if necessary
    resetMocktailState();
  });

  group('CategoryRepositoryImpl', () {
    test('saveCategory saves a category to Isar', () async {
      final category = CategoryEntity(name: 'Food');
      when(() => mockIsar.writeTxn<void>(any())).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as Future<void> Function();
        await callback();
        return Future.value(); // Explicitly return a Future<void>
      });
      when(() => mockCategoryCollection.put(any())).thenAnswer((_) async => 1); // Simulate successful put

      await repository.saveCategory(category);

      verify(() => mockCategoryCollection.put(category)).called(1);
    });

    test('getCategories returns a list of categories from Isar', () async {
      final categories = [
        CategoryEntity(name: 'Food'),
        CategoryEntity(name: 'Transport'),
      ];

      when(() => mockCategoryCollection.findAll()).thenAnswer((_) async => categories);

      final result = await repository.getCategories();

      expect(result, categories);
      verify(() => mockCategoryCollection.where()).called(1);
      verify(() => mockCategoryCollection.findAll()).called(1);
    });

    test('updateCategory updates an existing category in Isar', () async {
      final existingCategory = CategoryEntity(name: 'Old Name');
      existingCategory.id = 1; // Simulate Isar assigning an ID
      final updatedCategory = CategoryEntity(name: 'New Name');
      updatedCategory.id = 1;

      when(() => mockIsar.writeTxn<void>(any())).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as Future<void> Function();
        await callback();
        return Future.value(); // Explicitly return a Future<void>
      });
      when(() => mockCategoryCollection.get(existingCategory.id))
          .thenAnswer((_) async => existingCategory);
      when(() => mockCategoryCollection.put(any())).thenAnswer((_) async => 1);

      await repository.updateCategory(updatedCategory);

      verify(() => mockCategoryCollection.get(existingCategory.id)).called(1);
      verify(() => mockCategoryCollection.put(updatedCategory)).called(1);
    });

    test('deleteCategory deletes a category from Isar', () async {
      const categoryId = 1;
      when(() => mockIsar.writeTxn<void>(any())).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0] as Future<void> Function();
        await callback();
        return Future.value(); // Explicitly return a Future<void>
      });
      when(() => mockCategoryCollection.delete(categoryId)).thenAnswer((_) async => true); // Simulate successful delete

      await repository.deleteCategory(categoryId);

      verify(() => mockCategoryCollection.delete(categoryId)).called(1);
    });
  });
} 