import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RecordStorage {
  static Directory? _recordsDir;

  // Get or create the match_records folder
  static Future<Directory> getRecordsDir() async {
    if (_recordsDir != null) return _recordsDir!;

    final appDocDir = await getApplicationDocumentsDirectory();
    final recordsDir = Directory('${appDocDir.path}/match_records');
    print('Trying to get/create folder at: ${recordsDir.path}');
    if (!await recordsDir.exists()) {
      print('Folder does not exist. Creating records folder now...');
      await recordsDir.create(recursive: true);
    } else {
      print('Folder already exists.');
    }
    _recordsDir = recordsDir;
    return _recordsDir!;
  }

  // Sanitize file name
  static String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[\\/:*?"<>| ]'), '_');
  }

  // Get file for a specific record
  static Future<File> _getRecordFile(String recordName) async {
    final dir = await getRecordsDir();
    final safeName = _sanitizeFileName(recordName);
    return File('${dir.path}/$safeName.json');
  }

  // Save a MatchRecord JSON map to a file
  static Future<void> saveRecord(String recordName, Map<String, dynamic> recordJson) async {
    final file = await _getRecordFile(recordName);
    final jsonString = jsonEncode(recordJson);
    await file.writeAsString(jsonString);
  }

  // Load all records
  static Future<Map<String, Map<String, dynamic>>> loadAllRecords() async {
    final dir = await getRecordsDir();
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

  // Delete a record file
  static Future<void> deleteRecord(String recordName) async {
    final file = await _getRecordFile(recordName);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
