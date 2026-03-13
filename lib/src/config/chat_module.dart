import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../config/chat_theme.dart';
import '../data/api/chat_api_client.dart';
import '../data/api/chat_stomp_client.dart';
import '../data/repositories/chat_room_repository.dart';
import '../data/repositories/chat_message_repository.dart';
import '../data/repositories/chat_user_repository.dart';

final _sl = GetIt.instance;

/// Checks if [ChatModule] has been initialized.
bool get isChatModuleInitialized => _sl.isRegistered<ChatApiClient>();

/// Global entry point for the chat_flutter package.
///
/// Call [ChatModule.init] once at app startup, before navigating to any chat screen.
///
/// ```dart
/// await ChatModule.init(
///   baseUrl: 'https://api.myapp.com',
///   authTokenProvider: () => myAuthService.getToken(),
///   currentUserId: myUser.id,
///   currentUserName: myUser.name,
/// );
/// ```
class ChatModule {
  ChatModule._();

  // Stored as a static field to avoid conflicts with host app's GetIt registrations.
  static ThemeData? _parentTheme;

  /// Initializes the chat package with the given configuration.
  ///
  /// - [baseUrl]: base URL of the chat-api backend (e.g. `https://api.myapp.com`)
  /// - [authTokenProvider]: async function returning the current Bearer token
  /// - [currentUserId]: ID of the authenticated user
  /// - [currentUserName]: Display name of the authenticated user
  /// - [theme]: optional [ChatTheme] to override colors manually
  /// - [parentTheme]: optional Flutter [ThemeData] to auto-derive [ChatTheme] from
  ///   the parent app's color scheme. Ignored if [theme] is also provided.
  /// - [onUnauthorized]: optional callback invoked when a 401 is received.
  ///   Should return a fresh Bearer token (after refresh) or null to give up.
  ///   When a non-null token is returned, the failed request is retried once.
  static Future<void> init({
    required String baseUrl,
    required Future<String?> Function() authTokenProvider,
    required int currentUserId,
    required String currentUserName,
    ChatTheme theme = ChatTheme.defaultTheme,
    ThemeData? parentTheme,
    Future<String?> Function()? onUnauthorized,
  }) async {
    if (_sl.isRegistered<ChatApiClient>()) return; // already initialized

    _parentTheme = parentTheme;

    _sl.registerSingleton<ChatTheme>(theme);
    _sl.registerSingleton<_ChatConfig>(
      _ChatConfig(
        baseUrl: baseUrl,
        currentUserId: currentUserId,
        currentUserName: currentUserName,
      ),
    );

    _sl.registerSingleton<ChatApiClient>(
      ChatApiClient(
        baseUrl: baseUrl,
        authTokenProvider: authTokenProvider,
        currentUserId: currentUserId,
        currentUserName: currentUserName,
        onUnauthorized: onUnauthorized,
      ),
    );

    _sl.registerSingleton<ChatStompClient>(
      ChatStompClient(
        baseUrl: baseUrl,
        authTokenProvider: authTokenProvider,
      ),
    );

    _sl.registerLazySingleton<ChatRoomRepository>(
      () => ChatRoomRepository(_sl<ChatApiClient>()),
    );
    _sl.registerLazySingleton<ChatMessageRepository>(
      () => ChatMessageRepository(_sl<ChatApiClient>()),
    );
    _sl.registerLazySingleton<ChatUserRepository>(
      () => ChatUserRepository(_sl<ChatApiClient>()),
    );

    await _sl<ChatStompClient>().connect();
  }

  /// Disposes all resources (call on logout).
  static Future<void> dispose() async {
    if (!_sl.isRegistered<ChatApiClient>()) return;
    await _sl<ChatStompClient>().disconnect();
    await _sl.reset();
    _parentTheme = null;
  }

  static ChatTheme get theme => _sl<ChatTheme>();

  /// The parent app's [ThemeData], stored to inherit fonts/input styles in routes.
  static ThemeData? get parentTheme => _parentTheme;

  static String get baseUrl => _sl<_ChatConfig>().baseUrl;
  static int get currentUserId => _sl<_ChatConfig>().currentUserId;
  static String get currentUserName => _sl<_ChatConfig>().currentUserName;
  static ChatApiClient get api => _sl<ChatApiClient>();
  static ChatStompClient get stomp => _sl<ChatStompClient>();
  static ChatRoomRepository get rooms => _sl<ChatRoomRepository>();
  static ChatMessageRepository get messages => _sl<ChatMessageRepository>();
  static ChatUserRepository get users => _sl<ChatUserRepository>();
}

class _ChatConfig {
  const _ChatConfig({
    required this.baseUrl,
    required this.currentUserId,
    required this.currentUserName,
  });
  final String baseUrl;
  final int currentUserId;
  final String currentUserName;
}
