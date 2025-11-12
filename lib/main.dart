import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';
import 'screens/contacts_page.dart';
import 'screens/settings_page.dart';
import 'screens/chat_page.dart';
import 'providers/theme_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/settings_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => ChatProvider()),
    ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Messenger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/contacts':
            return MaterialPageRoute(builder: (_) => const ContactsPage());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsPage());
          case '/chat':
            final args = settings.arguments as Map<String, dynamic>?;
            final id = args != null ? args['id'] as String? : null;
            final name = args != null ? args['name'] as String? : null;
            return MaterialPageRoute(
              builder: (_) => ChatPage(
                chatId: id ?? 'unknown',
                title: name ?? 'Chat',
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}

// HomePage implementation moved to screens/home_page.dart
