import 'package:flutter/material.dart';
import 'package:frc_scout_app/header/app_header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Dashboard'),
      body: const Center(child: Text('Dashboard Content')),
    );
  }
}