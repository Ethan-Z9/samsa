import 'package:flutter/material.dart';
import 'package:frc_scout_app/app.dart';
import 'package:frc_scout_app/data/csv_loader.dart';
import 'package:frc_scout_app/data/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveInit.init();

  // Fetch and save all CSVs from Google Sheets (e.g., scouts, matches)
  await CSVLoader.fetchAllCsvs();

  // Optionally populate scoutsBox if it's empty
  if (HiveInit.scoutsBox.isEmpty) {
    final scouts = await CSVLoader.loadScouts(); // should read from local cache
    await HiveInit.scoutsBox.addAll(scouts);
  }

  runApp(const FRCScoutApp());
}
