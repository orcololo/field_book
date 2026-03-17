import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderWidget extends StatefulWidget {
  final Future<String> Function() resolveQuality;
  final Function(String audioPath) onRecordingComplete;

  const AudioRecorderWidget({
    super.key,
    required this.onRecordingComplete,
    required this.resolveQuality,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final _audioRecorder = AudioRecorder();
  Timer? _timer;
  bool _isRecording = false;
  bool _isPaused = false;
  Duration _recordDuration = Duration.zero;
  String? _recordingPath;

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  RecordConfig _configForQuality(String quality) {
    switch (quality) {
      case 'low':
        return const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 22050,
        );
      case 'high':
        return const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 192000,
          sampleRate: 48000,
        );
      case 'medium':
      default:
        return const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        );
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        
        // Ensure directory exists
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        _recordingPath = '${directory.path}/audio_note_$timestamp.wav';
        final quality = await widget.resolveQuality();

        await _audioRecorder.start(
          _configForQuality(quality),
          path: _recordingPath!,
        );

        setState(() {
          _isRecording = true;
          _isPaused = false;
          _recordDuration = Duration.zero;
        });

        _startTimer();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de microfone negada')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao iniciar gravação: $e')),
        );
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_isRecording) {
        timer.cancel();
        return;
      }
      if (!_isPaused) {
        setState(() {
          _recordDuration = _recordDuration + const Duration(seconds: 1);
        });
      }
    });
  }

  Future<void> _pauseRecording() async {
    await _audioRecorder.pause();
    setState(() => _isPaused = true);
  }

  Future<void> _resumeRecording() async {
    await _audioRecorder.resume();
    setState(() => _isPaused = false);
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _audioRecorder.stop();

    setState(() {
      _isRecording = false;
      _isPaused = false;
    });

    if (path != null && mounted) {
      widget.onRecordingComplete(path);

      // Reset for next recording
      setState(() {
        _recordDuration = Duration.zero;
        _recordingPath = null;
      });
    }
  }

  Future<void> _cancelRecording() async {
    _timer?.cancel();
    await _audioRecorder.stop();

    // Delete the file
    if (_recordingPath != null) {
      final file = File(_recordingPath!);
      if (file.existsSync()) {
        await file.delete();
      }
    }

    setState(() {
      _isRecording = false;
      _isPaused = false;
      _recordDuration = Duration.zero;
      _recordingPath = null;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isRecording ? Icons.mic : Icons.mic_none,
                  size: 48,
                  color: _isRecording ? Colors.red : Colors.grey,
                ),
                if (_isRecording) ...[
                  const SizedBox(width: 16),
                  Text(
                    _formatDuration(_recordDuration),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            if (!_isRecording)
              FilledButton.icon(
                onPressed: _startRecording,
                icon: const Icon(Icons.fiber_manual_record),
                label: const Text('Iniciar Gravação'),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.outlined(
                    onPressed: _cancelRecording,
                    icon: const Icon(Icons.close),
                    iconSize: 32,
                    tooltip: 'Cancelar',
                  ),
                  const SizedBox(width: 16),
                  IconButton.filled(
                    onPressed: _isPaused ? _resumeRecording : _pauseRecording,
                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                    iconSize: 32,
                    tooltip: _isPaused ? 'Retomar' : 'Pausar',
                  ),
                  const SizedBox(width: 16),
                  IconButton.filledTonal(
                    onPressed: _stopRecording,
                    icon: const Icon(Icons.stop),
                    iconSize: 32,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    tooltip: 'Parar',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
