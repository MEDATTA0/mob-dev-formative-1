# ADR 0001: Storage Solution Evolution for the Model Layer

## Context

The persistence requirements of the application evolved through several distinct phases. Each choice was driven by a balance of speed, database structure, and the need for flexibility during rapid prototyping.

### 1. Plain Temporary Storage
* **Implementation**: In-memory storage lists.
* **Rationale**: Initial bootstrapping. Allowed us to write UI components and view states without managing database connections.
* **Limitations**: Data was volatile and did not persist across application restarts.

### 2. Transition to `sqflite` (SQLite)
* **Implementation**: Relational database tables using standard SQL.
* **Rationale**: Introduced to provide robust local persistence.
* **Limitations**: Rigid schema definitions, boilerplate query mapping, and migration setup slowed down development and modifications of entities during the MVP phase.

### 3. Migration to `Hive` (NoSQL)
* **Implementation**: Lightweight, local NoSQL key-value persistence.
* **Rationale**: Moved to Hive to support fast prototyping, schema flexibility, and lower setup overhead.
* **Design Decision (Avoiding Decorators)**:
  We chose **not** to use Hive's advanced features like custom adapters generated via decorators (`@HiveType`, `@HiveField`, and `build_runner`). Instead, we stored raw `Map` structures inside the boxes and handled serialization manually (`toMap()` and `fromMap()`) on the entity models.
  * *Why?* Keeping the domain entities free of library-specific annotations preserved maximum flexibility and avoided compile-time dependencies or code-generation overhead. This decoupled the core data models from Hive, allowing us to swap the database driver without refactoring the entities themselves.

### 4. Decision to Migrate Back to SQL (if needed)
* **Implementation**: Restructuring the store layer back to a SQL database (e.g. SQLite/`sqflite` or Drift).
* **Rationale**: Hive is no longer actively maintained. We'll need to migrate from Hive to another NoSQL or SQL database. Relational query complexities (such as cascade deletes and multi-entity joins) are naturally handled better by relational systems than by manual box queries, while NoSQL databases are better suited for unstructured data and provide a more flexible schema.
* **Consequence of Design Decision**:
  Because we previously avoided binding our models to Hive annotations, our entity definitions (`lib/models/entities/`) are clean, standard Dart classes. The migration back to a SQL database will be straightforward, requiring updates only to the storage layer (`lib/models/stores/`) and SQL helper methods without rewriting the entity files.

## Decision

We decided to use **Hive without annotations** as an intermediate, flexible NoSQL store to build out the MVP quickly, while keeping the architecture decoupled from Hive-specific APIs to facilitate a migration back to a SQL database (SQLite).

## Consequences

* **Decoupled Architecture**: Domain models remain clean Dart files with no direct dependency on the storage framework.
* **Easier Migrations**: Transitioning to another SQL solution is simplified since entities are not cluttered with `@HiveType` or `@HiveField` decorators.
* **Maintenance overhead**: Manual cascade logic (e.g., deleting a user manually deletes their posts/memberships/messages in other boxes) had to be written in Hive store files, illustrating the long-term benefits of a relational database.
