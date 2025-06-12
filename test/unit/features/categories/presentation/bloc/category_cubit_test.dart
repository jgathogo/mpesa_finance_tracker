import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';
import 'package:mpesa_finance_tracker/features/categories/domain/usecases/delete_category.dart';
import 'package:mpesa_finance_tracker/features/categories/domain/usecases/get_categories.dart';
import 'package:mpesa_finance_tracker/features/categories/domain/usecases/save_category.dart';
import 'package:mpesa_finance_tracker/features/categories/domain/usecases/update_category.dart';
import 'package:mpesa_finance_tracker/features/categories/presentation/bloc/category_cubit.dart';

// Mock the use cases
class MockSaveCategory extends Mock implements SaveCategory {}

class MockGetCategories extends Mock implements GetCategories {}

class MockUpdateCategory extends Mock implements UpdateCategory {}

class MockDeleteCategory extends Mock implements DeleteCategory {}

void main() {
  group('CategoryCubit', () {
    late CategoryCubit categoryCubit;
    late MockSaveCategory mockSaveCategory;
    late MockGetCategories mockGetCategories;
    late MockUpdateCategory mockUpdateCategory;
    late MockDeleteCategory mockDeleteCategory;

    setUp(() {
      mockSaveCategory = MockSaveCategory();
      mockGetCategories = MockGetCategories();
      mockUpdateCategory = MockUpdateCategory();
      mockDeleteCategory = MockDeleteCategory();
      categoryCubit = CategoryCubit(
        mockSaveCategory,
        mockGetCategories,
        mockUpdateCategory,
        mockDeleteCategory,
      );
    });

    tearDown(() {
      categoryCubit.close();
      resetMocktailState();
    });

    test('initial state is CategoryInitial', () {
      expect(categoryCubit.state, CategoryInitial());
    });

    blocTest<
        CategoryCubit,
        CategoryState>(
      'emits [CategoryLoading, CategoryLoaded] when fetchCategories is successful',
      build: () {
        when(() => mockGetCategories()).thenAnswer((_) async => [
              CategoryEntity(name: 'Food', id: 1),
            ]);
        return categoryCubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        CategoryLoading(),
        CategoryLoaded([CategoryEntity(name: 'Food', id: 1)]),
      ],
      verify: (_) {
        verify(() => mockGetCategories()).called(1);
      },
    );

    blocTest<
        CategoryCubit,
        CategoryState>(
      'emits [CategoryLoading, CategoryError] when fetchCategories fails',
      build: () {
        when(() => mockGetCategories()).thenThrow(Exception('Failed to fetch'));
        return categoryCubit;
      },
      act: (cubit) => cubit.fetchCategories(),
      expect: () => [
        CategoryLoading(),
        const CategoryError('Failed to fetch categories: Exception: Failed to fetch'),
      ],
      verify: (_) {
        verify(() => mockGetCategories()).called(1);
      },
    );

    blocTest<
        CategoryCubit,
        CategoryState>(
      'emits [CategoryLoading, CategoryLoaded] when addCategory is successful',
      build: () {
        when(() => mockSaveCategory(any())).thenAnswer((_) async => Future.value());
        when(() => mockGetCategories()).thenAnswer((_) async => [
              CategoryEntity(name: 'New Category', id: 1),
            ]);
        return categoryCubit;
      },
      act: (cubit) => cubit.addCategory('New Category'),
      expect: () => [
        CategoryLoading(),
        CategoryLoaded([CategoryEntity(name: 'New Category', id: 1)]),
      ],
      verify: (_) {
        verify(() => mockSaveCategory(any(that: isA<CategoryEntity>()))).called(1);
        verify(() => mockGetCategories()).called(1);
      },
    );

    blocTest<
        CategoryCubit,
        CategoryState>(
      'emits [CategoryLoading, CategoryError] when addCategory fails',
      build: () {
        when(() => mockSaveCategory(any())).thenThrow(Exception('Failed to save'));
        return categoryCubit;
      },
      act: (cubit) => cubit.addCategory('New Category'),
      expect: () => [
        CategoryLoading(),
        const CategoryError('Failed to add category: Exception: Failed to save'),
      ],
      verify: (_) {
        verify(() => mockSaveCategory(any(that: isA<CategoryEntity>()))).called(1);
      },
    );

    blocTest<
        CategoryCubit,
        CategoryState>(
      'emits [CategoryLoading, CategoryLoaded] when editCategory is successful',
      build: () {
        final updatedCategory = CategoryEntity(name: 'Updated Category', id: 1);
        when(() => mockUpdateCategory(any())).thenAnswer((_) async => Future.value());
        when(() => mockGetCategories()).thenAnswer((_) async => [updatedCategory]);
        return categoryCubit;
      },
      act: (cubit) => cubit.editCategory(CategoryEntity(name: 'Updated Category', id: 1)),
      expect: () => [
        CategoryLoading(),
        CategoryLoaded([CategoryEntity(name: 'Updated Category', id: 1)]),
      ],
      verify: (_) {
        verify(() => mockUpdateCategory(any(that: isA<CategoryEntity>()))).called(1);
        verify(() => mockGetCategories()).called(1);
      },
    );

    blocTest<
        CategoryCubit,
        CategoryState>(
      'emits [CategoryLoading, CategoryError] when editCategory fails',
      build: () {
        when(() => mockUpdateCategory(any())).thenThrow(Exception('Failed to update'));
        return categoryCubit;
      },
      act: (cubit) => cubit.editCategory(CategoryEntity(name: 'Updated Category', id: 1)),
      expect: () => [
        CategoryLoading(),
        const CategoryError('Failed to edit category: Exception: Failed to update'),
      ],
      verify: (_) {
        verify(() => mockUpdateCategory(any(that: isA<CategoryEntity>()))).called(1);
      },
    );

    blocTest<
        CategoryCubit,
        CategoryState>(
      'emits [CategoryLoading, CategoryLoaded] when removeCategory is successful',
      build: () {
        when(() => mockDeleteCategory(any())).thenAnswer((_) async => Future.value());
        when(() => mockGetCategories()).thenAnswer((_) async => []);
        return categoryCubit;
      },
      act: (cubit) => cubit.removeCategory(1),
      expect: () => [
        CategoryLoading(),
        CategoryLoaded([]),
      ],
      verify: (_) {
        verify(() => mockDeleteCategory(1)).called(1);
        verify(() => mockGetCategories()).called(1);
      },
    );

    blocTest<
        CategoryCubit,
        CategoryState>(
      'emits [CategoryLoading, CategoryError] when removeCategory fails',
      build: () {
        when(() => mockDeleteCategory(any())).thenThrow(Exception('Failed to delete'));
        return categoryCubit;
      },
      act: (cubit) => cubit.removeCategory(1),
      expect: () => [
        CategoryLoading(),
        const CategoryError('Failed to delete category: Exception: Failed to delete'),
      ],
      verify: (_) {
        verify(() => mockDeleteCategory(1)).called(1);
      },
    );
  });
} 