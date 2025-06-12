import 'package:mpesa_finance_tracker/features/categories/domain/repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory(this.repository);

  Future<void> call(int id) async {
    await repository.deleteCategory(id);
  }
} 