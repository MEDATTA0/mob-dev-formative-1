import 'package:assignment1/models/entities/posts.dart';

final List<Post> posts = [
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
];

final List<RSVP> rsvps = [
  RSVP(
    userId: 1,
    postId: 1,
    status: RSVPStatus.going,
  ),
  RSVP(
    userId: 2,
    postId: 1,
    status: RSVPStatus.interested,
  ),
];

final List<SavedPost> savedPosts = [
  SavedPost(
    userId: 1,
    postId: 2,
  ),
];

final List<AppNotification> notifications = [
  AppNotification(
    userId: 1,
    type: NotificationType.system,
    title: 'Welcome to Campus Connect!',
    body: 'Explore groups, events, and opportunities around your campus.',
  ),
  AppNotification(
    userId: 2,
    type: NotificationType.rsvp,
    title: 'New RSVP',
    body: 'Aline Umuhoza is going to your workshop.',
    relatedEntityId: 1,
  ),
];
