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
  final List<FormConfig>? formConfigs;

  const MatchScout({super.key, this.formConfigs});

  @override
  State<MatchScout> createState() => _MatchScoutState();
}

class _MatchScoutState extends State<MatchScout> {
  List<FormConfig> formConfigs = [];

  @override
  void initState() {
    super.initState();
    if (widget.formConfigs != null && widget.formConfigs!.isNotEmpty) {
      formConfigs = widget.formConfigs!;
    } else {
      _loadFormConfigs();
    }
  }

  Future<void> _loadFormConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('formConfigs');
    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      setState(() {
        formConfigs = decoded.map((item) => FormConfig.fromJson(item)).toList();
      });
    }
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
          List.generate(optionsList.length, (i) => i),
          optionsList,
        );
        return RadioInput(label: config.label, options: optionsMap);
      case FormType.selection:
        final optionsList = (config.extraParams['options'] as List<String>?) ?? [];
        final optionsMap = Map.fromIterables(
          List.generate(optionsList.length, (i) => i),
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
        children: formConfigs.map((config) {
          return DraggableResizableCard(
            initialWidth: 250,
            initialHeight: 200,
            child: _buildWidget(config),
          );
        }).toList(),
      ),
    );
  }
}
