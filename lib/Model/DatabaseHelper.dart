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
          'CREATE TABLE items(plaka TEXT PRIMARY KEY, sofor TEXT, per TEXT, sube TEXT)',
        );
        await db.execute(
          'CREATE TABLE kargo(barkod INTEGER PRIMARY KEY, plaka TEXT, tip TEXT, evrakno TEXT, tarih TEXT, carino TEXT, unvan TEXT, resim TEXT, imza TEXT, teslimtarih TEXT, teslimalan TEXT, islem TEXT)',
        );
      },
    );
  }

  Future<void> insertItemD(String plaka) async {
    final db = await database;
    await db.insert(
      'items',
      {'plaka': plaka,
        'sofor': "sofor",
        'per': "per",
        'sube': "sube"},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert an item into the database
  Future<void> insertItem(String plaka,String sofor,String per,String sube) async {
    final db = await database;
    await db.insert(
      'items',
      {'plaka': plaka,
        'sofor': sofor,
        'per': per,
        'sube': sube},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertKargoD(int barkod,String plaka) async {
    try {
      final db = await database;
      await db.insert(
        'kargo',
        {
          'barkod': barkod,
          'plaka': plaka,
          'tip': "tip",
          'evrakno': "evrakno",
          'tarih': "tarih",
          'carino': "carino",
          'unvan': "unvan",
          'resim': "resim",
          'imza': "imza",
          'teslimtarih': "teslimtarih",
          'teslimalan': "teslimalan",
          'islem': "islem",
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting kargo: $e'); // Log the error
    }
  }

  Future<void> insertKargo(int barkod,String plaka,String tip,String evrakno,String tarih,String carino,String unvan,String resim,String imza,String teslimtarih,String teslimalan,String islem) async {
    try {
      final db = await database;
      await db.insert(
        'kargo',
        {
          'barkod': barkod,
          'plaka': plaka,
          'tip': tip,
          'evrakno': evrakno,
          'tarih': tarih,
          'carino': carino,
          'unvan': unvan,
          'resim': resim,
          'imza': imza,
          'teslimtarih': teslimtarih,
          'teslimalan': teslimalan,
          'islem': islem,
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
    return await db.query('kargo',where: 'plaka = ?', whereArgs: [plaka]);
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
    print("deleted $barkod");
    final db = await database;
    await db.delete(
      'kargo',
      where: 'barkod = ?',
      whereArgs: [barkod],
    );
  }
}