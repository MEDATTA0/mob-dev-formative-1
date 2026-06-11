# models/

Data layer: domain entities, Hive-backed stores, and a barrel initialiser.

## entities/

Plain Dart classes that map to Hive boxes. Each extends `Entity` (provides `id`, `createdAt`, `updatedAt`) and exposes `toMap` / `fromMap` helpers.

| File | Classes |
|------|---------|
| `entity.dart` | `Entity` – base class with `id`, `createdAt`, `updatedAt`. |
| `users.dart` | `User`, `UserConnection` |
| `clubs.dart` | `Club`, `ClubMembership` |
| `posts.dart` | `Post` (supports `PostType.event` / `opportunity`), `RSVP`, `SavedPost`, `AppNotification` |
| `messages.dart` | `Chat`, `Message`, `ChatParticipant`, `MessageReaction` |

## stores/

Hive-backed repositories. Each store implements the `Store<T>` interface (`add`, `findById`, `findAll`, `delete`, `loadDummy`) and performs cascade deletes when required.

| File | Stores |
|------|--------|
| `store.dart` | `Store<T>` – abstract interface. |
| `users.dart` | `UserStore`, `UserConnectionStore` |
| `clubs.dart` | `ClubStore`, `ClubMembershipStore` |
| `posts.dart` | `PostStore`, `RSVPStore`, `SavedPostStore`, `NotificationStore` |
| `messages.dart` | `ChatStore`, `MessageStore`, `ChatParticipantStore`, `MessageReactionStore` |

## index.dart

Barrel file that exports all entities and stores, declares the global store singletons (`userStore`, `postStore`, etc.), and exposes `initializeStores()` which opens all Hive boxes and seeds them with dummy data on first launch.
