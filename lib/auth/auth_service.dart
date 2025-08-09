import 'dart:convert'; // for jsonDecode
import 'package:flutter/foundation.dart';
import 'package:frc_scout_app/data/hive_init.dart';

class AuthService {
  static const String _currentUserKey = 'current_user_email';

  Future<bool> login(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (!await validateScout(cleanEmail)) return false;

    // Save current user email
    await HiveInit.scoutsBox.put(_currentUserKey, {'email': cleanEmail});
    return true;
  }

  Future<void> logout() async {
    await HiveInit.scoutsBox.delete(_currentUserKey);
  }

  Future<bool> isLoggedIn() async {
    final currentEmail = await getCurrentEmail();
    return currentEmail != null && currentEmail.isNotEmpty;
  }

  Future<String?> getCurrentEmail() async {
    final userData = await HiveInit.scoutsBox.get(_currentUserKey);
    return userData?['email']?.toString();
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final email = await getCurrentEmail();
    if (email == null) return null;
    return getScoutData(email);
  }

  Future<Map<String, dynamic>?> getScoutData(String email) async {
    final scoutsList = await _getScoutsList();
    if (scoutsList == null) return null;

    final lowerEmail = email.trim().toLowerCase();
    try {
      final scout = scoutsList.firstWhere(
        (scout) => (scout['email']?.toString().toLowerCase() ?? '') == lowerEmail,
      );
      return Map<String, dynamic>.from(scout);
    } catch (_) {
      return null;
    }
  }

  Future<bool> validateScout(String email) async {
    final scoutsList = await _getScoutsList();
    if (scoutsList == null) return false;

    final lowerEmail = email.trim().toLowerCase();
    return scoutsList.any(
      (scout) => (scout['email']?.toString().toLowerCase() ?? '') == lowerEmail,
    );
  }

  /// Reads the 'data' key from scoutsBox and returns a List of scouts.
  /// Decodes JSON if stored as string.
  Future<List<dynamic>?> _getScoutsList() async {
    final box = HiveInit.scoutsBox;
    final data = box.get('data');
    if (data == null) {
      debugPrint('No scouts data found in Hive.');
      return null;
    }

    if (data is String) {
      // Data stored as JSON string, decode it
      try {
        final decoded = jsonDecode(data);
        if (decoded is List) {
          return decoded;
        } else {
          debugPrint('Decoded scouts data is not a List');
          return null;
        }
      } catch (e) {
        debugPrint('Error decoding scouts JSON string: $e');
        return null;
      }
    } else if (data is List) {
      // Data already decoded
      return data;
    } else {
      debugPrint('Scouts data is neither String nor List. Actual type: ${data.runtimeType}');
      return null;
    }
  }

  static Future<void> debugPrintAllScoutEmails() async {
    final box = HiveInit.scoutsBox;
    final data = box.get('data');
    if (data == null) {
      debugPrint('No scouts data found in Hive.');
      return;
    }

    if (data is String) {
      debugPrint('Data is a String, decoding...');
      try {
        final decoded = jsonDecode(data);
        if (decoded is List) {
          for (var scout in decoded) {
            debugPrint('Scout email (decoded): ${scout['email']}');
          }
        } else {
          debugPrint('Decoded data is not a List');
        }
      } catch (e) {
        debugPrint('Error decoding data in debugPrintAllScoutEmails: $e');
      }
    } else if (data is List) {
      for (var scout in data) {
        debugPrint('Scout email: ${scout['email']}');
      }
    } else {
      debugPrint('Scouts data is not a List or String. Actual type: ${data.runtimeType}');
    }
  }
}
