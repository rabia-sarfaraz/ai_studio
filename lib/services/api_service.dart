import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  // Text generation
  static Future<String> generateText(String prompt) async {
    final response = await http.get(
      Uri.parse('https://text.pollinations.ai/$prompt'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to generate text');
    }
  }

  // Audio generation
  static Future<Uint8List> generateAudio(String text) async {
    final response = await http.get(
      Uri.parse(
          'https://text.pollinations.ai/$text?model=openai-audio&voice=alloy'),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to generate audio');
    }
  }

  // 3D model generation
  static Future<String> generate3D(String prompt) async {
    final response = await http.get(
      Uri.parse('https://image.pollinations.ai/prompt/$prompt'),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to generate 3D model');
    }
  }
}
