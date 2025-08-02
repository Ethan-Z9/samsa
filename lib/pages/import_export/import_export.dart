import 'package:flutter/material.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/header/app_header.dart';

import 'import/import.dart';  // your import UI widget
import 'export/export.dart';  // your export UI widget

class ImportExport extends StatelessWidget {
  const ImportExport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Import/Export'),
      drawer: const AppDrawer(),
      body: Row(
        children: const [
          Expanded(
            child: ImportPage(),  // replace with your actual import widget class name
          ),
          VerticalDivider(width: 1),
          Expanded(
            child: ExportPage(),  // replace with your actual export widget class name
          ),
        ],
      ),
    );
  }
}
