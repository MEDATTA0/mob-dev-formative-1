import 'package:assignment1/models/entities/clubs.dart';

List<Club> clubs = [
  Club(
    name: 'Entrepreneurship Club',
    description: 'Build and validate startup ideas with peers.',
    memberCount: 250,
    campusId: 'MU',
    category: 'Business',
    logoIconName: 'lightbulb',
  ),
  Club(
    name: 'Women in Leadership',
    description: 'Leadership workshops and mentoring circles.',
    memberCount: 180,
    campusId: 'RW',
    category: 'Leadership',
    logoIconName: 'insights',
  ),
];

List<ClubMembership> clubMemberships = [
  ClubMembership(
    userId: 2,
    clubId: 1,
    role: ClubMemberRole.president,
    status: MembershipStatus.active,
  ),
  ClubMembership(
    userId: 1,
    clubId: 1,
    role: ClubMemberRole.member,
    status: MembershipStatus.active,
  ),
  ClubMembership(
    userId: 1,
    clubId: 2,
    role: ClubMemberRole.president,
    status: MembershipStatus.active,
  ),
];
