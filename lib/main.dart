import 'package:flutter/material.dart';
import 'package:frc_scout_app/app.dart';
import 'package:frc_scout_app/data/csv_loader.dart';
import 'package:frc_scout_app/data/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveInit.init();

  // Fetch CSVs from Google Sheets and cache them locally
  await CSVLoader.fetchAllCsvs();

  // Load scouts from cached CSV into Hive if empty
  if (HiveInit.scoutsBox.isEmpty) {
    final scouts = await CSVLoader.loadScouts(); // now loads from cached file
    await HiveInit.scoutsBox.addAll(scouts);
  }

  runApp(const FRCScoutApp());
}
