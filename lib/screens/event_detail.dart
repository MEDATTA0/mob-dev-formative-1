import 'package:flutter/material.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/rsvp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  final Post post;

  const EventDetailScreen({super.key, required this.post});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String _userStatus = '';

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('MMM d, yyyy').format(dt);
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('hh:mm a').format(dt);
  }

  // ── Image helper ──────────────────────────────────────────
  Widget _buildImage(
    String? url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final theme = Theme.of(context);
    if (url == null || url.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        child: Icon(
          Icons.image_outlined,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          size: 32,
        ),
      );
    }

    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        alignment: Alignment.topCenter,
        errorBuilder: (_, _, _) => Container(
          width: width,
          height: height,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      alignment: Alignment.topCenter,
      placeholder: (_, _) => Container(
        width: width,
        height: height,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      errorWidget: (_, _, _) => Container(
        width: width,
        height: height,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        child: Icon(
          Icons.image_outlined,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          size: 32,
        ),
      ),
    );
  }

  Future<void> _setStatus(String status) async {
    setState(() => _userStatus = status);

    final RSVPStatus rsvpStatus = status == 'Going'
        ? RSVPStatus.going
        : RSVPStatus.interested;

    int userId = 1;
    try {
      final users = await userStore.findAll();
      if (users.isNotEmpty) userId = users.first.getId();
    } catch (_) {}

    await rsvpStore.add(
      RSVP(userId: userId, postId: widget.post.getId(), status: rsvpStatus),
    );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MyRsvpsScreen(initialTab: status)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHero(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTags(post),
                        const SizedBox(height: 14),
                        Text(
                          post.title,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow(
                          Icons.access_time_outlined,
                          _formatDate(post.startTime),
                          post.startTime != null && post.endTime != null
                              ? '${_formatTime(post.startTime)} - ${_formatTime(post.endTime)}'
                              : '',
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          Icons.location_on_outlined,
                          post.location,
                          post.campusId,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          post.description,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildAttendees(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHero() {
    final theme = Theme.of(context);
    return Stack(
      children: [
        _buildImage(
          widget.post.coverImageUrl,
          width: double.infinity,
          height: 270,
        ),
        // Bottom fade
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [theme.scaffoldBackgroundColor, Colors.transparent],
              ),
            ),
          ),
        ),
        // Top bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.sync_alt,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTags(Post post) {
    final theme = Theme.of(context);
    final tagsToShow = post.tags.isNotEmpty ? post.tags : [post.category];

    return Wrap(
      spacing: 8,
      children: tagsToShow
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildInfoRow(IconData icon, String line1, String line2) {
    final theme = Theme.of(context);
    if (line1.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line1,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (line2.isNotEmpty)
                Text(
                  line2,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendees() {
    final theme = Theme.of(context);
    final avatarColors = [
      const Color(0xFFE8A87C),
      const Color(0xFF85C1E9),
      const Color(0xFF82E0AA),
    ];

    final postId = widget.post.getId();

    return FutureBuilder<List<RSVP>>(
      future: rsvpStore.findByPostId(postId),
      builder: (context, snap) {
        final allRsvps = snap.data ?? [];
        final goingCount = allRsvps
            .where((r) => r.status == RSVPStatus.going)
            .length;
        final interestedCount = allRsvps
            .where((r) => r.status == RSVPStatus.interested)
            .length;

        return Row(
          children: [
            SizedBox(
              width: 88,
              height: 32,
              child: Stack(
                children: List.generate(
                  3,
                  (i) => Positioned(
                    left: i * 22.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: avatarColors[i],
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$goingCount going',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: '   $interestedCount interested',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActions() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => _setStatus('Going'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _userStatus == 'Going'
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text(
                _userStatus == 'Going' ? 'Going ✓' : 'RSVP',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              onPressed: () => _setStatus('Interested'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: _userStatus == 'Interested'
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text(
                _userStatus == 'Interested' ? 'Interested ✓' : 'Interested',
                style: TextStyle(
                  color: _userStatus == 'Interested'
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
