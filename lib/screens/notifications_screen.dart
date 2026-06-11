import 'package:flutter/material.dart';
import 'package:assignment1/constants.dart';
import 'package:assignment1/models/index.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotification> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final allUsers = await userStore.findAll();
    final loggedInEmail = AuthSession().loggedInEmail;
    final currentUser = loggedInEmail != null
        ? allUsers.firstWhere(
            (u) => u.email.toLowerCase() == loggedInEmail.toLowerCase(),
            orElse: () => allUsers.first,
          )
        : (allUsers.isNotEmpty ? allUsers.first : null);

    if (currentUser?.id == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final notifs =
        await notificationStore.findByUserId(currentUser!.id!);
    notifs.sort((a, b) => b.getCreatedAt().compareTo(a.getCreatedAt()));

    if (mounted) {
      setState(() {
        _notifications = notifs;
        _loading = false;
      });
    }
  }

  Future<void> _markAllRead() async {
    final updated = <AppNotification>[];
    for (final n in _notifications) {
      if (!n.isRead) {
        final replacement = AppNotification(
          id: n.id,
          createdAt: n.createdAt,
          updatedAt: DateTime.now(),
          userId: n.userId,
          type: n.type,
          title: n.title,
          body: n.body,
          relatedEntityId: n.relatedEntityId,
          isRead: true,
        );
        await notificationStore.delete(n.id!);
        await notificationStore.add(replacement);
        updated.add(replacement);
      } else {
        updated.add(n);
      }
    }
    if (mounted) setState(() => _notifications = updated);
  }

  IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.rsvp:
        return Icons.event_available_outlined;
      case NotificationType.club:
        return Icons.groups_outlined;
      case NotificationType.message:
        return Icons.chat_bubble_outline;
      case NotificationType.system:
        return Icons.notifications_outlined;
    }
  }

  Color _colorFor(NotificationType type, ColorScheme cs) {
    switch (type) {
      case NotificationType.rsvp:
        return const Color(0xFF2A9D6F);
      case NotificationType.club:
        return const Color(0xFF6C63FF);
      case NotificationType.message:
        return cs.primary;
      case NotificationType.system:
        return const Color(0xFFF5A623);
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          if (unreadCount > 0)
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
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_off_outlined,
                          size: 56,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.25)),
                      const SizedBox(height: 12),
                      Text(
                        'No notifications yet',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.45),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _notifications.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 72,
                    endIndent: 16,
                    color: theme.dividerColor,
                  ),
                  itemBuilder: (context, i) {
                    final notif = _notifications[i];
                    final color =
                        _colorFor(notif.type, theme.colorScheme);
                    return _NotificationTile(
                      notification: notif,
                      icon: _iconFor(notif.type),
                      color: color,
                      timeLabel: _formatDate(notif.getCreatedAt()),
                    );
                  },
                ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final IconData icon;
  final Color color;
  final String timeLabel;

  const _NotificationTile({
    required this.notification,
    required this.icon,
    required this.color,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = !notification.isRead;

    return Container(
      color: isUnread
          ? theme.colorScheme.primary.withValues(alpha: 0.05)
          : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8, top: 3),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.65),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    timeLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                    ),
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
