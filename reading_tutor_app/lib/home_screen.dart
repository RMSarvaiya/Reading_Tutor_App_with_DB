import 'package:flutter/material.dart';
import 'story.dart';
import 'progress.dart';
import 'reading_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart'; // 👈 YE ADD KARO
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Tutor'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildLevelSelector(),
          Expanded(
            child: _buildStoriesList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Always show Stories tab as selected
        onTap: (index) {
          if (index == 1) {
            // Navigate to Progress Screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProgressScreen(),
              ),
            );
          }
          // No need to change _currentIndex since we're always on Stories tab
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Stories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Reading Level',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) {
                final level = index + 1;
                final isSelected = _selectedLevel == level;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('Level $level'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedLevel = level;
                      });
                    },
                    selectedColor: Colors.white,
                    backgroundColor: Colors.blue.shade700,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.blue : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getLevelDescription(_selectedLevel),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _getLevelDescription(int level) {
    switch (level) {
      case 1:
        return 'Beginner - Simple words and short sentences';
      case 2:
        return 'Elementary - Basic vocabulary and longer stories';
      case 3:
        return 'Intermediate - Richer vocabulary and complex plots';
      case 4:
        return 'Advanced - Challenging words and detailed narratives';
      case 5:
        return 'Expert - Complex language and sophisticated themes';
      default:
        return '';
    }
  }

  Widget _buildStoriesList() {
    final stories = StoriesDatabase.getStoriesByLevel(_selectedLevel);

    if (stories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No stories available for this level yet.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different level!',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return _buildStoryCard(story);
      },
    );
  }

  Widget _buildStoryCard(Story story) {
    final isCompleted = ProgressManager.hasCompletedStory(story.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToReading(story),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story.category,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 24,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(
                    Icons.timer_outlined,
                    '${story.estimatedMinutes} min',
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.quiz_outlined,
                    '${story.questions.length} questions',
                    Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.signal_cellular_alt,
                    'Level ${story.level}',
                    Colors.purple,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _navigateToReading(story),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(isCompleted ? 'Read Again' : 'Start Reading'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToReading(Story story) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingScreen(story: story),
      ),
    ).then((_) {
      setState(() {}); // Refresh to show completion status
    });
  }

}

// ApiService class - moved outside HomeScreen
class ApiService {
  // Base URL - Using JSONPlaceholder for dummy data
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // POST - Submit Activity
  static Future<Map<String, dynamic>> submitActivity({
    required String userId,
    required String activityTitle,
    required int readingTime,
    required int score,
    required List<String> answers,
  }) async {
    try {
      print('Submitting activity...');

      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: headers,
        body: json.encode({
          'userId': userId,
          'activityTitle': activityTitle,
          'readingTime': readingTime,
          'score': score,
          'answers': answers,
          'completedAt': DateTime.now().toIso8601String(),
        }),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        return {
          'success': true,
          'message': 'Activity submitted successfully!',
          'submissionId': responseData['id'],
          'pointsEarned': score * 10,
          'badge': score >= 8 ? 'Gold Star' : score >= 6 ? 'Silver Star' : 'Bronze Star',
          'accuracy': '${(score / 10 * 100).toInt()}%',
        };
      } else {
        throw Exception('Failed to submit activity');
      }
    } catch (e) {
      print('Error: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
