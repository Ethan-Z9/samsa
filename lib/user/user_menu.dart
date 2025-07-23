import 'package:flutter/material.dart';
import 'package:frc_scout_app/auth/auth_service.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.account_circle),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
          ),
        ),
      ],
      onSelected: (value) async {
        if (value == 'logout') {
          await AuthService().logout();
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login', 
            (route) => false,  // Remove all existing routes
          );
        }
      },
    );
  }
}