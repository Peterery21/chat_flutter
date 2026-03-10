import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/chat_module.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc() : super(const ChatListInitial()) {
    on<ChatListLoadRequested>(_onLoad);
    on<ChatListRoomsUpdated>(_onRoomsUpdated);
    on<ChatListRoomTypingUpdated>(_onTypingUpdated);
    on<ChatListMentionReceived>(_onMentionReceived);
  }

  StreamSubscription? _roomsSub;
  StreamSubscription? _mentionSub;

  Future<void> _onLoad(
    ChatListLoadRequested event,
    Emitter<ChatListState> emit,
  ) async {
    emit(const ChatListLoading());
    try {
      final rooms = await ChatModule.rooms.getRooms(event.userId);
      emit(ChatListLoaded(rooms: rooms));

      // Subscribe to real-time room list updates
      await _roomsSub?.cancel();
      _roomsSub = ChatModule.stomp.roomListFor(event.userId).listen(
        (updatedRooms) => add(ChatListRoomsUpdated(updatedRooms)),
      );

      // Subscribe to incoming @mention notifications
      await _mentionSub?.cancel();
      _mentionSub = ChatModule.stomp.mentionsFor(event.userId).listen(
        (msg) => add(ChatListMentionReceived(msg)),
      );
    } catch (e) {
      emit(ChatListError(e.toString()));
    }
  }

  void _onRoomsUpdated(
    ChatListRoomsUpdated event,
    Emitter<ChatListState> emit,
  ) {
    final current = state;
    if (current is ChatListLoaded) {
      emit(current.copyWith(rooms: event.rooms));
    } else {
      emit(ChatListLoaded(rooms: event.rooms));
    }
  }

  void _onMentionReceived(
    ChatListMentionReceived event,
    Emitter<ChatListState> emit,
  ) {
    final current = state;
    if (current is ChatListLoaded) {
      final updated = current.rooms.map((r) {
        if (r.id == event.message.chatRoomId) {
          return r.copyWith(unreadCount: r.unreadCount + 1);
        }
        return r;
      }).toList();
      emit(current.copyWith(rooms: updated));
    }
  }

  void _onTypingUpdated(
    ChatListRoomTypingUpdated event,
    Emitter<ChatListState> emit,
  ) {
    final current = state;
    if (current is ChatListLoaded) {
      final updated = Map<int, String>.from(current.typingByRoom);
      if (event.isTyping) {
        updated[event.roomId] = event.username;
      } else {
        updated.remove(event.roomId);
      }
      emit(current.copyWith(typingByRoom: updated));
    }
  }

  @override
  Future<void> close() async {
    await _roomsSub?.cancel();
    await _mentionSub?.cancel();
    return super.close();
  }
}
