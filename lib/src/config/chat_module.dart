import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../config/chat_theme.dart';
import '../data/api/chat_api_client.dart';
import '../data/api/chat_stomp_client.dart';
import '../data/repositories/chat_room_repository.dart';
import '../data/repositories/chat_message_repository.dart';
import '../data/repositories/chat_user_repository.dart';

final _sl = GetIt.instance;

/// Checks if [ChatModule] has been fully initialized.
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

  // Stored as static fields to avoid conflicts with host app's GetIt registrations.
  static final ValueNotifier<ThemeData?> _parentThemeNotifier =
      ValueNotifier(null);
  static ChatTheme _chatTheme = ChatTheme.defaultTheme;
  static ChatTheme Function(ThemeData)? _themeBuilder;

  // Created eagerly so screens can await it even before init() is called.
  static Completer<void> _readyCompleter = Completer<void>();

  // Resolved chat-system user id (may differ from auth user id).
  // Set once createOrUpdateUser() returns during init().
  static int? _resolvedChatUserId;

  /// A [Future] that completes once [init] has finished successfully.
  ///
  /// Screens should `await ChatModule.ready` before accessing [ChatModule.api]
  /// or any other service. This future is always non-null — it will simply
  /// block until [init] is called and completes, even if navigation happens first.
  static Future<void> get ready => _readyCompleter.future;

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
    ChatTheme Function(ThemeData)? themeBuilder,
    Future<String?> Function()? onUnauthorized,
  }) async {
    if (themeBuilder != null) _themeBuilder = themeBuilder;

    // Already initialized — ready future is already completed.
    if (_readyCompleter.isCompleted) return;

    try {
      _parentThemeNotifier.value = parentTheme;
      if (themeBuilder != null && parentTheme != null) {
        _chatTheme = themeBuilder(parentTheme);
      } else {
        _chatTheme = theme;
      }

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

      // Auto-provision the ChatUser and capture the chat-system userId before
      // marking ready, so all screens use the correct chatUser.id (PK), not the
      // auth userId. This avoids messages appearing on the wrong side of the UI.
      try {
        final chatUser = await _sl<ChatApiClient>().createOrUpdateUser(
          userId: currentUserId,
          username: currentUserName,
        );
        _resolvedChatUserId = chatUser.id;
      } catch (e) {
        debugPrint('[ChatModule] Failed to provision chat user: $e');
        _resolvedChatUserId = currentUserId; // fallback: use auth userId
      }

      // Mark ready after user provisioning — screens get the correct currentUserId.
      _readyCompleter.complete();

      _sl<ChatStompClient>().connect().catchError((e) {
        debugPrint('[ChatModule] STOMP connect failed: $e');
      });
    } catch (e) {
      // Complete with error so waiting screens get the error state.
      // Reset readyCompleter so a retry (after dispose) can re-init.
      _readyCompleter.completeError(e);
      await _sl.reset();
      _parentThemeNotifier.value = null;
      _chatTheme = ChatTheme.defaultTheme;
      rethrow;
    }
  }

  /// Disposes all resources (call on logout).
  static Future<void> dispose() async {
    if (!_sl.isRegistered<ChatApiClient>()) return;
    await _sl<ChatStompClient>().disconnect();
    await _sl.reset();
    _readyCompleter = Completer<void>(); // reset for next login session
    _parentThemeNotifier.value = null;
    _chatTheme = ChatTheme.defaultTheme;
    _themeBuilder = null;
    _resolvedChatUserId = null;
  }

  static ChatTheme get theme => _chatTheme;

  /// The parent app's [ThemeData], stored to inherit fonts/input styles in routes.
  static ThemeData? get parentTheme => _parentThemeNotifier.value;

  /// A [ValueNotifier] that notifies when [parentTheme] changes.
  /// Used by routes to rebuild the theme wrapper reactively.
  static ValueNotifier<ThemeData?> get parentThemeNotifier =>
      _parentThemeNotifier;

  /// Updates the parent app's theme at runtime (e.g. on system dark/light change).
  /// All chat screens will rebuild automatically via [parentThemeNotifier].
  static void updateParentTheme(ThemeData theme) {
    _parentThemeNotifier.value = theme;
    if (_themeBuilder != null) _chatTheme = _themeBuilder!(theme);
  }

  static String get baseUrl => _sl<_ChatConfig>().baseUrl;
  static int get currentUserId =>
      _resolvedChatUserId ?? _sl<_ChatConfig>().currentUserId;
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
