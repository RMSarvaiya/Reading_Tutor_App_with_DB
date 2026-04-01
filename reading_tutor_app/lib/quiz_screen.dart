import 'package:flutter/material.dart';
import 'story.dart';
import 'progress.dart';

class QuizScreen extends StatefulWidget {
  final Story story;
  final Duration readingTime;

  const QuizScreen({
    Key? key,
    required this.story,
    required this.readingTime,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  bool _showExplanation = false;
  int _score = 0;
  final List<int> _userAnswers = [];

  Question get _currentQuestion =>
      widget.story.questions[_currentQuestionIndex];

  bool get _isLastQuestion =>
      _currentQuestionIndex == widget.story.questions.length - 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showExitConfirmation();
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz: ${widget.story.title}'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldExit = await _showExitConfirmation();
              if (shouldExit == true && mounted) {
                Navigator.pop(context, false);
              }
            },
          ),
        ),
        body: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: _showExplanation
                  ? _buildExplanation()
                  : _buildQuestion(),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress =
        (_currentQuestionIndex + 1) / widget.story.questions.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of ${widget.story.questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Score: $_score/${_currentQuestionIndex}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              _currentQuestion.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ..._currentQuestion.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return _buildOptionButton(index, option);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildOptionButton(int index, String option) {
    final isSelected = _selectedAnswer == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected ? Colors.blue.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 2 : 0,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedAnswer = index;
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue.shade400 : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.blue : Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.blue.shade900 : Colors.grey.shade800,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Colors.blue.shade600,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExplanation() {
    final isCorrect = _selectedAnswer == _currentQuestion.correctAnswer;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isCorrect ? 'Correct!' : 'Incorrect',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explanation:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentQuestion.explanation,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          if (!isCorrect) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Correct Answer:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentQuestion.options[_currentQuestion.correctAnswer],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: _showExplanation
            ? ElevatedButton(
          onPressed: _nextQuestion,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(
            _isLastQuestion ? 'Finish Quiz' : 'Next Question',
            style: const TextStyle(fontSize: 16),
          ),
        )
            : ElevatedButton(
          onPressed: _selectedAnswer != null ? _checkAnswer : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
          ),
          child: const Text(
            'Check Answer',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _checkAnswer() {
    if (_selectedAnswer == null) return;

    setState(() {
      _showExplanation = true;
      _userAnswers.add(_selectedAnswer!);
      if (_selectedAnswer == _currentQuestion.correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_isLastQuestion) {
      _finishQuiz();
    } else {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showExplanation = false;
      });
    }
  }

  void _finishQuiz() {
    // Save progress
    final progress = ReadingProgress(
      storyId: widget.story.id,
      completedDate: DateTime.now(),
      score: _score,
      totalQuestions: widget.story.questions.length,
      readingTime: widget.readingTime,
    );
    ProgressManager.addProgress(progress);

    // Show results
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Score:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_score / ${widget.story.questions.length}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Percentage: ${(_score / widget.story.questions.length * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Reading Time: ${_formatDuration(widget.readingTime)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              _getPerformanceMessage(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return to home
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _getPerformanceMessage() {
    final percentage = (_score / widget.story.questions.length) * 100;
    if (percentage == 100) {
      return '🌟 Perfect! You understood everything!';
    } else if (percentage >= 80) {
      return '🎉 Excellent work! Great comprehension!';
    } else if (percentage >= 60) {
      return '👍 Good job! Keep practicing!';
    } else {
      return '📚 Keep reading and you\'ll improve!';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  Future<bool?> _showExitConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
          'Your progress will not be saved if you exit now. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
