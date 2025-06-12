import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../categories/data/models/category_entity.dart';
import '../../../categories/domain/usecases/save_category.dart';
import '../../../categories/domain/usecases/get_categories.dart';
import '../../../categories/domain/usecases/update_category.dart';
import '../../../categories/domain/usecases/delete_category.dart';

// States for CategoryCubit
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;

  const CategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

/// Cubit for managing categories.
class CategoryCubit extends Cubit<CategoryState> {
  final SaveCategory _saveCategory;
  final GetCategories _getCategories;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;

  CategoryCubit(
    this._saveCategory,
    this._getCategories,
    this._updateCategory,
    this._deleteCategory,
  ) : super(CategoryInitial());

  Future<void> fetchCategories() async {
    try {
      emit(CategoryLoading());
      final categories = await _getCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError('Failed to fetch categories: $e'));
    }
  }

  Future<void> addCategory(String name) async {
    try {
      emit(CategoryLoading());
      final newCategory = CategoryEntity(name: name);
      await _saveCategory(newCategory);
      fetchCategories(); // Refresh the list
    } catch (e) {
      emit(CategoryError('Failed to add category: $e'));
    }
  }

  Future<void> editCategory(CategoryEntity category) async {
    try {
      emit(CategoryLoading());
      await _updateCategory(category);
      fetchCategories(); // Refresh the list
    } catch (e) {
      emit(CategoryError('Failed to edit category: $e'));
    }
  }

  Future<void> removeCategory(int id) async {
    try {
      emit(CategoryLoading());
      await _deleteCategory(id);
      fetchCategories(); // Refresh the list
    } catch (e) {
      emit(CategoryError('Failed to delete category: $e'));
    }
  }
} 