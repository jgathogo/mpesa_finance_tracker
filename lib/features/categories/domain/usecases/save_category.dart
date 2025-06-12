import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';
import 'package:mpesa_finance_tracker/features/categories/domain/repositories/category_repository.dart';

class SaveCategory {
  final CategoryRepository repository;

  SaveCategory(this.repository);

  Future<void> call(CategoryEntity category) async {
    await repository.saveCategory(category);
  }
} 