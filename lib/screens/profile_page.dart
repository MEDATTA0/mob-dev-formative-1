import 'package:assignment1/screens/chats_screen.dart';
import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'home.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(
            CurveTween(
              curve: Curves.easeInOut,
            ),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
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
              _navigateToPage(
                context,
                const SettingsPage(),
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
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          children: [
            const SizedBox(height: 20),

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
                child: Column(
                  children: [
                    const ProfileMenuTile(
                      icon: Icons.article_outlined,
                      title: "My Posts",
                    ),

                    const Divider(height: 1),

                    const ProfileMenuTile(
                      icon: Icons.bookmark_outline,
                      title: "Saved",
                    ),

                    const Divider(height: 1),

                    const ProfileMenuTile(
                      icon: Icons.notifications_none,
                      title: "Notifications",
                    ),

                    const Divider(height: 1),

                    ProfileMenuTile(
                      icon: Icons.settings_outlined,
                      title: "Account Settings",
                      onTap: () {
                        _navigateToPage(
                          context,
                          const SettingsPage(),
                        );
                      },
                    ),

                    const Divider(height: 1),

                    ProfileMenuTile(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                      onTap: () {
                        _navigateToPage(
                          context,
                          const SettingsPage(),
                        );
                      },
                    ),

                    const Divider(height: 1),

                    ProfileMenuTile(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        _navigateToPage(
                          context,
                          const SettingsPage(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.black,
        elevation: 8,
        onPressed: () {
          _navigateToPage(
            context,
            const SettingsPage(),
          );
        },
        child: const Icon(Icons.add),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: theme.colorScheme.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 12,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: "Home",
                selected: false,
                onTap: () {
                  _navigateToPage(
                    context,
                    const HomeScreen(),
                  );
                },
              ),

              _NavItem(
                icon: Icons.search,
                label: "Explore",
                selected: false,
                onTap: () {
                  _navigateToPage(
                    context,
                    const HomeScreen(),
                  );
                },
              ),

              const SizedBox(width: 40),

              _NavItem(
                icon: Icons.chat_bubble_outline,
                label: "Chats",
                selected: false,
                onTap: () {
                  _navigateToPage(
                    context,
                    const ChatsScreen(),
                  );
                },
              ),

              _NavItem(
                icon: Icons.person,
                label: "Profile",
                selected: true,
                onTap: () {},
              ),
            ],
          ),
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
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
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
      onTap: onTap,
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}