# Assignment 1

A Flutter application designed as a social and community-building platform that provides user authentication, club directories, post creation, event RSVPs, chat messaging, and profile management, all supporting dynamic dark and light mode themes.

## Key Features

* **Authentication & Profiles**:
  * Login interface and session management.
  * Profiles with customizable details and profile pictures.
  * Settings for privacy, app settings, and help center.
* **Clubs**:
  * Discover clubs and view member directories.
  * Join or leave clubs.
* **Home Feed**:
  * View posts and events.
  * Create new posts.
  * RSVP to events and save posts.
* **Chat**:
  * Conversation screens.
  * Send, delete, and react to messages.
* **Theme**:
  * Dark Mode and Light Mode.

## Tech Stack

* **Core**: [Flutter SDK](https://flutter.dev/)
* **State & Persistence**: [Hive](https://pub.dev/packages/hive) & [Hive Flutter](https://pub.dev/packages/hive_flutter)
* **Fonts**: [Google Fonts (Poppins)](https://pub.dev/packages/google_fonts)
* **Images**: [Cached Network Image](https://pub.dev/packages/cached_network_image)
* **Utilities**: `collection`, `intl`, `image_picker`, `url_launcher`

---

## Architecture & Database Design

This project implements a clean **Layered Architecture** to keep the business logic separated from the presentation layer:

1. **Presentation Layer (`lib/screens/`, `lib/components/`)**: Handles UI widgets, page routing, and theme styling (defined in `lib/constants.dart`).
2. **Logic & Storage Layer (`lib/models/stores/`)**: Implements base storage operations to query and mutate records inside Hive boxes.
3. **Data Layer (`lib/models/entities/`, `lib/data/`)**: Comprises clean entity classes and static seed data used to populate the local database on initial launch.

### Documentation & Architectural Decisions
Detailed architectural decisions are maintained within the repository:
* **Architecture Walkthrough**: See [ARCHITECTURE.md](lib/docs/ARCHITECTURE.md) to understand folder structure and execution flow.
* **Architecture Decision Record (ADR)**: See [ADR 0001: Storage Solution](lib/docs/adr/0001-storage-solution-evolution.md) to read about our choice of Hive NoSQL key-value persistence and migration roadmap.

## Directory Structure

```text
lib/
├── components/      # UI Components
├── constants.dart   # Styling constants
├── data/            # Static seed data
├── docs/            # Documentation
│   └── adr/         # Architectural Decisions
├── models/          # Data Layer
│   ├── entities/    # Domain classes
│   └── stores/      # Data Operations
├── screens/         # Screens
└── utils/           # Utilities
```

## Getting Started

### Prerequisites
Make sure you have the Flutter SDK installed and configured on your system.

```bash
flutter --version
```

### Installation

```bash
flutter pub get
```

### Run
```bash
flutter run
```