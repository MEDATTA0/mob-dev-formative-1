import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  String profileVisibility = "Campus Only";

  bool allowMessages = true;
  bool allowConnectionRequests = true;
  bool showEmail = false;
  bool showCampus = true;

  Widget buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  void saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Privacy settings updated"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
        title: Text(
          "Privacy Settings",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSectionTitle(context, "PROFILE VISIBILITY"),

            buildCard(
              context,
              child: Column(
                children: [
                  RadioGroup<String>(
                    groupValue: profileVisibility,
                    onChanged: (value) {
                      setState(() {
                        profileVisibility = value!;
                      });
                    },
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          activeColor: theme.colorScheme.primary,
                          title: Text(
                            "Public",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            "Anyone can view your profile",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          value: "Public",
                        ),
                        RadioListTile<String>(
                          activeColor: theme.colorScheme.primary,
                          title: Text(
                            "Campus Only",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            "Only ALU students can view your profile",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          value: "Campus Only",
                        ),
                        RadioListTile<String>(
                          activeColor: theme.colorScheme.primary,
                          title: Text(
                            "Private",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            "Only approved connections can view your profile",
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                          value: "Private",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            buildSectionTitle(context, "COMMUNICATION"),

            buildCard(
              context,
              child: Column(
                children: [
                  SwitchListTile(
                    activeThumbColor: theme.colorScheme.primary,
                    value: allowMessages,
                    title: Text(
                      "Allow Direct Messages",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        allowMessages = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    activeThumbColor: theme.colorScheme.primary,
                    value: allowConnectionRequests,
                    title: Text(
                      "Allow Connection Requests",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        allowConnectionRequests = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            buildSectionTitle(context, "PROFILE INFORMATION"),

            buildCard(
              context,
              child: Column(
                children: [
                  SwitchListTile(
                    activeThumbColor: theme.colorScheme.primary,
                    value: showEmail,
                    title: Text(
                      "Display Email Address",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        showEmail = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    activeThumbColor: theme.colorScheme.primary,
                    value: showCampus,
                    title: Text(
                      "Display Campus",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        showCampus = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: saveSettings,
                child: const Text(
                  "Save Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}