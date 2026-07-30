import 'package:sqflite/sqflite.dart';
import 'package:kakeibo/database/app_database.dart';
import 'package:kakeibo/features/categories/domain/entities/category.dart';
import 'package:kakeibo/features/categories/domain/repositories/category_repository.dart';
import 'package:kakeibo/features/categories/data/models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  Future<Database> get _db => AppDatabase.database;

  @override
  Future<List<Category>> getAllCategories() async {
    final db = await _db;
    final results = await db.query('categories', orderBy: 'sort_order ASC');
    return results.map((map) => Category.fromModel(CategoryModel.fromMap(map))).toList();
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    final db = await _db;
    final results = await db.query('categories', where: 'id = ?', whereArgs: [id], limit: 1);
    if (results.isEmpty) return null;
    return Category.fromModel(CategoryModel.fromMap(results.first));
  }

  @override
  Future<Category> addCategory(Category category) async {
    final db = await _db;
    final id = await db.insert('categories', category.toModel().toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return category.copyWith(id: id);
  }

  @override
  Future<void> updateCategory(Category category) async {
    if (category.id == null) return;
    final db = await _db;
    await db.update(
      'categories',
      category.toModel().toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<void> deleteCategory(int id) async {
    final category = await getCategoryById(id);
    if (category == null) return;

    if (category.isDefault) {
      throw Exception('Cannot delete default categories');
    }

    final db = await _db;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> reorderCategories(List<Category> categories) async {
    final db = await _db;
    await db.transaction((txn) async {
      for (var i = 0; i < categories.length; i++) {
        final category = categories[i].copyWith(sortOrder: i);
        if (category.id != null) {
          await txn.update(
            'categories',
            category.toModel().toMap(),
            where: 'id = ?',
            whereArgs: [category.id],
          );
        }
      }
    });
  }
}
