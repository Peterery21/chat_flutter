/// chat_flutter — Reusable Flutter chat package for chat-api (Spring Boot).
///
/// Usage:
/// ```dart
/// import 'package:chat_flutter/chat_flutter.dart';
///
/// await ChatModule.init(
///   baseUrl: 'https://api.myapp.com',
///   authTokenProvider: () async => await storage.read(key: 'token'),
///   currentUserId: user.id,
///   currentUserName: user.name,
/// );
/// ```
library chat_flutter;

// Config
export 'src/config/chat_module.dart';
export 'src/config/chat_theme.dart';

// Models
export 'src/data/models/models.dart';

// API (export TypingEvent for external use)
export 'src/data/api/chat_stomp_client.dart' show TypingEvent;

// Repositories
export 'src/data/repositories/chat_room_repository.dart';
export 'src/data/repositories/chat_message_repository.dart';
export 'src/data/repositories/chat_user_repository.dart';

// BLoCs
export 'src/blocs/chat_list/chat_list_bloc.dart';
export 'src/blocs/chat_list/chat_list_event.dart';
export 'src/blocs/chat_list/chat_list_state.dart';
export 'src/blocs/chat_room/chat_room_bloc.dart';
export 'src/blocs/chat_room/chat_room_event.dart';
export 'src/blocs/chat_room/chat_room_state.dart';
export 'src/blocs/typing/typing_cubit.dart';
export 'src/blocs/presence/presence_cubit.dart';

// Screens
export 'src/ui/screens/chat_list_screen.dart';
export 'src/ui/screens/chat_screen.dart';
export 'src/ui/screens/new_chat_screen.dart';
export 'src/ui/screens/group_settings_screen.dart';

// Widgets (for advanced customization)
export 'src/ui/widgets/message_bubble.dart';
export 'src/ui/widgets/chat_input_bar.dart';
export 'src/ui/widgets/typing_indicator.dart';
export 'src/ui/widgets/reaction_picker.dart';
export 'src/ui/widgets/pinned_message_bar.dart';
