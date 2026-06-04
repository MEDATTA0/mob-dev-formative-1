import 'package:assignment1/models/storage.dart';
import 'package:assignment1/models/database_helper.dart';
import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

class ClubStore implements Store<Club> {
  @override
  Future<Club> add(Club data) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert('clubs', data.toMap());
    data.id = id;
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('clubs', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Club>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('clubs');
    return maps.map((map) => Club.fromMap(map)).toList();
  }

  @override
  Future<Club?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('clubs', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Club.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Club>> findByCampus(String campusId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('clubs', where: 'campusId = ?', whereArgs: [campusId]);
    return maps.map((map) => Club.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {
    final db = await DatabaseHelper.instance.database;
    final countMaps = await db.rawQuery('SELECT COUNT(*) as count FROM clubs');
    final count = Sqflite.firstIntValue(countMaps) ?? 0;
    if (count > 0) return;

    await add(
      Club(
        name: 'Entrepreneurship Club',
        description: 'Build and validate startup ideas with peers.',
        memberCount: 250,
        campusId: 'MU',
        category: 'Business',
        logoIconName: 'lightbulb',
      ),
    );

    await add(
      Club(
        name: 'Women in Leadership',
        description: 'Leadership workshops and mentoring circles.',
        memberCount: 180,
        campusId: 'RW',
        category: 'Leadership',
        logoIconName: 'insights',
      ),
    );
  }
}

/// Represents student-run communities
class Club extends Entity {
  final String name;
  final String description;
  final int memberCount;
  final String campusId;
  final String category;
  final String? coverImageUrl;
  final String? logoUrl;
  final String? logoIconName;
  final int? ownerUserId;

  Club({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.campusId,
    required this.category,
    this.coverImageUrl,
    this.logoUrl,
    this.logoIconName,
    this.ownerUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'name': name,
      'description': description,
      'memberCount': memberCount,
      'campusId': campusId,
      'category': category,
      'coverImageUrl': coverImageUrl,
      'logoUrl': logoUrl,
      'logoIconName': logoIconName,
      'ownerUserId': ownerUserId,
    };
  }

  factory Club.fromMap(Map<String, dynamic> map) {
    return Club(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      name: map['name'] as String,
      description: map['description'] as String,
      memberCount: map['memberCount'] as int? ?? 0,
      campusId: map['campusId'] as String,
      category: map['category'] as String,
      coverImageUrl: map['coverImageUrl'] as String?,
      logoUrl: map['logoUrl'] as String?,
      logoIconName: map['logoIconName'] as String?,
      ownerUserId: map['ownerUserId'] as int?,
    );
  }
}

class ClubMembership extends Entity {
  final int userId;
  final int clubId;
  final ClubMemberRole role;
  final MembershipStatus status;
  final DateTime joinedAt;

  ClubMembership({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.userId,
    required this.clubId,
    this.role = ClubMemberRole.member,
    this.status = MembershipStatus.active,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'createdAt': getCreatedAt().toIso8601String(),
      'updatedAt': getUpdatedAt().toIso8601String(),
      'userId': userId,
      'clubId': clubId,
      'role': role.name,
      'status': status.name,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory ClubMembership.fromMap(Map<String, dynamic> map) {
    return ClubMembership(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
      userId: map['userId'] as int,
      clubId: map['clubId'] as int,
      role: ClubMemberRole.values.byName(map['role'] as String),
      status: MembershipStatus.values.byName(map['status'] as String),
      joinedAt: map['joinedAt'] != null ? DateTime.parse(map['joinedAt'] as String) : null,
    );
  }
}

class ClubMembershipStore implements Store<ClubMembership> {
  @override
  Future<ClubMembership> add(ClubMembership data) async {
    final db = await DatabaseHelper.instance.database;
    var existsMaps = await db.query(
      'club_memberships',
      where: 'userId = ? AND clubId = ?',
      whereArgs: [data.userId, data.clubId],
    );
    if (existsMaps.isEmpty) {
      final id = await db.insert('club_memberships', data.toMap());
      data.id = id;
    } else {
      data.id = existsMaps.first['id'] as int?;
    }
    return data;
  }

  @override
  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('club_memberships', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<ClubMembership>> findAll() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('club_memberships');
    return maps.map((map) => ClubMembership.fromMap(map)).toList();
  }

  @override
  Future<ClubMembership?> findById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('club_memberships', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ClubMembership.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ClubMembership>> findByUserId(int userId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('club_memberships', where: 'userId = ?', whereArgs: [userId]);
    return maps.map((map) => ClubMembership.fromMap(map)).toList();
  }

  Future<List<ClubMembership>> findByClubId(int clubId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query('club_memberships', where: 'clubId = ?', whereArgs: [clubId]);
    return maps.map((map) => ClubMembership.fromMap(map)).toList();
  }

  @override
  Future<void> loadDummy() async {}
}

enum ClubMemberRole { member, officer, president }

enum MembershipStatus { active, pending, removed }
