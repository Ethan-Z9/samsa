import 'package:flutter/cupertino.dart';

class DashboardPanelNavCommands {
  static Color? getCellColor({
    required String columnKey,
    required dynamic cellValue,
    int? highlightedTeam,
    String? highlightedScout,
    String? currentUserEmail,
    bool highlightUserScout = false,
  }) {
    // User assignments highlight (GREEN - highest priority)
    if (highlightUserScout && 
        currentUserEmail != null &&
        columnKey.contains('scout')) {
      final userScout = _shortenScoutEmail(currentUserEmail);
      final cellScout = _shortenScoutEmail(cellValue.toString());
      if (cellScout == userScout) {
        return const Color.fromARGB(150, 0, 255, 0); // Green
      }
    }

    // Team search highlight (YELLOW)
    if (highlightedTeam != null && 
        columnKey.contains('robot') && 
        cellValue == highlightedTeam) {
      return const Color.fromARGB(150, 255, 255, 0); // Yellow
    }

    // Scout search highlight (BLUE)
    if (highlightedScout != null && 
        columnKey.contains('scout')) {
      final cellScout = _shortenScoutEmail(cellValue.toString());
      if (cellScout.contains(highlightedScout.toLowerCase())) {
        return const Color.fromARGB(150, 0, 0, 255); // Blue
      }
    }

    return null;
  }

  static String _shortenScoutEmail(String email) {
    final prefix = email.split('@')[0];
    final letters = prefix.replaceAll(RegExp(r'\d'), '');
    final firstTwoLetters = letters.length >= 2 ? letters.substring(0, 2) : letters;
    final digits = prefix.replaceAll(RegExp(r'\D'), '');
    final firstDigit = digits.isNotEmpty ? digits[0] : '';
    return '$firstTwoLetters$firstDigit'.toLowerCase();
  }
}