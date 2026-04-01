// lib/database/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'reading_tutor.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // ================== ALL TABLES ==================

    await db.execute('''
      CREATE TABLE users (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        name        TEXT    NOT NULL,
        email       TEXT    NOT NULL UNIQUE,
        phone       TEXT,
        password    TEXT    NOT NULL,
        token       TEXT,
        created_at  TEXT    DEFAULT (datetime('now')),
        updated_at  TEXT    DEFAULT (datetime('now'))
      );
    ''');

    await db.execute('''
      CREATE TABLE stories (
        id                  TEXT    PRIMARY KEY,
        title               TEXT    NOT NULL,
        content             TEXT    NOT NULL,
        level               INTEGER NOT NULL,
        category            TEXT    NOT NULL,
        estimated_minutes   INTEGER NOT NULL,
        created_at          TEXT    DEFAULT (datetime('now'))
      );
    ''');

    await db.execute('''
      CREATE TABLE questions (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        story_id        TEXT    NOT NULL,
        question_text   TEXT    NOT NULL,
        option_a        TEXT    NOT NULL,
        option_b        TEXT    NOT NULL,
        option_c        TEXT    NOT NULL,
        option_d        TEXT    NOT NULL,
        correct_option  INTEGER NOT NULL,
        explanation     TEXT    NOT NULL,
        FOREIGN KEY (story_id) REFERENCES stories(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE reading_progress (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id             INTEGER NOT NULL,
        story_id            TEXT    NOT NULL,
        score               INTEGER NOT NULL,
        total_questions     INTEGER NOT NULL,
        reading_time_secs   INTEGER NOT NULL,
        completed_at        TEXT    DEFAULT (datetime('now')),
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (story_id) REFERENCES stories(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE quiz_answers (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        progress_id     INTEGER NOT NULL,
        question_id     INTEGER NOT NULL,
        selected_option INTEGER NOT NULL,
        is_correct      INTEGER NOT NULL,
        FOREIGN KEY (progress_id) REFERENCES reading_progress(id),
        FOREIGN KEY (question_id) REFERENCES questions(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE achievements (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        code        TEXT    NOT NULL UNIQUE,
        title       TEXT    NOT NULL,
        description TEXT    NOT NULL,
        icon_name   TEXT    NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE user_achievements (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id         INTEGER NOT NULL,
        achievement_id  INTEGER NOT NULL,
        unlocked_at     TEXT    DEFAULT (datetime('now')),
        UNIQUE(user_id, achievement_id),
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (achievement_id) REFERENCES achievements(id)
      );
    ''');

    // ================== INDEXES ==================
    await db.execute('CREATE INDEX idx_progress_user ON reading_progress(user_id);');
    await db.execute('CREATE INDEX idx_progress_story ON reading_progress(story_id);');
    await db.execute('CREATE INDEX idx_questions_story ON questions(story_id);');
    await db.execute('CREATE INDEX idx_answers_progress ON quiz_answers(progress_id);');
    await db.execute('CREATE INDEX idx_stories_level ON stories(level);');

    // ================== SEED DATA ==================
    await _insertSeedData(db);
  }

  Future<void> _insertSeedData(Database db) async {
    // Stories
    await db.rawInsert('''
      INSERT INTO stories (id, title, content, level, category, estimated_minutes) VALUES
      ('1', 'The Clever Fox', '...', 1, 'Fables', 3),
      ('2', 'The Little Seed', '...', 1, 'Nature', 2),
      ('3', 'The Rainbow Fish', '...', 2, 'Friendship', 4),
      ('4', 'The Ant and the Grasshopper', '...', 2, 'Fables', 3),
      ('5', 'The Magic Library', '...', 3, 'Adventure', 5);
    ''');

    // Achievements
    await db.rawInsert('''
      INSERT INTO achievements (code, title, description, icon_name) VALUES
      ('first_steps',       'First Steps',        'Complete your first story',     'book'),
      ('bookworm',          'Bookworm',           'Read 5 stories',                'local_library'),
      ('scholar',           'Scholar',            'Read 10 stories',               'school'),
      ('perfect_score',     'Perfect Score',      'Get 100% on a quiz',            'stars'),
      ('consistent_reader', 'Consistent Reader',  'Maintain 80%+ accuracy',        'trending_up');
    ''');
  }

  // ================== HELPER METHODS ==================
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}