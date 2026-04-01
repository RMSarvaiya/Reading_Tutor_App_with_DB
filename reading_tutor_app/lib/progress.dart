class ReadingProgress {
  final String storyId;
  final DateTime completedDate;
  final int score;
  final int totalQuestions;
  final Duration readingTime;

  ReadingProgress({
    required this.storyId,
    required this.completedDate,
    required this.score,
    required this.totalQuestions,
    required this.readingTime,
  });

  double get percentage => (score / totalQuestions) * 100;
}

class UserStats {
  final int totalStoriesRead;
  final int totalQuestionsAnswered;
  final int totalCorrectAnswers;
  final Duration totalReadingTime;
  final List<ReadingProgress> recentProgress;

  UserStats({
    required this.totalStoriesRead,
    required this.totalQuestionsAnswered,
    required this.totalCorrectAnswers,
    required this.totalReadingTime,
    required this.recentProgress,
  });

  double get overallAccuracy {
    if (totalQuestionsAnswered == 0) return 0;
    return (totalCorrectAnswers / totalQuestionsAnswered) * 100;
  }

  String get averageReadingTime {
    if (totalStoriesRead == 0) return '0 min';
    final avgMinutes = totalReadingTime.inMinutes ~/ totalStoriesRead;
    return '$avgMinutes min';
  }
}

// In-memory storage for progress (in a real app, use a database)
class ProgressManager {
  static final List<ReadingProgress> _progressList = [];

  static void addProgress(ReadingProgress progress) {
    _progressList.add(progress);
  }

  static UserStats getUserStats() {
    final totalStories = _progressList.length;
    final totalQuestions = _progressList.fold<int>(
      0,
          (sum, progress) => sum + progress.totalQuestions,
    );
    final totalCorrect = _progressList.fold<int>(
      0,
          (sum, progress) => sum + progress.score,
    );
    final totalTime = _progressList.fold<Duration>(
      Duration.zero,
          (sum, progress) => sum + progress.readingTime,
    );

    return UserStats(
      totalStoriesRead: totalStories,
      totalQuestionsAnswered: totalQuestions,
      totalCorrectAnswers: totalCorrect,
      totalReadingTime: totalTime,
      recentProgress: List.from(_progressList.reversed.take(10)),
    );
  }

  static List<ReadingProgress> getAllProgress() {
    return List.from(_progressList);
  }

  static bool hasCompletedStory(String storyId) {
    return _progressList.any((progress) => progress.storyId == storyId);
  }
}
