import 'package:assignment1/data/users.dart';
import 'package:assignment1/models/entities/users.dart';
import 'package:assignment1/models/stores/store.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';

class UserStore implements Store<User> {
  Box<Map> get _box => Hive.box<Map>('users');

  @override
  Future<User> add(User data) async {
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
    // 1. User Connections where user is requester or receiver
    final connBox = Hive.box<Map>('user_connections');
    final connIdsToDelete = connBox.keys.where((key) {
      final connMap = connBox.get(key);
      return connMap != null &&
          (connMap['requesterId'] == id || connMap['receiverId'] == id);
    }).toList();
    for (var connId in connIdsToDelete) {
      await connBox.delete(connId);
    }

    // 2. Posts where user is author
    final postBox = Hive.box<Map>('posts');
    final postIdsToDelete = postBox.keys.where((key) {
      final postMap = postBox.get(key);
      return postMap != null && postMap['authorId'] == id;
    }).toList();
    for (var postId in postIdsToDelete) {
      await postBox.delete(postId);
      // Clean up RSVPs for this post
      final rsvpBox = Hive.box<Map>('rsvps');
      final rsvpsToDelete = rsvpBox.keys
          .where((k) => rsvpBox.get(k)?['postId'] == postId)
          .toList();
      for (var rid in rsvpsToDelete) {
        await rsvpBox.delete(rid);
      }
      // Clean up SavedPosts for this post
      final savedPostBox = Hive.box<Map>('saved_posts');
      final savedToDelete = savedPostBox.keys
          .where((k) => savedPostBox.get(k)?['postId'] == postId)
          .toList();
      for (var sid in savedToDelete) {
        await savedPostBox.delete(sid);
      }
    }

    // 3. RSVPs where user is RSVP-ing
    final rsvpBox = Hive.box<Map>('rsvps');
    final rsvpIdsToDelete = rsvpBox.keys
        .where((key) => rsvpBox.get(key)?['userId'] == id)
        .toList();
    for (var rId in rsvpIdsToDelete) {
      await rsvpBox.delete(rId);
    }

    // 4. SavedPosts where user saved a post
    final savedPostBox = Hive.box<Map>('saved_posts');
    final savedIdsToDelete = savedPostBox.keys
        .where((key) => savedPostBox.get(key)?['userId'] == id)
        .toList();
    for (var sId in savedIdsToDelete) {
      await savedPostBox.delete(sId);
    }

    // 5. AppNotifications for this user
    final notificationBox = Hive.box<Map>('notifications');
    final notifIdsToDelete = notificationBox.keys
        .where((key) => notificationBox.get(key)?['userId'] == id)
        .toList();
    for (var nId in notifIdsToDelete) {
      await notificationBox.delete(nId);
    }

    // 6. Chats created by this user
    final chatBox = Hive.box<Map>('chats');
    final chatIdsToDelete = chatBox.keys
        .where((key) => chatBox.get(key)?['createdByUserId'] == id)
        .toList();
    for (var chatId in chatIdsToDelete) {
      await chatBox.delete(chatId);
      // Clean up Messages for this chat
      final msgBox = Hive.box<Map>('messages');
      final msgIdsToDelete = msgBox.keys
          .where((k) => msgBox.get(k)?['chatId'] == chatId)
          .toList();
      for (var mid in msgIdsToDelete) {
        await msgBox.delete(mid);
        // Clean up message reactions
        final reactBox = Hive.box<Map>('message_reactions');
        final reactIds = reactBox.keys
            .where((rk) => reactBox.get(rk)?['messageId'] == mid)
            .toList();
        for (var rid in reactIds) {
          await reactBox.delete(rid);
        }
      }
      // Clean up ChatParticipants for this chat
      final partBox = Hive.box<Map>('chat_participants');
      final partIds = partBox.keys
          .where((k) => partBox.get(k)?['chatId'] == chatId)
          .toList();
      for (var pid in partIds) {
        await partBox.delete(pid);
      }
    }

    // 7. ChatParticipants where user is participant
    final partBox = Hive.box<Map>('chat_participants');
    final partIdsToDelete = partBox.keys
        .where((key) => partBox.get(key)?['userId'] == id)
        .toList();
    for (var pId in partIdsToDelete) {
      await partBox.delete(pId);
    }

    // 8. MessageReactions where user reacted
    final reactBox = Hive.box<Map>('message_reactions');
    final reactIdsToDelete = reactBox.keys
        .where((key) => reactBox.get(key)?['userId'] == id)
        .toList();
    for (var rId in reactIdsToDelete) {
      await reactBox.delete(rId);
    }

    // 9. Messages sent by this user
    final msgBox = Hive.box<Map>('messages');
    final msgIdsToDelete = msgBox.keys
        .where((key) => msgBox.get(key)?['senderId'] == id)
        .toList();
    for (var mId in msgIdsToDelete) {
      await msgBox.delete(mId);
      final reactBox = Hive.box<Map>('message_reactions');
      final reactIds = reactBox.keys
          .where((key) => reactBox.get(key)?['messageId'] == mId)
          .toList();
      for (var rId in reactIds) {
        await reactBox.delete(rId);
      }
    }

    // 10. Club memberships where user is member
    final membershipBox = Hive.box<Map>('club_memberships');
    final membershipIdsToDelete = membershipBox.keys
        .where((key) => membershipBox.get(key)?['userId'] == id)
        .toList();
    for (var mId in membershipIdsToDelete) {
      await membershipBox.delete(mId);
    }
  }

  @override
  Future<List<User>> findAll() async {
    final list = <User>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(User.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<User?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return User.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<User?> findByCampusId(String campusId) async {
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['campusId'] == campusId) {
        return User.fromMap(Map<String, dynamic>.from(map));
      }
    }
    return null;
  }

  @override
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;
    for (var u in users) {
      await add(u);
    }
  }
}

class UserConnectionStore implements Store<UserConnection> {
  Box<Map> get _box => Hive.box<Map>('user_connections');

  @override
  Future<UserConnection> add(UserConnection data) async {
    final existingKey = _box.keys.firstWhereOrNull((key) {
      final map = _box.get(key);
      return map != null &&
          map['requesterId'] == data.requesterId &&
          map['receiverId'] == data.receiverId;
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
  Future<List<UserConnection>> findAll() async {
    final list = <UserConnection>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(UserConnection.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<UserConnection?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return UserConnection.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<UserConnection>> findByUserId(int userId) async {
    final list = <UserConnection>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null &&
          (map['requesterId'] == userId || map['receiverId'] == userId)) {
        list.add(UserConnection.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;

    for (var conn in userConnections) {
      await add(conn);
    }
  }
}
