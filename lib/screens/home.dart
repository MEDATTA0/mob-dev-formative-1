import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:assignment1/constants.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/screens/event_detail.dart';
import 'package:assignment1/screens/rsvp.dart';
import 'package:assignment1/screens/chats_screen.dart';
import 'package:assignment1/screens/profile_page.dart';
import 'package:assignment1/screens/communities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:assignment1/screens/create_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  List<Post> _allPosts = [];
  List<Post> _posts = [];
  User? _currentUser;

  final List<Map<String, dynamic>> _categories = [
    {
      'label': 'All',
      'icon': Icons.grid_view_rounded,
      'color': const Color(0xFFF5A623),
    },
    {
      'label': 'Events',
      'icon': Icons.calendar_today_outlined,
      'color': const Color(0xFF6C63FF),
    },
    {
      'label': 'Opportunities',
      'icon': Icons.card_giftcard_outlined,
      'color': const Color(0xFF2A9D6F),
    },
    {
      'label': 'Clubs',
      'icon': Icons.groups_outlined,
      'color': const Color(0xFF2A9D6F),
    },
    {
      'label': 'Academics',
      'icon': Icons.school_outlined,
      'color': const Color(0xFF3B82F6),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final allPosts = await postStore.findAll();
    final allUsers = await userStore.findAll();
    if (!mounted) return;
    setState(() {
      _allPosts = allPosts.where((p) => p.isPublished).toList();
      _posts = _allPosts;
      final loggedInEmail = AuthSession().loggedInEmail;
      _currentUser = loggedInEmail != null
          ? allUsers.firstWhere(
              (u) => u.email.toLowerCase() == loggedInEmail.toLowerCase(),
              orElse: () => allUsers.first,
            )
          : (allUsers.isNotEmpty ? allUsers.first : null);
    });
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  List<Post> get _filteredPosts {
    if (_selectedCategory == 'All') return _posts;
    if (_selectedCategory == 'Events') {
      return _posts.where((p) => p.type == PostType.event).toList();
    }
    if (_selectedCategory == 'Opportunities') {
      return _posts.where((p) => p.type == PostType.opportunity).toList();
    }
    return _posts.where((p) => p.category == _selectedCategory).toList();
  }

  Post? get _featuredPost =>
      _filteredPosts.isNotEmpty ? _filteredPosts.first : null;

  List<Post> get _latestPosts {
    final all = _filteredPosts;
    if (all.length > 1) return all.skip(1).toList();
    return [];
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('MMM d, yyyy').format(dt);
  }

  Color _tagColor(Post post) {
    if (post.type == PostType.event) return const Color(0xFF2A9D6F);
    if (post.type == PostType.opportunity) return const Color(0xFFF5A623);
    return const Color(0xFF6C63FF);
  }

  String _tagLabel(Post post) {
    return post.type == PostType.event ? 'Event' : 'Opportunity';
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        setState(() => _currentIndex = 0);
        break;
      case 1:
        setState(() => _currentIndex = 1);
        _navigateTo(const CommunitiesScreen());
        break;
      case 2:
      	setState(() => _currentIndex = 2);
        _navigateTo(const CreatePostScreen());
        break;
      case 3:
        setState(() => _currentIndex = 3);
        _navigateTo(const MyRsvpsScreen());
        break;
      case 4:
        setState(() => _currentIndex = 4);
        _navigateTo(const ChatsScreen());
        break;
    }
  }

  Widget _buildImage(
    String? url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? placeholderColor,
  }) {
    final theme = Theme.of(context);
    final fallbackPlaceholderColor =
        placeholderColor ??
        (theme.brightness == Brightness.dark
            ? const Color(0xFF1E293B)
            : const Color(0xFFE8EAF0));

    if (url == null || url.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: fallbackPlaceholderColor,
        child: Icon(
          Icons.image_outlined,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
          color: fallbackPlaceholderColor,
          child: Icon(
            Icons.image_outlined,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 32,
          ),
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
        color: fallbackPlaceholderColor,
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
        color: fallbackPlaceholderColor,
        child: Icon(
          Icons.image_outlined,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          size: 32,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstName = _currentUser?.fullName.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(firstName),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildCategories(),
              const SizedBox(height: 28),
              if (_featuredPost != null) ...[
                _buildSectionHeader('Featured'),
                const SizedBox(height: 14),
                _buildFeaturedCard(_featuredPost!),
                const SizedBox(height: 28),
              ],
              _buildSectionHeader('Latest Opportunities'),
              const SizedBox(height: 14),
              if (_latestPosts.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No posts yet',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                )
              else
                ..._latestPosts.map(
                  (post) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildOpportunityCard(post),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(String firstName) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hi, $firstName! ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Text('👋', style: TextStyle(fontSize: 22)),
              ],
            ),
            Text(
              "What's happening today?",
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => _navigateTo(const ProfilePage()),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _currentUser?.profilePictureUrl != null
                ? NetworkImage(_currentUser!.profilePictureUrl!)
                : null,
            child: _currentUser?.profilePictureUrl == null
                ? Text(
                    firstName[0].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF5A623),
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search opportunities, events, people...',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (val) {
                setState(() {
                  if (val.isEmpty) {
                    _posts = _allPosts;
                  } else {
                    _posts = _allPosts
                        .where(
                          (p) =>
                              p.title.toLowerCase().contains(val.toLowerCase()),
                        )
                        .toList();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final theme = Theme.of(context);
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final isSelected = _selectedCategory == cat['label'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['label']),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (cat['color'] as Color)
                        : (cat['color'] as Color).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    cat['icon'] as IconData,
                    color: isSelected ? Colors.white : cat['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cat['label'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        GestureDetector(
          onTap: () => _navigateTo(const MyRsvpsScreen()),
          child: Text(
            'See all',
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(Post post) {
    return GestureDetector(
      onTap: () => _navigateTo(EventDetailScreen(post: post)),
      child: Container(
        width: double.infinity,
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: _buildImage(
                  post.coverImageUrl,
                  fit: BoxFit.cover,
                  placeholderColor: const Color(0xFF1A2B3C),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      post.category,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDate(post.startTime)} • ${post.location}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          _navigateTo(EventDetailScreen(post: post)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5A623),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'View details',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(Post post) {
    final theme = Theme.of(context);
    final color = _tagColor(post);
    final tag = _tagLabel(post);

    return GestureDetector(
      onTap: () => _navigateTo(EventDetailScreen(post: post)),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: _buildImage(post.coverImageUrl, width: 80, height: 80),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            post.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      post.deadline != null
                          ? 'Apply by ${_formatDate(post.deadline)}'
                          : _formatDate(post.startTime),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      post.location,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final theme = Theme.of(context);
    return Container(
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
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 36, color: Color(0xFFF5A623)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available_outlined),
            activeIcon: Icon(Icons.event_available),
            label: 'RSVPs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
        ],
      ),
    );
  }

}

