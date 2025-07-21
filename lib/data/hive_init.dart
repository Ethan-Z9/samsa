import 'package:hive_flutter/hive_flutter.dart';

class HiveInit {
  static late Box<Map<dynamic, dynamic>> scoutsBox;
  static late Box<Map<dynamic, dynamic>> matchesBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    scoutsBox = await Hive.openBox('scouts');
    matchesBox = await Hive.openBox('matches');
  }
  
  static Future<void> clearAllData() async {
    await scoutsBox.clear();
    await matchesBox.clear();
  }
}