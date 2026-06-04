import 'package:assignment1/models/entities/messages.dart';

final List<Chat> chats = [
  Chat(
    name: 'AI Workshop Group',
    isGroupChat: true,
    createdByUserId: 1,
    participantIds: const [1, 2],
    lastMessagePreview: 'Can\'t wait',
    unreadCount: 1,
  ),
];

final List<Message> messages = [
  Message(
    chatId: 1,
    senderId: 1,
    contentText: 'Hello everyone!',
    timestamp: DateTime.now(),
  ),
  Message(
    chatId: 1,
    senderId: 2,
    contentText: 'Hi there!',
    timestamp: DateTime.now().add(const Duration(minutes: 5)),
  ),
];

final List<MessageReaction> messageReactions = [
  MessageReaction(messageId: 1, userId: 2, reactionEmoji: '👍'),
];

final List<ChatParticipant> chatParticipants = [
  ChatParticipant(
    chatId: 1,
    userId: 1,
    role: ChatParticipantRole.admin,
  ),
  ChatParticipant(
    chatId: 1,
    userId: 2,
    role: ChatParticipantRole.member,
  ),
];
