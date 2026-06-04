import 'package:assignment1/models/clubs.dart';
import 'package:assignment1/models/messages.dart';
import 'package:assignment1/models/posts.dart';
import 'package:assignment1/models/users.dart';

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

