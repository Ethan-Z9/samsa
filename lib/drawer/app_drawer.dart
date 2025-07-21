import 'package:flutter/material.dart';
import 'package:frc_scout_app/drawer/app_drawer_nav.dart'; // Correct import

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('FRC Scout Menu'),
          ),
          ...AppDrawerNav.getDrawerItems(context), // Changed from DrawerNav to AppDrawerNav
        ],
      ),
    );
  }
}