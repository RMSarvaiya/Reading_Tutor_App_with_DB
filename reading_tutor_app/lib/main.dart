import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'database_helper.dart';
import 'screens/login_screen.dart';
import 'login_screen.dart';
import 'reading_db_tutor.dart' hide DatabaseHelper;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper.instance;
  final db = await dbHelper.database;

  print("✅ Database opened!");

  // Stories count check karo
  final stories = await db.query('stories');
  print("📚 Total Stories in Database: ${stories.length}");

  if (stories.isNotEmpty) {
    print("First Story Title: ${stories.first['title']}");
  } else {
    print("❌ No stories found! Seed data not inserted.");
  }

  // Achievements check
  final achievements = await db.query('achievements');
  print("🏆 Total Achievements: ${achievements.length}");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Tutor',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}