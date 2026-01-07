import '../models/posting_schedule.dart';
import 'database_helper.dart';

class PostingScheduleService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(PostingSchedule schedule) async {
    final db = await _dbHelper.database;
    return await db.insert('posting_schedule', schedule.toMap());
  }

  Future<List<PostingSchedule>> getAll(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'posting_schedule',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'post_date DESC',
    );

    return results.map((map) => PostingSchedule.fromMap(map)).toList();
  }

  Future<PostingSchedule?> getById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'posting_schedule',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return PostingSchedule.fromMap(results.first);
  }

  Future<List<PostingSchedule>> getByDate(int userId, String date) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'posting_schedule',
      where: 'user_id = ? AND post_date = ?',
      whereArgs: [userId, date],
    );

    return results.map((map) => PostingSchedule.fromMap(map)).toList();
  }

  Future<int> update(PostingSchedule schedule) async {
    final db = await _dbHelper.database;
    return await db.update(
      'posting_schedule',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'posting_schedule',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
