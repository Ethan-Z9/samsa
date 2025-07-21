import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frc_scout_app/app.dart';
import 'package:frc_scout_app/data/csv_loader.dart';
import 'package:frc_scout_app/data/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await HiveInit.init();
  
  // Load initial data if empty
  if (HiveInit.scoutsBox.isEmpty) {
    final scouts = await CSVLoader.loadScouts();
    await HiveInit.scoutsBox.addAll(scouts);
  }

  runApp(const FRCScoutApp());
}