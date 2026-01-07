import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import 'database_helper.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<User?> login(String username, String password) async {
    final db = await _dbHelper.database;
    final hashedPassword = _hashPassword(password);

    final results = await db.query(
      'users',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, hashedPassword],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return User.fromMap(results.first);
  }

  Future<User?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final db = await _dbHelper.database;
    final hashedPassword = _hashPassword(password);
    final createdAt = DateTime.now().toIso8601String();

    try {
      final id = await db.insert('users', {
        'username': username,
        'email': email,
        'password_hash': hashedPassword,
        'created_at': createdAt,
      }, conflictAlgorithm: ConflictAlgorithm.fail);

      return User(
        id: id,
        username: username,
        email: email,
        passwordHash: hashedPassword,
        createdAt: createdAt,
      );
    } catch (e) {
      // Username already exists
      return null;
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return results.isEmpty;
  }

  Future<User?> getUserById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return User.fromMap(results.first);
  }
}
