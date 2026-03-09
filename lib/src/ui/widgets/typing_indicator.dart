import 'package:flutter/material.dart';
import '../../config/chat_module.dart';

/// Animated typing indicator ("..." dots).
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key, required this.typingUsers});
  final Map<int, String> typingUsers;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingUsers.isEmpty) return const SizedBox.shrink();

    final theme = ChatModule.theme;
    final names = widget.typingUsers.values.join(', ');
    final label = widget.typingUsers.length == 1
        ? '$names est en train d\'écrire'
        : '$names écrivent';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _DotsAnimation(controller: _controller, color: theme.secondaryTextColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: theme.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotsAnimation extends StatelessWidget {
  const _DotsAnimation({required this.controller, required this.color});
  final AnimationController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          children: List.generate(3, (i) {
            final offset = (i * 0.3).clamp(0.0, 1.0);
            final opacity = (controller.value - offset).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.3 + opacity * 0.7),
              ),
            );
          }),
        );
      },
    );
  }
}
