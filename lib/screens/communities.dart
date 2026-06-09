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

  IconData _iconFor(String? name) {
    switch (name) {
      case 'lightbulb':
        return Icons.lightbulb_outline;
      case 'insights':
        return Icons.insights;
      case 'school':
        return Icons.school_outlined;
      default:
        return Icons.groups_outlined;
    }
  }

  Widget _buildClubCard(Club club) {
    final isMember = _isMember(club);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: _amber.withValues(alpha: 0.12),
            child: Icon(_iconFor(club.logoIconName), color: _amber),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club.name,
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${club.memberCount} members',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),
          // status indicator (becomes a real button in commit 4)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: (isMember ? _green : _amber).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isMember ? 'Joined' : 'Join',
              style: TextStyle(
                color: isMember ? _green : _amber,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
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

  String _tab = 'All Clubs';

  List<Club> get _visibleClubs {
    if (_tab == 'My Clubs') return _clubs.where(_isMember).toList();
    return _clubs;
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: ['All Clubs', 'My Clubs'].map((tab) {
            final selected = _tab == tab;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _tab = tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: selected
                        ? Border.all(color: _amber, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? _amber : Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
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
          : Column(
            children: [
              _buildTabs(),
              Expanded(
                child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: _clubs.map(_buildClubCard).toList(), // temporary
                  ),
              ),
            ],
          ),
    );
  }
}
