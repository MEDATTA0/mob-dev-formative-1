import 'package:assignment1/models/entities/entity.dart';

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

enum PostType { event, opportunity }

enum RSVPStatus { going, interested, notGoing, waitlist }

enum NotificationType { system, rsvp, club, message }
