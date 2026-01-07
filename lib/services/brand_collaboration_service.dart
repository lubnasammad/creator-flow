import '../models/brand_collaboration.dart';
import 'database_helper.dart';

class BrandCollaborationService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(BrandCollaboration collaboration) async {
    final db = await _dbHelper.database;
    return await db.insert('brand_collaboration', collaboration.toMap());
  }

  Future<List<BrandCollaboration>> getAll(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'brand_collaboration',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'start_date DESC',
    );

    return results.map((map) => BrandCollaboration.fromMap(map)).toList();
  }

  Future<BrandCollaboration?> getById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'brand_collaboration',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return BrandCollaboration.fromMap(results.first);
  }

  Future<int> update(BrandCollaboration collaboration) async {
    final db = await _dbHelper.database;
    return await db.update(
      'brand_collaboration',
      collaboration.toMap(),
      where: 'id = ?',
      whereArgs: [collaboration.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'brand_collaboration',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
