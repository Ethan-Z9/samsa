import 'package:flutter/material.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/header/app_header.dart';

class MatchScout extends StatelessWidget {
  const MatchScout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Match Scout'),
      body: const Center(child: Text('Content here')),
      drawer: const AppDrawer(),
    );
  }
}
