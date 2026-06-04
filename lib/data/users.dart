import 'package:assignment1/models/entities/users.dart';

final List<User> users = [
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
    password: 'password',
  ),
  User(
    fullName: 'David N',
    email: 'david@alu.edu',
    campusId: 'ALU-MU-3311',
    campusName: 'Mauritius Campus',
    headline: 'Entrepreneurship Club Lead',
    bio: 'Passionate about design and civic-tech communities.',
    eventsCount: 23,
    communitiesCount: 5,
    connectionsCount: 87,
    password: 'password',
  ),
];

final List<UserConnection> userConnections = [
  UserConnection(
    requesterId: 1,
    receiverId: 2,
    status: ConnectionStatus.accepted,
  ),
];
