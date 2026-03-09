import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/chat_module.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  ChatRoomBloc() : super(const ChatRoomInitial()) {
    on<ChatRoomLoadRequested>(_onLoad);
    on<ChatRoomMessageReceived>(_onMessageReceived);
    on<ChatRoomSendMessage>(_onSendMessage);
    on<ChatRoomLoadOlderMessages>(_onLoadOlder);
    on<ChatRoomDeleteMessage>(_onDelete);
    on<ChatRoomEditMessage>(_onEdit);
    on<ChatRoomAddReaction>(_onReaction);
  }

  int? _roomId;
  int? _userId;
  StreamSubscription? _msgSub;

  Future<void> _onLoad(
    ChatRoomLoadRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(const ChatRoomLoading());
    try {
      _roomId = event.roomId;
      _userId = event.userId;

      final room = await ChatModule.rooms
          .getRooms(event.userId)
          .then((rooms) => rooms.firstWhere((r) => r.id == event.roomId));

      final messages = await ChatModule.messages.getMessages(
        userId: event.userId,
        roomId: event.roomId,
        fromMessageId: 0,
      );

      emit(ChatRoomLoaded(
        room: room,
        messages: messages,
        hasMore: messages.length >= 20,
      ));

      // Real-time message subscription
      await _msgSub?.cancel();
      _msgSub = ChatModule.stomp.messagesFor(event.roomId).listen(
        (msg) => add(ChatRoomMessageReceived(msg)),
      );
    } catch (e) {
      emit(ChatRoomError(e.toString()));
    }
  }

  void _onMessageReceived(
    ChatRoomMessageReceived event,
    Emitter<ChatRoomState> emit,
  ) {
    final current = state;
    if (current is ChatRoomLoaded) {
      final updated = [event.message, ...current.messages];
      emit(current.copyWith(messages: updated));
    }
  }

  Future<void> _onSendMessage(
    ChatRoomSendMessage event,
    Emitter<ChatRoomState> emit,
  ) async {
    final current = state;
    if (current is! ChatRoomLoaded || _roomId == null || _userId == null) {
      return;
    }
    emit(current.copyWith(sendingMessage: true));
    try {
      final msg = await ChatModule.messages.send(
        userId: _userId!,
        roomId: _roomId!,
        content: event.content,
        replyToMessageId: event.replyToMessageId,
        mediaFile: event.mediaFile,
      );
      final updated = [msg, ...current.messages];
      emit(current.copyWith(messages: updated, sendingMessage: false));
    } catch (_) {
      emit(current.copyWith(sendingMessage: false));
    }
  }

  Future<void> _onLoadOlder(
    ChatRoomLoadOlderMessages event,
    Emitter<ChatRoomState> emit,
  ) async {
    final current = state;
    if (current is! ChatRoomLoaded ||
        !current.hasMore ||
        _roomId == null ||
        _userId == null) {
      return;
    }
    final oldestId = current.messages.isNotEmpty
        ? current.messages.last.id
        : 0;
    try {
      final older = await ChatModule.messages.getOlderMessages(
        userId: _userId!,
        roomId: _roomId!,
        fromMessageId: oldestId,
      );
      emit(current.copyWith(
        messages: [...current.messages, ...older],
        hasMore: older.length >= 20,
      ));
    } catch (_) {}
  }

  Future<void> _onDelete(
    ChatRoomDeleteMessage event,
    Emitter<ChatRoomState> emit,
  ) async {
    final current = state;
    if (current is! ChatRoomLoaded) return;
    try {
      if (event.forAll) {
        await ChatModule.messages.deleteForAll(event.messageId);
      } else {
        await ChatModule.messages.deleteForMe(event.messageId);
      }
      final updated = current.messages
          .where((m) => m.id != event.messageId)
          .toList();
      emit(current.copyWith(messages: updated));
    } catch (_) {}
  }

  Future<void> _onEdit(
    ChatRoomEditMessage event,
    Emitter<ChatRoomState> emit,
  ) async {
    final current = state;
    if (current is! ChatRoomLoaded) return;
    try {
      final edited =
          await ChatModule.messages.edit(event.messageId, event.content);
      final updated = current.messages
          .map((m) => m.id == event.messageId ? edited : m)
          .toList();
      emit(current.copyWith(messages: updated));
    } catch (_) {}
  }

  Future<void> _onReaction(
    ChatRoomAddReaction event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      await ChatModule.messages.addReaction(event.messageId, event.emoji);
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    await _msgSub?.cancel();
    return super.close();
  }
}
