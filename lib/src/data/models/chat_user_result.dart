/// Result from user search endpoint `GET /chats/user/search?q=`
class ChatUserResult {
  const ChatUserResult({
    required this.id,
    required this.userId,
    required this.name,
    this.photo,
  });

  /// Internal chat user id (used for room creation / mention mapping).
  final int id;

  /// Application user id.
  final int userId;

  final String name;
  final String? photo;

  factory ChatUserResult.fromJson(Map<String, dynamic> json) {
    return ChatUserResult(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      photo: json['photo'] as String?,
    );
  }
}
