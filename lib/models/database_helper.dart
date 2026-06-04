import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('assignment1.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _configureDB,
    );
  }

  Future _configureDB(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON;');
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const integerType = 'INTEGER NOT NULL';
    const integerTypeNullable = 'INTEGER';

    // 1. Users table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        fullName $textType,
        email $textType,
        campusId $textType,
        campusName $textTypeNullable,
        bio $textTypeNullable,
        headline $textTypeNullable,
        profilePictureUrl $textTypeNullable,
        eventsCount $integerType DEFAULT 0,
        communitiesCount $integerType DEFAULT 0,
        connectionsCount $integerType DEFAULT 0
      )
    ''');

    // 2. User Connections table
    await db.execute('''
      CREATE TABLE user_connections (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        requesterId $integerType,
        receiverId $integerType,
        status $textType,
        FOREIGN KEY (requesterId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (receiverId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 3. Clubs table
    await db.execute('''
      CREATE TABLE clubs (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        name $textType,
        description $textType,
        memberCount $integerType DEFAULT 0,
        campusId $textType,
        category $textType,
        coverImageUrl $textTypeNullable,
        logoUrl $textTypeNullable,
        logoIconName $textTypeNullable,
        ownerUserId $integerTypeNullable,
        FOREIGN KEY (ownerUserId) REFERENCES users (id) ON DELETE SET NULL
      )
    ''');

    // 4. Club Memberships table
    await db.execute('''
      CREATE TABLE club_memberships (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        userId $integerType,
        clubId $integerType,
        role $textType,
        status $textType,
        joinedAt $textType,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (clubId) REFERENCES clubs (id) ON DELETE CASCADE
      )
    ''');

    // 5. Posts table
    await db.execute('''
      CREATE TABLE posts (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        authorId $integerType,
        type $textType,
        title $textType,
        description $textType,
        coverImageUrl $textTypeNullable,
        campusId $textType,
        category $textType,
        location $textType,
        tags $textType,
        startTime $textTypeNullable,
        endTime $textTypeNullable,
        deadline $textTypeNullable,
        capacity $integerTypeNullable,
        isPublished INTEGER NOT NULL CHECK (isPublished IN (0, 1)),
        FOREIGN KEY (authorId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 6. RSVPs table
    await db.execute('''
      CREATE TABLE rsvps (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        userId $integerType,
        postId $integerType,
        status $textType,
        respondedAt $textType,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (postId) REFERENCES posts (id) ON DELETE CASCADE
      )
    ''');

    // 7. Saved Posts table
    await db.execute('''
      CREATE TABLE saved_posts (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        userId $integerType,
        postId $integerType,
        savedAt $textType,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (postId) REFERENCES posts (id) ON DELETE CASCADE
      )
    ''');

    // 8. Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        userId $integerType,
        type $textType,
        title $textType,
        body $textType,
        relatedEntityId $integerTypeNullable,
        isRead INTEGER NOT NULL CHECK (isRead IN (0, 1)),
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 9. Chats table
    await db.execute('''
      CREATE TABLE chats (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        name $textType,
        isGroupChat INTEGER NOT NULL CHECK (isGroupChat IN (0, 1)),
        createdByUserId $integerType,
        participantIds $textType,
        lastMessagePreview $textTypeNullable,
        lastActivityAt $textTypeNullable,
        unreadCount $integerType DEFAULT 0,
        FOREIGN KEY (createdByUserId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 10. Messages table
    await db.execute('''
      CREATE TABLE messages (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        chatId $integerType,
        senderId $integerType,
        contentText $textType,
        type $textType,
        isRead INTEGER NOT NULL CHECK (isRead IN (0, 1)),
        attachmentUrl $textTypeNullable,
        timestamp $textType,
        FOREIGN KEY (chatId) REFERENCES chats (id) ON DELETE CASCADE,
        FOREIGN KEY (senderId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 11. Chat Participants table
    await db.execute('''
      CREATE TABLE chat_participants (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        chatId $integerType,
        userId $integerType,
        role $textType,
        joinedAt $textType,
        lastReadAt $textTypeNullable,
        FOREIGN KEY (chatId) REFERENCES chats (id) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 12. Message Reactions table
    await db.execute('''
      CREATE TABLE message_reactions (
        id $idType,
        createdAt $textType,
        updatedAt $textType,
        messageId $integerType,
        userId $integerType,
        reactionEmoji $textType,
        FOREIGN KEY (messageId) REFERENCES messages (id) ON DELETE CASCADE,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
