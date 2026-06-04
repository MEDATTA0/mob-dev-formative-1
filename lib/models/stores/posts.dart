import 'package:assignment1/data/posts.dart';
import 'package:assignment1/models/entities/posts.dart';
import 'package:assignment1/models/stores/store.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';

class PostStore implements Store<Post> {
  Box<Map> get _box => Hive.box<Map>('posts');

  @override
  Future<Post> add(Post data) async {
    if (data.type == PostType.event &&
        data.startTime != null &&
        data.endTime != null &&
        data.endTime!.isBefore(data.startTime!)) {
      throw ArgumentError('Event endTime must be after startTime.');
    }

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
    // 1. RSVPs for this post
    final rsvpBox = Hive.box<Map>('rsvps');
    final rsvpIdsToDelete = rsvpBox.keys
        .where((key) => rsvpBox.get(key)?['postId'] == id)
        .toList();
    for (var rId in rsvpIdsToDelete) {
      await rsvpBox.delete(rId);
    }

    // 2. SavedPosts for this post
    final savedBox = Hive.box<Map>('saved_posts');
    final savedIdsToDelete = savedBox.keys
        .where((key) => savedBox.get(key)?['postId'] == id)
        .toList();
    for (var sId in savedIdsToDelete) {
      await savedBox.delete(sId);
    }
  }

  @override
  Future<List<Post>> findAll() async {
    final list = <Post>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(Post.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<Post?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return Post.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<Post>> findByType(PostType type) async {
    final list = <Post>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['type'] == type.name) {
        list.add(Post.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  Future<List<Post>> findByCampus(String campusId) async {
    final list = <Post>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['campusId'] == campusId) {
        list.add(Post.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;

    for (var p in posts) {
      await add(p);
    }
  }
}

class RSVPStore implements Store<RSVP> {
  Box<Map> get _box => Hive.box<Map>('rsvps');

  @override
  Future<RSVP> add(RSVP data) async {
    final existingKey = _box.keys.firstWhereOrNull((key) {
      final map = _box.get(key);
      return map != null &&
          map['userId'] == data.userId &&
          map['postId'] == data.postId;
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
  Future<List<RSVP>> findAll() async {
    final list = <RSVP>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(RSVP.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<RSVP?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return RSVP.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<RSVP>> findByUserId(int userId) async {
    final list = <RSVP>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['userId'] == userId) {
        list.add(RSVP.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  Future<List<RSVP>> findByPostId(int postId) async {
    final list = <RSVP>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['postId'] == postId) {
        list.add(RSVP.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;
    for (var r in rsvps) {
      await add(r);
    }
  }
}

class SavedPostStore implements Store<SavedPost> {
  Box<Map> get _box => Hive.box<Map>('saved_posts');

  @override
  Future<SavedPost> add(SavedPost data) async {
    final existingKey = _box.keys.firstWhereOrNull((key) {
      final map = _box.get(key);
      return map != null &&
          map['userId'] == data.userId &&
          map['postId'] == data.postId;
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
  Future<List<SavedPost>> findAll() async {
    final list = <SavedPost>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(SavedPost.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<SavedPost?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return SavedPost.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<SavedPost>> findByUserId(int userId) async {
    final list = <SavedPost>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['userId'] == userId) {
        list.add(SavedPost.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;
    for (var sp in savedPosts) {
      await add(sp);
    }
  }
}

class NotificationStore implements Store<AppNotification> {
  Box<Map> get _box => Hive.box<Map>('notifications');

  @override
  Future<AppNotification> add(AppNotification data) async {
    final map = data.toMap();
    final id = await _box.add(map);
    data.id = id;
    await _box.put(id, data.toMap());
    return data;
  }

  @override
  Future<void> delete(int id) async {
    await _box.delete(id);
  }

  @override
  Future<List<AppNotification>> findAll() async {
    final list = <AppNotification>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(AppNotification.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<AppNotification?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return AppNotification.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<AppNotification>> findByUserId(int userId) async {
    final list = <AppNotification>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['userId'] == userId) {
        list.add(AppNotification.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;
    for (var n in notifications) {
      await add(n);
    }
  }
}
