import 'dart:async';
import 'package:oiichat/models/useri_info_model.dart';
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
        db.execute(
            'CREATE TABLE messages (id INTEGER PRIMARY KEY AUTOINCREMENT, user1 TEXT NOT NULL, user2 TEXT NOT NULL, message TEXT NOT NULL,status INTEGER, timestamp TEXT NOT NULL)');

        db.execute(
            'CREATE TABLE user_info (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT NOT NULL, user_name TEXT NOT NULL, user_image TEXT NOT NULL)');
      },
    );
  }

  Future<int> insertOrUpdateUserInfo(UseriInfoModel model) async {
    final db = await database;

    // Check if the user already exists
    final existingRecord = await db.query(
      'user_info',
      where: 'user_id = ?', // Assuming 'id' is the primary key
      whereArgs: [model.user_id],
    );

    if (existingRecord.isNotEmpty) {
      // Update the record if it already exists
      return await db.rawUpdate('''
        UPDATE user_info 
        SET user_name = ? ,
        user_image = ? 
        WHERE user_id = ?
      ''', [model.user_name, model.user_image, model.user_id]);
    } else {
      // Insert a new record if it doesn't exist
      return await db.insert('user_info', model.toMap());
    }
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

  // Query to get the last message for each user
  Future<List<Map<String, dynamic>>> getChatList(String currentUser) async {
    final db = await database;

    // Query to get the last message for each user
    return await db.rawQuery('''
      SELECT 
        CASE 
          WHEN user1 = ? THEN user2 
          ELSE user1 
        END AS chatUser, 
        MAX(timestamp) AS lastMessageTime, 
        message,
        user_info.user_name AS chatUserName,
        user_info.user_image AS chatUserImage
      FROM messages
      LEFT JOIN user_info ON user_info.user_id = (
        CASE 
          WHEN user1 = ? THEN user2 
          ELSE user1 
        END
      )
      WHERE user1 = ? OR user2 = ?
      GROUP BY chatUser
      ORDER BY lastMessageTime DESC
    ''', [currentUser, currentUser, currentUser, currentUser]);
  }

  Future<int> updateMessageStatus(int id, int newStatus) async {
    final db = await database;
    return await db.update(
      'messages', // Table name
      {'status': newStatus}, // Column and value to update
      where: 'id = ?', // WHERE clause
      whereArgs: [id], // Value for the WHERE clause
    );
  }

  Future<List<Message>> check_offline_message(String user1) async {
    final db = await database;
    final maps = await db.query('messages',
        where: '(user1 = ? AND status = ?)',
        whereArgs: [user1, 0],
        orderBy: 'timestamp ASC');

    // Convert List<Map<String, dynamic>> to List<Message>
    return maps.map((map) => Message.fromMap(map)).toList();
  }
}
