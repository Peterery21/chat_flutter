import 'package:flutter/material.dart';
import '../../config/chat_module.dart';
import '../../config/chat_theme.dart';
import '../../data/models/models.dart';
import 'reaction_picker.dart';

/// Displays a single chat message bubble.
/// Handles: text, media, reply-to, reactions, bot indicator, delete/edit states.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.onReact,
    this.onForward,
  });

  final ChatMessage message;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String emoji)? onReact;
  final VoidCallback? onForward;

  bool get _isOwn => message.senderId == ChatModule.currentUserId;

  @override
  Widget build(BuildContext context) {
    final theme = ChatModule.theme;

    return GestureDetector(
      onLongPress: () => _showOptions(context, theme),
      child: Align(
        alignment: _isOwn ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _bubbleColor(theme),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(theme.bubbleBorderRadius),
                topRight: Radius.circular(theme.bubbleBorderRadius),
                bottomLeft: _isOwn
                    ? Radius.circular(theme.bubbleBorderRadius)
                    : const Radius.circular(0),
                bottomRight: _isOwn
                    ? const Radius.circular(0)
                    : Radius.circular(theme.bubbleBorderRadius),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isOwn && !message.fromBot) _SenderName(message: message, theme: theme),
                if (message.fromBot) _BotLabel(message: message, theme: theme),
                if (message.replyToMessageId != null) _ReplyPreview(message: message, theme: theme),
                if (message.deleted)
                  _DeletedText(theme: theme)
                else ...[
                  if (message.mediaUrl != null) _MediaContent(message: message),
                  _MessageText(message: message, theme: theme),
                ],
                _MessageFooter(message: message, theme: theme, isOwn: _isOwn),
                if (message.reactions.isNotEmpty)
                  _ReactionsRow(message: message),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _bubbleColor(ChatTheme theme) {
    if (message.fromBot) return theme.botBubbleColor;
    if (_isOwn) return theme.ownBubbleColor;
    return theme.otherBubbleColor;
  }

  void _showOptions(BuildContext context, ChatTheme theme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _MessageOptionsSheet(
        message: message,
        isOwn: _isOwn,
        onReply: onReply != null ? () { Navigator.pop(context); onReply!(); } : null,
        onEdit: (onEdit != null && _isOwn && !message.deleted)
            ? () { Navigator.pop(context); onEdit!(); }
            : null,
        onDelete: onDelete != null ? () { Navigator.pop(context); onDelete!(); } : null,
        onReact: onReact != null
            ? (emoji) { Navigator.pop(context); onReact!(emoji); }
            : null,
        onForward: onForward != null ? () { Navigator.pop(context); onForward!(); } : null,
      ),
    );
  }
}

class _SenderName extends StatelessWidget {
  const _SenderName({required this.message, required this.theme});
  final ChatMessage message;
  final ChatTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        message.senderName ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}

class _BotLabel extends StatelessWidget {
  const _BotLabel({required this.message, required this.theme});
  final ChatMessage message;
  final ChatTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.smart_toy, size: 12, color: theme.primaryColor),
          const SizedBox(width: 4),
          Text(
            message.botName ?? 'AI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplyPreview extends StatelessWidget {
  const _ReplyPreview({required this.message, required this.theme});
  final ChatMessage message;
  final ChatTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: theme.primaryColor, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.replyToSenderName ?? '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: theme.primaryColor,
            ),
          ),
          Text(
            message.replyToContent ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: theme.secondaryTextColor),
          ),
        ],
      ),
    );
  }
}

class _MediaContent extends StatelessWidget {
  const _MediaContent({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final url = message.mediaUrl!;
    final isImage = message.mediaType?.startsWith('image') == true ||
        url.contains('/images/');
    if (isImage) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attach_file, size: 18),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              url.split('/').last,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeletedText extends StatelessWidget {
  const _DeletedText({required this.theme});
  final ChatTheme theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.block, size: 14, color: theme.secondaryTextColor),
        const SizedBox(width: 4),
        Text(
          'Message supprimé',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: theme.secondaryTextColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _MessageText extends StatelessWidget {
  const _MessageText({required this.message, required this.theme});
  final ChatMessage message;
  final ChatTheme theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      message.content,
      style: TextStyle(fontSize: theme.messageFontSize),
    );
  }
}

class _MessageFooter extends StatelessWidget {
  const _MessageFooter({
    required this.message,
    required this.theme,
    required this.isOwn,
  });
  final ChatMessage message;
  final ChatTheme theme;
  final bool isOwn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (message.edited)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                'modifié',
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: theme.secondaryTextColor,
                ),
              ),
            ),
          Text(
            _formatTime(message.createdAt),
            style: TextStyle(fontSize: 11, color: theme.secondaryTextColor),
          ),
          if (isOwn) ...[
            const SizedBox(width: 4),
            Icon(
              message.read ? Icons.done_all : Icons.done,
              size: 14,
              color: message.read ? Colors.blue : theme.secondaryTextColor,
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(String createdAt) {
    try {
      final dt = DateTime.parse(createdAt).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}

class _ReactionsRow extends StatelessWidget {
  const _ReactionsRow({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        children: message.reactions.map((r) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${r.emoji} ${r.count}', style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
      ),
    );
  }
}

class _MessageOptionsSheet extends StatelessWidget {
  const _MessageOptionsSheet({
    required this.message,
    required this.isOwn,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.onReact,
    this.onForward,
  });

  final ChatMessage message;
  final bool isOwn;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String emoji)? onReact;
  final VoidCallback? onForward;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onReact != null)
              ReactionPicker(onReact: onReact!),
            const SizedBox(height: 8),
            if (onReply != null)
              _OptionTile(
                icon: Icons.reply,
                label: 'Répondre',
                onTap: onReply!,
              ),
            if (onEdit != null)
              _OptionTile(
                icon: Icons.edit,
                label: 'Modifier',
                onTap: onEdit!,
              ),
            if (onForward != null)
              _OptionTile(
                icon: Icons.forward,
                label: 'Transférer',
                onTap: onForward!,
              ),
            if (onDelete != null)
              _OptionTile(
                icon: Icons.delete,
                label: isOwn ? 'Supprimer' : 'Supprimer pour moi',
                color: Colors.red,
                onTap: onDelete!,
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
