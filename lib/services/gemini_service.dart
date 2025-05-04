import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint

class GeminiService {
  static final String _apiKey = dotenv.env['API_KEY'] ?? '';
  static final String _baseUrl = dotenv.env['API_URL'] ?? '';
  static String get fullUrl => '$_baseUrl?key=$_apiKey';

  // For study plan generation
  static Future<String> generatePlan(String prompt) async {
    try {
      debugPrint('generatePlan: Sending prompt: $prompt'); // Add this line
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
      debugPrint('generatePlan: Response status code: ${response.statusCode}'); // And this

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('generatePlan: Response body: $data'); // And this

        final candidates = data['candidates'];
        if (candidates == null || candidates.isEmpty) {
          throw Exception('❌ No response from AI.');
        }

        final content = candidates[0]['content'];
        if (content == null || content['parts'] == null || content['parts'].isEmpty) {
          throw Exception('❌ Empty AI response.');
        }

        String result = content['parts'][0]['text'] ?? '⚠️ AI returned no text.';
        debugPrint('generatePlan: result: $result');
        return result;
      } else {
        debugPrint('generatePlan: Error: ${response.statusCode}, ${response.body}');
        throw Exception('❌ Failed to generate plan: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      debugPrint('generatePlan: Exception: $e'); // Catch and print any exceptions
      throw Exception('❌ Error generating plan: $e');
    }
  }

  // For chatbot functionality
  static Future<String> chatWithAI(String userMessage) async {
    try{
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
    } catch (e){
      debugPrint('chatWithAI: Exception: $e'); // Catch and print any exceptions
      return '❌ Error: $e';
    }
  }
}
