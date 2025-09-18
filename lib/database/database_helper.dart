import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static Db? _mongoDb;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal() {
    _initializeMongoDb();
  }

  Future<void> _initializeMongoDb() async {
    if (_mongoDb == null) {
      // Replace <db_password> with your actual password
      _mongoDb = Db(
          'mongodb+srv://dbUser:Moh%40mmed_10@cluster0.9hv9acb.mongodb.net/erp_database?retryWrites=true&w=majority');
      await _mongoDb!.open();
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    String path = join(await getDatabasesPath(), 'erp_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT UNIQUE,
        email TEXT UNIQUE,
        password TEXT,
        isVerified INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE employees (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        phone TEXT,
        position TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        price REAL,
        stock INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE sales (
        id TEXT PRIMARY KEY,
        customerId TEXT,
        productId TEXT,
        quantity INTEGER,
        total REAL,
        date TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        type TEXT,
        amount REAL,
        description TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    Database db = await database;
    int localResult = await db.insert('users', user.toJson());
    // Save to MongoDB online
    if (_mongoDb != null && _mongoDb!.state == State.OPEN) {
      await _mongoDb!.collection('users').insertOne(user.toJson());
    }
    return localResult;
  }

  Future<User?> getUser(String username, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    // If not found locally, try online
    if (_mongoDb != null && _mongoDb!.state == State.OPEN) {
      Map<String, dynamic>? data =
          await _mongoDb!.collection('users').findOne(where.eq('email', email));
      if (data != null) {
        User user = User.fromJson(data);
        // Save to local for future use
        await db.insert('users', user.toJson());
        return user;
      }
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    Database db = await database;
    int localResult = await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    // Update in MongoDB online
    if (_mongoDb != null && _mongoDb!.state == State.OPEN) {
      await _mongoDb!
          .collection('users')
          .replaceOne(where.eq('id', user.id), user.toJson());
    }
    return localResult;
  }
}
