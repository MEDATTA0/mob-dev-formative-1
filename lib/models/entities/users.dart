import 'package:assignment1/models/entities/entity.dart';

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
  final String password;

  User({
    super.id,
    super.createdAt,
    super.updatedAt,
    required this.fullName,
    required this.email,
    required this.campusId,
    required this.password,
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
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
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
      password: map['password'] as String? ?? 'password',
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
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      requesterId: map['requesterId'] as int,
      receiverId: map['receiverId'] as int,
      status: ConnectionStatus.values.byName(map['status'] as String),
    );
  }
}
