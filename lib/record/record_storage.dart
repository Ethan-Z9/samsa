import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RecordStorage {
  static Future<Directory> _getRecordsDir() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final recordsDir = Directory('${appDocDir.path}/match_records');
    if (!await recordsDir.exists()) {
      await recordsDir.create(recursive: true);
    }
    return recordsDir;
  }

  static Future<File> _getRecordFile(String recordName) async {
    final dir = await _getRecordsDir();
    final safeName = recordName.replaceAll(RegExp(r'[\\/:*?"<>| ]'), '_');
    return File('${dir.path}/$safeName.json');
  }

  /// Save a MatchRecord JSON map to a file named by recordName.
  static Future<void> saveRecord(String recordName, Map<String, dynamic> recordJson) async {
    final file = await _getRecordFile(recordName);
    final jsonString = jsonEncode(recordJson);
    await file.writeAsString(jsonString);
  }

  /// Load all records found in the folder, returning a Map of recordName to JSON map.
  static Future<Map<String, Map<String, dynamic>>> loadAllRecords() async {
    final dir = await _getRecordsDir();
    final records = <String, Map<String, dynamic>>{};
    if (await dir.exists()) {
      final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
      for (var file in files) {
        final content = await file.readAsString();
        try {
          final jsonData = jsonDecode(content) as Map<String, dynamic>;
          final fileName = file.uri.pathSegments.last;
          final recordName = fileName.replaceAll('.json', '').replaceAll('_', ' ');
          records[recordName] = jsonData;
        } catch (_) {
          // Ignore corrupted file
        }
      }
    }
    return records;
  }

  /// Delete a record file by recordName.
  static Future<void> deleteRecord(String recordName) async {
    final file = await _getRecordFile(recordName);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
