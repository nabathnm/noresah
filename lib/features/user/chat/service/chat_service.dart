import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  late GenerativeModel _model;
  late ChatSession _chatSession;

  ChatService() {
    _initializeModel();
  }

  void _initializeModel() {
    final apiKey = dotenv.env['GEMINI_KEY'];

    if (apiKey == null) {
      throw Exception('GEMINI_KEY is not defined in .env file');
    }

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,

      // AI ROLE
      systemInstruction: Content.text('''
Kamu adalah mentor mental health care yang suportif, tenang, empatik, dan profesional.

Aturan:
- Hanya jawab topik seputar kesehatan mental, emosi, stres, overthinking, burnout, self-care, dan pengembangan diri.
- Jika ditanya di luar topik mental health, arahkan kembali secara halus.
- Jawaban harus singkat.
- Jawaban HARUS hanya 1 paragraf.
- Jangan gunakan bullet list atau numbering.
- Gunakan format **teks** untuk menekankan bagian penting.
- Jangan memberikan diagnosis medis.
        '''),
    );

    _chatSession = _model.startChat();
  }

  Future<String?> sendMessage(String message) async {
    try {
      final response = await _chatSession.sendMessage(Content.text(message));

      return response.text;
    } catch (e) {
      return 'Error: $e';
    }
  }
}
