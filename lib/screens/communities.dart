import 'package:flutter/material.dart';
import 'package:assignment1/models/index.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
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

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 52,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            _tab == 'My Clubs'
                ? "You haven't joined any clubs yet"
                : 'No clubs available',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClubCard(Club club) {
    final theme = Theme.of(context);
    final isMember = _isMember(club);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            child: Icon(
              _iconFor(club.logoIconName),
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club.name,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${club.memberCount} members',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // status indicator (becomes a real button in commit 4)
          OutlinedButton(
            onPressed: () => _toggledJoin(club),
            style: OutlinedButton.styleFrom(
              backgroundColor: isMember
                  ? theme.colorScheme.secondary.withValues(alpha: 0.1)
                  : Colors.transparent,
              side: BorderSide(
                color: isMember
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.primary,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            ),
            child: Text(
              isMember ? 'Joined' : 'Join',
              style: TextStyle(
                color: isMember
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.primary,
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

  Future<void> _toggledJoin(Club club) async {
    final clubId = club.getId();
    if (_isMember(club)) {
      // leave: delete this user's membership for the club
      final mine = await clubMembershipStore.findByUserId(_userId);
      for (final m in mine.where((m) => m.clubId == clubId)) {
        await clubMembershipStore.delete(m.getId());
      }
    } else {
      // join: add a membership
      await clubMembershipStore.add(
        ClubMembership(userId: _userId, clubId: clubId),
      );
    }
    await _loadData(); // refresh so the button reflects the new state
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isMember(club) ? 'Joined ${club.name}' : 'Left ${club.name}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildTabs() {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
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
                    color: selected ? surface : Colors.transparent,
                    color: selected
                        ? theme.colorScheme.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: selected
                        ? Border.all(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          )
                        : null,
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? _amber : onSurface.withValues(alpha: 0.5),
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0.5,
        title: const Text('Communities'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : Column(
              children: [
                _buildTabs(),
                Expanded(
                  child: _visibleClubs.isEmpty
                      ? _buildEmptyState()
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: _visibleClubs
                              .map(_buildClubCard)
                              .toList(), // temporary
                        ),
                ),
              ],
            ),
    );
  }
}
