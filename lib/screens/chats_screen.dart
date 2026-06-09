import 'package:flutter/material.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/conversation_screen.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<Chat> _chats = [];
  Map<int, User> _usersById = {};
  Map<int, Message> _lastMessagesByChatId = {};
  User? _currentUser;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final chats = await chatStore.findAll();
    final users = await userStore.findAll();
    final lastMessages = await messageStore.getLastMessageOfEachChat();
    if (!mounted) return;
    setState(() {
      _chats = chats
        ..sort((a, b) {
          final aMsg = lastMessages[a.id];
          final bMsg = lastMessages[b.id];
          final aTime = aMsg?.timestamp ?? a.lastActivityAt ?? a.getCreatedAt();
          final bTime = bMsg?.timestamp ?? b.lastActivityAt ?? b.getCreatedAt();
          return bTime.compareTo(aTime);
        });
      _usersById = {
        for (final u in users)
          if (u.id != null) u.id!: u,
      };
      _lastMessagesByChatId = lastMessages;
      _currentUser = users.isNotEmpty ? users.first : null;
      _loading = false;
    });
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    if (now.difference(dt).inDays == 0) return DateFormat('h:mm a').format(dt);
    if (now.difference(dt).inDays < 7) return DateFormat('EEE').format(dt);
    return DateFormat('MMM d').format(dt);
  }

  Future<void> _navigateToChat(Chat chat) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConversationScreen(chat: chat, usersById: _usersById),
      ),
    );
    _loadData();
  }

  // ── Create conversation ────────────────────────────────────

  void _showNewConversationSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New Conversation',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F1B2D),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFFF5A623),
                  size: 22,
                ),
              ),
              title: const Text(
                'Direct Message',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1B2D),
                ),
              ),
              subtitle: Text(
                'Message someone directly',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDirectMessageSheet();
              },
            ),
            ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group_outlined,
                  color: Color(0xFFF5A623),
                  size: 22,
                ),
              ),
              title: const Text(
                'New Group',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1B2D),
                ),
              ),
              subtitle: Text(
                'Create a group conversation',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                _showNewGroupSheet();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showDirectMessageSheet() {
    final others = _usersById.values
        .where((u) => u.id != _currentUser?.id)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Direct Message',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F1B2D),
                ),
              ),
            ),
          ),
          if (others.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No other users to message',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            )
          else
            ...others.map(
              (user) => ListTile(
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(
                    0xFFF5A623,
                  ).withValues(alpha: 0.15),
                  child: Text(
                    user.fullName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFFF5A623),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  user.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1B2D),
                  ),
                ),
                subtitle: user.headline != null
                    ? Text(
                        user.headline!,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _startDirectMessage(user);
                },
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showNewGroupSheet() {
    final nameController = TextEditingController();
    final selected = <User>{};
    final others = _usersById.values
        .where((u) => u.id != _currentUser?.id)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New Group',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F1B2D),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Group name',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (_) => setModalState(() {}),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add members',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1B2D),
                    ),
                  ),
                ),
              ),
              ...others.map(
                (user) => CheckboxListTile(
                  value: selected.contains(user),
                  onChanged: (val) => setModalState(() {
                    val == true ? selected.add(user) : selected.remove(user);
                  }),
                  activeColor: const Color(0xFFF5A623),
                  secondary: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(
                      0xFFF5A623,
                    ).withValues(alpha: 0.15),
                    child: Text(
                      user.fullName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFF5A623),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1B2D),
                      fontSize: 14,
                    ),
                  ),
                  subtitle: user.headline != null
                      ? Text(
                          user.headline!,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        )
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        nameController.text.trim().isNotEmpty &&
                            selected.isNotEmpty
                        ? () {
                            Navigator.pop(ctx);
                            _createGroup(
                              nameController.text.trim(),
                              selected.toList(),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      disabledBackgroundColor: const Color(
                        0xFFF5A623,
                      ).withValues(alpha: 0.3),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create Group',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startDirectMessage(User other) async {
    if (_currentUser?.id == null || other.id == null) return;

    final existing = _chats.firstWhereOrNull(
      (c) =>
          !c.isGroupChat &&
          c.participantIds.contains(_currentUser!.id) &&
          c.participantIds.contains(other.id),
    );

    if (existing != null) {
      _navigateToChat(existing);
      return;
    }

    final chat = Chat(
      name: other.fullName,
      isGroupChat: false,
      createdByUserId: _currentUser!.id!,
      participantIds: [_currentUser!.id!, other.id!],
    );
    final created = await chatStore.add(chat);
    await chatParticipantStore.add(
      ChatParticipant(
        chatId: created.id!,
        userId: _currentUser!.id!,
        role: ChatParticipantRole.admin,
      ),
    );
    await chatParticipantStore.add(
      ChatParticipant(chatId: created.id!, userId: other.id!),
    );

    if (!mounted) return;
    setState(() => _chats.insert(0, created));
    _navigateToChat(created);
  }

  Future<void> _createGroup(String name, List<User> members) async {
    if (_currentUser?.id == null) return;

    final chat = Chat(
      name: name,
      isGroupChat: true,
      createdByUserId: _currentUser!.id!,
      participantIds: [_currentUser!.id!, ...members.map((u) => u.id!)],
    );
    final created = await chatStore.add(chat);
    await chatParticipantStore.add(
      ChatParticipant(
        chatId: created.id!,
        userId: _currentUser!.id!,
        role: ChatParticipantRole.admin,
      ),
    );
    for (final member in members) {
      await chatParticipantStore.add(
        ChatParticipant(chatId: created.id!, userId: member.id!),
      );
    }

    if (!mounted) return;
    setState(() => _chats.insert(0, created));
    _navigateToChat(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF0F1B2D),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F1B2D),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showNewConversationSheet,
            icon: const Icon(Icons.edit_outlined, color: Color(0xFFF5A623)),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFF5A623)),
              )
            : _chats.isEmpty
            ? Center(
                child: Text(
                  'No conversations yet',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _chats.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, indent: 72, endIndent: 16),
                itemBuilder: (context, i) => _buildChatTile(_chats[i]),
              ),
      ),
    );
  }

  Widget _buildChatTile(Chat chat) {
    final initial = chat.name[0].toUpperCase();
    final lastMsg = _lastMessagesByChatId[chat.id];
    final time = _formatTime(
      lastMsg?.timestamp ?? chat.lastActivityAt ?? chat.getCreatedAt(),
    );

    return InkWell(
      onTap: () => _navigateToChat(chat),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFFF5A623).withValues(alpha: 0.15),
              child: Text(
                initial,
                style: const TextStyle(
                  color: Color(0xFFF5A623),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F1B2D),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMsg?.contentText ??
                              chat.lastMessagePreview ??
                              'No messages yet',
                          style: TextStyle(
                            fontSize: 13,
                            color: chat.unreadCount > 0
                                ? const Color(0xFF0F1B2D)
                                : Colors.grey.shade500,
                            fontWeight: chat.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5A623),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
