import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';

abstract class CategoryRepository {
  Future<void> saveCategory(CategoryEntity category);
  Future<List<CategoryEntity>> getCategories();
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(int id);
} 