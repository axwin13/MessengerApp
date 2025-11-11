import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = const [
      'Alice Johnson',
      'Bob Chen',
      'Charlie Kim',
      'Diana Patel',
      'Ethan Clark',
      'Fiona Zhang',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('New Message')),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final name = contacts[index];
          return ListTile(
            leading: CircleAvatar(child: Text(name.substring(0, 1))),
            title: Text(name),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/chat',
                arguments: {
                  'id': 'contact-$index',
                  'name': name,
                },
              );
            },
          );
        },
      ),
    );
  }
}