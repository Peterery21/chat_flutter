import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../config/chat_module.dart';
import '../../config/chat_theme.dart';
import '../../data/models/models.dart';
import 'voice_recorder_bar.dart';

/// Bottom input bar for composing and sending messages.
/// Handles: text, media attachment (image/video/file), voice recording,
/// reply-to preview, and @mention trigger.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    this.participants = const [],
    this.replyToMessage,
    this.onCancelReply,
  });

  /// Called when the user taps send. [mediaFilename] is the original filename
  /// for audio, video and file attachments (used by backend for categorisation).
  final Function(String content,
      {int? replyToId,
      File? mediaFile,
      String? mediaFilename,
      List<int>? mentionedUserIds}) onSend;
  final List<ChatParticipant> participants;
  final ChatMessage? replyToMessage;
  final VoidCallback? onCancelReply;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  File? _selectedMedia;
  String? _mediaFilename;
  bool _showMentions = false;
  bool _isRecording = false;
  List<ChatParticipant> _filteredParticipants = [];
  String _mentionQuery = '';
  final Map<String, int> _mentionUserIdMap = {};

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasContent =>
      _controller.text.trim().isNotEmpty || _selectedMedia != null;

  void _onTextChanged(String value) {
    setState(() {}); // update send/mic toggle
    // Detect @ mention
    final cursorPos = _controller.selection.baseOffset;
    if (cursorPos < 0) return;

    final textBefore = value.substring(0, cursorPos);
    final atIndex = textBefore.lastIndexOf('@');

    if (atIndex >= 0 && !textBefore.substring(atIndex).contains(' ')) {
      _mentionQuery = textBefore.substring(atIndex + 1);
      final filtered = widget.participants
          .where((p) => p.username
              .toLowerCase()
              .contains(_mentionQuery.toLowerCase()))
          .toList();
      setState(() {
        _filteredParticipants = filtered;
        _showMentions = filtered.isNotEmpty;
      });
    } else {
      setState(() => _showMentions = false);
    }
  }

  void _selectMention(ChatParticipant participant) {
    _mentionUserIdMap[participant.username] = participant.chatUserId;
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    final atIndex = text.lastIndexOf('@', cursorPos);
    if (atIndex >= 0) {
      final newText =
          '${text.substring(0, atIndex)}@${participant.username} ${text.substring(cursorPos)}';
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: atIndex + participant.username.length + 2),
      );
    }
    setState(() => _showMentions = false);
  }

  // ─── Pickers ──────────────────────────────────────────────────────────────

  Future<void> _pickFromGallery() async {
    Navigator.pop(context);
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _selectedMedia = File(picked.path);
        _mediaFilename = picked.name;
      });
    }
  }

  Future<void> _pickFromCamera() async {
    Navigator.pop(context);
    final picked =
        await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _selectedMedia = File(picked.path);
        _mediaFilename = picked.name.isEmpty
            ? 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg'
            : picked.name;
      });
    }
  }

  Future<void> _pickVideo() async {
    Navigator.pop(context);
    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedMedia = File(picked.path);
        _mediaFilename = picked.name.isEmpty
            ? 'video_${DateTime.now().millisecondsSinceEpoch}.mp4'
            : picked.name;
      });
    }
  }

  Future<void> _pickFile() async {
    Navigator.pop(context);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx',
          'txt', 'zip', 'rar'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedMedia = File(result.files.single.path!);
        _mediaFilename = result.files.single.name;
      });
    }
  }

  void _showAttachMenu() {
    final theme = ChatModule.theme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AttachOption(
                icon: Icons.photo_camera,
                label: 'Camera',
                color: theme.primaryColor,
                onTap: _pickFromCamera,
              ),
              _AttachOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                color: theme.primaryColor,
                onTap: _pickFromGallery,
              ),
              _AttachOption(
                icon: Icons.videocam,
                label: 'Video',
                color: theme.errorColor,
                onTap: _pickVideo,
              ),
              _AttachOption(
                icon: Icons.attach_file,
                label: 'Document',
                color: theme.botIndicatorColor,
                onTap: _pickFile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Voice recording ──────────────────────────────────────────────────────

  void _toggleRecording() {
    setState(() => _isRecording = true);
  }

  void _onVoiceSend(File audioFile, String filename) {
    setState(() => _isRecording = false);
    widget.onSend('', mediaFile: audioFile, mediaFilename: filename);
    widget.onCancelReply?.call();
  }

  void _onVoiceCancel() {
    setState(() => _isRecording = false);
  }

  // ─── Text send ────────────────────────────────────────────────────────────

  void _send() {
    final content = _controller.text.trim();
    if (content.isEmpty && _selectedMedia == null) return;

    final mentionedIds = _mentionUserIdMap.entries
        .where((e) => _controller.text.contains('@${e.key}'))
        .map((e) => e.value)
        .toSet()
        .toList();

    widget.onSend(
      content,
      replyToId: widget.replyToMessage?.id,
      mediaFile: _selectedMedia,
      mediaFilename: _mediaFilename,
      mentionedUserIds: mentionedIds.isEmpty ? null : mentionedIds,
    );

    _controller.clear();
    _mentionUserIdMap.clear();
    setState(() {
      _selectedMedia = null;
      _mediaFilename = null;
    });
    widget.onCancelReply?.call();
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;

    // Voice recording mode — replaces the entire bar
    if (_isRecording) {
      return VoiceRecorderBar(
        onSend: _onVoiceSend,
        onCancel: _onVoiceCancel,
      );
    }

    // Determine media preview label (non-image files show filename)
    final isImageMedia = _mediaFilename != null &&
        (_mediaFilename!.endsWith('.jpg') ||
            _mediaFilename!.endsWith('.jpeg') ||
            _mediaFilename!.endsWith('.png') ||
            _mediaFilename!.endsWith('.gif'));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mention overlay
        if (_showMentions)
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              color: theme.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredParticipants.length,
              itemBuilder: (_, i) {
                final p = _filteredParticipants[i];
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundImage: p.avatar != null
                        ? NetworkImage(p.avatar!)
                        : null,
                    child: p.avatar == null
                        ? Text(p.username[0].toUpperCase())
                        : null,
                  ),
                  title: Text('@${p.username}'),
                  onTap: () => _selectMention(p),
                );
              },
            ),
          ),

        // Reply preview
        if (widget.replyToMessage != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.inputFillColor,
            child: Row(
              children: [
                Container(width: 3, height: 36, color: theme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.replyToMessage!.senderName ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        widget.replyToMessage!.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: widget.onCancelReply,
                ),
              ],
            ),
          ),

        // Media preview
        if (_selectedMedia != null)
          Container(
            color: theme.inputFillColor,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
            child: Row(
              children: [
                if (isImageMedia || _selectedMedia != null && _mediaFilename == null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_selectedMedia!, height: 70, width: 70,
                        fit: BoxFit.cover),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_fileIcon(_mediaFilename), color: theme.secondaryTextColor),
                        const SizedBox(width: 6),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 160),
                          child: Text(
                            _mediaFilename ?? '',
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() {
                    _selectedMedia = null;
                    _mediaFilename = null;
                  }),
                ),
              ],
            ),
          ),

        // Input row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: theme.inputBarColor,
          child: Row(
            children: [
              // Attach "+" button
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _showAttachMenu,
                color: theme.secondaryTextColor,
                tooltip: 'Attach',
              ),
              // Text field
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: _onTextChanged,
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.inputFillColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Send (when text/media) or Mic (when empty)
              _hasContent
                  ? _SendButton(onSend: _send, theme: theme)
                  : IconButton(
                      icon: Icon(Icons.mic, color: theme.secondaryTextColor),
                      onPressed: _toggleRecording,
                      tooltip: 'Voice message',
                    ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _fileIcon(String? filename) {
    final ext = filename?.split('.').last.toLowerCase() ?? '';
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'mp4':
      case 'mov':
        return Icons.videocam;
      case 'mp3':
      case 'wav':
      case 'm4a':
        return Icons.audiotrack;
      default:
        return Icons.insert_drive_file;
    }
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onSend, required this.theme});
  final VoidCallback onSend;
  final ChatTheme theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSend,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor,
              theme.primaryColor.withOpacity(0.75),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.35),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(Icons.send_rounded, color: theme.appBarTextColor, size: 20),
      ),
    );
  }
}

class _AttachOption extends StatelessWidget {
  const _AttachOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: theme.appBarTextColor, size: 20),
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}
