import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../config/chat_module.dart';
import '../../config/chat_theme.dart';
import '../../data/models/models.dart';
import 'audio_player_widget.dart';
import 'video_player_widget.dart';
import 'file_attachment_widget.dart';

/// Displays a single chat message bubble.
/// Handles: text, media, reply-to, reactions, bot indicator, delete/edit states.
/// Long-press shows a Telegram-style contextual popup with copy/share/forward/reply/edit/delete.
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

    if (_isOwn) {
      return GestureDetector(
        onLongPressStart: (details) =>
            _showContextMenu(context, theme, details.globalPosition),
        child: Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: _buildBubble(theme),
          ),
        ),
      );
    }

    // Non-own message: show avatar on the left (Telegram style)
    return GestureDetector(
      onLongPressStart: (details) =>
          _showContextMenu(context, theme, details.globalPosition),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _InlineAvatar(message: message, theme: theme),
            const SizedBox(width: 6),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                child: _buildBubble(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(ChatTheme theme) {
    return Container(
      margin: _isOwn
          ? const EdgeInsets.only(top: 2, bottom: 2, left: 60, right: 8)
          : const EdgeInsets.only(top: 2, bottom: 2, left: 0, right: 60),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _bubbleColor(theme),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.bubbleBorderRadius),
          topRight: Radius.circular(theme.bubbleBorderRadius),
          bottomLeft: _isOwn
              ? Radius.circular(theme.bubbleBorderRadius)
              : const Radius.circular(4),
          bottomRight: _isOwn
              ? const Radius.circular(4)
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
            if (message.mediaUrl != null) _MediaContent(message: message, isSender: _isOwn),
            _MessageText(message: message, theme: theme),
          ],
          _MessageFooter(message: message, theme: theme, isOwn: _isOwn),
          if (message.reactions.isNotEmpty)
            _ReactionsRow(message: message),
        ],
      ),
    );
  }

  Color _bubbleColor(ChatTheme theme) {
    if (message.fromBot) return const Color(0xFFE8F5E9);
    if (_isOwn) return theme.ownBubbleColor;
    return theme.otherBubbleColor;
  }

  void _showContextMenu(
      BuildContext context, ChatTheme theme, Offset globalPosition) {
    final screenSize = MediaQuery.of(context).size;
    final isUpperHalf = globalPosition.dy < screenSize.height / 2;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 180),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          alignment: Alignment.center,
          child: child,
        ),
      ),
      pageBuilder: (ctx, _, __) => _BubbleContextMenu(
        message: message,
        isOwn: _isOwn,
        theme: theme,
        tapPosition: globalPosition,
        isUpperHalf: isUpperHalf,
        onReply: onReply != null
            ? () {
                Navigator.pop(ctx);
                onReply!();
              }
            : null,
        onEdit: (onEdit != null && _isOwn && !message.deleted)
            ? () {
                Navigator.pop(ctx);
                onEdit!();
              }
            : null,
        onDelete: onDelete != null
            ? () {
                Navigator.pop(ctx);
                onDelete!();
              }
            : null,
        onReact: onReact != null
            ? (emoji) {
                Navigator.pop(ctx);
                onReact!(emoji);
              }
            : null,
        onForward: onForward != null
            ? () {
                Navigator.pop(ctx);
                onForward!();
              }
            : null,
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
          Icon(Icons.smart_toy, size: 12, color: const Color(0xFF00897B)),
          const SizedBox(width: 4),
          Text(
            message.botName ?? 'AI',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF00897B),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small avatar shown beside non-own messages (Telegram style).
class _InlineAvatar extends StatelessWidget {
  const _InlineAvatar({required this.message, required this.theme});
  final ChatMessage message;
  final ChatTheme theme;

  static Color _colorFromName(String name) {
    final colors = [
      const Color(0xFF1976D2), const Color(0xFF388E3C), const Color(0xFF7B1FA2),
      const Color(0xFFE64A19), const Color(0xFF0288D1), const Color(0xFF00796B),
      const Color(0xFFC2185B), const Color(0xFF5D4037),
    ];
    if (name.isEmpty) return colors[0];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    if (message.fromBot) {
      return CircleAvatar(
        radius: 14,
        backgroundColor: const Color(0xFF00897B).withOpacity(0.15),
        child: const Icon(Icons.smart_toy, size: 16, color: Color(0xFF00897B)),
      );
    }
    final name = message.senderName ?? '';
    final color = _colorFromName(name);
    return CircleAvatar(
      radius: 14,
      backgroundColor: color.withOpacity(0.15),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: color),
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
  const _MediaContent({required this.message, required this.isSender});
  final ChatMessage message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    final rawUrl = message.mediaUrl!;
    final url = rawUrl.startsWith('http')
        ? rawUrl
        : '${ChatModule.baseUrl}/$rawUrl';
    final mediaType = message.mediaType ?? '';
    final filename = url.split('/').last;

    // Audio
    if (mediaType.startsWith('audio') ||
        url.toLowerCase().endsWith('.mp3') ||
        url.toLowerCase().endsWith('.wav') ||
        url.toLowerCase().endsWith('.m4a') ||
        url.toLowerCase().endsWith('.aac')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: AudioPlayerWidget(audioUrl: url, isSender: isSender),
      );
    }

    // Video
    if (mediaType.startsWith('video') ||
        url.toLowerCase().endsWith('.mp4') ||
        url.toLowerCase().endsWith('.mov') ||
        url.toLowerCase().endsWith('.avi')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: VideoPlayerWidget(videoUrl: url),
      );
    }

    // Image
    if (mediaType.startsWith('image') || url.contains('/Image/')) {
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

    // Document / file fallback
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: FileAttachmentWidget(
        fileUrl: url,
        filename: filename,
        isSender: isSender,
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
    return _buildContent(
      message.content,
      theme.messageFontSize,
    );
  }

  Widget _buildContent(String content, double fontSize) {
    final regex = RegExp(r'(@\w+)');
    if (!regex.hasMatch(content)) {
      return Text(content, style: TextStyle(fontSize: fontSize));
    }
    final spans = <TextSpan>[];
    int lastEnd = 0;
    for (final match in regex.allMatches(content)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: content.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(
          color: ChatModule.theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < content.length) {
      spans.add(TextSpan(text: content.substring(lastEnd)));
    }
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: fontSize),
        children: spans,
      ),
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
              message.read
                  ? Icons.done_all          // lu = double check bleu
                  : message.id > 0
                      ? Icons.done_all      // livré (sauvegardé) = double check gris
                      : Icons.done,         // envoi en cours = simple check gris
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

/// Telegram/WhatsApp-style contextual popup menu.
/// Appears near the bubble with emoji reactions + action buttons.
class _BubbleContextMenu extends StatelessWidget {
  const _BubbleContextMenu({
    required this.message,
    required this.isOwn,
    required this.theme,
    required this.tapPosition,
    required this.isUpperHalf,
    this.onReply,
    this.onEdit,
    this.onDelete,
    this.onReact,
    this.onForward,
  });

  final ChatMessage message;
  final bool isOwn;
  final ChatTheme theme;
  final Offset tapPosition;
  final bool isUpperHalf;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String emoji)? onReact;
  final VoidCallback? onForward;

  void _copy(BuildContext context) {
    if (message.content.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: message.content));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message copié'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _share(BuildContext context) {
    Navigator.pop(context);
    if (message.mediaUrl != null) {
      final uri = Uri.tryParse(message.mediaUrl!);
      if (uri != null) {
        Share.shareUri(uri);
        return;
      }
    }
    final text = message.content.isNotEmpty
        ? message.content
        : message.mediaUrl ?? '';
    if (text.isNotEmpty) Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = (screenWidth * 0.52).clamp(200.0, 260.0);
    final leftOffset = isOwn
        ? (screenWidth - menuWidth - 12).clamp(0.0, screenWidth)
        : 12.0;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Positioned menu card
          Positioned(
            left: leftOffset,
            top: isUpperHalf ? tapPosition.dy + 8 : null,
            bottom: isUpperHalf
                ? null
                : MediaQuery.of(context).size.height - tapPosition.dy + 8,
            child: SizedBox(
              width: menuWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Emoji reactions pill
                  if (onReact != null) ...[
                    _ReactionsPill(onReact: onReact!, theme: theme),
                    const SizedBox(height: 6),
                  ],
                  // Action buttons card
                  Card(
                    elevation: 8,
                    shadowColor: Colors.black38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildActions(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <_MenuAction>[];

    if (onReply != null) {
      actions.add(_MenuAction(
        icon: Icons.reply_rounded,
        label: 'Répondre',
        onTap: onReply!,
      ));
    }

    if (!message.deleted && message.content.isNotEmpty) {
      actions.add(_MenuAction(
        icon: Icons.copy_rounded,
        label: 'Copier',
        onTap: () => _copy(context),
      ));
    }

    if (!message.deleted) {
      actions.add(_MenuAction(
        icon: Icons.share_rounded,
        label: 'Partager',
        onTap: () => _share(context),
      ));
    }

    if (onForward != null && !message.deleted) {
      actions.add(_MenuAction(
        icon: Icons.forward_rounded,
        label: 'Transférer',
        onTap: onForward!,
      ));
    }

    if (onEdit != null) {
      actions.add(_MenuAction(
        icon: Icons.edit_rounded,
        label: 'Modifier',
        onTap: onEdit!,
      ));
    }

    if (onDelete != null) {
      actions.add(_MenuAction(
        icon: Icons.delete_outline_rounded,
        label: isOwn ? 'Supprimer' : 'Supprimer pour moi',
        color: Colors.red,
        onTap: onDelete!,
      ));
    }

    final widgets = <Widget>[];
    for (int i = 0; i < actions.length; i++) {
      widgets.add(_ActionTile(action: actions[i]));
      if (i < actions.length - 1) {
        widgets.add(const Divider(height: 1, thickness: 0.5, indent: 48));
      }
    }
    return widgets;
  }
}

class _ReactionsPill extends StatelessWidget {
  const _ReactionsPill({required this.onReact, required this.theme});
  final Function(String) onReact;
  final ChatTheme theme;

  static const _emojis = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _emojis.map((emoji) {
            return GestureDetector(
              onTap: () => onReact(emoji),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _MenuAction {
  const _MenuAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});
  final _MenuAction action;

  @override
  Widget build(BuildContext context) {
    final color = action.color ?? Theme.of(context).textTheme.bodyLarge?.color;
    return InkWell(
      onTap: action.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(action.icon, size: 20, color: color),
            const SizedBox(width: 14),
            Text(
              action.label,
              style: TextStyle(fontSize: 15, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
