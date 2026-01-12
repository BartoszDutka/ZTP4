import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';

/// Serwis do obsługi lokalnego cache produktów (SQLite)
/// Pozwala na przeglądanie produktów w trybie offline
class ProductCacheService {
  static const String _databaseName = 'products_cache.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'products';

  Database? _database;

  /// Inicjalizuje bazę danych
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        cachedAt TEXT NOT NULL
      )
    ''');
  }

  /// Zapisuje listę produktów do cache
  Future<void> cacheProducts(List<ProductModel> products) async {
    final db = await database;
    final batch = db.batch();
    final now = DateTime.now().toIso8601String();

    // Czyścimy stary cache i zapisujemy nowy
    batch.delete(_tableName);
    for (final product in products) {
      batch.insert(
        _tableName,
        {
          'id': product.id,
          'name': product.name,
          'category': product.category,
          'price': product.price,
          'quantity': product.quantity,
          'createdAt': product.createdAt.toIso8601String(),
          'cachedAt': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// Zapisuje/aktualizuje pojedynczy produkt w cache (z pełnymi danymi)
  Future<void> cacheProduct(ProductModel product) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.insert(
      _tableName,
      {
        'id': product.id,
        'name': product.name,
        'category': product.category,
        'price': product.price,
        'quantity': product.quantity,
        'createdAt': product.createdAt.toIso8601String(),
        'cachedAt': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Pobiera wszystkie produkty z cache
  Future<List<ProductModel>> getCachedProducts() async {
    final db = await database;
    final maps = await db.query(_tableName);

    return maps.map((map) => ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    )).toList();
  }

  /// Pobiera pojedynczy produkt z cache
  Future<ProductModel?> getCachedProductById(String id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final map = maps.first;
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  /// Sprawdza czy cache zawiera dane
  Future<bool> hasCache() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }
}
