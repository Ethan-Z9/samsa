import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveInit {
  static late Box<Map<dynamic, dynamic>> scoutsBox;

  static late Box<Map<dynamic, dynamic>> matchesFLRBox;
  static late Box<Map<dynamic, dynamic>> matchesTVRBox;
  static late Box<Map<dynamic, dynamic>> matchesChampsBox;
  static late Box<Map<dynamic, dynamic>> matchesWorldsBox;

  static Future<void> init() async {
    // Get app's documents directory
    Directory appDir = await getApplicationDocumentsDirectory();
    
    // Create custom folder path
    Directory hiveDir = Directory('${appDir.path}/hive_data');
    
    // Make sure the folder exists
    if (!await hiveDir.exists()) {
      await hiveDir.create(recursive: true);
    }

    // Initialize Hive at that custom folder
    await Hive.initFlutter(hiveDir.path);

    // Open scouts box
    scoutsBox = await Hive.openBox('scouts');

    // Open boxes for each matches dataset
    matchesFLRBox = await Hive.openBox('matches_flr');
    matchesTVRBox = await Hive.openBox('matches_tvr');
    matchesChampsBox = await Hive.openBox('matches_champs');
    matchesWorldsBox = await Hive.openBox('matches_worlds');
  }

  static Future<void> clearAllData() async {
    await scoutsBox.clear();
    await matchesFLRBox.clear();
    await matchesTVRBox.clear();
    await matchesChampsBox.clear();
    await matchesWorldsBox.clear();
  }
}
