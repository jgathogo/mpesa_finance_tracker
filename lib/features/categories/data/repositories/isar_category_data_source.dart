import 'package:isar/isar.dart';
import '../models/category_entity.dart';
import 'category_data_source.dart';

class IsarCategoryDataSource implements CategoryDataSource {
  final IsarCollection<CategoryEntity> _categoryCollection;

  IsarCategoryDataSource(this._categoryCollection);

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