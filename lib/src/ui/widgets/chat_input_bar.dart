import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/chat_module.dart';
import '../../data/models/models.dart';

/// Bottom input bar for composing and sending messages.
/// Handles: text, media attachment, reply-to preview, @mention trigger.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    this.participants = const [],
    this.replyToMessage,
    this.onCancelReply,
  });

  final Function(String content, {int? replyToId, File? mediaFile}) onSend;
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
  bool _showMentions = false;
  List<ChatParticipant> _filteredParticipants = [];
  String _mentionQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
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

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedMedia = File(picked.path));
    }
  }

  void _send() {
    final content = _controller.text.trim();
    if (content.isEmpty && _selectedMedia == null) return;

    widget.onSend(
      content,
      replyToId: widget.replyToMessage?.id,
      mediaFile: _selectedMedia,
    );

    _controller.clear();
    setState(() => _selectedMedia = null);
    widget.onCancelReply?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Mention overlay
        if (_showMentions)
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              color: Colors.white,
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
            color: Colors.grey.shade100,
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
          Stack(
            children: [
              Image.file(_selectedMedia!, height: 80, fit: BoxFit.cover),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMedia = null),
                  child: const CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

        // Input row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: theme.inputBarColor,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: _pickMedia,
                color: theme.secondaryTextColor,
              ),
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
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _SendButton(onSend: _send, theme: theme),
            ],
          ),
        ),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onSend, required this.theme});
  final VoidCallback onSend;
  final theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSend,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.send, color: Colors.white, size: 20),
      ),
    );
  }
}
