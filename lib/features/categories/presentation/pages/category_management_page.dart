import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../categories/data/models/category_entity.dart';
import '../bloc/category_cubit.dart';

class CategoryManagementPage extends StatelessWidget {
  const CategoryManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _categoryNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: BlocConsumer<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _categoryNameController,
                          decoration: const InputDecoration(
                            labelText: 'New Category Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_categoryNameController.text.isNotEmpty) {
                            context.read<CategoryCubit>().addCategory(
                                  _categoryNameController.text,
                                );
                            _categoryNameController.clear();
                          }
                        },
                        child: const Text('Add Category'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return ListTile(
                        title: Text(category.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditCategoryDialog(context, category);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                context.read<CategoryCubit>().removeCategory(category.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is CategoryInitial) {
            context.read<CategoryCubit>().fetchCategories();
            return const Center(child: Text('Loading categories...'));
          } else if (state is CategoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No categories found.'));
        },
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, CategoryEntity category) {
    final TextEditingController _editController = TextEditingController(text: category.name);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (_editController.text.isNotEmpty) {
                  final updatedCategory = CategoryEntity(id: category.id, name: _editController.text);
                  context.read<CategoryCubit>().editCategory(updatedCategory);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
} 