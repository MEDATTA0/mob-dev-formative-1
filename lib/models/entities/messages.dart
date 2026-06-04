import 'package:assignment1/models/entities/entity.dart';

/// Represents a chat group or conversation
class Chat extends Entity {
  final String name;
  final bool isGroupChat;
  final int createdByUserId;
  final List<int> participantIds;
  final String? lastMessagePreview;
  final DateTime? lastActivityAt;
  final int unreadCount;

  Chat({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.name,
    required this.isGroupChat,
    required this.createdByUserId,
    this.participantIds = const [],
    this.lastMessagePreview,
    this.lastActivityAt,
    this.unreadCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'name': name,
      'isGroupChat': isGroupChat,
      'createdByUserId': createdByUserId,
      'participantIds': participantIds,
      'lastMessagePreview': lastMessagePreview,
      'lastActivityAt': lastActivityAt?.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      name: map['name'] as String,
      isGroupChat: map['isGroupChat'] as bool? ?? false,
      createdByUserId: map['createdByUserId'] as int,
      participantIds: List<int>.from(map['participantIds'] as List),
      lastMessagePreview: map['lastMessagePreview'] as String?,
      lastActivityAt: map['lastActivityAt'] != null ? DateTime.parse(map['lastActivityAt'] as String) : null,
      unreadCount: map['unreadCount'] as int? ?? 0,
    );
  }
}

/// Represents a message within a chat
class Message extends Entity {
  final int chatId;
  final int senderId;
  final String contentText;
  final MessageType type;
  final bool isRead;
  final String? attachmentUrl;
  final DateTime timestamp;

  Message({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.chatId,
    required this.senderId,
    required this.contentText,
    this.type = MessageType.text,
    this.isRead = false,
    this.attachmentUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'chatId': chatId,
      'senderId': senderId,
      'contentText': contentText,
      'type': type.name,
      'isRead': isRead,
      'attachmentUrl': attachmentUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      chatId: map['chatId'] as int,
      senderId: map['senderId'] as int,
      contentText: map['contentText'] as String,
      type: MessageType.values.byName(map['type'] as String),
      isRead: map['isRead'] as bool? ?? false,
      attachmentUrl: map['attachmentUrl'] as String?,
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp'] as String) : DateTime.now(),
    );
  }
}

class ChatParticipant extends Entity {
  final int chatId;
  final int userId;
  final ChatParticipantRole role;
  final DateTime joinedAt;
  final DateTime? lastReadAt;

  ChatParticipant({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.chatId,
    required this.userId,
    this.role = ChatParticipantRole.member,
    DateTime? joinedAt,
    this.lastReadAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'chatId': chatId,
      'userId': userId,
      'role': role.name,
      'joinedAt': joinedAt.toIso8601String(),
      'lastReadAt': lastReadAt?.toIso8601String(),
    };
  }

  factory ChatParticipant.fromMap(Map<String, dynamic> map) {
    return ChatParticipant(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      chatId: map['chatId'] as int,
      userId: map['userId'] as int,
      role: ChatParticipantRole.values.byName(map['role'] as String),
      joinedAt: map['joinedAt'] != null ? DateTime.parse(map['joinedAt'] as String) : DateTime.now(),
      lastReadAt: map['lastReadAt'] != null ? DateTime.parse(map['lastReadAt'] as String) : null,
    );
  }
}

enum MessageType { text, image, file, link }

enum ChatParticipantRole { member, admin }

class MessageReaction extends Entity {
  final int messageId;
  final int userId;
  final String reactionEmoji;

  MessageReaction({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.messageId,
    required this.userId,
    required this.reactionEmoji,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'messageId': messageId,
      'userId': userId,
      'reactionEmoji': reactionEmoji,
    };
  }

  factory MessageReaction.fromMap(Map<String, dynamic> map) {
    return MessageReaction(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      messageId: map['messageId'] as int,
      userId: map['userId'] as int,
      reactionEmoji: map['reactionEmoji'] as String,
    );
  }
}
