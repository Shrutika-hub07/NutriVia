import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isInitialized = false;
  bool isListening = false;
  bool isSpeaking = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (val) => isListening = false,
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            isListening = false;
          }
        },
      );
      await _tts.setSpeechRate(0.85); // Gentle, calm speaking cadence
      await _tts.setPitch(1.0);
      _tts.setCompletionHandler(() {
        isSpeaking = false;
      });
      return _isInitialized;
    } catch (e) {
      debugPrint("Voice initialization error: $e");
      return false;
    }
  }

  Future<void> setLanguage(String langCode) async {
    final ttsLocale = langCode == 'mr'
        ? 'mr-IN'
        : (langCode == 'hi' ? 'hi-IN' : 'en-IN');
    try {
      await _tts.setLanguage(ttsLocale);
    } catch (_) {}
  }

  Future<void> startListening({
    required String langCode,
    required Function(String recognizedWords) onResult,
    required VoidCallback onDone,
  }) async {
    await initialize();
    if (!_isInitialized) {
      onDone();
      return;
    }

    final String speechLocale = langCode == 'mr'
        ? 'mr-IN'
        : (langCode == 'hi' ? 'hi-IN' : 'en-IN');

    try {
      isListening = true;
      await _speech.listen(
        onResult: (result) {
          final words = result.recognizedWords;
          if (words.isNotEmpty) {
            onResult(words);
          }
          if (result.finalResult) {
            isListening = false;
            onDone();
          }
        },
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          partialResults: true,
          cancelOnError: false,
          localeId: speechLocale,
        ),
      );
    } catch (e) {
      debugPrint("Speech listen error: $e");
      isListening = false;
      onDone();
    }
  }

  Future<void> stopListening() async {
    if (isListening) {
      await _speech.stop();
      isListening = false;
    }
  }

  Future<void> speak(String text, String langCode) async {
    try {
      await stopListening();
      await setLanguage(langCode);
      isSpeaking = true;
      await _tts.speak(text);
    } catch (e) {
      isSpeaking = false;
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
      isSpeaking = false;
    } catch (_) {}
  }
}
