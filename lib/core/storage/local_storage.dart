import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/notes/models/note.dart';

class NotesDatabaseService {
  static const String _dbName = 'notes_app.db';
  static const int _dbVersion = 2;

  static const String _notesTable = 'notes';
  static const String _settingsTable = 'settings';

  static Database? _db;

  static NotesDatabaseService? _instance;
  NotesDatabaseService._();
  static NotesDatabaseService get instance =>
      _instance ??= NotesDatabaseService._();

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_notesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        status INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $_settingsTable (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  // Add migration handler
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add status column if it doesn't exist
      try {
        await db.execute('ALTER TABLE $_notesTable ADD COLUMN status INTEGER NOT NULL DEFAULT 0');
      } catch (e) {
        // Column might already exist, ignore error
        print('Migration note: $e');
      }
    }
  }

  // ────────────────────────── Notes CRUD ──────────────────────────

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final maps = await db.query(_notesTable);
    return maps.map((m) => Note.fromMap(_convertMap(m))).toList();
  }

  Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert(
      _notesTable,
      _toDbMap(note),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      _notesTable,
      _toDbMap(note),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(_notesTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllNotes() async {
    final db = await database;
    await db.delete(_notesTable);
  }

  Future<void> updateNoteStatus(int id, bool status) async {
  final db = await database;
    await db.update(
        _notesTable,
        {'status': status ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
  }

  // ────────────────────────── Settings ──────────────────────────

  Future<String?> getSetting(String key) async {
    final db = await database;
    final result = await db.query(
      _settingsTable,
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isEmpty) return null;
    return result.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      _settingsTable,
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ────────────────────────── Helpers ──────────────────────────

  Map<String, dynamic> _toDbMap(Note note) => {
    'id': note.id,
    'title': note.title,
    'content': note.content,
    'status': note.status ? 1 : 0,
    'created_at': note.createdAt.toIso8601String(),
  };

  /// Converts DB column names (created_at) to model field names (createdAt).
  Map<String, dynamic> _convertMap(Map<String, dynamic> map) => {
    'id': map['id'],
    'title': map['title'],
    'content': map['content'],
    'status': map['status'] == 1,
    'createdAt': map['created_at'],
  };
}
