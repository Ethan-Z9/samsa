import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'form_config.dart';

class FormConfigStorage {
  static const _key = 'formConfigs';

  static Future<void> saveConfigs(List<FormConfig> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = configs.map((c) => c.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<FormConfig>> loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList.map((j) => FormConfig.fromJson(j)).toList();
  }
}
