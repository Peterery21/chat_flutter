import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/chat_module.dart';
import '../../data/api/chat_stomp_client.dart';

/// Tracks who is typing in a given room.
/// Maps userId → username for currently typing users.
class TypingCubit extends Cubit<Map<int, String>> {
  TypingCubit(this._roomId) : super({}) {
    _sub = ChatModule.stomp.typingFor(_roomId).listen((event) {
      final current = Map<int, String>.from(state);
      if (event.typing) {
        current[event.userId] = event.username;
      } else {
        current.remove(event.userId);
      }
      emit(current);
    });
  }

  final int _roomId;
  StreamSubscription? _sub;
  Timer? _stopTypingTimer;

  /// Call when the current user starts typing.
  void startTyping(int userId, String username) {
    ChatModule.stomp.sendTyping(_roomId, userId, username, true);
    _stopTypingTimer?.cancel();
    _stopTypingTimer = Timer(const Duration(seconds: 3), () {
      stopTyping(userId, username);
    });
  }

  /// Call when the current user explicitly stops typing.
  void stopTyping(int userId, String username) {
    _stopTypingTimer?.cancel();
    ChatModule.stomp.sendTyping(_roomId, userId, username, false);
  }

  @override
  Future<void> close() async {
    _stopTypingTimer?.cancel();
    await _sub?.cancel();
    return super.close();
  }
}
