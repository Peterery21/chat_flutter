import 'package:equatable/equatable.dart';
import '../../data/models/models.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();
  @override
  List<Object?> get props => [];
}

class ChatRoomInitial extends ChatRoomState {
  const ChatRoomInitial();
}

class ChatRoomLoading extends ChatRoomState {
  const ChatRoomLoading();
}

class ChatRoomLoaded extends ChatRoomState {
  const ChatRoomLoaded({
    required this.room,
    required this.messages,
    this.hasMore = true,
    this.sendingMessage = false,
  });
  final ChatRoom room;
  final List<ChatMessage> messages;
  final bool hasMore;
  final bool sendingMessage;

  ChatRoomLoaded copyWith({
    ChatRoom? room,
    List<ChatMessage>? messages,
    bool? hasMore,
    bool? sendingMessage,
  }) {
    return ChatRoomLoaded(
      room: room ?? this.room,
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      sendingMessage: sendingMessage ?? this.sendingMessage,
    );
  }

  @override
  List<Object?> get props => [room, messages, hasMore, sendingMessage];
}

class ChatRoomError extends ChatRoomState {
  const ChatRoomError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
