import 'package:assignment1/models/storage.dart';
import 'package:collection/collection.dart';

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
  }) : super();
}

/// Represents a user's RSVP status for an event
class RSVP extends Entity {
  final int userId;
  final int postId;
  final RSVPStatus status;
  final DateTime respondedAt;

  RSVP({
    required this.userId,
    required this.postId,
    required this.status,
    DateTime? respondedAt,
  }) : respondedAt = respondedAt ?? DateTime.now(),
       super();
}

class SavedPost extends Entity {
  final int userId;
  final int postId;
  final DateTime savedAt;

  SavedPost({required this.userId, required this.postId, DateTime? savedAt})
    : savedAt = savedAt ?? DateTime.now(),
      super();
}

class AppNotification extends Entity {
  final int userId;
  final NotificationType type;
  final String title;
  final String body;
  final int? relatedEntityId;
  final bool isRead;

  AppNotification({
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.relatedEntityId,
    this.isRead = false,
  }) : super();
}

class PostStore implements Store<Post> {
  final List<Post> _store = [];

  @override
  void loadDummy() {
    if (_store.isNotEmpty) return;

    add(
      Post(
        authorId: 1,
        type: PostType.event,
        title: 'AI for Social Impact Workshop',
        description:
            'Learn how AI tools can drive social impact through hands-on projects.',
        campusId: 'MU',
        category: 'Workshop',
        location: 'Mauritius Campus Innovation Lab',
        tags: ['AI', 'Social Impact'],
        startTime: DateTime(2026, 6, 5, 9, 0),
        endTime: DateTime(2026, 6, 5, 13, 0),
      ),
    );

    add(
      Post(
        authorId: 2,
        type: PostType.opportunity,
        title: 'Sustainable Solutions Challenge',
        description: 'Pitch sustainability ideas and get mentorship support.',
        campusId: 'MU',
        category: 'Competition',
        location: 'Mauritius Campus',
        tags: ['Climate', 'Innovation'],
        deadline: DateTime(2026, 5, 20, 23, 59),
      ),
    );
  }

  @override
  Post add(Post data) {
    if (data.type == PostType.event &&
        data.startTime != null &&
        data.endTime != null &&
        data.endTime!.isBefore(data.startTime!)) {
      throw ArgumentError('Event endTime must be after startTime.');
    }

    _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((e) => e.getId() == id);

  @override
  List<Post> findAll() => _store;

  @override
  Post? findById(int id) => _store.firstWhereOrNull((c) => c.getId() == id);

  List<Post> findByType(PostType type) {
    return _store.where((p) => p.type == type).toList();
  }

  List<Post> findByCampus(String campusId) {
    return _store.where((p) => p.campusId == campusId).toList();
  }
}

class RSVPStore implements Store<RSVP> {
  final List<RSVP> _store = [];

  @override
  RSVP add(RSVP data) {
    var exists = _store.any(
      (e) => e.userId == data.userId && e.postId == data.postId,
    );
    if (!exists) _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((e) => e.getId() == id);

  @override
  List<RSVP> findAll() => _store;

  @override
  RSVP? findById(int id) => _store.firstWhereOrNull((e) => e.getId() == id);

  List<RSVP> findByUserId(int userId) =>
      _store.where((e) => e.userId == userId).toList();

  List<RSVP> findByPostId(int postId) =>
      _store.where((e) => e.postId == postId).toList();

  @override
  void loadDummy() {}
}

class SavedPostStore implements Store<SavedPost> {
  final List<SavedPost> _store = [];

  @override
  SavedPost add(SavedPost data) {
    var exists = _store.any(
      (e) => e.userId == data.userId && e.postId == data.postId,
    );
    if (!exists) _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((e) => e.getId() == id);

  @override
  List<SavedPost> findAll() => _store;

  @override
  SavedPost? findById(int id) =>
      _store.firstWhereOrNull((e) => e.getId() == id);

  List<SavedPost> findByUserId(int userId) {
    return _store.where((e) => e.userId == userId).toList();
  }

  @override
  void loadDummy() {}
}

class NotificationStore implements Store<AppNotification> {
  final List<AppNotification> _store = [];

  @override
  AppNotification add(AppNotification data) {
    _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((e) => e.getId() == id);

  @override
  List<AppNotification> findAll() => _store;

  @override
  AppNotification? findById(int id) {
    return _store.firstWhereOrNull((e) => e.getId() == id);
  }

  List<AppNotification> findByUserId(int userId) {
    return _store.where((e) => e.userId == userId).toList();
  }

  @override
  void loadDummy() {}
}

enum PostType { event, opportunity }

enum RSVPStatus { going, interested, notGoing, waitlist }

enum NotificationType { system, rsvp, club, message }
