import 'package:flutter/material.dart';
import '../models/index.dart';

class EventDetailScreen extends StatefulWidget {
  final Post post;

  const EventDetailScreen({super.key, required this.post});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String _userStatus = '';

  String _readString(Post post, List<String> keys, {String fallback = ''}) {
    final dynamic p = post;
    for (final key in keys) {
      try {
        final value = p[key];
        if (value != null) return value.toString();
      } catch (_) {}
      try {
        final value = (p as dynamic).toJson?[key];
        if (value != null) return value.toString();
      } catch (_) {}
      try {
        final value = (p as dynamic).toJson();
        if (value is Map && value[key] != null) return value[key].toString();
      } catch (_) {}
    }
    return fallback;
  }

  int _readInt(Post post, List<String> keys, {int fallback = 0}) {
    final text = _readString(post, keys);
    return int.tryParse(text) ?? fallback;
  }

  RSVPStatus _statusFor(String status) {
    final normalized = status.toLowerCase();
    for (final value in RSVPStatus.values) {
      if (value.name.toLowerCase() == normalized) return value;
    }
    return RSVPStatus.values.first;
  }

  void _setStatus(String status) {
    setState(() => _userStatus = status);
    dynamic currentUser;
    try {
      currentUser = (userStore as dynamic).currentUser;
    } catch (_) {
      try {
        currentUser = (userStore as dynamic).user;
      } catch (_) {
        currentUser = null;
      }
    }
    rsvpStore.add(RSVP(
      userId: currentUser?.id ?? 1,
      postId: widget.post.getId(),
      status: _statusFor(status),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHero(post),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTags(post),
                        const SizedBox(height: 14),
                        Text(
                          post.title,
                          style: const TextStyle(
                            color: Color(0xFF0F1B2D),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow(
                          Icons.access_time_outlined,
                          _readString(post, ['date', 'eventDate', 'startDate']),
                          _readString(post, ['time', 'eventTime', 'startTime']),
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          Icons.location_on_outlined,
                          _readString(post, ['venue', 'location', 'address']),
                          _readString(post, ['sublocation', 'subLocation', 'subtitle']),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          post.description,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildAttendees(post),
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

  Widget _buildHero(Post post) {
    return Stack(
      children: [
        Image.asset(
          _readString(post, ['imagePath', 'image', 'thumbnail', 'photoUrl']),
          width: double.infinity,
          height: 270,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.sync_alt, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTags(Post post) {
    return Wrap(
      spacing: 8,
      children: post.tags.map((tag) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildInfoRow(IconData icon, String line1, String line2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 18),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              line1,
              style: const TextStyle(
                color: Color(0xFF0F1B2D),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              line2,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendees(Post post) {
    final avatarColors = [
      const Color(0xFFE8A87C),
      const Color(0xFF85C1E9),
      const Color(0xFF82E0AA),
    ];

    return Row(
      children: [
        SizedBox(
          width: 88,
          height: 32,
          child: Stack(
            children: List.generate(3, (i) => Positioned(
              left: i * 22.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: avatarColors[i], width: 2),
                ),
                child: CircleAvatar(
                  radius: 14,
                  backgroundImage: AssetImage(_readString(post, ['imagePath', 'image', 'thumbnail', 'photoUrl'])),
                ),
              ),
            )),
          ),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${_readInt(post, ['goingCount', 'going', 'attendingCount'])} going',
                style: const TextStyle(
                  color: Color(0xFF0F1B2D),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              TextSpan(
                text: '   ${_readInt(post, ['interestedCount', 'interested', 'interestedUsersCount'])} interested',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
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
                    ? const Color(0xFF2A9D6F)
                    : const Color(0xFFF5A623),
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
                      ? const Color(0xFFF5A623)
                      : Colors.grey.shade300,
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
                      ? const Color(0xFFF5A623)
                      : Colors.grey.shade700,
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