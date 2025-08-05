import 'package:flutter/material.dart';
// Needed for Android exit
import 'dart:io'; // Needed for Windows exit

import 'package:frc_scout_app/pages/dashboard/dashboard.dart';
import 'package:frc_scout_app/pages/match_scout/match_scout.dart';
import 'package:frc_scout_app/pages/pit_scout/pit_scout.dart';
import 'package:frc_scout_app/pages/view_data/view_data.dart';
import 'package:frc_scout_app/pages/import_export/import_export.dart';
import 'package:frc_scout_app/pages/setting/setting.dart';

class AppDrawerNav extends StatelessWidget {
  const AppDrawerNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Navigation list
        Expanded(
          child: ListView(
            children: [
              _buildNavTile(context, Icons.dashboard, 'Dashboard', const Dashboard()),
              _buildNavTile(context, Icons.assignment, 'Match Scout', const MatchScout()),
              _buildNavTile(context, Icons.build, 'Pit Scout', const PitScout()),
              _buildNavTile(context, Icons.visibility, 'View Data', const ViewData()),
              _buildNavTile(context, Icons.import_export, 'Import / Export', const ImportExport()),
              _buildNavTile(context, Icons.settings, 'Settings', const Setting()),
            ],
          ),
        ),

        const Divider(),

        // Close App button with confirmation
        ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
          title: const Text(
            'Close App',
            style: TextStyle(color: Colors.redAccent),
          ),
          onTap: () => _confirmExit(context),
        ),
      ],
    );
  }

  Widget _buildNavTile(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close App'),
        content: const Text('Are you sure you want to close the app?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Exit'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog

              // ======== EXIT OPTIONS BELOW ========

              // Use this for Windows (Desktop):
              exit(0); // <-- ✅ Windows: Leave this uncommented

              // Use this for Android:
              // SystemNavigator.pop(); // <-- ✅ Android: Uncomment this and comment out exit(0)

              // =====================================
            },
          ),
        ],
      ),
    );
  }
}
