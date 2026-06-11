import 'package:flutter/material.dart';
import 'package:assignment1/models/index.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _loading = true;
  List<AppNotification> _notifications = [];
  int _userId = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final users = await userStore.findAll();
    final userId = users.isNotEmpty ? users.first.getId() : 1;
    final notifications = await notificationStore.findByUserId(userId);
    if (!mounted) return;
    setState(() {
      _userId = userId;
      _notifications = notifications.reversed.toList(); // newest first
      _loading = false;
    });
  }

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.rsvp:
        return Icons.event_available_outlined;
      case NotificationType.club:
        return Icons.groups_outlined;
      case NotificationType.message:
        return Icons.chat_bubble_outline;
      case NotificationType.system:
        return Icons.campaign_outlined;
    }
  }

  Widget _buildTile(AppNotification n) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: n.isRead
            ? theme.colorScheme.surface
            : accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: n.isRead
              ? theme.colorScheme.onSurface.withValues(alpha: 0.08)
              : accent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: accent.withValues(alpha: 0.12),
            child: Icon(_iconForType(n.type), color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  n.body,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (!n.isRead)
            Container(
              margin: const EdgeInsets.only(left: 8, top: 4),
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }

  Future<void> _markAsRead(AppNotification n) async {
    if (n.isRead) return;
    await notificationStore.delete(n.getId());
    await notificationStore.add(
      AppNotification(
        userId: n.userId,
        type: n.type,
        title: n.title,
        body: n.body,
        relatedEntityId: n.relatedEntityId,
        isRead: true,
      ),
    );
    await _loadData();
  }

  Future<void> _markAllRead() async {
    for (final n in _notifications.where((n) => !n.isRead)) {
      await notificationStore.delete(n.getId());
      await notificationStore.add(
        AppNotification(
          userId: n.userId,
          type: n.type,
          title: n.title,
          body: n.body,
          relatedEntityId: n.relatedEntityId,
          isRead: true,
        ),
      );
    }
    await _loadData();
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 52,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            "You're all caught up",
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0.5,
        title: const Text('Notifications'),
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
      body: _loading
          ? Center(
              child:
                  CircularProgressIndicator(color: theme.colorScheme.primary),
            )
          : _notifications.isEmpty
              ? _buildEmptyState()
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: _notifications
                      .map((n) => InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => _markAsRead(n),
                            child: _buildTile(n),
                          ))
                      .toList(),
                ),
    );
  }
}