import 'package:assignment1/models/storage.dart';
import 'package:collection/collection.dart';

class ClubStore implements Store<Club> {
  final List<Club> _store = [];

  @override
  Club add(Club data) {
    _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((c) => c.getId() == id);

  @override
  List<Club> findAll() => _store;

  @override
  Club? findById(int id) => _store.firstWhereOrNull((c) => c.getId() == id);

  List<Club> findByCampus(String campusId) {
    return _store.where((c) => c.campusId == campusId).toList();
  }

  @override
  void loadDummy() {
    if (_store.isNotEmpty) return;

    add(
      Club(
        name: 'Entrepreneurship Club',
        description: 'Build and validate startup ideas with peers.',
        memberCount: 250,
        campusId: 'MU',
        category: 'Business',
      ),
    );

    add(
      Club(
        name: 'Women in Leadership',
        description: 'Leadership workshops and mentoring circles.',
        memberCount: 180,
        campusId: 'RW',
        category: 'Leadership',
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
  final int? ownerUserId;

  Club({
    required this.name,
    required this.description,
    required this.memberCount,
    required this.campusId,
    required this.category,
    this.coverImageUrl,
    this.ownerUserId,
  }) : super();
}

class ClubMembership extends Entity {
  final int userId;
  final int clubId;
  final ClubMemberRole role;
  final MembershipStatus status;
  final DateTime joinedAt;

  ClubMembership({
    required this.userId,
    required this.clubId,
    this.role = ClubMemberRole.member,
    this.status = MembershipStatus.active,
    DateTime? joinedAt,
  }) : joinedAt = joinedAt ?? DateTime.now(),
       super();
}

class ClubMembershipStore implements Store<ClubMembership> {
  final List<ClubMembership> _store = [];

  @override
  ClubMembership add(ClubMembership data) {
    var exists = _store.any(
      (e) => e.userId == data.userId && e.clubId == data.clubId,
    );
    if (!exists) _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((e) => e.getId() == id);

  @override
  List<ClubMembership> findAll() => _store;

  @override
  ClubMembership? findById(int id) =>
      _store.firstWhereOrNull((e) => e.getId() == id);

  List<ClubMembership> findByUserId(int userId) =>
      _store.where((e) => e.userId == userId).toList();

  List<ClubMembership> findByClubId(int clubId) =>
      _store.where((e) => e.clubId == clubId).toList();

  @override
  void loadDummy() {}
}

enum ClubMemberRole { member, officer, president }

enum MembershipStatus { active, pending, removed }
