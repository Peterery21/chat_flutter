import 'package:flutter/material.dart';

const _defaultEmojis = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

/// Quick emoji reaction picker shown above message options.
class ReactionPicker extends StatelessWidget {
  const ReactionPicker({
    super.key,
    required this.onReact,
    this.emojis = _defaultEmojis,
  });

  final Function(String emoji) onReact;
  final List<String> emojis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: emojis.map((emoji) {
          return GestureDetector(
            onTap: () => onReact(emoji),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
