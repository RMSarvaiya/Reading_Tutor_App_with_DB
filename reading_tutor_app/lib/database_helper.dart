import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reading_tutor.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT,
        password TEXT NOT NULL,
        token TEXT,
        created_at TEXT DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE stories (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        level INTEGER NOT NULL,
        category TEXT NOT NULL,
        estimated_minutes INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        story_id TEXT NOT NULL,
        question_text TEXT NOT NULL,
        option_a TEXT NOT NULL,
        option_b TEXT NOT NULL,
        option_c TEXT NOT NULL,
        option_d TEXT NOT NULL,
        correct_option INTEGER NOT NULL,
        explanation TEXT NOT NULL,
        FOREIGN KEY (story_id) REFERENCES stories(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE reading_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        story_id TEXT NOT NULL,
        score INTEGER NOT NULL,
        total_questions INTEGER NOT NULL,
        reading_time_secs INTEGER NOT NULL,
        completed_at TEXT DEFAULT (datetime('now')),
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (story_id) REFERENCES stories(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE user_achievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        achievement_code TEXT NOT NULL,
        unlocked_at TEXT DEFAULT (datetime('now')),
        UNIQUE(user_id, achievement_code)
      )
    ''');

    // Seed achievements
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    // Seed stories from story.dart
    final stories = [
      {'id': '1', 'title': 'The Clever Fox',    'level': 1, 'category': 'Fables',      'estimated_minutes': 3, 'content': 'One sunny day, a clever fox...'},
      {'id': '2', 'title': 'The Little Seed',   'level': 1, 'category': 'Nature',      'estimated_minutes': 2, 'content': 'There was once a tiny seed...'},
      {'id': '3', 'title': 'The Rainbow Fish',  'level': 2, 'category': 'Friendship',  'estimated_minutes': 4, 'content': 'Deep in the ocean lived...'},
      {'id': '4', 'title': 'The Ant and the Grasshopper', 'level': 2, 'category': 'Fables', 'estimated_minutes': 3, 'content': 'It was a beautiful summer day...'},
      {'id': '5', 'title': 'The Magic Library', 'level': 3, 'category': 'Adventure',   'estimated_minutes': 5, 'content': 'Emma loved books more than anything...'},
    ];
    for (final story in stories) {
      await db.insert('stories', story);
    }
  }

  // ── USER METHODS ─────────────────────────────────────────

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  // ── STORY METHODS ────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getStoriesByLevel(int level) async {
    final db = await database;
    return await db.query('stories', where: 'level = ?', whereArgs: [level]);
  }

  Future<List<Map<String, dynamic>>> getQuestionsForStory(String storyId) async {
    final db = await database;
    return await db.query('questions', where: 'story_id = ?', whereArgs: [storyId]);
  }

  // ── PROGRESS METHODS ─────────────────────────────────────

  Future<int> saveProgress({
    required int userId,
    required String storyId,
    required int score,
    required int totalQuestions,
    required int readingTimeSecs,
  }) async {
    final db = await database;
    return await db.insert('reading_progress', {
      'user_id': userId,
      'story_id': storyId,
      'score': score,
      'total_questions': totalQuestions,
      'reading_time_secs': readingTimeSecs,
    });
  }

  Future<bool> hasCompletedStory(int userId, String storyId) async {
    final db = await database;
    final result = await db.query(
      'reading_progress',
      where: 'user_id = ? AND story_id = ?',
      whereArgs: [userId, storyId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>> getUserStats(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT
        COUNT(DISTINCT story_id)                              AS total_stories,
        SUM(total_questions)                                  AS total_questions,
        SUM(score)                                            AS total_correct,
        SUM(reading_time_secs)                                AS total_secs,
        ROUND(SUM(score)*100.0 / MAX(SUM(total_questions),1), 1) AS accuracy_pct
      FROM reading_progress
      WHERE user_id = ?
    ''', [userId]);
    return result.isNotEmpty ? result.first : {};
  }

  Future<List<Map<String, dynamic>>> getRecentActivity(int userId, {int limit = 10}) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT rp.*, s.title, s.level, s.category
      FROM reading_progress rp
      JOIN stories s ON rp.story_id = s.id
      WHERE rp.user_id = ?
      ORDER BY rp.completed_at DESC
      LIMIT ?
    ''', [userId, limit]);
  }

  // ── ACHIEVEMENTS ─────────────────────────────────────────

  Future<void> unlockAchievement(int userId, String code) async {
    final db = await database;
    await db.insert(
      'user_achievements',
      {'user_id': userId, 'achievement_code': code},
      conflictAlgorithm: ConflictAlgorithm.ignore, // already unlocked ho to skip
    );
  }

  Future<List<String>> getUnlockedAchievements(int userId) async {
    final db = await database;
    final result = await db.query(
      'user_achievements',
      columns: ['achievement_code'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result.map((r) => r['achievement_code'] as String).toList();
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
