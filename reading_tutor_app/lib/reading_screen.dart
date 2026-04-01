import 'package:flutter/material.dart';
import 'dart:async';
import 'story.dart';
import 'progress.dart';
import 'quiz_screen.dart';

class ReadingScreen extends StatefulWidget {
  final Story story;

  const ReadingScreen({Key? key, required this.story}) : super(key: key);

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final ScrollController _scrollController = ScrollController();
  late Stopwatch _stopwatch;
  Timer? _timer;
  double _fontSize = 18.0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {}); // Update UI every second
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        actions: [
          IconButton(
            icon: Icon(_showControls ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _showControls = !_showControls;
              });
            },
            tooltip: _showControls ? 'Hide controls' : 'Show controls',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showControls) _buildReadingInfo(),
          Expanded(
            child: _buildStoryContent(),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildReadingInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.timer, size: 20, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                _formatDuration(_stopwatch.elapsed),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _fontSize > 14 ? _decreaseFontSize : null,
                tooltip: 'Decrease font size',
                iconSize: 20,
              ),
              Text(
                'A',
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _fontSize < 28 ? _increaseFontSize : null,
                tooltip: 'Increase font size',
                iconSize: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoryContent() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.story.title,
              style: TextStyle(
                fontSize: _fontSize + 6,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildBadge(
                  Icons.category,
                  widget.story.category,
                  Colors.purple,
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  Icons.signal_cellular_alt,
                  'Level ${widget.story.level}',
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              widget.story.content,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.8,
                color: Colors.grey.shade800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
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
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _startQuiz,
                icon: const Icon(Icons.quiz),
                label: const Text('Take Quiz'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _increaseFontSize() {
    setState(() {
      if (_fontSize < 28) _fontSize += 2;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      if (_fontSize > 14) _fontSize -= 2;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _startQuiz() {
    _stopwatch.stop();
    final readingTime = _stopwatch.elapsed;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          story: widget.story,
          readingTime: readingTime,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // Quiz completed, go back to home
        Navigator.pop(context);
      } else {
        // User cancelled quiz, restart timer
        _stopwatch.start();
      }
    });
  }
}
