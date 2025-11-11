import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/setting_item.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _lastSeen = true;
  bool _readReceipts = true;
  String _notificationSound = 'Default';
  bool _messageNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileSection(),
          const SizedBox(height: 24),
          _buildSettingsCategory(
            title: 'Privacy',
            icon: Icons.lock_outline,
            items: _buildPrivacySettings(),
          ),
          const SizedBox(height: 16),
          _buildSettingsCategory(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            items: _buildNotificationSettings(),
          ),
          const SizedBox(height: 16),
          _buildSettingsCategory(
            title: 'Chat Settings',
            icon: Icons.chat_bubble_outline,
            items: _buildChatSettings(),
          ),
          const SizedBox(height: 16),
          _buildSettingsCategory(
            title: 'Account',
            icon: Icons.person_outline,
            items: _buildAccountSettings(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(
              Icons.person,
              size: 32,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ashwin K J',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Available',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ashwin.k.j@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit profile functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCategory({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    );
  }

  List<Widget> _buildPrivacySettings() {
    return [
      SettingItem(
        title: 'Last seen',
        subtitle: 'Everyone',
        type: SettingItemType.toggle,
        value: _lastSeen,
        onToggle: (value) => setState(() => _lastSeen = value),
      ),
      SettingItem(
        title: 'Read receipts',
        type: SettingItemType.toggle,
        value: _readReceipts,
        onToggle: (value) => setState(() => _readReceipts = value),
      ),
      const SettingItem(
        title: 'Block list',
        type: SettingItemType.navigation,
      ),
    ];
  }

  List<Widget> _buildNotificationSettings() {
    return [
      SettingItem(
        title: 'Message notifications',
        type: SettingItemType.toggle,
        value: _messageNotifications,
        onToggle: (value) => setState(() => _messageNotifications = value),
      ),
      SettingItem(
        title: 'Notification sound',
        type: SettingItemType.selection,
        selectedOption: _notificationSound,
        options: const ['Default', 'None', 'Note', 'Chime', 'Bell'],
        onOptionSelected: (value) => setState(() => _notificationSound = value),
      ),
    ];
  }

  List<Widget> _buildChatSettings() {
    return [
      const SettingItem(
        title: 'Chat backup',
        subtitle: 'Back up your chats to cloud storage',
        type: SettingItemType.navigation,
      ),
      const SettingItem(
        title: 'Chat history',
        type: SettingItemType.navigation,
      ),
    ];
  }

  List<Widget> _buildAccountSettings() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return [
      SettingItem(
        title: 'Dark Mode',
        type: SettingItemType.toggle,
        value: themeProvider.isDarkMode,
        onToggle: (value) => themeProvider.toggleTheme(),
      ),
      const SettingItem(
        title: 'Change number',
        type: SettingItemType.navigation,
      ),
      const SettingItem(
        title: 'Delete account',
        type: SettingItemType.navigation,
      ),
      const SettingItem(
        title: 'Logout',
        type: SettingItemType.navigation,
      ),
    ];
  }
}