import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';
import 'package:mpesa_finance_tracker/features/categories/domain/repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory(this.repository);

  Future<void> call(CategoryEntity category) async {
    await repository.updateCategory(category);
  }
} 