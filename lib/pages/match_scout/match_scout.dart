import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frc_scout_app/header/app_header.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/form/form_config.dart';
import 'package:frc_scout_app/form/draggable_resizable_card.dart';

import 'package:frc_scout_app/form/basic_inputs/counter.dart';
import 'package:frc_scout_app/form/basic_inputs/number.dart';
import 'package:frc_scout_app/form/basic_inputs/toggle_switch.dart';
import 'package:frc_scout_app/form/basic_inputs/text_input.dart';
import 'package:frc_scout_app/form/selection_inputs/checkbox.dart';
import 'package:frc_scout_app/form/selection_inputs/radio.dart';
import 'package:frc_scout_app/form/selection_inputs/selection.dart';
import 'package:frc_scout_app/form/selection_inputs/slider.dart';
import 'package:frc_scout_app/form/structured_inputs/date.dart';
import 'package:frc_scout_app/form/structured_inputs/time.dart';
import 'package:frc_scout_app/form/structured_inputs/stopwatch.dart';

class MatchScout extends StatefulWidget {
  const MatchScout({super.key});

  @override
  State<MatchScout> createState() => _MatchScoutState();
}

class _MatchScoutState extends State<MatchScout> {
  Map<String, List<FormConfig>> _savedConfigs = {};
  List<FormConfig> _currentConfig = [];
  String? _selectedConfigName;

  static const savedConfigsKey = 'saved_form_configs';
  static const defaultConfigNameKey = 'default_form_config_name';

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(savedConfigsKey);
    final defaultName = prefs.getString(defaultConfigNameKey);

    Map<String, List<FormConfig>> configs = {};
    if (raw != null) {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      decoded.forEach((key, value) {
        final List<dynamic> listJson = value;
        configs[key] = listJson.map((e) => FormConfig.fromJson(e)).toList();
      });
    }

    setState(() {
      _savedConfigs = configs;
      _selectedConfigName = defaultName ?? (configs.keys.isNotEmpty ? configs.keys.first : null);
      _currentConfig = _selectedConfigName != null ? configs[_selectedConfigName!] ?? [] : [];
    });
  }

  void _onConfigSelected(String? name) {
    if (name == null) return;
    setState(() {
      _selectedConfigName = name;
      _currentConfig = _savedConfigs[name] ?? [];
    });
  }

  void _openConfigSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Config', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedConfigName,
              items: _savedConfigs.keys.map((name) {
                return DropdownMenuItem(
                  value: name,
                  child: Text(name),
                );
              }).toList(),
              onChanged: (name) {
                Navigator.pop(context);
                _onConfigSelected(name);
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidget(FormConfig config) {
    switch (config.type) {
      case FormType.counter:
        return Counter(label: config.label);
      case FormType.number:
        return Number(label: config.label);
      case FormType.switchInput:
        return ToggleSwitch(
          label: config.label,
          leftLabel: config.extraParams['leftLabel'] ?? 'Off',
          rightLabel: config.extraParams['rightLabel'] ?? 'On',
        );
      case FormType.text:
        return TextInput(label: config.label);
      case FormType.checkbox:
        return CheckboxInput(label: config.label);
      case FormType.radio:
        final optionsList = (config.extraParams['options'] as List<String>?) ?? [];
        final optionsMap = Map.fromIterables(
          List.generate(optionsList.length, (index) => index),
          optionsList,
        );
        return RadioInput(label: config.label, options: optionsMap);
      case FormType.selection:
        final optionsList = (config.extraParams['options'] as List<String>?) ?? [];
        final optionsMap = Map.fromIterables(
          List.generate(optionsList.length, (index) => index),
          optionsList,
        );
        return Selection(label: config.label, options: optionsMap);
      case FormType.slider:
        return SliderInput(
          label: config.label,
          min: config.extraParams['min'] ?? 0,
          max: config.extraParams['max'] ?? 10,
        );
      case FormType.date:
        return DateInput(label: config.label);
      case FormType.time:
        return TimeInput(label: config.label);
      case FormType.stopwatch:
        return StopwatchInput(label: config.label);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Match Scout'),
      drawer: const AppDrawer(),
      body: Stack(
        children: _currentConfig.map((config) {
          return DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: _buildWidget(config),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openConfigSelector,
        tooltip: 'Select Config',
        child: const Icon(Icons.add),
      ),
    );
  }
}
