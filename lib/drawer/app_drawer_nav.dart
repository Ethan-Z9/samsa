import 'package:flutter/material.dart';

class AppDrawerNav {
  static List<Widget> getDrawerItems(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.dashboard),
        title: const Text('Dashboard'),
        onTap: () {
          Navigator.pop(context); // Close drawer first
          Navigator.pushReplacementNamed(context, '/dashboard');
        },
      ),
      ListTile(
        leading: const Icon(Icons.people),
        title: const Text('Match Scout'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/match-scout');
        },
      ),
      // Add more navigation items as needed
    ];
  }
}