import 'package:assignment1/models/storage.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';

class ChatStore implements Store<Chat> {
  Box<Map> get _box => Hive.box<Map>('chats');

  @override
  Future<Chat> add(Chat data) async {
    final map = data.toMap();
    final id = await _box.add(map);
    data.id = id;
    await _box.put(id, data.toMap());
    return data;
  }

  @override
  Future<void> delete(int id) async {
    await _box.delete(id);

    // Cascade deletes:
    // 1. Delete all ChatParticipants where chatId matches this chat
    final partBox = Hive.box<Map>('chat_participants');
    final partIdsToDelete = partBox.keys.where((key) => partBox.get(key)?['chatId'] == id).toList();
    for (var pId in partIdsToDelete) {
      await partBox.delete(pId);
    }

    // 2. Delete all Messages in this chat (and their reactions)
    final msgBox = Hive.box<Map>('messages');
    final msgIdsToDelete = msgBox.keys.where((key) => msgBox.get(key)?['chatId'] == id).toList();
    final reactBox = Hive.box<Map>('message_reactions');
    for (var mId in msgIdsToDelete) {
      await msgBox.delete(mId);
      final reactIds = reactBox.keys.where((k) => reactBox.get(k)?['messageId'] == mId).toList();
      for (var rId in reactIds) {
        await reactBox.delete(rId);
      }
    }
  }

  @override
  Future<List<Chat>> findAll() async {
    final list = <Chat>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(Chat.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<Chat?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return Chat.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  @override
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;

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

class MessageStore implements Store<Message> {
  Box<Map> get _box => Hive.box<Map>('messages');

  @override
  Future<Message> add(Message data) async {
    final map = data.toMap();
    final id = await _box.add(map);
    data.id = id;
    await _box.put(id, data.toMap());
    return data;
  }

  @override
  Future<void> delete(int id) async {
    await _box.delete(id);

    // Cascade deletes:
    // Delete all MessageReactions for this message
    final reactBox = Hive.box<Map>('message_reactions');
    final reactIdsToDelete = reactBox.keys.where((key) => reactBox.get(key)?['messageId'] == id).toList();
    for (var rId in reactIdsToDelete) {
      await reactBox.delete(rId);
    }
  }

  @override
  Future<List<Message>> findAll() async {
    final list = <Message>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(Message.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<Message?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return Message.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<Message>> findByChatId(int chatId) async {
    final list = <Message>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['chatId'] == chatId) {
        list.add(Message.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    // Sort by timestamp ascending
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
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
  Box<Map> get _box => Hive.box<Map>('chat_participants');

  @override
  Future<ChatParticipant> add(ChatParticipant data) async {
    final existingKey = _box.keys.firstWhereOrNull((key) {
      final map = _box.get(key);
      return map != null &&
          map['chatId'] == data.chatId &&
          map['userId'] == data.userId;
    });

    if (existingKey == null) {
      final id = await _box.add(data.toMap());
      data.id = id;
      await _box.put(id, data.toMap());
    } else {
      data.id = existingKey as int;
    }
    return data;
  }

  @override
  Future<void> delete(int id) async {
    await _box.delete(id);
  }

  @override
  Future<List<ChatParticipant>> findAll() async {
    final list = <ChatParticipant>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(ChatParticipant.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<ChatParticipant?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return ChatParticipant.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<ChatParticipant>> findByChatId(int chatId) async {
    final list = <ChatParticipant>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['chatId'] == chatId) {
        list.add(ChatParticipant.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
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
  Box<Map> get _box => Hive.box<Map>('message_reactions');

  @override
  Future<MessageReaction> add(MessageReaction data) async {
    final existingKey = _box.keys.firstWhereOrNull((key) {
      final map = _box.get(key);
      return map != null &&
          map['messageId'] == data.messageId &&
          map['userId'] == data.userId &&
          map['reactionEmoji'] == data.reactionEmoji;
    });

    if (existingKey == null) {
      final id = await _box.add(data.toMap());
      data.id = id;
      await _box.put(id, data.toMap());
    } else {
      data.id = existingKey as int;
    }
    return data;
  }

  @override
  Future<void> delete(int id) async {
    await _box.delete(id);
  }

  @override
  Future<List<MessageReaction>> findAll() async {
    final list = <MessageReaction>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(MessageReaction.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<MessageReaction?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return MessageReaction.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<MessageReaction>> findByMessageId(int messageId) async {
    final list = <MessageReaction>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['messageId'] == messageId) {
        list.add(MessageReaction.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<void> loadDummy() async {}
}
