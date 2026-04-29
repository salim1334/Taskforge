import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _taskTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksContentColumnName = "content";
  final String _tasksStatusColumnName = "status";

  Future<Database> get database async {
    if (_db == null) {
      _db = await getDatabase();
    }
    return _db!;
  }

  DatabaseService._constructor();

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database =
        await openDatabase(databasePath, version: 1, onCreate: (db, version) {
      db.execute('''
          CREATE TABLE $_taskTableName (
            $_tasksIdColumnName INTEGER PRIMARY KEY,
            $_tasksContentColumnName TEXT NOT NULL,
            $_tasksStatusColumnName   INTEGER NOT NULL
          )
        ''');
    });
    return database;
  }

  void addTask(String content) async {
    final db = await database;
    await db.insert(_taskTableName, {
      _tasksContentColumnName: content,
      _tasksStatusColumnName: 0,
    });
  }

  Future<List<Task>> getTask() async {
    final db = await database;
    final data = await db.query(_taskTableName);
    List<Task> tasks = data
        .map((e) => Task(
            id: e['id'] as int,
            status: e['status'] as int,
            content: e['content'] as String))
        .toList();
    return tasks;
  }

  void updateTakStatus(int id, int status) async {
    final db = await database;
    await db.update(
        _taskTableName,
        {
          _tasksStatusColumnName: status,
        },
        where: 'id = ?',
        whereArgs: [
          id,
        ],);
  }

  void deleteTask(int id) async {
    final db = await database;
    await db.delete(
      _taskTableName,
      where: 'id = ?',
      whereArgs: [
        id,
      ]
    );
  }
}

class Task {
  final int status, id;
  final String content;

  Task({
    required this.id,
    required this.status,
    required this.content,
  });
}
