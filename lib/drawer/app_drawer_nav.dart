import 'package:flutter/material.dart';
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
    return ListView(
      children: [
        _buildNavTile(context, Icons.dashboard, 'Dashboard', const Dashboard()),

        // Pass empty list for formConfigs for now
        _buildNavTile(
          context,
          Icons.assignment,
          'Match Scout',
          MatchScout(formConfigs: []),
        ),

        _buildNavTile(context, Icons.build, 'Pit Scout', const PitScout()),
        _buildNavTile(context, Icons.visibility, 'View Data', const ViewData()),
        _buildNavTile(context, Icons.import_export, 'Import / Export', const ImportExport()),
        _buildNavTile(context, Icons.settings, 'Settings', const Setting()),
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
}
