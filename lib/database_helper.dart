import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'oii_chat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('CREATE TABLE messages (id INTEGER PRIMARY KEY AUTOINCREMENT,user1 TEXT NOT NULL,user2 TEXT NOT NULL,message TEXT NOT NULL,timestamp TEXT NOT NULL)');
      },
    );
  }

  // Insert a message into the database
  Future<int> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    return await db.insert('messages', message);
  }

  // Fetch all messages from the database (for debugging)
  Future<List<Map<String, dynamic>>> getAllMessages() async {
    final db = await database;
    return await db.query('messages'); // Query the 'messages' table
  }

  // Retrieve messages between two users
  Future<List<Map<String, dynamic>>> getMessages(String user1, String user2) async {
    final db = await database;
    return await db.query(
      'messages',
      where: '(user1 = ? AND user2 = ?) OR (user1 = ? AND user2 = ?)',
      whereArgs: [user1, user2, user2, user1],
      orderBy: 'timestamp ASC',
    );
  }
}
