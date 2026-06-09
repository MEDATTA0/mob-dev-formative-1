import 'package:flutter/material.dart';
import 'package:assignment1/models/index.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  static const _bg = Color(0xFFF8F9FB);
  static const _navy = Color(0xFF0F1B2D);
  static const _amber = Color(0xFFF5A623);
  static const _green = Color(0xFF2A9D6F);

  bool _loading = true;
  List<Club> _clubs = [];
  List<ClubMembership> _myMemberships = [];
  int _userId = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final users = await userStore.findAll();
    final clubs = await clubStore.findAll();
    final userId = users.isNotEmpty ? users.first.getId() : 1;
    final memberships = await clubMembershipStore.findByUserId(userId);
    if (!mounted) return;
    setState(() {
      _userId = userId;
      _clubs = clubs;
      _myMemberships = memberships;
      _loading = false;
    });
  }

  // Is the current user an active member of this club?
  bool _isMember(Club club) {
    return _myMemberships.any(
      (m) => m.clubId == club.getId() && m.status == MembershipStatus.active,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _navy,
        elevation: 0.5,
        title: const Text('Communities'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: _clubs.map((c) => Text(c.name)).toList(), // temporary
            ),
    );
  }
}