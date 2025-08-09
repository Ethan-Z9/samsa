import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveInit {
  static late Box scoutsBox;
  static late Box matchesFLRBox;
  static late Box matchesTVRBox;
  static late Box matchesChampsBox;
  static late Box matchesWorldsBox;

  static Future<void> init() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    Directory hiveDir = Directory('${appDir.path}/hive_data');

    if (!await hiveDir.exists()) {
      await hiveDir.create(recursive: true);
    }

    await Hive.initFlutter(hiveDir.path);

    scoutsBox = await Hive.openBox('scouts');
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
