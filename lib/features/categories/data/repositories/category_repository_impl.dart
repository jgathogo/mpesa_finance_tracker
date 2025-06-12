import 'package:isar/isar.dart';
import 'package:mpesa_finance_tracker/core/services/isar_service.dart';
import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';
import 'package:mpesa_finance_tracker/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final IsarCollection<CategoryEntity> _categoryCollection;

  CategoryRepositoryImpl({required IsarCollection<CategoryEntity> categoryCollection})
      : _categoryCollection = categoryCollection;

  @override
  Future<void> saveCategory(CategoryEntity category) async {
    await _categoryCollection.isar.writeTxn(() async {
      await _categoryCollection.put(category);
    });
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await _categoryCollection.where().findAll();
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    await _categoryCollection.isar.writeTxn(() async {
      // Check if the category exists before updating
      final existingCategory = await _categoryCollection.get(category.id);
      if (existingCategory != null) {
        await _categoryCollection.put(category);
      }
    });
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _categoryCollection.isar.writeTxn(() async {
      await _categoryCollection.delete(id);
    });
  }
} 