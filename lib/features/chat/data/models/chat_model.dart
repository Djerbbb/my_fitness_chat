class ChatModel {
  final String id;
  final String title;
  final String avatarUrl;
  final bool isGroup;
  final bool isTrainer;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ChatModel({
    required this.id,
    required this.title,
    required this.avatarUrl,
    required this.isGroup,
    required this.isTrainer,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  ChatModel copyWith({
    String? id,
    String? title,
    String? avatarUrl,
    bool? isGroup,
    bool? isTrainer,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return ChatModel(
      id: id ?? this.id,
      title: title ?? this.title,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isGroup: isGroup ?? this.isGroup,
      isTrainer: isTrainer ?? this.isTrainer,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}