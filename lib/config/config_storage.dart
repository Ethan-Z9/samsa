import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:frc_scout_app/form/form_config.dart';

class ConfigStorage {
  static Directory? _configsDir;

  // Get or create the configs folder in the app documents directory
  static Future<Directory> getConfigsDir() async {
    if (_configsDir != null) return _configsDir!;

    final appDocDir = await getApplicationDocumentsDirectory();
    final configsDir = Directory('${appDocDir.path}/configs');
    print('Trying to get/create folder at: ${configsDir.path}');
    if (!await configsDir.exists()) {
      print('Folder does not exist. Creating configs folder now...');
      await configsDir.create(recursive: true);
    } else {
      print('Folder already exists.');
    }
    _configsDir = configsDir;
    return _configsDir!;
  }

  // Sanitize file names to avoid invalid characters
  static String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  }

  // List all config names (filenames without extension)
  static Future<List<String>> getConfigNames() async {
    final dir = await getConfigsDir();
    final files = dir.listSync().whereType<File>().toList();
    final names = <String>[];
    for (var file in files) {
      final filename = file.uri.pathSegments.last;
      if (filename.endsWith('.json')) {
        names.add(filename.substring(0, filename.length - 5)); // remove .json
      }
    }
    return names;
  }

  // Load a config by name
  static Future<List<FormConfig>> loadConfig(String name) async {
    final dir = await getConfigsDir();
    final fileName = _sanitizeFileName(name) + '.json';
    final file = File('${dir.path}/$fileName');
    if (!await file.exists()) {
      print('Config file not found: $fileName');
      return [];
    }
    final content = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(content);
    return jsonList.map((e) => FormConfig.fromJson(e)).toList();
  }

  // Save a config by name
  static Future<void> saveConfig(String name, List<FormConfig> configs) async {
    final dir = await getConfigsDir();
    final fileName = _sanitizeFileName(name) + '.json';
    final file = File('${dir.path}/$fileName');
    final jsonList = configs.map((c) => c.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
    print('Config saved: $fileName');
  }

  // Delete a config by name
  static Future<void> deleteConfig(String name) async {
    final dir = await getConfigsDir();
    final fileName = _sanitizeFileName(name) + '.json';
    final file = File('${dir.path}/$fileName');
    if (await file.exists()) {
      await file.delete();
      print('Config deleted: $fileName');
    } else {
      print('Config to delete not found: $fileName');
    }
  }
}
