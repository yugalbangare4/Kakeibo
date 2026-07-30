import 'package:kakeibo/features/categories/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
  Future<Category?> getCategoryById(int id);
  Future<Category> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(int id);
  Future<void> reorderCategories(List<Category> categories);
}
