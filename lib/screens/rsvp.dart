import 'package:flutter/material.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/event_detail.dart';
import 'package:intl/intl.dart';

class MyRsvpsScreen extends StatefulWidget {
  final String initialTab;
  const MyRsvpsScreen({super.key, this.initialTab = 'Going'});

  @override
  State<MyRsvpsScreen> createState() => _MyRsvpsScreenState();
}

class _MyRsvpsScreenState extends State<MyRsvpsScreen> with RouteAware {
  late String _selectedTab;
  List<RSVP> _allUserRsvps = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final users = await userStore.findAll();
    final user = users.isNotEmpty ? users.first : null;
    List<RSVP> rsvps = [];
    if (user != null) {
      rsvps = await rsvpStore.findByUserId(user.getId());
    }
    if (mounted) {
      setState(() {
        _allUserRsvps = rsvps;
        _loading = false;
      });
    }
  }

  Future<void> _goToDetail(Post post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(post: post)),
    );
    // Reload when returning from detail in case RSVP status changed
    _loadData();
  }

  List<RSVP> get _userRsvps =>
      _allUserRsvps.where((r) => _matchesTab(r.status)).toList();

  bool _matchesTab(RSVPStatus status) {
    if (_selectedTab == 'Going') return status == RSVPStatus.going;
    return status == RSVPStatus.interested;
  }

  Color _badgeColor(RSVPStatus status) => status == RSVPStatus.going
      ? const Color(0xFF2A9D6F)
      : const Color(0xFFF5A623);

  String _badgeLabel(RSVPStatus status) =>
      status == RSVPStatus.going ? 'Going' : 'Interested';

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('MMM d, yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My RSVPs',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTabToggle(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle() {
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
          children: ['Going', 'Interested'].map((tab) {
            final isSelected = _selectedTab == tab;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: isSelected
                        ? Border.all(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.07),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFF5A623)
                          : onSurface.withValues(alpha: 0.5),
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

  Widget _buildList() {
    final theme = Theme.of(context);
    final rsvps = _userRsvps;

    if (rsvps.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 52,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 12),
            Text(
              'No $_selectedTab events yet',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: rsvps.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        return FutureBuilder<Post?>(
          future: postStore.findById(rsvps[i].postId),
          builder: (context, snap) {
            if (!snap.hasData || snap.data == null) {
              return const SizedBox.shrink();
            }
            return _buildCard(rsvps[i], snap.data!);
          },
        );
      },
    );
  }

  Widget _buildCard(RSVP rsvp, Post post) {
    final theme = Theme.of(context);
    final color = _badgeColor(rsvp.status);
    final label = _badgeLabel(rsvp.status);

    return GestureDetector(
      onTap: () => _goToDetail(post),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: post.coverImageUrl != null
                      ? Image.network(
                          post.coverImageUrl!,
                          width: 95,
                          height: 95,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, _, _) => _imagePlaceholder(color),
                        )
                      : _imagePlaceholder(color),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_formatDate(post.startTime)} • ${post.location}',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3), size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder(Color color) {
    return Container(
      width: 95,
      height: 95,
      color: color.withValues(alpha: 0.1),
      child: Icon(
        Icons.event_outlined,
        color: color.withValues(alpha: 0.4),
        size: 28,
      ),
    );
  }
}
