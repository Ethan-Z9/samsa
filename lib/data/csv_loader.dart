import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

/// Google Sheets export URLs mapped to local CSV filenames
const Map<String, String> googleSheetUrls = {
  'matches_flr': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=0',
  'matches_tvr': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=1201219434',
  'matches_champs': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=905692206',
  'matches_worlds': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=881259372',
  'scouts': 'https://docs.google.com/spreadsheets/d/17okPy9e4EeNwetLvIwmrVakDecikzmwcZFkKpMRvcJI/export?format=csv&gid=1815027224',
};

/// Helper class for local file caching of CSVs
class CSVStorage {
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

  static Future<void> saveCsv(String name, String content) async {
    final file = await getCsvFile(name);
    await file.writeAsString(content);
  }

  static Future<String?> readCsv(String name) async {
    try {
      final file = await getCsvFile(name);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (_) {}
    return null;
  }
}

/// Service to fetch and load CSV data
class CSVLoader {
  /// Fetches and caches all CSV files from Google Sheets
  static Future<void> fetchAllCsvs() async {
    for (final entry in googleSheetUrls.entries) {
      await _fetchAndCacheCsv(entry.key, entry.value);
    }
  }

  /// Fetch a single CSV and save it to cache
  static Future<void> _fetchAndCacheCsv(String name, String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await CSVStorage.saveCsv(name, response.body);
        debugPrint('Fetched and cached: $name');
      } else {
        throw Exception('Failed to load $name from Google Sheets');
      }
    } catch (e) {
      debugPrint('Error fetching $name: $e');
    }
  }

  /// Load a cached CSV and return parsed rows
  static Future<List<Map<String, dynamic>>> loadCsv(String name) async {
    try {
      final csvString = await CSVStorage.readCsv(name);
      if (csvString == null) throw Exception('No cached CSV found: $name');

      final rows = const CsvToListConverter().convert(csvString);
      if (rows.isEmpty) throw Exception('CSV file is empty');

      final headers = rows.first.map((e) => e.toString()).toList();

      return rows.skip(1).map((row) {
        final Map<String, dynamic> rowMap = {};
        for (int i = 0; i < headers.length; i++) {
          rowMap[headers[i]] = row[i];
        }
        return rowMap;
      }).toList();
    } catch (e) {
      debugPrint('CSV Load Error ($name): $e');
      rethrow;
    }
  }

  // Match loaders
  static Future<List<Map<String, dynamic>>> loadMatchsFLR() => loadCsv('matches_flr');
  static Future<List<Map<String, dynamic>>> loadMatchsTVR() => loadCsv('matches_tvr');
  static Future<List<Map<String, dynamic>>> loadMatchsChamps() => loadCsv('matches_champs');
  static Future<List<Map<String, dynamic>>> loadMatchsWorlds() => loadCsv('matches_worlds');

  // Scout loader
  static Future<List<Map<String, dynamic>>> loadScouts() => loadCsv('scouts');
}
