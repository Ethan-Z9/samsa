import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RecordStorage {
  static Directory? _recordsDir;
  static String? _customFolderPath;

  /// Set a custom folder path to override default location.
  /// Must be an absolute path.
  static void setCustomFolderPath(String path) {
    final dir = Directory(path);
    if (!dir.isAbsolute) {
      throw ArgumentError('Custom folder path must be an absolute path');
    }
    _customFolderPath = path;
    _recordsDir = null; // reset cached dir
  }

  // Get or create the match_records folder
  static Future<Directory> getRecordsDir() async {
    if (_recordsDir != null) return _recordsDir!;

    Directory baseDir;

    if (_customFolderPath != null) {
      baseDir = Directory(_customFolderPath!);
    } else if (Platform.isWindows) {
      baseDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      baseDir = await getApplicationDocumentsDirectory();
    } else {
      baseDir = await getApplicationDocumentsDirectory();
    }

    final recordsDir = Directory('${baseDir.path}/match_records');

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
      await for (var entity in dir.list()) {
        if (entity is File && entity.path.endsWith('.json')) {
          try {
            final content = await entity.readAsString();
            final jsonData = jsonDecode(content) as Map<String, dynamic>;
            final fileName = entity.uri.pathSegments.last;
            final recordName = fileName.replaceAll('.json', '').replaceAll('_', ' ');
            records[recordName] = jsonData;
          } catch (_) {
            // Ignore corrupted file
          }
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
