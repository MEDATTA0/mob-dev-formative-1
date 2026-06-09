import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/chats_screen.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_chats_screen_');
    Hive.init(tempDir.path);
    await initializeStores();
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('ChatsScreen displays the correct last message from MessageStore', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Retrieve the first chat to get its ID
      final chatsList = await chatStore.findAll();
      expect(chatsList.isNotEmpty, isTrue);
      final chat = chatsList.first;
      final chatId = chat.id!;

      // Clear messages and add specific messages for this chatId
      final box = Hive.box<Map>('messages');
      await box.clear();

      final now = DateTime.now();
      await messageStore.add(Message(
        chatId: chatId,
        senderId: 1,
        contentText: 'Hello everyone!',
        timestamp: now.subtract(const Duration(minutes: 5)),
      ));
      await messageStore.add(Message(
        chatId: chatId,
        senderId: 2,
        contentText: 'Hi there!',
        timestamp: now,
      ));

      // Build our ChatsScreen widget.
      await tester.pumpWidget(
        const MaterialApp(
          home: ChatsScreen(),
        ),
      );

      // Wait a moment for _loadData to complete
      await Future.delayed(const Duration(milliseconds: 100));
    });

    // Re-pump widget to draw the loaded state
    await tester.pump();

    final chatsList = await chatStore.findAll();
    final chat = chatsList.first;

    // Verify chat name is displayed
    expect(find.text(chat.name), findsOneWidget);

    // Verify that the actual last message content 'Hi there!' is displayed, 
    // instead of the hardcoded dummy preview 'Can\'t wait'
    expect(find.text('Hi there!'), findsOneWidget);
    expect(find.text('Can\'t wait'), findsNothing);
  });
}
