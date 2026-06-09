import 'dart:io';
import 'package:assignment1/models/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    // Create a temporary directory for Hive storage during tests
    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);
    await initializeStores();
  });

  tearDown(() async {
    // Close all boxes and clean up files
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('Hive stores load dummy data on empty db', () async {
    // Verify Users
    final users = await userStore.findAll();
    expect(users.length, equals(2));
    expect(users[0].fullName, equals('Aline Umuhoza'));
    expect(users[1].fullName, equals('David N'));

    // Verify User Connection
    final connections = await userConnectionStore.findAll();
    expect(connections.length, equals(1));
    expect(connections[0].requesterId, equals(1));
    expect(connections[0].receiverId, equals(2));

    // Verify Clubs
    final clubs = await clubStore.findAll();
    expect(clubs.length, equals(2));
    expect(clubs[0].name, equals('Entrepreneurship Club'));
    expect(clubs[1].name, equals('Women in Leadership'));

    // Verify Posts
    final posts = await postStore.findAll();
    expect(posts.length, equals(11));
    expect(posts[0].title, equals('AI for Social Impact Workshop'));
    expect(posts[1].title, equals('Sustainable Solutions Challenge'));

    // Verify Chats
    final chats = await chatStore.findAll();
    expect(chats.length, equals(1));
    expect(chats[0].name, equals('AI Workshop Group'));

    // Verify Club Memberships
    final clubMembershipsList = await clubMembershipStore.findAll();
    expect(clubMembershipsList.length, equals(3));

    // Verify RSVPs
    final rsvpsList = await rsvpStore.findAll();
    expect(rsvpsList.length, equals(5));

    // Verify Saved Posts
    final savedPostsList = await savedPostStore.findAll();
    expect(savedPostsList.length, equals(1));

    // Verify Notifications
    final notificationsList = await notificationStore.findAll();
    expect(notificationsList.length, equals(2));

    // Verify Messages
    final messagesList = await messageStore.findAll();
    expect(messagesList.length, equals(2));

    // Verify Chat Participants
    final chatParticipantsList = await chatParticipantStore.findAll();
    expect(chatParticipantsList.length, equals(2));

    // Verify Message Reactions
    final reactionsList = await messageReactionStore.findAll();
    expect(reactionsList.length, equals(1));
  });

  test('User addition and CRUD works', () async {
    final newUser = await userStore.add(
      User(
        fullName: 'Jane Doe',
        email: 'jane@alu.edu',
        campusId: 'ALU-RW-9999',
        password: 'password',
      ),
    );

    expect(newUser.id, isNotNull);

    final fetched = await userStore.findById(newUser.id!);
    expect(fetched, isNotNull);
    expect(fetched!.fullName, equals('Jane Doe'));

    await userStore.delete(newUser.id!);
    final deleted = await userStore.findById(newUser.id!);
    expect(deleted, isNull);
  });

  test('Cascade delete works correctly when a User is deleted', () async {
    // Verify initial setup has connections, posts, and chats
    final initialConns = await userConnectionStore.findAll();
    expect(initialConns.isNotEmpty, isTrue);

    final initialPosts = await postStore.findAll();
    expect(initialPosts.isNotEmpty, isTrue);

    // Delete User with ID 1 (Aline)
    await userStore.delete(1);

    // 1. Connection (requesterId 1) should be cascade deleted
    final connections = await userConnectionStore.findAll();
    expect(connections.isEmpty, isTrue);

    // 2. Post (authorId 1) should be cascade deleted
    final posts = await postStore.findAll();
    expect(posts.length, equals(8));
    expect(posts.every((p) => p.authorId != 1), isTrue);

    // 3. Chat (createdByUserId 1) should be cascade deleted
    final chats = await chatStore.findAll();
    expect(chats.isEmpty, isTrue);
  });

  test('Post cascade delete works for RSVPs and SavedPosts', () async {
    // Add an RSVP and SavedPost for Post 1
    await rsvpStore.add(RSVP(userId: 2, postId: 1, status: RSVPStatus.going));

    await savedPostStore.add(SavedPost(userId: 2, postId: 1));

    // Verify they exist
    var rsvps = await rsvpStore.findByPostId(1);
    expect(rsvps.length, equals(2));

    var saved = await savedPostStore.findByUserId(2);
    expect(saved.length, equals(1));

    // Delete Post 1
    await postStore.delete(1);

    // Verify RSVPs and SavedPosts are cascade deleted
    rsvps = await rsvpStore.findByPostId(1);
    expect(rsvps.isEmpty, isTrue);

    saved = await savedPostStore.findByUserId(2);
    expect(saved.isEmpty, isTrue);
  });

  test('MessageStore getLastMessageOfEachChat works correctly', () async {
    // Clear the message box first
    final box = Hive.box<Map>('messages');
    await box.clear();

    final now = DateTime.now();

    // Chat 1 messages:
    // Msg 1: older
    final msg1 = await messageStore.add(
      Message(
        chatId: 1,
        senderId: 1,
        contentText: 'First message',
        timestamp: now.subtract(const Duration(minutes: 10)),
      ),
    );
    // Msg 2: newer
    final msg2 = await messageStore.add(
      Message(
        chatId: 1,
        senderId: 2,
        contentText: 'Second message',
        timestamp: now,
      ),
    );

    // Chat 2 messages:
    // Msg 3: only message
    final msg3 = await messageStore.add(
      Message(
        chatId: 2,
        senderId: 1,
        contentText: 'Only message in chat 2',
        timestamp: now.subtract(const Duration(minutes: 5)),
      ),
    );

    final lastMsgs = await messageStore.getLastMessageOfEachChat();

    expect(lastMsgs.length, equals(2));
    expect(lastMsgs[1], isNotNull);
    expect(lastMsgs[1]!.id, equals(msg2.id));
    expect(lastMsgs[1]!.contentText, equals('Second message'));

    expect(lastMsgs[2], isNotNull);
    expect(lastMsgs[2]!.id, equals(msg3.id));
    expect(lastMsgs[2]!.contentText, equals('Only message in chat 2'));
  });
}
