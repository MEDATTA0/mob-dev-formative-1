import 'dart:convert';
import 'package:assignment1/models/storage.dart';
import 'package:assignment1/models/database_helper.dart';
import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

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
      'tags': jsonEncode(tags),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'capacity': capacity,
      'isPublished': isPublished ? 1 : 0,
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
      tags: List<String>.from(jsonDecode(map['tags'] as String) as List),
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime'] as String) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime'] as String) : null,
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline'] as String) : null,
      capacity: map['capacity'] as int?,
      isPublished: (map['isPublished'] as int) == 1,
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
      'isRead': isRead ? 1 : 0,
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
      isRead: (map['isRead'] as int) == 1,
    );
  }
}

class PostStore implements Store<Post> {
  @override
  Future<Post> add(Post data) async {
    if (data.type == PostType.event &&
        data.startTime != null &&
        data.endTime != null &&
        data.endTime!.isBefore(data.startTime!)) {
      throw ArgumentError('Event endTime must be after startTime.');
    }

    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('posts', data.toMap());
    data.id = id;
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Post>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('posts');
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  @override
  Future<Post?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('posts', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Post.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Post>> findByType(PostType type) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('posts', where: 'type = ?', whereArgs: [type.name]);
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  Future<List<Post>> findByCampus(String campusId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('posts', where: 'campusId = ?', whereArgs: [campusId]);
    return maps.map((map) => Post.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {
    final db = await DatabaseHelper.instance.database;
    final countMaps = await db.rawQuery('SELECT COUNT(*) as count FROM posts');
    final count = Sqflite.firstIntValue(countMaps) ?? 0;
    if (count > 0) return;

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
  @override
  Future<RSVP> add(RSVP data) async {
    final db = await DatabaseHelper.instance.database;
    var existsMaps = await db.query(
      'rsvps',
      where: 'userId = ? AND postId = ?',
      whereArgs: [data.userId, data.postId],
    );
    if (existsMaps.isEmpty) {
      final id = await db.insert('rsvps', data.toMap());
      data.id = id;
    } else {
      data.id = existsMaps.first['id'] as int?;
    }
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('rsvps', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<RSVP>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('rsvps');
    return maps.map((map) => RSVP.fromMap(map)).toList();
  }

  @override
  Future<RSVP?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('rsvps', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return RSVP.fromMap(maps.first);
    }
    return null;
  }

  Future<List<RSVP>> findByUserId(int userId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('rsvps', where: 'userId = ?', whereArgs: [userId]);
    return maps.map((map) => RSVP.fromMap(map)).toList();
  }

  Future<List<RSVP>> findByPostId(int postId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('rsvps', where: 'postId = ?', whereArgs: [postId]);
    return maps.map((map) => RSVP.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {}
}

class SavedPostStore implements Store<SavedPost> {
  @override
  Future<SavedPost> add(SavedPost data) async {
    final db = await DatabaseHelper.instance.database;
    var existsMaps = await db.query(
      'saved_posts',
      where: 'userId = ? AND postId = ?',
      whereArgs: [data.userId, data.postId],
    );
    if (existsMaps.isEmpty) {
      final id = await db.insert('saved_posts', data.toMap());
      data.id = id;
    } else {
      data.id = existsMaps.first['id'] as int?;
    }
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('saved_posts', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<SavedPost>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('saved_posts');
    return maps.map((map) => SavedPost.fromMap(map)).toList();
  }

  @override
  Future<SavedPost?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('saved_posts', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return SavedPost.fromMap(maps.first);
    }
    return null;
  }

  Future<List<SavedPost>> findByUserId(int userId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('saved_posts', where: 'userId = ?', whereArgs: [userId]);
    return maps.map((map) => SavedPost.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {}
}

class NotificationStore implements Store<AppNotification> {
  @override
  Future<AppNotification> add(AppNotification data) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('notifications', data.toMap());
    data.id = id;
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<AppNotification>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('notifications');
    return maps.map((map) => AppNotification.fromMap(map)).toList();
  }

  @override
  Future<AppNotification?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('notifications', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return AppNotification.fromMap(maps.first);
    }
    return null;
  }

  Future<List<AppNotification>> findByUserId(int userId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('notifications', where: 'userId = ?', whereArgs: [userId]);
    return maps.map((map) => AppNotification.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {}
}

enum PostType { event, opportunity }

enum RSVPStatus { going, interested, notGoing, waitlist }

enum NotificationType { system, rsvp, club, message }
