import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String _apiKey = dotenv.env['API_KEY'] ?? '';
  static final String _baseUrl = dotenv.env['API_URL'] ?? '';
  static String get fullUrl => '$_baseUrl?key=$_apiKey';

  // For study plan generation
  static Future<String> generatePlan(String prompt) async {
    final response = await http.post(
      Uri.parse(fullUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final candidates = data['candidates'];
      if (candidates == null || candidates.isEmpty) {
        throw Exception('❌ No response from AI.');
      }

      final content = candidates[0]['content'];
      if (content == null || content['parts'] == null || content['parts'].isEmpty) {
        throw Exception('❌ Empty AI response.');
      }

      String result = content['parts'][0]['text'] ?? '⚠️ AI returned no text.';
      result = result.replaceAll(RegExp(r'^\s*\*\s+', multiLine: true), '');

      return result;
    } else {
      throw Exception('❌ Failed to generate plan: ${response.statusCode} ${response.body}');
    }
  }



  // For chatbot functionality
  static Future<String> chatWithAI(String userMessage) async {
    final response = await http.post(
      Uri.parse(fullUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": userMessage}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String content = data['candidates'][0]['content']['parts'][0]['text'];
      return content;
    } else {
      return '❌ Error: ${response.statusCode} ${response.body}';
    }
  }
}
