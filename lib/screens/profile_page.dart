import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // ALU Theme Colors
  static const Color primaryBg = Color(0xFF050A1F);
  static const Color cardBg = Color(0xFF1A243B);
  static const Color accentGold = Color(0xFFF4A300);
  static const Color textWhite = Colors.white;
  static const Color secondaryText = Color(0xFFB0B8C4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,

      appBar: AppBar(
        backgroundColor: primaryBg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: accentGold,
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
                  color: accentGold,
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

            const Text(
              "John Doe",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textWhite,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Kigali Campus",
              style: TextStyle(
                color: secondaryText,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
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
                color: cardBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    ProfileMenuTile(
                      icon: Icons.article_outlined,
                      title: "My Posts",
                    ),

                    Divider(color: Colors.white12, height: 1),

                    ProfileMenuTile(
                      icon: Icons.bookmark_outline,
                      title: "Saved",
                    ),

                    Divider(color: Colors.white12, height: 1),

                    ProfileMenuTile(
                      icon: Icons.notifications_none,
                      title: "Notifications",
                    ),

                    Divider(color: Colors.white12, height: 1),

                    ProfileMenuTile(
                      icon: Icons.settings_outlined,
                      title: "Account Settings",
                    ),

                    Divider(color: Colors.white12, height: 1),

                    ProfileMenuTile(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                    ),

                    Divider(color: Colors.white12, height: 1),

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
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ProfilePage.accentGold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: ProfilePage.secondaryText,
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 4,
      ),
      leading: Icon(
        icon,
        color: ProfilePage.accentGold,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: ProfilePage.textWhite,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: ProfilePage.accentGold,
      ),
      onTap: () {},
    );
  }
}