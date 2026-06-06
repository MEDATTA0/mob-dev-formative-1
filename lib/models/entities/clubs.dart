import 'package:assignment1/models/entities/entity.dart';

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
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
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
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      userId: map['userId'] as int,
      clubId: map['clubId'] as int,
      role: ClubMemberRole.values.byName(map['role'] as String),
      status: MembershipStatus.values.byName(map['status'] as String),
      joinedAt: map['joinedAt'] != null
          ? DateTime.parse(map['joinedAt'] as String)
          : null,
    );
  }
}

enum ClubMemberRole { member, officer, president }

enum MembershipStatus { active, pending, removed }
