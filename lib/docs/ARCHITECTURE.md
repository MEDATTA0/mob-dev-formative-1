# Project Setup and Architecture Documentation

This document describes the directory structure, architecture for this Flutter application.

## Directory Structure

The `lib/` directory is structured as follows:

1. **`components/`**: Reusable UI widgets and forms, and any custom components.
2. **`constants.dart`**: Theme settings, color configurations, and styling constants.
3. **`data/`**: Static seed data used to populate the local database on first run.
4. **`docs/`**: Project documentation files.
5. **`models/`**: Data layer composed of:
   - **`entities/`**: Serializable domain entity classes.
   - **`stores/`**: Persistence classes wrapping database storage operations.
6. **`screens/`**: Application screens (pages) handling views and local UI state.

---

## Architecture Overview

The application follows a **Layered Architecture**:

### 1. Presentation Layer (`screens/`, `components/`, `constants.dart`)
- **Screens**: Act as the controllers and view containers for distinct paths.
- **Components**: Reusable UI widgets and forms.
- **Constants**: Manage consistent styling across both light and dark themes.

### 2. Logic & Storage Layer (`models/stores/`)
- Handles storage querying, data persistence, and data-related business rules.
- Abstracted through the `Store<T>` class which is an abstract class that defines the basic CRUD operations.

### 3. Data Layer (`models/entities/`, `data/`)
- **Entities**: Represent application domain models with JSON serialization helpers (`toMap` and `fromMap`).
- **Data (Seeders)**: In-memory seed lists used to populate the local database on initial launch.

---

## Local Persistence (Hive)

The app uses [Hive](https://pub.dev/packages/hive) for fast, lightweight local NoSQL key-value persistence:
- **Initialization**: Hive and Hive Flutter are initialized in `main.dart` before the app starts (`Hive.initFlutter()`).
- **Boxes**: A unique Hive box is opened for each collection/table during the startup sequence.
- **Data Serialization**: Objects are stored as plain Maps and parsed back into Entities on retrieval.
The official Hive library is no longer maintained, yet it's still functional for our project use case.

For more information on the history and future direction of local persistence in this project, see [ADR 0001: Storage Solution Evolution](./adr/0001-storage-solution-evolution.md).

### Data Seeding
Upon startup, the `initializeStores()` helper instantiates the stores and checks if the corresponding Hive boxes are empty. If they are, it reads from the `lib/data/` seeds and populates the database.

---

## Data Models & Stores Architecture

### Domain Entities
Each entity inherits from the base `Entity` class. They do not contain storage code, maintaining a separation of concerns.

### Stores
Each store implements the `Store<T>` abstract class:
- **`Store` abstract class**: Declares standard CRUD operations (`add`, `delete`, `findById`, `findAll`, `loadDummy`).
- **Queries & Operations**: Stores contain lookup queries per entity.
- **Cascades**: Deleting an entity automatically cleans up related records in other boxes.

---

## State and Store Lifecycle

- **Global Singletons**: The application uses global store instances declared in `lib/models/index.dart`.
- **Initialization**: These stores are instantiated synchronously inside `initializeStores()` in `main.dart`.
- **Data Flow**: Screens and components call these stores directly to read or write data, ensuring data consistency across the app.

## NB: Do not create any new instance of the stores, they are already instantiated in `lib/models/index.dart` and made available globally. All you need is to import them when needed. 
(Don't make your life and the life of future developers harder than it already is by being a developer. You're welcome. :))
