import '../models/barter_collaboration.dart';
import 'database_helper.dart';

class BarterCollaborationService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(BarterCollaboration collaboration) async {
    final db = await _dbHelper.database;
    return await db.insert('barter_collaboration', collaboration.toMap());
  }

  Future<List<BarterCollaboration>> getAll(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'barter_collaboration',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'start_date DESC',
    );

    return results.map((map) => BarterCollaboration.fromMap(map)).toList();
  }

  Future<BarterCollaboration?> getById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'barter_collaboration',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return BarterCollaboration.fromMap(results.first);
  }

  Future<int> update(BarterCollaboration collaboration) async {
    final db = await _dbHelper.database;
    return await db.update(
      'barter_collaboration',
      collaboration.toMap(),
      where: 'id = ?',
      whereArgs: [collaboration.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'barter_collaboration',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
