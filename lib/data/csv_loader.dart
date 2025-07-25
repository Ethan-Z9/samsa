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

  /// Loads the matches_flr.csv file dynamically and returns
  /// a List of Maps where each map corresponds to a row keyed by column headers.
  static Future<List<Map<String, dynamic>>> loadMatchsFLR() async {
    try {
      final csvString = await rootBundle.loadString('assets/csv/matches_flr.csv');
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
      debugPrint('CSV Load Error (matches_flr): $e');
      rethrow;
    }
  }
}
