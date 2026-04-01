import 'package:flutter/material.dart';
import 'progress.dart';
import 'story.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = ProgressManager.getUserStats();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Your Progress'),
        automaticallyImplyLeading: false,
      ),
      body: stats.totalStoriesRead == 0
          ? _buildEmptyState()
          : _buildProgressContent(stats),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'No Reading History Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start reading stories and taking quizzes to see your progress here!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressContent(UserStats stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverallStats(stats),
          const SizedBox(height: 24),
          _buildSectionTitle('Recent Activity'),
          const SizedBox(height: 12),
          _buildRecentActivity(stats.recentProgress),
          const SizedBox(height: 24),
          _buildSectionTitle('Achievements'),
          const SizedBox(height: 12),
          _buildAchievements(stats),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOverallStats(UserStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Overall Statistics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Stories Read',
                    stats.totalStoriesRead.toString(),
                    Icons.book,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Accuracy',
                    '${stats.overallAccuracy.toStringAsFixed(0)}%',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Questions',
                    stats.totalQuestionsAnswered.toString(),
                    Icons.quiz,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Avg. Time',
                    stats.averageReadingTime,
                    Icons.timer,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<ReadingProgress> recentProgress) {
    if (recentProgress.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              'No recent activity',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ),
      );
    }

    return Column(
      children: recentProgress.map((progress) {
        final story = StoriesDatabase.getStoryById(progress.storyId);
        return _buildActivityCard(progress, story);
      }).toList(),
    );
  }

  Widget _buildActivityCard(ReadingProgress progress, Story? story) {
    if (story == null) return const SizedBox.shrink();

    final percentage = progress.percentage;
    final color = percentage >= 80
        ? Colors.green
        : percentage >= 60
        ? Colors.orange
        : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(progress.completedDate),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green.shade600),
                const SizedBox(width: 4),
                Text(
                  '${progress.score}/${progress.totalQuestions}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 16),
                Icon(Icons.timer, size: 16, color: Colors.blue.shade600),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(progress.readingTime),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 16),
                Icon(Icons.signal_cellular_alt, size: 16, color: Colors.purple.shade600),
                const SizedBox(width: 4),
                Text(
                  'Level ${story.level}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements(UserStats stats) {
    final achievements = _getAchievements(stats);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...achievements.map((achievement) => _buildAchievementItem(
              achievement['icon'],
              achievement['title'],
              achievement['description'],
              achievement['unlocked'],
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(
      IconData icon,
      String title,
      String description,
      bool unlocked,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: unlocked
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: unlocked ? Colors.amber.shade700 : Colors.grey.shade400,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: unlocked ? Colors.black87 : Colors.grey.shade600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            Icon(
              Icons.check_circle,
              color: Colors.green.shade600,
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAchievements(UserStats stats) {
    return [
      {
        'icon': Icons.book,
        'title': 'First Steps',
        'description': 'Complete your first story',
        'unlocked': stats.totalStoriesRead >= 1,
      },
      {
        'icon': Icons.local_library,
        'title': 'Bookworm',
        'description': 'Read 5 stories',
        'unlocked': stats.totalStoriesRead >= 5,
      },
      {
        'icon': Icons.school,
        'title': 'Scholar',
        'description': 'Read 10 stories',
        'unlocked': stats.totalStoriesRead >= 10,
      },
      {
        'icon': Icons.stars,
        'title': 'Perfect Score',
        'description': 'Get 100% on a quiz',
        'unlocked': stats.recentProgress.any((p) => p.percentage == 100),
      },
      {
        'icon': Icons.trending_up,
        'title': 'Consistent Reader',
        'description': 'Maintain 80%+ accuracy',
        'unlocked': stats.overallAccuracy >= 80,
      },
    ];
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
