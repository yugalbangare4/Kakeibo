import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:kakeibo/core/constants/app_constants.dart';

class AppDatabase {
  static Database? _database;
  static const String _dbName = 'kakeibo.db';
  static const int _dbVersion = 1;

  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon_name TEXT NOT NULL,
        color_index INTEGER NOT NULL,
        sort_order INTEGER NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        note TEXT,
        category_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      )
    ''');
    await db.execute('CREATE INDEX idx_expenses_date ON expenses(date)');
    
    // Seed default categories
    await _seedCategories(db);
  }

  static Future<void> _seedCategories(Database db) async {
    final now = DateTime.now().toIso8601String();
    int sortOrder = 0;
    
    for (final cat in AppConstants.defaultCategories) {
      await db.insert('categories', {
        'name': cat['name'],
        'icon_name': cat['iconName'],
        'color_index': cat['colorIndex'],
        'sort_order': sortOrder++,
        'is_default': 1,
        'created_at': now,
      });
    }
  }
}
