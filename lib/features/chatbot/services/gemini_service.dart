import 'package:flutter_gemini/flutter_gemini.dart';
import '../../../constants/global_variables.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  late final Gemini gemini;

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal() {
    Gemini.init(apiKey: GEMINI_API_KEY);
    gemini = Gemini.instance;
  }

  Future<String> getCodingResponse(String prompt) async {
    try {
      final query =
          "As a coding assistant, help with the following programming question: $prompt\n\nProvide clear, concise, and practical answers with code examples when relevant.";

      final response = await gemini.text(query);

      if (response == null || response.output == null) {
        throw Exception('No response from Gemini API');
      }

      return response.output ?? 'Sorry, I could not generate a response';
    } catch (e) {
      throw Exception('Error connecting to Gemini API: $e');
    }
  }
}
