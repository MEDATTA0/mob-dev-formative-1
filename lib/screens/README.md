# screens/

Full-page route screens. Each file exports a single `StatefulWidget` that is pushed onto the navigator stack.

| File | Screen | Description |
|------|--------|-------------|
| `login.dart` | `LoginScreen` | Entry point; hosts `LoginForm` and `SignupForm` with a toggle between modes. |
| `session.dart` | `AuthSession` | Singleton that holds the currently logged-in user's email across the session. |
| `home.dart` | `HomeScreen` | Main feed with category filter, featured card, post list, search bar, and bottom navigation. |
| `create_post.dart` | `CreatePostScreen` | Form to compose and publish a new post or event. |
| `event_detail.dart` | `EventDetailScreen` | Detail view for a single post/event with RSVP and save actions. |
| `rsvp.dart` | `MyRsvpsScreen` | Lists events the current user has RSVP'd to. |
| `communities.dart` | `CommunitiesScreen` | Club directory; supports join/leave and member directory browsing. |
| `chats_screen.dart` | `ChatsScreen` | Conversation list sorted by last activity; supports creating DMs and group chats. |
| `conversation_screen.dart` | `ConversationScreen` | Real-time-style message thread with send, delete, and emoji reaction support. |
| `profile_page.dart` | `ProfilePage` | Displays the current user's profile, connections, and posts. |
| `edit_profile_page.dart` | `EditProfilePage` | Form to update profile details and profile picture. |
| `settings_page.dart` | `SettingsPage` | App settings including theme toggle (dark / light mode). |
| `privacy_page.dart` | `PrivacyPage` | Privacy policy and account privacy controls. |
| `help_page.dart` | `HelpPage` | Help centre with FAQs and support links. |
