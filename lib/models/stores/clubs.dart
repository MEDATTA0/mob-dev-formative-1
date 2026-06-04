import 'package:assignment1/data/clubs.dart';
import 'package:assignment1/models/entities/clubs.dart';
import 'package:assignment1/models/stores/store.dart';
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
    final membershipIdsToDelete = membershipBox.keys
        .where((key) => membershipBox.get(key)?['clubId'] == id)
        .toList();
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
    for (var c in clubs) {
      await add(c);
    }
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
  Future<void> loadDummy() async {
    if (_box.isNotEmpty) return;
    for (var cm in clubMemberships) {
      await add(cm);
    }
  }
}
