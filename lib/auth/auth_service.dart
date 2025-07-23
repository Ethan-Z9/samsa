import 'package:flutter/foundation.dart';
import 'package:frc_scout_app/data/hive_init.dart';

class AuthService {
  static const String _currentUserKey = 'current_user_email';

  Future<bool> login(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (!await _emailExists(cleanEmail)) return false;
    
    // Create a proper Map object to store
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
    final scout = _findScoutByEmail(email.trim().toLowerCase());
    return scout?.cast<String, dynamic>();
  }

  Future<bool> validateScout(String email) async {
    return _emailExists(email.trim().toLowerCase());
  }

  Future<bool> _emailExists(String email) async {
    return HiveInit.scoutsBox.values.any(
      (scout) => scout['email']?.toString().toLowerCase() == email
    );
  }

  Map<dynamic, dynamic>? _findScoutByEmail(String email) {
    try {
      return HiveInit.scoutsBox.values.firstWhere(
        (scout) => scout['email']?.toString().toLowerCase() == email,
      );
    } catch (_) {
      return null;
    }
  }

  static void printAllScouts() {
    debugPrint('=== SCOUTS ===');
    for (var scout in HiveInit.scoutsBox.values) {
      debugPrint('${scout['email']}');
    }
  }
}