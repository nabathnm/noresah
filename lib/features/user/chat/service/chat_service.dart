import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

const String _systemPrompt = '''
Kamu adalah mentor mental health care yang suportif, tenang, empatik, dan profesional.

Aturan:
- Hanya jawab topik seputar kesehatan mental, emosi, stres, overthinking, burnout, self-care, dan pengembangan diri.
- Jika ditanya di luar topik mental health, arahkan kembali secara halus.
- Jawaban harus singkat.
- Jawaban HARUS hanya 1 paragraf.
- Jangan gunakan bullet list atau numbering.
- Gunakan format **teks** untuk menekankan bagian penting.
- Jangan memberikan diagnosis medis.
''';

class ChatService {
  late GenerativeModel _geminiModel;
  late ChatSession _geminiSession;

  // Groq chat history untuk multi-turn conversation
  final List<Map<String, String>> _groqHistory = [];

  ChatService() {
    _initializeGemini();
  }

  void _initializeGemini() {
    final apiKey = dotenv.env['GEMINI_KEY'];
    if (apiKey == null) throw Exception('GEMINI_KEY is not defined in .env');

    _geminiModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.text(_systemPrompt),
    );

    _geminiSession = _geminiModel.startChat();
  }

  // ── Gemini ──────────────────────────────────────────────────

  Future<String?> _sendViaGemini(String message) async {
    final response = await _geminiSession.sendMessage(Content.text(message));
    return response.text;
  }

  // ── Groq (fallback) ─────────────────────────────────────────

  Future<String?> _sendViaGroq(String message) async {
    final apiKey = dotenv.env['GROQ_KEY'];
    if (apiKey == null) throw Exception('GROQ_KEY is not defined in .env');

    // Tambahkan pesan user ke history
    _groqHistory.add({'role': 'user', 'content': message});

    final body = jsonEncode({
      'model': 'llama-3.3-70b-versatile',
      'messages': [
        {'role': 'system', 'content': _systemPrompt},
        ..._groqHistory,
      ],
      'max_tokens': 1000,
      'temperature': 0.7,
    });

    final response = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Groq API error ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final reply = data['choices'][0]['message']['content'] as String;

    // Simpan balasan assistant ke history agar konteks terjaga
    _groqHistory.add({'role': 'assistant', 'content': reply});

    return reply;
  }

  // ── Public API ───────────────────────────────────────────────

  Future<String?> sendMessage(String message) async {
    // Coba Gemini dulu
    try {
      final reply = await _sendViaGemini(message);
      if (reply != null && reply.isNotEmpty) return reply;
      throw Exception('Empty response from Gemini');
    } catch (geminiError) {
      // Fallback ke Groq
      try {
        return await _sendViaGroq(message);
      } catch (groqError) {
        return 'Maaf, layanan sedang tidak tersedia. Silakan coba beberapa saat lagi.';
      }
    }
  }
}
