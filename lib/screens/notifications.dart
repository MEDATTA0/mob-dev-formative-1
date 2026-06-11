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
      // newest first
      _notifications = notifications.reversed.toList();
      _loading = false;
    });
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
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : const Center(child: Text('Notifications go here')),
    );
  }
}