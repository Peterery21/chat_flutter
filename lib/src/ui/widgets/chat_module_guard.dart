import 'package:flutter/material.dart';
import '../../config/chat_module.dart';

/// Waits for [ChatModule.ready] before rendering [child].
///
/// Place this at the root of any screen that accesses [ChatModule] services.
/// Shows a themed loading spinner while init is in progress, and an error
/// state (with retry) if init fails.
class ChatModuleGuard extends StatefulWidget {
  const ChatModuleGuard({super.key, required this.child});

  final Widget child;

  @override
  State<ChatModuleGuard> createState() => _ChatModuleGuardState();
}

class _ChatModuleGuardState extends State<ChatModuleGuard> {
  late Future<void> _ready;

  @override
  void initState() {
    super.initState();
    _ready = ChatModule.ready;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _ready,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => setState(() {
                      _ready = ChatModule.ready;
                    }),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        return widget.child;
      },
    );
  }
}
