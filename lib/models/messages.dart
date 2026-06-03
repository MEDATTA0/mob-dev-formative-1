import 'package:assignment1/models/storage.dart';
import 'package:collection/collection.dart';

class ChatStore implements Store<Chat> {
  final List<Chat> _store = [];

  @override
  Chat add(Chat data) {
    _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((e) => e.getId() == id);

  @override
  List<Chat> findAll() => _store;

  @override
  Chat? findById(int id) => _store.firstWhereOrNull((e) => e.getId() == id);

  @override
  void loadDummy() {
    if (_store.isNotEmpty) return;

    add(
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
    required this.name,
    required this.isGroupChat,
    required this.createdByUserId,
    this.participantIds = const [],
    this.lastMessagePreview,
    this.lastActivityAt,
    this.unreadCount = 0,
  }) : super();
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
    required this.chatId,
    required this.senderId,
    required this.contentText,
    this.type = MessageType.text,
    this.isRead = false,
    this.attachmentUrl,
    required this.timestamp,
  }) : super();
}

class MessageStore implements Store<Message> {
  final List<Message> _store = [];

  @override
  Message add(Message data) {
    _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((e) => e.getId() == id);

  @override
  List<Message> findAll() => _store;

  @override
  Message? findById(int id) => _store.firstWhereOrNull((e) => e.getId() == id);

  List<Message> findByChatId(int chatId) => _store
      .where((e) => e.chatId == chatId)
      .toList()
      .sortedBy((e) => e.timestamp);

  @override
  void loadDummy() {}
}

class ChatParticipant extends Entity {
  final int chatId;
  final int userId;
  final ChatParticipantRole role;
  final DateTime joinedAt;
  final DateTime? lastReadAt;

  ChatParticipant({
    required this.chatId,
    required this.userId,
    this.role = ChatParticipantRole.member,
    DateTime? joinedAt,
    this.lastReadAt,
  }) : joinedAt = joinedAt ?? DateTime.now(),
       super();
}

class ChatParticipantStore implements Store<ChatParticipant> {
  final List<ChatParticipant> _store = [];

  @override
  ChatParticipant add(ChatParticipant data) {
    var exists = _store.any(
      (e) => e.chatId == data.chatId && e.userId == data.userId,
    );
    if (!exists) _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((e) => e.getId() == id);

  @override
  List<ChatParticipant> findAll() => _store;

  @override
  ChatParticipant? findById(int id) =>
      _store.firstWhereOrNull((e) => e.getId() == id);

  List<ChatParticipant> findByChatId(int chatId) =>
      _store.where((e) => e.chatId == chatId).toList();

  @override
  void loadDummy() {}
}

enum MessageType { text, image, file, link }

enum ChatParticipantRole { member, admin }
