import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

class AudioTranscriptionService {
  static final _log = Logger(printer: PrettyPrinter(methodCount: 2));
  final SpeechToText _speechToText;
  Whisper? _whisper;
  bool _whisperInitialized = false;

  AudioTranscriptionService({SpeechToText? speechToText})
      : _speechToText = speechToText ?? SpeechToText();

  /// Transcribe an audio file using Whisper (on-device ML)
  /// Audio must be in WAV format (16kHz, mono)
  Future<String> transcribeFile({
    required String audioPath,
    String? localeId,
  }) async {
    try {
      // Verify audio file exists
      final file = File(audioPath);
      if (!await file.exists()) {
        throw Exception('Audio file not found: $audioPath');
      }

      // Initialize Whisper if not already done
      if (!_whisperInitialized) {
        _whisper = Whisper(
          model: WhisperModel.small,
          downloadHost: "https://huggingface.co/ggerganov/whisper.cpp/resolve/main",
        );
        _whisperInitialized = true;
      }

      // Transcribe using Whisper
      final response = await _whisper!.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: audioPath,
          isTranslate: false, // Keep in original language
          isNoTimestamps: true, // We don't need timestamps
        ),
      );

      return response.text.trim();
    } catch (e, stackTrace) {
      // Log full error context for debugging
      _log.e('Audio transcription error', error: e, stackTrace: stackTrace);
      throw Exception('Failed to transcribe audio file: $e');
    }
  }

  /// Transcribe from microphone (real-time) - legacy method
  Future<String> transcribeRealtime({
    required String localeId,
    Duration listenFor = const Duration(minutes: 2),
  }) async {
    final available = await _speechToText.initialize();
    if (!available) {
      throw StateError('Speech recognition unavailable');
    }

    final completer = Completer<String>();
    var transcript = '';

    final resolvedLocale = await _resolveLocaleId(localeId);

    await _speechToText.listen(
      localeId: resolvedLocale,
      listenFor: listenFor,
      pauseFor: const Duration(seconds: 2),
      onResult: (result) {
        transcript = result.recognizedWords;
        if (result.finalResult && !completer.isCompleted) {
          completer.complete(transcript.trim());
        }
      },
    );

    return completer.future.timeout(
      listenFor + const Duration(seconds: 5),
      onTimeout: () async {
        await _speechToText.stop();
        return transcript.trim();
      },
    );
  }

  Future<String> _resolveLocaleId(String localeId) async {
    final locales = await _speechToText.locales();
    if (locales.isEmpty) {
      return localeId;
    }

    final normalized = localeId.toLowerCase();
    
    // Try exact prefix match
    final prefixMatch = locales.firstWhere(
      (locale) => locale.localeId.toLowerCase().startsWith(normalized),
      orElse: () => LocaleName('', ''),
    );
    
    if (prefixMatch.localeId.isNotEmpty) {
      return prefixMatch.localeId;
    }
    
    // Try contains match
    final containsMatch = locales.firstWhere(
      (locale) => locale.localeId.toLowerCase().contains(normalized),
      orElse: () => LocaleName('', ''),
    );
    
    if (containsMatch.localeId.isNotEmpty) {
      return containsMatch.localeId;
    }
    
    // Fallback to first locale or original
    return locales.isNotEmpty ? locales.first.localeId : localeId;
  }

  Future<void> stop() async {
    await _speechToText.stop();
  }

  void dispose() {
    _whisper = null;
    _whisperInitialized = false;
  }
}
