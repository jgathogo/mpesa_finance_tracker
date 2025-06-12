import '../models/category_entity.dart';

abstract class CategoryDataSource {
  Future<void> saveCategory(CategoryEntity category);
  Future<List<CategoryEntity>> getCategories();
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(int id);
} 