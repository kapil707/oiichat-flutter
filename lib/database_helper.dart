import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/message.dart';

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
        db.execute('CREATE TABLE messages (id INTEGER PRIMARY KEY AUTOINCREMENT, user1 TEXT NOT NULL, user2 TEXT NOT NULL, message TEXT NOT NULL, timestamp TEXT NOT NULL)');
      },
    );
  }

  // Insert a Message object into the database
  Future<int> insertMessage(Message message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getMessages(String user1, String user2) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: '(user1 = ? AND user2 = ?) OR (user1 = ? AND user2 = ?)',
      whereArgs: [user1, user2, user2, user1],
      orderBy: 'timestamp ASC',
    );

    // Convert the List<Map<String, dynamic>> to List<Message>
    return maps.map((map) => Message.fromMap(map)).toList();
  }

  Future<void> deleteMessages(String user1, String user2) async {
    final db = await database;

    // Delete messages between user1 and user2
    await db.delete(
      'messages',
      where: '(user1 = ? AND user2 = ?) OR (user1 = ? AND user2 = ?)',
      whereArgs: [user1, user2, user2, user1],
    );
  }

  Future<List<Map<String, dynamic>>> getChatList(String currentUser) async {
    final db = await database;

    // Query to get the last message for each user
    return await db.rawQuery('''
      SELECT user2 AS chatUser, MAX(timestamp) AS lastMessageTime, message
      FROM messages
      WHERE user1 = ? OR user2 = ?
      GROUP BY chatUser
      ORDER BY lastMessageTime DESC
    ''', [currentUser, currentUser]);
  }
}
