import 'package:assignment1/models/clubs.dart';
import 'package:assignment1/models/messages.dart';
import 'package:assignment1/models/posts.dart';
import 'package:assignment1/models/users.dart';

late ClubStore clubStore;
late ClubMembershipStore clubMembershipStore;

late UserStore userStore;

late PostStore postStore;
late RSVPStore rsvpStore;
late SavedPostStore savedPostStore;
late NotificationStore notificationStore;

late ChatStore chatStore;
late MessageStore messageStore;
late ChatParticipantStore chatParticipantStore;

void initializeStores() {
  userStore = UserStore();
  userStore.loadDummy();

  clubStore = ClubStore();
  clubStore.loadDummy();

  clubMembershipStore = ClubMembershipStore();
  clubMembershipStore.loadDummy();

  postStore = PostStore();
  postStore.loadDummy();

  rsvpStore = RSVPStore();
  rsvpStore.loadDummy();

  savedPostStore = SavedPostStore();
  savedPostStore.loadDummy();

  notificationStore = NotificationStore();
  notificationStore.loadDummy();

  chatStore = ChatStore();
  chatStore.loadDummy();

  messageStore = MessageStore();
  messageStore.loadDummy();

  chatParticipantStore = ChatParticipantStore();
  chatParticipantStore.loadDummy();
}
