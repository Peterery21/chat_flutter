# chat_flutter

Un package Flutter **réutilisable** qui intègre toutes les fonctionnalités de chat-api (Spring Boot 3.5). Intégrez un chat complet dans n'importe quel projet Flutter en quelques lignes.

## Fonctionnalités

| Feature | Statut |
|---------|--------|
| Conversations 1:1 et groupes | ✅ |
| Messages temps réel (STOMP WebSocket) | ✅ |
| Médias (images, fichiers) | ✅ |
| Réponse à un message | ✅ |
| Réactions (emojis) | ✅ |
| Indicateur de frappe | ✅ |
| Présence (en ligne / vu à) | ✅ |
| Accusés de lecture ✓✓ | ✅ |
| @Mentions | ✅ |
| Message épinglé | ✅ |
| Gestion des groupes (rôles, expulsion) | ✅ |
| Bot IA (chat-api Spring AI) | ✅ |
| Thème personnalisable Material + Cupertino | ✅ |

---

## Installation

```yaml
dependencies:
  chat_flutter:
    path: ../chat_flutter   # local
    # ou git: url: https://github.com/kodzotech/chat_flutter.git
```

```bash
flutter pub get
```

---

## Démarrage rapide

```dart
import 'package:chat_flutter/chat_flutter.dart';

// 1. Initialiser une seule fois (après login)
await ChatModule.init(
  baseUrl: 'https://api.monapp.com',
  authTokenProvider: () async => await storage.read(key: 'token'),
  currentUserId: user.id,
  currentUserName: user.name,
  theme: ChatTheme(primaryColor: Colors.green),
);

// 2. Afficher la liste des conversations
Navigator.push(context, MaterialPageRoute(
  builder: (_) => ChatListScreen(
    onRoomTap: (room) => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(roomId: room.id)),
    ),
  ),
));

// 3. Sur logout
await ChatModule.dispose();
```

---

## Thème

```dart
ChatModule.init(
  // ...
  theme: ChatTheme(
    primaryColor: Color(0xFF1A73E8),
    ownBubbleColor: Color(0xFFE3F2FD),
    otherBubbleColor: Colors.white,
    botBubbleColor: Color(0xFFF3E5F5),
    bubbleBorderRadius: 16.0,
    messageFontSize: 15.0,
  ),
);
```

---

## App exemple

```bash
cd example && flutter run
```

L'app démo demande `baseUrl`, `userId` et `username`, puis démarre le chat complet.

---

## Structure

```
lib/
├── chat_flutter.dart          # Export public
└── src/
    ├── config/                # ChatModule.init(), ChatTheme
    ├── data/api/              # Dio REST + STOMP WebSocket
    ├── data/models/           # ChatRoom, ChatMessage, ChatUser...
    ├── data/repositories/     # ChatRoomRepo, ChatMessageRepo, ChatUserRepo
    ├── blocs/                 # ChatListBloc, ChatRoomBloc, TypingCubit, PresenceCubit
    └── ui/screens/            # ChatListScreen, ChatScreen, NewChatScreen, GroupSettingsScreen
        ui/widgets/            # MessageBubble, ChatInputBar, TypingIndicator...
```

---

## Prérequis backend

Instance de [chat-api](../chat-api) Spring Boot 3.5+ avec WebSocket STOMP activé.
