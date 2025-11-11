import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Conversation> _allConversations = _mockConversations;
  late List<Conversation> _filtered;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _filtered = List.of(_allConversations);
    _searchController.addListener(_handleSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = List.of(_allConversations);
      } else {
        _filtered = _allConversations
            .where((c) => c.name.toLowerCase().contains(query) ||
                c.lastMessage.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    // Simulate a network refresh
    await Future<void>.delayed(const Duration(milliseconds: 800));
    setState(() => _isRefreshing = false);
  }

  void _openNewChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Open New Contact Selection (to be implemented)')),
    );
  }

  void _openSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Open Settings (to be implemented)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messenger'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: _filtered.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Text(
                              _isRefreshing
                                  ? 'Refreshing…'
                                  : 'No conversations found',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 0),
                      itemBuilder: (context, index) {
                        final c = _filtered[index];
                        return ConversationTile(
                          conversation: c,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Open chat with ${c.name} (to be implemented)')),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewChat,
        tooltip: 'New message',
        child: const Icon(Icons.message_outlined),
      ),
    );
  }
}

class Conversation {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastTime;
  final int unreadCount;
  final String? avatarUrl; // if null, use initials

  const Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastTime,
    this.unreadCount = 0,
    this.avatarUrl,
  });
}

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback? onTap;
  const ConversationTile({super.key, required this.conversation, this.onTap});

  @override
  Widget build(BuildContext context) {
    final timeText = _formatTime(conversation.lastTime);
    return ListTile(
      onTap: onTap,
      leading: _Avatar(name: conversation.name, avatarUrl: conversation.avatarUrl),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: 8),
      Text(
    timeText,
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context)
          .colorScheme
          .onSurface
          .withValues(alpha: 0.7),
        ),
      ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
    child: Text(
      conversation.lastMessage,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color:
        Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
      ),
    ),
      ),
      trailing: conversation.unreadCount > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                conversation.unreadCount.toString(),
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            )
          : null,
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    if (isToday) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ampm';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = dt.year == yesterday.year && dt.month == yesterday.month && dt.day == yesterday.day;
    if (isYesterday) return 'Yesterday';
    return '${dt.month}/${dt.day}/${dt.year}';
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  const _Avatar({required this.name, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(backgroundImage: NetworkImage(avatarUrl!));
    }
    final initials = _initialsFromName(name);
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        initials,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
      ),
    );
  }

  String _initialsFromName(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

// --- Mock data below ---

final List<Conversation> _mockConversations = [
  Conversation(
    id: '1',
    name: 'Alice Johnson',
    lastMessage: 'See you soon! 👋',
    lastTime: DateTime.now().subtract(const Duration(minutes: 5)),
    unreadCount: 2,
  ),
  Conversation(
    id: '2',
    name: 'Bob Chen',
    lastMessage: 'Sent a photo',
    lastTime: DateTime.now().subtract(const Duration(minutes: 12)),
    unreadCount: 0,
  ),
  Conversation(
    id: '3',
    name: 'Design Team',
    lastMessage: 'Let’s finalize the color palette.',
    lastTime: DateTime.now().subtract(const Duration(hours: 2)),
    unreadCount: 5,
  ),
  Conversation(
    id: '4',
    name: 'Mom',
    lastMessage: 'Dinner at 7?',
    lastTime: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    unreadCount: 0,
  ),
  Conversation(
    id: '5',
    name: 'Project Group',
    lastMessage: 'I pushed the latest changes to Git.',
    lastTime: DateTime.now().subtract(const Duration(days: 3)),
    unreadCount: 1,
  ),
];
