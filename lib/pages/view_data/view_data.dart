import 'package:flutter/material.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/header/app_header.dart';

class ViewData extends StatelessWidget {
  const ViewData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'View Data'),
      body: const Center(child: Text('Content here')),
      drawer: const AppDrawer(),
    );
  }
}
