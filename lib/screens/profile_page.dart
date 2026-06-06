import 'package:flutter/material.dart';
import 'settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            icon: Icon(
              Icons.settings,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Picture
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 3,
                ),
              ),
              child: const CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(
                  "https://picsum.photos/200",
                ),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "John Doe",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              "Kigali Campus",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProfileStat(
                  number: "23",
                  label: "Events",
                ),
                ProfileStat(
                  number: "5",
                  label: "Communities",
                ),
                ProfileStat(
                  number: "87",
                  label: "Connections",
                ),
              ],
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: theme.colorScheme.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    ProfileMenuTile(
                      icon: Icons.article_outlined,
                      title: "My Posts",
                    ),
                    Divider(height: 1),
                    ProfileMenuTile(
                      icon: Icons.bookmark_outline,
                      title: "Saved",
                    ),
                    Divider(height: 1),
                    ProfileMenuTile(
                      icon: Icons.notifications_none,
                      title: "Notifications",
                    ),
                    Divider(height: 1),
                    ProfileMenuTile(
                      icon: Icons.settings_outlined,
                      title: "Account Settings",
                    ),
                    Divider(height: 1),
                    ProfileMenuTile(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                    ),
                    Divider(height: 1),
                    ProfileMenuTile(
                      icon: Icons.logout,
                      title: "Logout",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String number;
  final String label;

  const ProfileStat({
    super.key,
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 4,
      ),
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.primary,
      ),
      onTap: () {},
    );
  }
}