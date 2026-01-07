import '../models/shooting_schedule.dart';
import 'database_helper.dart';

class ShootingScheduleService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(ShootingSchedule schedule) async {
    final db = await _dbHelper.database;
    return await db.insert('shooting_schedule', schedule.toMap());
  }

  Future<List<ShootingSchedule>> getAll(int userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'shooting_schedule',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'shooting_date DESC',
    );

    return results.map((map) => ShootingSchedule.fromMap(map)).toList();
  }

  Future<ShootingSchedule?> getById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'shooting_schedule',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return ShootingSchedule.fromMap(results.first);
  }

  Future<List<ShootingSchedule>> getByDate(int userId, String date) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      'shooting_schedule',
      where: 'user_id = ? AND shooting_date = ?',
      whereArgs: [userId, date],
    );

    return results.map((map) => ShootingSchedule.fromMap(map)).toList();
  }

  Future<int> update(ShootingSchedule schedule) async {
    final db = await _dbHelper.database;
    return await db.update(
      'shooting_schedule',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'shooting_schedule',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
