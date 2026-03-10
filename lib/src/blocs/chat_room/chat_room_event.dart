import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../data/models/models.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();
  @override
  List<Object?> get props => [];
}

class ChatRoomLoadRequested extends ChatRoomEvent {
  const ChatRoomLoadRequested({required this.roomId, required this.userId});
  final int roomId;
  final int userId;
  @override
  List<Object?> get props => [roomId, userId];
}

class ChatRoomMessageReceived extends ChatRoomEvent {
  const ChatRoomMessageReceived(this.message);
  final ChatMessage message;
  @override
  List<Object?> get props => [message];
}

class ChatRoomSendMessage extends ChatRoomEvent {
  const ChatRoomSendMessage({
    required this.content,
    this.replyToMessageId,
    this.mediaFile,
    this.mediaFilename,
    this.mentionedUserIds,
  });
  final String content;
  final int? replyToMessageId;
  final File? mediaFile;
  final String? mediaFilename;
  final List<int>? mentionedUserIds;
  @override
  List<Object?> get props => [content, replyToMessageId, mentionedUserIds];
}

class ChatRoomLoadOlderMessages extends ChatRoomEvent {
  const ChatRoomLoadOlderMessages();
}

class ChatRoomDeleteMessage extends ChatRoomEvent {
  const ChatRoomDeleteMessage({required this.messageId, required this.forAll});
  final int messageId;
  final bool forAll;
  @override
  List<Object?> get props => [messageId, forAll];
}

class ChatRoomEditMessage extends ChatRoomEvent {
  const ChatRoomEditMessage({required this.messageId, required this.content});
  final int messageId;
  final String content;
  @override
  List<Object?> get props => [messageId, content];
}

class ChatRoomAddReaction extends ChatRoomEvent {
  const ChatRoomAddReaction({required this.messageId, required this.emoji});
  final int messageId;
  final String emoji;
  @override
  List<Object?> get props => [messageId, emoji];
}
