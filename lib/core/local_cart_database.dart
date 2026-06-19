import 'dart:developer';

import 'package:e_comm_user/models/wishlist_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:e_comm_user/models/cart_model.dart';

/// Guest cart persistence (SQLite). Logged-in users use the API via [CartRepository].
class LocalCartDatabase {
  static final LocalCartDatabase _instance = LocalCartDatabase._internal();
  static Database? _database;

  factory LocalCartDatabase() => _instance;

  LocalCartDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shopease.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL UNIQUE,
        product_name TEXT NOT NULL,
        product_price INTEGER NOT NULL,
        discount INTEGER,
        discount_price INTEGER,
        product_image_url TEXT,
        quantity INTEGER NOT NULL DEFAULT 1,
        is_synced INTEGER NOT NULL DEFAULT 0,
        total_price INTEGER NOT NULL,
        total_discount_price INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
  CREATE TABLE wishlist_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL UNIQUE,
    product_name TEXT NOT NULL,
    product_price INTEGER NOT NULL,
    discount INTEGER,
    discount_price INTEGER,
    product_image_url TEXT,
    is_synced INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  )
''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE cart_items ADD COLUMN product_image_url TEXT',
      );
    }
  }

  Future<int> addToCart(CartItem item) async {
    final db = await database;

    final productId = item.product_id;

    if (productId == null) return 0;

    final now = DateTime.now().toIso8601String();

    /// FIND ANY ITEM
    final existingItem = await db.query(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (existingItem.isNotEmpty) {
      final currentQuantity = existingItem.first['quantity'] as int;

      final productPrice = existingItem.first['product_price'] as int;
      final discountPrice = existingItem.first['discount_price'] as int;

      final newQuantity = currentQuantity + (item.quantity ?? 1);

      final newTotalPrice = newQuantity * productPrice;
      final newDiscountPrice = newQuantity * discountPrice;

      /// IMPORTANT
      /// mark as unsynced because user modified it
      return await db.update(
        'cart_items',
        {
          'quantity': newQuantity,
          'total_price': newTotalPrice,
          'total_discount_price': newDiscountPrice,

          // CRITICAL FIX
          'is_synced': 0,

          'updated_at': now,
        },
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    }

    final row = item.toLocalDbMap()
      ..['is_synced'] = 0
      ..['created_at'] = now
      ..['updated_at'] = now;

    return await db.insert(
      'cart_items',
      row,
    );
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final maps = await db.query(
      'cart_items',
      orderBy: 'created_at ASC',
    );
    return maps.map(CartItem.fromLocalDb).toList();
  }

  Future<int> updateQuantity(int productId, int quantity) async {
    final db = await database;
    final item = await db.query(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
    );

    if (item.isEmpty) return 0;

    final productPrice = item.first['product_price'] as int;
    final discountPrice = item.first['discount_price'] as int;
    final newTotalPrice = quantity * productPrice;
    final newDiscountPrice = quantity * discountPrice;

    return await db.update(
      'cart_items',
      {
        'quantity': quantity,
        'total_price': newTotalPrice,
        'total_discount_price': newDiscountPrice,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<int> removeItem(int productId) async {
    final db = await database;
    return await db.delete(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<int> clearCart() async {
    final db = await database;
    return await db.delete('cart_items');
  }

  Future<bool> isProductInCart(int productId) async {
    final db = await database;
    final result = await db.query(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<int> getCartItemCount() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(quantity) as total FROM cart_items');
    return result.first['total'] as int? ?? 0;
  }

  Future<int> getCartTotal() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(total_price) as total FROM cart_items');
    return result.first['total'] as int? ?? 0;
  }
  Future<int> getDiscountCartTotal() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(total_discount_price) as total_discount FROM cart_items');
    return result.first['total_discount'] as int? ?? 0;
  }
  // Get only unsynced items
  Future<List<CartItem>> getUnsyncedCartItems() async {
    final db = await database;

    final result = await db.query(
      'cart_items',
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return result.map((e) => CartItem.fromLocalDb(e)).toList();
  }
  //Mark all synced
  Future<void> markAllCartItemsSynced() async {
    final db = await database;

    await db.update(
      'cart_items',
      {
        'is_synced': 1,
      },
    );
  }
  Future<int> addToWishlist(WishlistItem item) async {
    final db = await database;

    final productId = item.product_id;

    if (productId == null) return 0;

    final exists = await db.query(
      'wishlist_items',
      where: 'product_id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (exists.isNotEmpty) {
      return 1;
    }

    final now = DateTime.now().toIso8601String();

    final row = item.toLocalDbMap()
      ..['is_synced'] = 0
      ..['created_at'] = now
      ..['updated_at'] = now;

    return await db.insert(
      'wishlist_items',
      row,
    );
  }

  Future<List<WishlistItem>> getWishlistItems() async {
    final db = await database;

    final maps = await db.query(
      'wishlist_items',
      orderBy: 'created_at DESC',
    );

    return maps.map(WishlistItem.fromLocalDb).toList();
  }

  Future<int> removeWishListItem(int productId) async {
    final db = await database;

    return await db.delete(
      'wishlist_items',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<int> clearWishlist() async {
    final db = await database;

    return await db.delete('wishlist_items');
  }

  Future<bool> isProductInWishlist(int productId) async {
    final db = await database;

    final result = await db.query(
      'wishlist_items',
      where: 'product_id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<int> getWishlistItemCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM wishlist_items',
    );

    return result.first['total'] as int? ?? 0;
  }

  Future<List<WishlistItem>>
  getUnsyncedWishlistItems() async {
    final db = await database;

    final result = await db.query(
      'wishlist_items',
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return result
        .map((e) => WishlistItem.fromLocalDb(e))
        .toList();
  }

  Future<void> markAllWishlistItemsSynced() async {
    final db = await database;

    await db.update(
      'wishlist_items',
      {
        'is_synced': 1,
      },
    );
  }
  Future<int> removeWishlistItem(int productId) async {
    final db = await database;
    return await db.delete(
      'wishlist_items',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }
}
