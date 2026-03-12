import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../config/chat_module.dart';

/// Full-width recording bar shown instead of [ChatInputBar] while recording.
/// Calls [onSend] with the recorded file path, or [onCancel] if discarded.
class VoiceRecorderBar extends StatefulWidget {
  const VoiceRecorderBar({
    super.key,
    required this.onSend,
    required this.onCancel,
  });

  final void Function(File audioFile, String filename) onSend;
  final VoidCallback onCancel;

  @override
  State<VoiceRecorderBar> createState() => _VoiceRecorderBarState();
}

class _VoiceRecorderBarState extends State<VoiceRecorderBar>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  int _secondsElapsed = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _startRecording();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      widget.onCancel();
      return;
    }
    final dir = await getTemporaryDirectory();
    final filename =
        'voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _recordingPath = '${dir.path}/$filename';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: _recordingPath!,
    );
    setState(() => _isRecording = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _secondsElapsed++);
    });
  }

  Future<void> _stopAndSend() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    setState(() => _isRecording = false);
    if (path != null) {
      final file = File(path);
      final filename = path.split('/').last;
      widget.onSend(file, filename);
    }
  }

  Future<void> _cancelRecording() async {
    _timer?.cancel();
    await _recorder.cancel();
    setState(() => _isRecording = false);
    widget.onCancel();
  }

  String get _formattedDuration {
    final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: ChatModule.theme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cancel
          IconButton(
            onPressed: _cancelRecording,
            icon: Icon(Icons.delete_outline, color: ChatModule.theme.errorColor),
            tooltip: 'Cancel',
          ),
          // Pulsing mic + duration
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Icon(
                    Icons.mic,
                    color: ChatModule.theme.errorColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formattedDuration,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ChatModule.theme.errorColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Recording...',
                  style: TextStyle(color: ChatModule.theme.hintColor, fontSize: 13),
                ),
              ],
            ),
          ),
          // Send
          IconButton(
            onPressed: _isRecording ? _stopAndSend : null,
            icon: Icon(
              Icons.send,
              color: ChatModule.theme.primaryColor,
            ),
            tooltip: 'Send',
          ),
        ],
      ),
    );
  }
}
