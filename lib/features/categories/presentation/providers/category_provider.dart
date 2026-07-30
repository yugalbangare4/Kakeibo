import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo/features/categories/data/category_repository_impl.dart';
import 'package:kakeibo/features/categories/domain/entities/category.dart';

final categoryRepositoryProvider = Provider<CategoryRepositoryImpl>((ref) {
  return CategoryRepositoryImpl();
});

final allCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getAllCategories();
});

final categoryByIdProvider = FutureProvider.family<Category?, int>((ref, id) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getCategoryById(id);
});

class CategoryNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final CategoryRepositoryImpl _repository;
  final Ref _ref;

  CategoryNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _repository.getAllCategories();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addCategory(Category category) async {
    await _repository.addCategory(category);
    _ref.invalidate(allCategoriesProvider);
    await _loadCategories();
  }

  Future<void> updateCategory(Category category) async {
    await _repository.updateCategory(category);
    _ref.invalidate(allCategoriesProvider);
    _ref.invalidate(categoryByIdProvider(category.id!));
    await _loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _repository.deleteCategory(id);
    _ref.invalidate(allCategoriesProvider);
    _ref.invalidate(categoryByIdProvider(id));
    await _loadCategories();
  }

  Future<void> reorder(List<Category> categories) async {
    state = AsyncValue.data(categories);
    await _repository.reorderCategories(categories);
    _ref.invalidate(allCategoriesProvider);
  }
}

final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, AsyncValue<List<Category>>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryNotifier(repository, ref);
});
