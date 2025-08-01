import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class CSVLoader {
  /// Loads the scouts.csv file and returns a List of maps with keys:
  /// 'firstName', 'lastName', 'grade', 'email'
  static Future<List<Map<String, dynamic>>> loadScouts() async {
    try {
      final csvData = await rootBundle.loadString('assets/csv/scouts.csv');
      final rows = const CsvToListConverter().convert(csvData);

      if (rows.isEmpty) throw Exception('CSV file is empty');

      final headers = rows.first.map((e) => e.toString()).toList();
      return rows.skip(1).map((row) {
        return {
          'firstName': row[headers.indexOf('firstName')].toString(),
          'lastName': row[headers.indexOf('lastName')].toString(),
          'grade': row[headers.indexOf('grade')].toString(),
          'email': row[headers.indexOf('email')].toString().toLowerCase(),
        };
      }).toList();
    } catch (e) {
      debugPrint('CSV Load Error (scouts): $e');
      rethrow;
    }
  }

  /// Generic CSV loader given a filename (without path)
  static Future<List<Map<String, dynamic>>> _loadMatchFile(String fileName) async {
    try {
      final csvString = await rootBundle.loadString('assets/csv/$fileName');
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
      debugPrint('CSV Load Error ($fileName): $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> loadMatchsFLR() =>
      _loadMatchFile('matches_flr.csv');

  static Future<List<Map<String, dynamic>>> loadMatchsTVR() =>
      _loadMatchFile('matches_tvr.csv');

  static Future<List<Map<String, dynamic>>> loadMatchsChamps() =>
      _loadMatchFile('matches_champs.csv');
}
