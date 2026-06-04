import 'package:assignment1/models/storage.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';

/// Represents an Event or Opportunity
class Post extends Entity {
  final int authorId;
  final PostType type;
  final String title;
  final String description;
  final String? coverImageUrl;
  final String campusId;
  final String category;
  final String location;
  final List<String> tags;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? deadline;
  final int? capacity;
  final bool isPublished;

  Post({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.authorId,
    required this.type,
    required this.title,
    required this.description,
    this.coverImageUrl,
    required this.campusId,
    required this.category,
    required this.location,
    this.tags = const [],
    this.startTime,
    this.endTime,
    this.deadline,
    this.capacity,
    this.isPublished = true,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'authorId': authorId,
      'type': type.name,
      'title': title,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'campusId': campusId,
      'category': category,
      'location': location,
      'tags': tags,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'capacity': capacity,
      'isPublished': isPublished,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      authorId: map['authorId'] as int,
      type: PostType.values.byName(map['type'] as String),
      title: map['title'] as String,
      description: map['description'] as String,
      coverImageUrl: map['coverImageUrl'] as String?,
      campusId: map['campusId'] as String,
      category: map['category'] as String,
      location: map['location'] as String,
      tags: List<String>.from(map['tags'] as List),
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime'] as String) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime'] as String) : null,
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline'] as String) : null,
      capacity: map['capacity'] as int?,
      isPublished: map['isPublished'] as bool? ?? true,
    );
  }
}

/// Represents a user's RSVP status for an event
class RSVP extends Entity {
  final int userId;
  final int postId;
  final RSVPStatus status;
  final DateTime respondedAt;

  RSVP({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.userId,
    required this.postId,
    required this.status,
    DateTime? respondedAt,
  }) : respondedAt = respondedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'userId': userId,
      'postId': postId,
      'status': status.name,
      'respondedAt': respondedAt.toIso8601String(),
    };
  }

  factory RSVP.fromMap(Map<String, dynamic> map) {
    return RSVP(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      userId: map['userId'] as int,
      postId: map['postId'] as int,
      status: RSVPStatus.values.byName(map['status'] as String),
      respondedAt: map['respondedAt'] != null ? DateTime.parse(map['respondedAt'] as String) : null,
    );
  }
}

class SavedPost extends Entity {
  final int userId;
  final int postId;
  final DateTime savedAt;

  SavedPost({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.userId,
    required this.postId,
    DateTime? savedAt,
  }) : savedAt = savedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'userId': userId,
      'postId': postId,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory SavedPost.fromMap(Map<String, dynamic> map) {
    return SavedPost(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      userId: map['userId'] as int,
      postId: map['postId'] as int,
      savedAt: map['savedAt'] != null ? DateTime.parse(map['savedAt'] as String) : null,
    );
  }
}

class AppNotification extends Entity {
  final int userId;
  final NotificationType type;
  final String title;
  final String body;
  final int? relatedEntityId;
  final bool isRead;

  AppNotification({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.relatedEntityId,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'userId': userId,
      'type': type.name,
      'title': title,
      'body': body,
      'relatedEntityId': relatedEntityId,
      'isRead': isRead,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      userId: map['userId'] as int,
      type: NotificationType.values.byName(map['type'] as String),
      title: map['title'] as String,
      body: map['body'] as String,
      relatedEntityId: map['relatedEntityId'] as int?,
      isRead: map['isRead'] as bool? ?? false,
    );
  }
}

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
    final rsvpIdsToDelete = rsvpBox.keys.where((key) => rsvpBox.get(key)?['postId'] == id).toList();
    for (var rId in rsvpIdsToDelete) {
      await rsvpBox.delete(rId);
    }

    // 2. SavedPosts for this post
    final savedBox = Hive.box<Map>('saved_posts');
    final savedIdsToDelete = savedBox.keys.where((key) => savedBox.get(key)?['postId'] == id).toList();
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

    await add(
      Post(
        authorId: 1,
        type: PostType.event,
        title: 'AI for Social Impact Workshop',
        description:
            'Learn how AI tools can drive social impact through hands-on projects.',
        campusId: 'MU',
        category: 'Workshop',
        location: 'Mauritius Campus Innovation Lab',
        tags: const ['AI', 'Social Impact'],
        startTime: DateTime(2026, 6, 5, 9, 0),
        endTime: DateTime(2026, 6, 5, 13, 0),
      ),
    );

    await add(
      Post(
        authorId: 2,
        type: PostType.opportunity,
        title: 'Sustainable Solutions Challenge',
        description: 'Pitch sustainability ideas and get mentorship support.',
        campusId: 'MU',
        category: 'Competition',
        location: 'Mauritius Campus',
        tags: const ['Climate', 'Innovation'],
        deadline: DateTime(2026, 5, 20, 23, 59),
      ),
    );
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
  Future<void> loadDummy() async {}
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
  Future<void> loadDummy() async {}
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
  Future<void> loadDummy() async {}
}

enum PostType { event, opportunity }

enum RSVPStatus { going, interested, notGoing, waitlist }

enum NotificationType { system, rsvp, club, message }
