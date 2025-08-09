import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:hive/hive.dart';
import 'hive_init.dart'; // Your HiveInit class

class CSVLoader {
  /// Google Sheets export URLs mapped to box names
  static const Map<String, String> googleSheetUrls = {
    'matches_flr': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=0',
    'matches_tvr': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=1201219434',
    'matches_champs': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=905692206',
    'matches_worlds': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=881259372',
    'scouts': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=1815027224',
  };

  /// Folder for cached raw CSV files
  static Future<Directory> getCsvCacheDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${dir.path}/csv_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  static Future<File> getCsvFile(String name) async {
    final dir = await getCsvCacheDir();
    return File('${dir.path}/$name.csv');
  }

  static Future<void> saveCsvFile(String name, String content) async {
    final file = await getCsvFile(name);
    await file.writeAsString(content);
  }

  static Future<String?> readCsvFile(String name) async {
    try {
      final file = await getCsvFile(name);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (_) {}
    return null;
  }

  /// Fetch and cache a single CSV, update Hive box too
  static Future<void> fetchAndCacheCsvToHive(String boxName) async {
    final url = googleSheetUrls[boxName];
    if (url == null) throw Exception('No URL found for box: $boxName');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final csvString = response.body;
        // Save raw CSV file
        await saveCsvFile(boxName, csvString);

        // Parse CSV data
        final rows = const CsvToListConverter().convert(csvString);
        if (rows.isEmpty) throw Exception('CSV file is empty for $boxName');

        final headers = rows.first.map((e) => e.toString()).toList();
        final List<Map<String, dynamic>> parsedData = rows.skip(1).map((row) {
          final map = <String, dynamic>{};
          for (int i = 0; i < headers.length; i++) {
            map[headers[i]] = row[i];
          }
          return map;
        }).toList();

        // Save parsed data as JSON string into Hive box under key 'data'
        final box = _getHiveBoxByName(boxName);
        await box.put('data', jsonEncode(parsedData));

        debugPrint('Fetched, cached CSV and updated Hive box: $boxName');
      } else {
        throw Exception('Failed to fetch CSV for $boxName');
      }
    } catch (e) {
      debugPrint('Error fetching CSV for $boxName: $e');
      rethrow;
    }
  }

  /// Fetch and cache all CSVs and update all Hive boxes
  static Future<void> fetchAllAndCache() async {
    for (final boxName in googleSheetUrls.keys) {
      await fetchAndCacheCsvToHive(boxName);
    }
  }

  /// Load parsed data from Hive box (decodes JSON string)
  static Future<List<Map<String, dynamic>>> loadFromHive(String boxName) async {
    final box = _getHiveBoxByName(boxName);
    final jsonString = box.get('data') as String?;
    if (jsonString == null) return [];

    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.cast<Map<String, dynamic>>();
  }

  /// Helper: map box name to Hive box instance
  static Box _getHiveBoxByName(String boxName) {
    switch (boxName) {
      case 'scouts':
        return HiveInit.scoutsBox;
      case 'matches_flr':
        return HiveInit.matchesFLRBox;
      case 'matches_tvr':
        return HiveInit.matchesTVRBox;
      case 'matches_champs':
        return HiveInit.matchesChampsBox;
      case 'matches_worlds':
        return HiveInit.matchesWorldsBox;
      default:
        throw Exception('Unknown box name: $boxName');
    }
  }
}
