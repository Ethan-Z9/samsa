import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class CSVLoader {
  static Future<List<Map<String, dynamic>>> loadScouts() async {
    try {
      final csvData = await rootBundle.loadString('assets/csv/scouts.csv'); // Updated path
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
      debugPrint('CSV Load Error: $e');
      rethrow; // Better for debugging
    }
  }
}