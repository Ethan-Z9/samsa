import 'package:flutter/material.dart';
import 'package:frc_scout_app/pages/setting/setting_pages/setting_pages_customize_match_scout';
import 'setting_pages/setting_pages_appearance.dart';
import 'setting_pages/setting_pages_about.dart';
import 'setting_pages/setting_pages_disclaimer.dart';

class SettingNavigator extends StatelessWidget {
  final int selectedIndex;

  const SettingNavigator({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const SettingPagesAppearance();
      case 1:
        return const CustomizeMatchScout();
      case 2:
        return const SettingPagesDisclaimer();
      case 3:
        return const SettingPagesAbout();
      default:
        return const Center(child: Text("Unknown setting section"));
    }
  }
}
