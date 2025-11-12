import 'package:flutter/material.dart';

enum SettingItemType { toggle, navigation, selection }

class SettingItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final SettingItemType type;

  // Toggle
  final bool value;
  final ValueChanged<bool>? onToggle;

  // Navigation
  final VoidCallback? onTap;

  // Selection
  final String? selectedOption;
  final List<String>? options;
  final ValueChanged<String>? onOptionSelected;

  const SettingItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.type,
    this.value = false,
    this.onToggle,
    this.onTap,
    this.selectedOption,
    this.options,
    this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SettingItemType.toggle:
        return SwitchListTile(
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          value: value,
          onChanged: onToggle,
        );
      case SettingItemType.navigation:
        return ListTile(
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        );
      case SettingItemType.selection:
        return ListTile(
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedOption != null)
                Text(
                  selectedOption!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () => _showOptionsSheet(context),
        );
    }
  }

  void _showOptionsSheet(BuildContext context) {
    final opts = options ?? const <String>[];
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final opt in opts)
                ListTile(
                  title: Text(opt),
                  trailing: opt == selectedOption ? const Icon(Icons.check) : null,
                  onTap: () {
                    Navigator.pop(context);
                    if (onOptionSelected != null) {
                      onOptionSelected!(opt);
                    }
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
