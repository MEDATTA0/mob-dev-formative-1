import 'package:assignment1/data/messages.dart';
import 'package:assignment1/models/entities/messages.dart';
import 'package:assignment1/models/stores/store.dart';
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
    final partIdsToDelete = partBox.keys
        .where((key) => partBox.get(key)?['chatId'] == id)
        .toList();
    for (var pId in partIdsToDelete) {
      await partBox.delete(pId);
    }

    // 2. Delete all Messages in this chat (and their reactions)
    final msgBox = Hive.box<Map>('messages');
    final msgIdsToDelete = msgBox.keys
        .where((key) => msgBox.get(key)?['chatId'] == id)
        .toList();
    final reactBox = Hive.box<Map>('message_reactions');
    for (var mId in msgIdsToDelete) {
      await msgBox.delete(mId);
      final reactIds = reactBox.keys
          .where((k) => reactBox.get(k)?['messageId'] == mId)
          .toList();
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
    for (var c in chats) {
      await add(c);
    }
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
    final reactIdsToDelete = reactBox.keys
        .where((key) => reactBox.get(key)?['messageId'] == id)
        .toList();
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

  Future<Map<int, Message>> getLastMessageOfEachChat() async {
    final map = <int, Message>{};
    for (var key in _box.keys) {
      final data = _box.get(key);
      if (data != null) {
        final msg = Message.fromMap(Map<String, dynamic>.from(data));
        final existing = map[msg.chatId];
        if (existing == null || msg.timestamp.isAfter(existing.timestamp)) {
          map[msg.chatId] = msg;
        }
      }
    }
    return map;
  }

  @override
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;
    for (var m in messages) {
      await add(m);
    }
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
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;
    for (var cp in chatParticipants) {
      await add(cp);
    }
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
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;
    for (var mr in messageReactions) {
      await add(mr);
    }
  }
}
