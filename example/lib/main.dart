import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chat_flutter/chat_flutter.dart';

/// Example app demonstrating chat_flutter package integration.
///
/// This simulates a login screen + full chat navigation.
/// Replace the login logic with your real auth system.
void main() {
  runApp(const ChatExampleApp());
}

class ChatExampleApp extends StatefulWidget {
  const ChatExampleApp({super.key});

  @override
  State<ChatExampleApp> createState() => _ChatExampleAppState();
}

class _ChatExampleAppState extends State<ChatExampleApp> {
  bool _initialized = false;

  late final GoRouter _router = GoRouter(
    redirect: (context, state) {
      if (!_initialized && state.matchedLocation != '/login') return '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => LoginScreen(onLogin: _onLogin),
      ),
      GoRoute(
        path: '/chats',
        builder: (_, __) => ChatListScreen(
          onRoomTap: (room) => _router.push('/chats/${room.id}', extra: room),
          onNewChat: () => _router.push('/new-chat'),
        ),
      ),
      GoRoute(
        path: '/chats/:roomId',
        builder: (_, state) {
          final roomId = int.parse(state.pathParameters['roomId']!);
          final room = state.extra as ChatRoom?;
          return ChatScreen(
            roomId: roomId,
            onGroupSettings: room?.isGroup == true
                ? () => _router.push('/chats/$roomId/settings', extra: room)
                : null,
          );
        },
      ),
      GoRoute(
        path: '/chats/:roomId/settings',
        builder: (_, state) {
          final room = state.extra as ChatRoom;
          return GroupSettingsScreen(
            room: room,
            onRoomLeft: () => _router.go('/chats'),
            onRoomDeleted: () => _router.go('/chats'),
          );
        },
      ),
      GoRoute(
        path: '/new-chat',
        builder: (_, __) => NewChatScreen(
          onRoomCreated: (room) {
            _router.pop();
            _router.push('/chats/${room.id}', extra: room);
          },
        ),
      ),
    ],
  );

  Future<void> _onLogin({
    required int userId,
    required String username,
    required String baseUrl,
  }) async {
    await ChatModule.init(
      baseUrl: baseUrl,
      // JWT token for local test (userId=1, secret matches application.yml default)
      authTokenProvider: () async => 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwicm9sZXMiOlsiUk9MRV9VU0VSIl0sImlhdCI6MTc3MzA5Nzc2NiwiZXhwIjoxODA0NjMzNzY2fQ.QvMyxX0PjUwM_5j5WtLVQmpUuLcwZg5W6ktivHc97UU6F75zV_JV9djY3E1iphKgWvX37jkf9LSuKGbJPvsKzA',
      currentUserId: userId,
      currentUserName: username,
      theme: const ChatTheme(
        primaryColor: Color(0xFF075E54),
        unreadBadgeColor: Color(0xFF25D366),
      ),
    );

    // Sync user with chat-api
    try {
      await ChatModule.users.syncUser(userId: userId, username: username);
    } catch (_) {}

    setState(() => _initialized = true);
    _router.go('/chats');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Chat Demo',
      routerConfig: _router,
      theme: ThemeData(
        primaryColor: const Color(0xFF075E54),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF075E54),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void dispose() {
    ChatModule.dispose();
    super.dispose();
  }
}

// ─── Login Screen ──────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final Future<void> Function({
    required int userId,
    required String username,
    required String baseUrl,
  }) onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrlCtrl = TextEditingController(text: 'http://192.168.2.78:8060');
  final _userIdCtrl = TextEditingController(text: '1');
  final _usernameCtrl = TextEditingController(text: 'Alice');
  bool _loading = false;

  @override
  void dispose() {
    _baseUrlCtrl.dispose();
    _userIdCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await widget.onLogin(
        userId: int.parse(_userIdCtrl.text.trim()),
        username: _usernameCtrl.text.trim(),
        baseUrl: _baseUrlCtrl.text.trim(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF075E54),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.chat_bubble,
                      size: 64, color: Color(0xFF075E54)),
                  const SizedBox(height: 8),
                  const Text(
                    'Chat Flutter Demo',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _baseUrlCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Base URL (chat-api)',
                      prefixIcon: Icon(Icons.link),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v?.isNotEmpty == true) ? null : 'Requis',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userIdCtrl,
                    decoration: const InputDecoration(
                      labelText: 'User ID',
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        int.tryParse(v ?? '') != null ? null : 'ID invalide',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nom d\'affichage',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v?.isNotEmpty == true) ? null : 'Requis',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF075E54),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Se connecter',
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
