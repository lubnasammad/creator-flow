import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('creator_flow.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        username $textType UNIQUE,
        email $textType,
        password_hash $textType,
        created_at $textType
      )
    ''');

    // Create shooting_schedule table
    await db.execute('''
      CREATE TABLE shooting_schedule (
        id $idType,
        user_id $intType,
        title $textType,
        description $textTypeNullable,
        shooting_date $textType,
        location $textTypeNullable,
        status $textType,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create posting_schedule table
    await db.execute('''
      CREATE TABLE posting_schedule (
        id $idType,
        user_id $intType,
        title $textType,
        description $textTypeNullable,
        post_date $textType,
        platform $textType,
        status $textType,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create brand_collaboration table
    await db.execute('''
      CREATE TABLE brand_collaboration (
        id $idType,
        user_id $intType,
        brand_name $textType,
        description $textTypeNullable,
        start_date $textType,
        end_date $textType,
        payment $realType,
        status $textType,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create barter_collaboration table
    await db.execute('''
      CREATE TABLE barter_collaboration (
        id $idType,
        user_id $intType,
        brand_name $textType,
        description $textTypeNullable,
        product_value $realType,
        start_date $textType,
        end_date $textType,
        status $textType,
        created_at $textType,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
