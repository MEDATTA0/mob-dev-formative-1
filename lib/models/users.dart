import 'package:assignment1/models/storage.dart';
import 'package:collection/collection.dart';

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
  }) : super();
}

class UserStore implements Store<User> {
  final List<User> _store = [];

  @override
  User add(User data) {
    _store.add(data);
    return data;
  }

  @override
  void delete(int id) => _store.removeWhere((e) => e.getId() == id);

  @override
  List<User> findAll() => _store;

  @override
  User? findById(int id) => _store.firstWhereOrNull((e) => e.getId() == id);

  User? findByCampusId(String campusId) {
    return _store.firstWhereOrNull((e) => e.campusId == campusId);
  }

  @override
  void loadDummy() {
    if (_store.isNotEmpty) return;

    add(
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

    add(
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
