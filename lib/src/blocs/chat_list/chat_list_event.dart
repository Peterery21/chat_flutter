import 'package:equatable/equatable.dart';
import '../../data/models/models.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object?> get props => [];
}

class ChatListLoadRequested extends ChatListEvent {
  const ChatListLoadRequested(this.userId);
  final int userId;
  @override
  List<Object?> get props => [userId];
}

class ChatListRoomsUpdated extends ChatListEvent {
  const ChatListRoomsUpdated(this.rooms);
  final List<ChatRoom> rooms;
  @override
  List<Object?> get props => [rooms];
}

class ChatListRoomTypingUpdated extends ChatListEvent {
  const ChatListRoomTypingUpdated({
    required this.roomId,
    required this.username,
    required this.isTyping,
  });
  final int roomId;
  final String username;
  final bool isTyping;
  @override
  List<Object?> get props => [roomId, username, isTyping];
}

class ChatListMentionReceived extends ChatListEvent {
  const ChatListMentionReceived(this.message);
  final ChatMessage message;
  @override
  List<Object?> get props => [message];
}
