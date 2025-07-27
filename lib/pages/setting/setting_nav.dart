import 'package:flutter/material.dart';
import 'package:frc_scout_app/pages/setting/setting_pages/setting_pages_customize_match_scout.dart';
import 'setting_pages/setting_pages_appearance.dart';
import 'setting_pages/setting_pages_about.dart';
import 'setting_pages/setting_pages_disclaimer.dart';
import 'package:frc_scout_app/form/form_config.dart';

class SettingNavigator extends StatelessWidget {
  final int selectedIndex;
  final List<FormConfig> formConfigs;
  final ValueChanged<List<FormConfig>> onUpdate;

  const SettingNavigator({
    super.key,
    required this.selectedIndex,
    required this.formConfigs,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const SettingPagesAppearance();
      case 1:
        return CustomizeMatchScout(
          formConfigs: formConfigs,
          onUpdate: onUpdate,
        );
      case 2:
        return const SettingPagesDisclaimer();
      case 3:
        return const SettingPagesAbout();
      default:
        return const Center(child: Text("Unknown setting section"));
    }
  }
}
