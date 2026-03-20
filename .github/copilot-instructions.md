# chat_flutter - AI Coding Assistant Instructions

## Package Overview

`chat_flutter` is a **reusable Flutter package** (not an app) that provides a complete chat UI and logic for integrating with [chat-api](../chat-api). Supports 1:1 chats, group chats, AI bots, WebSocket STOMP real-time updates, media, reactions, and more.

**Version**: 0.1.5 | **SDK**: Dart ^3.11.0 / Flutter >=3.10.0

## Architecture

```
lib/src/
├── config/
│   ├── chat_module.dart      # Global entry point (init/dispose/ready)
│   ├── chat_routes.dart      # GoRouter routes (chatGoRoutes())
│   └── chat_theme.dart       # ChatTheme + ChatTheme.fromThemeData()
├── data/
│   ├── api/
│   │   ├── chat_api_client.dart    # Dio REST client
│   │   └── chat_stomp_client.dart  # WebSocket STOMP client
│   ├── models/               # Freezed models (ChatMessage, ChatRoom, ChatUser…)
│   │   └── models.dart       # Barrel export
│   └── repositories/
│       ├── chat_room_repository.dart
│       ├── chat_message_repository.dart
│       └── chat_user_repository.dart
├── blocs/
│   ├── chat_list/            # ChatListBloc (event/state)
│   ├── chat_room/            # ChatRoomBloc (event/state)
│   ├── presence/             # PresenceCubit
│   └── typing/               # TypingCubit
└── ui/
    ├── screens/              # ChatListScreen, ChatScreen, NewChatScreen, GroupSettingsScreen
    └── widgets/              # MessageBubble, ChatInputBar, VoiceRecorderBar, ChatModuleGuard…
```

## ChatModule — Point d'entrée

`ChatModule` est le seul point d'entrée du package. Il gère le cycle de vie complet.

### Init (après login)
```dart
await ChatModule.init(
  baseUrl: EnvInfo.connectionString,            // URL de l'API
  authTokenProvider: () async => prefs.getString('token'),
  currentUserId: user.id!,
  currentUserName: '${user.prenom} ${user.nom}',
  parentTheme: Theme.of(context),               // hérite fonts/couleurs de l'app
  themeBuilder: (theme) => ChatTheme.fromThemeData(theme).copyWith(
    primaryColor: const Color(0xFF8a5021),
    ownBubbleColor: const Color(0xFFD4956A),
  ),
  onUnauthorized: () async => /* refresh token ou null */,
  onDeeplinkTap: (href) {
    // ex: deeplink://trajet/123 → naviguer dans l'app hôte
    final uri = Uri.parse(href);
    if (uri.scheme == 'deeplink') router.push('/trajet/${uri.pathSegments.first}');
  },
);
```

### Dispose (à la déconnexion)
```dart
await ChatModule.dispose(); // toujours appeler avant de vider la session
```

### Accesseurs statiques
```dart
isChatModuleInitialized       // bool — true une fois GetIt enregistré
ChatModule.ready              // Future<void> — awaitable, jamais null
ChatModule.api                // ChatApiClient (HTTP)
ChatModule.stomp              // ChatStompClient (WebSocket)
ChatModule.rooms              // ChatRoomRepository
ChatModule.messages           // ChatMessageRepository
ChatModule.users              // ChatUserRepository
ChatModule.theme              // ChatTheme courant
ChatModule.parentTheme        // ThemeData de l'app hôte
ChatModule.currentUserId      // int — ID chat résolu (≠ auth userId)
ChatModule.updateParentTheme(theme)  // réactualise le thème (dark/light switch)
```

> **CRITIQUE** : `ChatModule.currentUserId` est l'ID **interne** (`ChatUser.id`, clé PK), pas l'auth userId. Il est résolu lors du `init()` via `createOrUpdateUser()`. Ne jamais utiliser l'auth userId directement dans les BLoCs chat.

### Attendre le ready dans les screens
```dart
// Option 1 — widget guard
return ChatModuleGuard(child: MyChatScreen());

// Option 2 — await manuel
await ChatModule.ready;
final bot = await ChatModule.api.getPrimaryBot();
```

## Dependency Injection (GetIt interne)

Le package utilise `get_it` en **interne** via l'instance globale `GetIt.instance`. Les services sont enregistrés dans `ChatModule.init()` et supprimés dans `ChatModule.dispose()`.

> **Ne jamais enregistrer les services chat dans le GetIt de l'app hôte.** L'isolation est intentionnelle pour permettre `dispose()` + re-`init()` sur logout/login.

```dart
// Vérifier si initialisé
final bool ready = GetIt.instance.isRegistered<ChatApiClient>();
// équivalent à : isChatModuleInitialized
```

## BLoC Pattern

### ChatRoomBloc
Gère la salle de chat active (messages, envoi, réactions, édition…).

```dart
// États
ChatRoomInitial | ChatRoomLoading | ChatRoomLoaded | ChatRoomError

// ChatRoomLoaded expose :
final ChatRoom room;
final List<ChatMessage> messages;
final bool hasMore;
final bool sendingMessage;

// Événements principaux
ChatRoomLoadRequested(roomId, userId, initialRoom?)
ChatRoomSendMessage(content, replyToMessageId?, mediaFile?, mentionedUserIds?)
ChatRoomMessageReceived(message)        // depuis STOMP stream
ChatRoomLoadOlderMessages()
ChatRoomDeleteMessage(messageId)
ChatRoomEditMessage(messageId, content)
ChatRoomAddReaction(messageId, emoji)
```

### ChatListBloc
Gère la liste des salles de l'utilisateur.

### PresenceCubit / TypingCubit
Cubits légers pour les indicateurs de présence et de frappe.

### Consommation dans les screens
```dart
BlocBuilder<ChatRoomBloc, ChatRoomState>(
  builder: (context, state) {
    if (state is ChatRoomLoaded) { ... }
    if (state is ChatRoomLoading) { ... }
    if (state is ChatRoomError) { ... }
  },
)
```

## Modèles Freezed

Tous les modèles sont immutables via `@freezed`. Les fichiers générés (`*.freezed.dart`, `*.g.dart`) ne doivent pas être modifiés manuellement.

```dart
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required int id,
    required int chatRoomId,
    @JsonKey(name: 'chatUserId') required int senderId,
    required String content,
    @JsonKey(name: 'time') required String createdAt,
    String? mediaUrl,
    String? mediaType,
    int? replyToMessageId,
    @Default(false) bool deleted,
    @Default(false) bool fromBot,
    @Default([]) List<ChatReaction> reactions,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
```

**Modèles disponibles** : `ChatMessage`, `ChatRoom`, `ChatUser`, `ChatParticipant`, `ChatReaction`, `ChatBot`

## ChatApiClient (Dio)

Client REST Dio avec :
- Injection auto du Bearer token via intercepteur
- Retry automatique sur 401 si `onUnauthorized` est fourni
- Timeout : 10s connect / 30s receive

```dart
// Accès via ChatModule
ChatModule.api.createOrUpdateUser(userId: id, username: name);
ChatModule.api.getRoomsByUser(userId);
ChatModule.api.sendMessage(dto);
ChatModule.api.getPrimaryBot();
```

## ChatStompClient (WebSocket STOMP)

Gère la connexion WebSocket avec re-subscription automatique sur reconnexion.

```dart
// Streams disponibles
ChatModule.stomp.messagesFor(roomId)    // Stream<ChatMessage>
ChatModule.stomp.roomListFor(userId)    // Stream<List<ChatRoom>>
ChatModule.stomp.typingFor(roomId)      // Stream<TypingEvent>
```

La connexion STOMP est établie automatiquement à la fin de `ChatModule.init()`. Les subscriptions sont rejouées sur chaque reconnexion.

## Routes GoRouter

Intégrer dans le router de l'app hôte avec le spread operator :

```dart
GoRouter(
  routes: [
    ...chatGoRoutes(
      chatsPath: '/chats',           // défaut
      newChatPath: '/new-chat',      // défaut
      showNewChatButton: true,       // défaut
    ),
    // autres routes de l'app…
  ],
)
```

Routes générées :
- `/chats` → `ChatListScreen`
- `/chats/:roomId` → `ChatScreen` (passer `ChatRoom` comme `extra`)
- `/chats/:roomId/settings` → `GroupSettingsScreen` (passer `ChatRoom` comme `extra`)
- `/new-chat` → `NewChatScreen`

## ChatTheme

```dart
// Option 1 — dériver du thème de l'app hôte (recommandé)
ChatTheme.fromThemeData(Theme.of(context))

// Option 2 — thème manuel avec overrides
ChatTheme.fromThemeData(theme).copyWith(
  primaryColor: const Color(0xFF8a5021),
  ownBubbleColor: const Color(0xFFD4956A),
  botBubbleColor: const Color(0xFFE3F2FD),
)

// Option 3 — thème par défaut (style WhatsApp vert)
ChatTheme.defaultTheme
```

Champs personnalisables : `primaryColor`, `ownBubbleColor`, `otherBubbleColor`, `botBubbleColor`, `scaffoldBackgroundColor`, `appBarColor`, `appBarTextColor`, `inputBarColor`, `unreadBadgeColor`, `onlineIndicatorColor`, `errorColor`, `botIndicatorColor`, `bubbleBorderRadius`, `messageFontSize`…

## Commands

```bash
# Génération de code (OBLIGATOIRE après modification d'un modèle Freezed)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Tests
flutter test

# Lancer l'app exemple
cd example && flutter run
```

## Conventions

| Élément | Pattern | Exemple |
|---------|---------|---------|
| Classes | PascalCase | `ChatRoomBloc`, `ChatApiClient` |
| Fichiers | snake_case | `chat_room_bloc.dart`, `chat_api_client.dart` |
| Variables/méthodes | camelCase | `roomId`, `sendMessage()` |
| Modèles | `Chat*` prefix | `ChatMessage`, `ChatRoom`, `ChatUser` |
| BLoC | `*Bloc` / `*Cubit` | `ChatRoomBloc`, `PresenceCubit` |
| Events | PascalCase verbe | `ChatRoomLoadRequested`, `ChatRoomSendMessage` |
| States | PascalCase nom | `ChatRoomLoaded`, `ChatRoomError` |
| Screens | `*Screen` suffix | `ChatListScreen`, `ChatScreen` |
| Widgets | `*Widget` ou nom descriptif | `MessageBubble`, `ChatInputBar` |

## Ajouter une fonctionnalité

1. **Modèle** : créer/modifier dans `data/models/` avec `@freezed`, lancer build_runner
2. **API** : ajouter méthode dans `ChatApiClient` + repo correspondant
3. **BLoC** : ajouter événement dans `*_event.dart`, état dans `*_state.dart`, handler dans `*_bloc.dart`
4. **UI** : consommer via `BlocBuilder`/`BlocListener` dans le screen concerné
5. **Exporter** : si API publique, ajouter dans `lib/chat_flutter.dart`
