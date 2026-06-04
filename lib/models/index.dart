import 'package:assignment1/models/stores/clubs.dart';
import 'package:assignment1/models/stores/messages.dart';
import 'package:assignment1/models/stores/posts.dart';
import 'package:assignment1/models/stores/users.dart';
import 'package:hive/hive.dart';

export 'package:assignment1/models/entities/entity.dart';
export 'package:assignment1/models/entities/clubs.dart';
export 'package:assignment1/models/entities/users.dart';
export 'package:assignment1/models/entities/posts.dart';
export 'package:assignment1/models/entities/messages.dart';

export 'package:assignment1/models/stores/store.dart';
export 'package:assignment1/models/stores/clubs.dart';
export 'package:assignment1/models/stores/users.dart';
export 'package:assignment1/models/stores/posts.dart';
export 'package:assignment1/models/stores/messages.dart';

late ClubStore clubStore;
late ClubMembershipStore clubMembershipStore;

late UserStore userStore;
late UserConnectionStore userConnectionStore;

late PostStore postStore;
late RSVPStore rsvpStore;
late SavedPostStore savedPostStore;
late NotificationStore notificationStore;

late ChatStore chatStore;
late MessageStore messageStore;
late ChatParticipantStore chatParticipantStore;
late MessageReactionStore messageReactionStore;

Future<void> initializeStores() async {
  // Open Hive boxes
  await Hive.openBox<Map>('users');
  await Hive.openBox<Map>('user_connections');
  await Hive.openBox<Map>('clubs');
  await Hive.openBox<Map>('club_memberships');
  await Hive.openBox<Map>('posts');
  await Hive.openBox<Map>('rsvps');
  await Hive.openBox<Map>('saved_posts');
  await Hive.openBox<Map>('notifications');
  await Hive.openBox<Map>('chats');
  await Hive.openBox<Map>('messages');
  await Hive.openBox<Map>('chat_participants');
  await Hive.openBox<Map>('message_reactions');

  userStore = UserStore();
  await userStore.loadDummy();

  userConnectionStore = UserConnectionStore();
  await userConnectionStore.loadDummy();

  clubStore = ClubStore();
  await clubStore.loadDummy();

  clubMembershipStore = ClubMembershipStore();
  await clubMembershipStore.loadDummy();

  postStore = PostStore();
  await postStore.loadDummy();

  rsvpStore = RSVPStore();
  await rsvpStore.loadDummy();

  savedPostStore = SavedPostStore();
  await savedPostStore.loadDummy();

  notificationStore = NotificationStore();
  await notificationStore.loadDummy();

  chatStore = ChatStore();
  await chatStore.loadDummy();

  messageStore = MessageStore();
  await messageStore.loadDummy();

  chatParticipantStore = ChatParticipantStore();
  await chatParticipantStore.loadDummy();

  messageReactionStore = MessageReactionStore();
  await messageReactionStore.loadDummy();
}
