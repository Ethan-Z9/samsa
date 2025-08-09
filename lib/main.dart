import 'package:flutter/material.dart';
import 'package:frc_scout_app/app.dart';
import 'package:frc_scout_app/data/csv_loader.dart';
import 'package:frc_scout_app/data/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open boxes
  await HiveInit.init();

  // Fetch CSVs from Google Sheets, save raw CSV files, and update Hive boxes with parsed data
  await CSVLoader.fetchAllAndCache();

  // If scouts data missing in Hive, fetch and cache scouts CSV explicitly
  final scoutsData = HiveInit.scoutsBox.get('data');
  if (scoutsData == null) {
    await CSVLoader.fetchAndCacheCsvToHive('scouts');
  }

  runApp(const FRCScoutApp());
}
