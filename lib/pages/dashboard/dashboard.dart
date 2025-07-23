import 'package:flutter/material.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/header/app_header.dart';
import 'dashboard_panel.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Dashboard'),
      drawer: const AppDrawer(),
      body: const DashboardPanel(),
    );
  }
}
