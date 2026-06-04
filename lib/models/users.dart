import 'package:assignment1/models/storage.dart';
import 'package:assignment1/models/database_helper.dart';
import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

/// Represents the individual user
class User extends Entity {
  final String fullName;
  final String email;
  final String campusId;
  final String? campusName;
  final String? bio;
  final String? headline;
  final String? profilePictureUrl;
  final int eventsCount;
  final int communitiesCount;
  final int connectionsCount;

  User({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.fullName,
    required this.email,
    required this.campusId,
    this.campusName,
    this.bio,
    this.headline,
    this.profilePictureUrl,
    this.eventsCount = 0,
    this.communitiesCount = 0,
    this.connectionsCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'fullName': fullName,
      'email': email,
      'campusId': campusId,
      'campusName': campusName,
      'bio': bio,
      'headline': headline,
      'profilePictureUrl': profilePictureUrl,
      'eventsCount': eventsCount,
      'communitiesCount': communitiesCount,
      'connectionsCount': connectionsCount,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      campusId: map['campusId'] as String,
      campusName: map['campusName'] as String?,
      bio: map['bio'] as String?,
      headline: map['headline'] as String?,
      profilePictureUrl: map['profilePictureUrl'] as String?,
      eventsCount: map['eventsCount'] as int? ?? 0,
      communitiesCount: map['communitiesCount'] as int? ?? 0,
      connectionsCount: map['connectionsCount'] as int? ?? 0,
    );
  }
}

class UserStore implements Store<User> {
  @override
  Future<User> add(User data) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('users', data.toMap());
    data.id = id;
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<User>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('users');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  @override
  Future<User?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> findByCampusId(String campusId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('users', where: 'campusId = ?', whereArgs: [campusId]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> loadDummy() async {
    final db = await DatabaseHelper.instance.database;
    final countMaps = await db.rawQuery('SELECT COUNT(*) as count FROM users');
    final count = Sqflite.firstIntValue(countMaps) ?? 0;
    if (count > 0) return;

    await add(
      User(
        fullName: 'Aline Umuhoza',
        email: 'aline@alu.edu',
        campusId: 'ALU-RW-1023',
        campusName: 'Kigali Campus',
        headline: 'AI for Social Impact',
        bio: 'Passionate about design and civic-tech communities.',
        eventsCount: 23,
        communitiesCount: 5,
        connectionsCount: 87,
      ),
    );

    await add(
      User(
        fullName: 'David N.',
        email: 'david@alu.edu',
        campusId: 'ALU-MU-3311',
        campusName: 'Mauritius Campus',
        headline: 'Entrepreneurship Club Lead',
      ),
    );
  }
}

enum ConnectionStatus { pending, accepted, declined }

class UserConnection extends Entity {
  final int requesterId;
  final int receiverId;
  final ConnectionStatus status;

  UserConnection({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.requesterId,
    required this.receiverId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'requesterId': requesterId,
      'receiverId': receiverId,
      'status': status.name,
    };
  }

  factory UserConnection.fromMap(Map<String, dynamic> map) {
    return UserConnection(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      requesterId: map['requesterId'] as int,
      receiverId: map['receiverId'] as int,
      status: ConnectionStatus.values.byName(map['status'] as String),
    );
  }
}

class UserConnectionStore implements Store<UserConnection> {
  @override
  Future<UserConnection> add(UserConnection data) async {
    final db = await DatabaseHelper.instance.database;
    var existsMaps = await db.query(
      'user_connections',
      where: 'requesterId = ? AND receiverId = ?',
      whereArgs: [data.requesterId, data.receiverId],
    );
    if (existsMaps.isEmpty) {
      final id = await db.insert('user_connections', data.toMap());
      data.id = id;
    } else {
      data.id = existsMaps.first['id'] as int?;
    }
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('user_connections', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<UserConnection>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('user_connections');
    return maps.map((map) => UserConnection.fromMap(map)).toList();
  }

  @override
  Future<UserConnection?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('user_connections', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UserConnection.fromMap(maps.first);
    }
    return null;
  }

  Future<List<UserConnection>> findByUserId(int userId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'user_connections',
      where: 'requesterId = ? OR receiverId = ?',
      whereArgs: [userId, userId],
    );
    return maps.map((map) => UserConnection.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {
    final db = await DatabaseHelper.instance.database;
    final countMaps = await db.rawQuery('SELECT COUNT(*) as count FROM user_connections');
    final count = Sqflite.firstIntValue(countMaps) ?? 0;
    if (count > 0) return;

    // Load a dummy connection between Aline (ID 1) and David (ID 2)
    await add(
      UserConnection(
        requesterId: 1,
        receiverId: 2,
        status: ConnectionStatus.accepted,
      ),
    );
  }
}
