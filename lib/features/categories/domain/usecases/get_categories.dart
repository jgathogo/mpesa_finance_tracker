import 'package:mpesa_finance_tracker/features/categories/data/models/category_entity.dart';
import 'package:mpesa_finance_tracker/features/categories/domain/repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  GetCategories(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
} 