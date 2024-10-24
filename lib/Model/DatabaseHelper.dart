import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  // Create a singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._privateConstructor();

  // Database reference
  static Database? _database;

  // Method to get the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    print("Database path: $path"); // Log the database path
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE items(plaka TEXT PRIMARY KEY)',
        );
        await db.execute(
          'CREATE TABLE kargo(barkod INTEGER PRIMARY KEY, name TEXT,plaka TEXT)',
        );
      },
    );
  }



  // Insert an item into the database
  Future<void> insertItem(String plaka) async {
    final db = await database;
    await db.insert(
      'items',
      {'plaka': plaka},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertKargo(String name,String plaka) async {
    try {
      final db = await database;
      await db.insert(
        'kargo',
        {
          'name': name,
          'plaka': plaka,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting kargo: $e'); // Log the error
    }
  }

  // Retrieve all items from the database
  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await database;
    return await db.query('items');
  }
  Future<List<Map<String, dynamic>>> fetchKargo(String plaka) async {
    final db = await database;
    return await db.query('kargo',where: 'plaka = ?', whereArgs: [plaka],);
  }

  // Update an item
  Future<void> updateItem(String plaka, String newName) async {
    final db = await database;
    await db.update(
      'items',
      {'name': newName},
      where: 'plaka = ?',
      whereArgs: [plaka],
    );
  }

  Future<void> updateKargo(int barkod, String newName) async {
    final db = await database;
    await db.update(
      'kargo',
      {'name': newName},
      where: 'barkod = ?',
      whereArgs: [barkod],
    );
  }

  // Delete an item
  Future<void> deleteItem(String plaka) async {
    final db = await database;
    await db.delete(
      'items',
      where: 'plaka = ?',
      whereArgs: [plaka],
    );
  }

  Future<void> deleteKargo(int barkod) async {
    final db = await database;
    await db.delete(
      'kargo',
      where: 'barkod = ?',
      whereArgs: [barkod],
    );
  }
}