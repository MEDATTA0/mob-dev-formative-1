import 'package:assignment1/models/storage.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';

class ClubStore implements Store<Club> {
  Box<Map> get _box => Hive.box<Map>('clubs');

  @override
  Future<Club> add(Club data) async {
    final map = data.toMap();
    final id = await _box.add(map);
    data.id = id;
    await _box.put(id, data.toMap());
    return data;
  }

  @override
  Future<void> delete(int id) async {
    await _box.delete(id);

    // Cascade deletes:
    // Delete all ClubMemberships where clubId matches this club
    final membershipBox = Hive.box<Map>('club_memberships');
    final membershipIdsToDelete = membershipBox.keys.where((key) => membershipBox.get(key)?['clubId'] == id).toList();
    for (var mId in membershipIdsToDelete) {
      await membershipBox.delete(mId);
    }
  }

  @override
  Future<List<Club>> findAll() async {
    final list = <Club>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(Club.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<Club?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return Club.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<Club>> findByCampus(String campusId) async {
    final list = <Club>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['campusId'] == campusId) {
        list.add(Club.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;

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
  Box<Map> get _box => Hive.box<Map>('club_memberships');

  @override
  Future<ClubMembership> add(ClubMembership data) async {
    final existingKey = _box.keys.firstWhereOrNull((key) {
      final map = _box.get(key);
      return map != null &&
          map['userId'] == data.userId &&
          map['clubId'] == data.clubId;
    });

    if (existingKey == null) {
      final id = await _box.add(data.toMap());
      data.id = id;
      await _box.put(id, data.toMap());
    } else {
      data.id = existingKey as int;
    }
    return data;
  }

  @override
  Future<void> delete(int id) async {
    await _box.delete(id);
  }

  @override
  Future<List<ClubMembership>> findAll() async {
    final list = <ClubMembership>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null) {
        list.add(ClubMembership.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<ClubMembership?> findById(int id) async {
    final map = _box.get(id);
    if (map != null) {
      return ClubMembership.fromMap(Map<String, dynamic>.from(map));
    }
    return null;
  }

  Future<List<ClubMembership>> findByUserId(int userId) async {
    final list = <ClubMembership>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['userId'] == userId) {
        list.add(ClubMembership.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  Future<List<ClubMembership>> findByClubId(int clubId) async {
    final list = <ClubMembership>[];
    for (var key in _box.keys) {
      final map = _box.get(key);
      if (map != null && map['clubId'] == clubId) {
        list.add(ClubMembership.fromMap(Map<String, dynamic>.from(map)));
      }
    }
    return list;
  }

  @override
  Future<void> loadDummy() async {}
}

enum ClubMemberRole { member, officer, president }

enum MembershipStatus { active, pending, removed }
