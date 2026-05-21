import 'package:flutter/material.dart';
import '../../features/user/chat/service/chat_service.dart';
import '../models/distress_classification.dart';
import 'classification_provider.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  final List<Map<String, dynamic>> _messages = [
    {
      'isMe': false,
      'message':
          'Halo, aku **UBMentalCareAI** 👋\n\nSenang kamu ada di sini. Aku akan menemanimu. Bagaimana kabarmu hari ini?',
    },
  ];

  bool _isLoading = false;
  bool _showEmergencyBanner = false;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get showEmergencyBanner => _showEmergencyBanner;

  void hideEmergencyBanner() {
    _showEmergencyBanner = false;
    notifyListeners();
  }

  Future<void> sendMessage(String message, ClassificationProvider classificationProvider) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;

    _messages.add({'isMe': true, 'message': trimmedMessage});
    _isLoading = true;
    notifyListeners();

    // Setup classification callback
    _chatService.onClassificationDetected = (level) {
      classificationProvider.updateLevel(level);
      classificationProvider.saveClassification(
        level: level,
        summary: 'Klasifikasi dari percakapan chat',
      );

      // Jika kritis, tampilkan banner darurat
      if (level == DistressLevel.kritis) {
        _showEmergencyBanner = true;
        notifyListeners();
      }
    };

    // Setup emergency callback
    _chatService.onEmergencyDetected = () {
      _showEmergencyBanner = true;
      notifyListeners();
    };

    final response = await _chatService.sendMessage(trimmedMessage);

    _isLoading = false;
    if (response != null) {
      _messages.add({'isMe': false, 'message': response});
    } else {
      _messages.add({
        'isMe': false,
        'message':
            'Maaf, saya tidak dapat memproses permintaan kamu saat ini. Silakan coba lagi.',
      });
    }
    notifyListeners();
  }
}
