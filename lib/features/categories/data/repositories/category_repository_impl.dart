import '../models/category_entity.dart';
import 'category_data_source.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource _dataSource;

  CategoryRepositoryImpl({required CategoryDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<void> saveCategory(CategoryEntity category) async {
    await _dataSource.saveCategory(category);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await _dataSource.getCategories();
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    await _dataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _dataSource.deleteCategory(id);
  }
} 