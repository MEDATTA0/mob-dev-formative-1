import 'dart:convert';
import 'package:assignment1/models/storage.dart';
import 'package:assignment1/models/database_helper.dart';
import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

class ChatStore implements Store<Chat> {
  @override
  Future<Chat> add(Chat data) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('chats', data.toMap());
    data.id = id;
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('chats', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Chat>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('chats');
    return maps.map((map) => Chat.fromMap(map)).toList();
  }

  @override
  Future<Chat?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('chats', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Chat.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> loadDummy() async {
    final db = await DatabaseHelper.instance.database;
    final countMaps = await db.rawQuery('SELECT COUNT(*) as count FROM chats');
    final count = Sqflite.firstIntValue(countMaps) ?? 0;
    if (count > 0) return;

    await add(
      Chat(
        name: 'AI Workshop Group',
        isGroupChat: true,
        createdByUserId: 1,
        participantIds: const [1, 2],
        lastMessagePreview: 'Can\'t wait',
        unreadCount: 1,
      ),
    );
  }
}

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
      'isGroupChat': isGroupChat ? 1 : 0,
      'createdByUserId': createdByUserId,
      'participantIds': jsonEncode(participantIds),
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
      isGroupChat: (map['isGroupChat'] as int) == 1,
      createdByUserId: map['createdByUserId'] as int,
      participantIds: List<int>.from(jsonDecode(map['participantIds'] as String) as List),
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
      'isRead': isRead ? 1 : 0,
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
      isRead: (map['isRead'] as int) == 1,
      attachmentUrl: map['attachmentUrl'] as String?,
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp'] as String) : DateTime.now(),
    );
  }
}

class MessageStore implements Store<Message> {
  @override
  Future<Message> add(Message data) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('messages', data.toMap());
    data.id = id;
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Message>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('messages');
    return maps.map((map) => Message.fromMap(map)).toList();
  }

  @override
  Future<Message?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('messages', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Message.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Message>> findByChatId(int chatId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('messages', where: 'chatId = ?', orderBy: 'timestamp ASC');
    return maps.map((map) => Message.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {}
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

class ChatParticipantStore implements Store<ChatParticipant> {
  @override
  Future<ChatParticipant> add(ChatParticipant data) async {
    final db = await DatabaseHelper.instance.database;
    var existsMaps = await db.query(
      'chat_participants',
      where: 'chatId = ? AND userId = ?',
      whereArgs: [data.chatId, data.userId],
    );
    if (existsMaps.isEmpty) {
      final id = await db.insert('chat_participants', data.toMap());
      data.id = id;
    } else {
      data.id = existsMaps.first['id'] as int?;
    }
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('chat_participants', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<ChatParticipant>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('chat_participants');
    return maps.map((map) => ChatParticipant.fromMap(map)).toList();
  }

  @override
  Future<ChatParticipant?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('chat_participants', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ChatParticipant.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ChatParticipant>> findByChatId(int chatId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('chat_participants', where: 'chatId = ?', whereArgs: [chatId]);
    return maps.map((map) => ChatParticipant.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {}
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

class MessageReactionStore implements Store<MessageReaction> {
  @override
  Future<MessageReaction> add(MessageReaction data) async {
    final db = await DatabaseHelper.instance.database;
    var existsMaps = await db.query(
      'message_reactions',
      where: 'messageId = ? AND userId = ? AND reactionEmoji = ?',
      whereArgs: [data.messageId, data.userId, data.reactionEmoji],
    );
    if (existsMaps.isEmpty) {
      final id = await db.insert('message_reactions', data.toMap());
      data.id = id;
    } else {
      data.id = existsMaps.first['id'] as int?;
    }
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('message_reactions', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<MessageReaction>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('message_reactions');
    return maps.map((map) => MessageReaction.fromMap(map)).toList();
  }

  @override
  Future<MessageReaction?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('message_reactions', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return MessageReaction.fromMap(maps.first);
    }
    return null;
  }

  Future<List<MessageReaction>> findByMessageId(int messageId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('message_reactions', where: 'messageId = ?', whereArgs: [messageId]);
    return maps.map((map) => MessageReaction.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {}
}
