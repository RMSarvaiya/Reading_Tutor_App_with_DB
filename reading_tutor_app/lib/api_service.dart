import 'dart:convert';
import 'package:http/http.dart' as http;

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