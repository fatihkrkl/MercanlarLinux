import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';


class DatabaseHelper {
  // Create a singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  var uuid = const Uuid();
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
    List<Map<String, String>> items = [
      {'id': '1', 'plaka': '34ABC123', 'sofor': 'Ahmet Yilmaz', 'per': 'Fatih Kürklü', 'sube': 'Istanbul'},
      {'id': '2', 'plaka': '35DEF456', 'sofor': 'Mehmet Kaya', 'per': 'Fatih Kürklü', 'sube': 'Izmir'},
      {'id': '3', 'plaka': '06GHI789', 'sofor': 'Fatma Demir', 'per': 'Fatih Kürklü', 'sube': 'Ankara'},
      {'id': '4', 'plaka': '07JKL012', 'sofor': 'Ali Çelik', 'per': 'Fatih Kürklü', 'sube': 'Antalya'},
      {'id': '5', 'plaka': '41MNO345', 'sofor': 'Elif Yildiz', 'per': 'Fatih Kürklü', 'sube': 'Kocaeli'},
    ];
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE items(id TEXT PRIMARY KEY, plaka TEXT , sofor TEXT, per TEXT, sube TEXT)',
        );

        for (var item in items) {
          await db.insert('items', item);
        }
        await db.execute(
          'CREATE TABLE kargo(barkod TEXT PRIMARY KEY, id TEXT, tip TEXT, evrakno TEXT, tarih TEXT, carino TEXT, unvan TEXT, resim TEXT, imza TEXT, teslimtarih TEXT, teslimalan TEXT, islem TEXT)',
        );
      },
    );
  }

  Future<String> insertItemD() async {
    final db = await database;

    String newId = uuid.v4();
    await db.insert(
      'items',
      {
        'id':newId,
        'plaka': "dfsfdsf",
        'sofor': "sofor12",
        'per': "per1",
        'sube': "sube12"},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return newId;
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

  Future<void> insertKargoD(String barkod,String id) async {
    try {
      final db = await database;
      await db.insert(
        'kargo',
        {
          'barkod': barkod,
          'id': id,
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

  Future<void> insertKargo(String barkod,String id,String tip,String evrakno,String tarih,String carino,String unvan,String resim,String imza,String teslimtarih,String teslimalan,String islem) async {
    try {
      final db = await database;
      await db.insert(
        'kargo',
        {
          'barkod': barkod,
          'id': id,
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
  Future<List<Map<String, dynamic>>> fetchKargo(String id) async {
    final db = await database;
    return await db.query('kargo',where: 'id = ?', whereArgs: [id]);
  }

  // Delete an item
  Future<void> deleteItem(String id) async {

    final db = await database;
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteKargo(String barkod) async {
    print("deleted $barkod");
    final db = await database;
    await db.delete(
      'kargo',
      where: 'barkod = ?',
      whereArgs: [barkod],
    );
  }
}