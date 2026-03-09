import 'package:equatable/equatable.dart';
import '../../data/models/models.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();
  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {
  const ChatListInitial();
}

class ChatListLoading extends ChatListState {
  const ChatListLoading();
}

class ChatListLoaded extends ChatListState {
  const ChatListLoaded({
    required this.rooms,
    this.typingByRoom = const {},
  });
  final List<ChatRoom> rooms;
  final Map<int, String> typingByRoom;

  ChatListLoaded copyWith({
    List<ChatRoom>? rooms,
    Map<int, String>? typingByRoom,
  }) {
    return ChatListLoaded(
      rooms: rooms ?? this.rooms,
      typingByRoom: typingByRoom ?? this.typingByRoom,
    );
  }

  @override
  List<Object?> get props => [rooms, typingByRoom];
}

class ChatListError extends ChatListState {
  const ChatListError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
