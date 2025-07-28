import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frc_scout_app/header/app_header.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/form/form_config.dart';
import 'package:frc_scout_app/form/draggable_resizable_card.dart';

import 'package:frc_scout_app/form/basic_inputs/counter_input.dart';
import 'package:frc_scout_app/form/basic_inputs/number_input.dart';
import 'package:frc_scout_app/form/basic_inputs/switch_input.dart';
import 'package:frc_scout_app/form/basic_inputs/text_input.dart';
import 'package:frc_scout_app/form/selection_inputs/checkbox_input.dart';
import 'package:frc_scout_app/form/selection_inputs/radio_input.dart';
import 'package:frc_scout_app/form/selection_inputs/dropdown_input.dart';
import 'package:frc_scout_app/form/selection_inputs/slider_input.dart';
import 'package:frc_scout_app/form/structured_inputs/date_input.dart';
import 'package:frc_scout_app/form/structured_inputs/time_input.dart';
import 'package:frc_scout_app/form/structured_inputs/stopwatch_input.dart';

class MatchRecord {
  String recordName;
  String matchNumber;
  String robotNumber;
  bool isRedAlliance;
  String userName;
  String userEmail;
  Map<String, dynamic> formData; // key = FormConfig label or ID, value = entered data

  MatchRecord({
    required this.recordName,
    required this.matchNumber,
    required this.robotNumber,
    required this.isRedAlliance,
    required this.userName,
    required this.userEmail,
    required this.formData,
  });

  Map<String, dynamic> toJson() => {
        'recordName': recordName,
        'matchNumber': matchNumber,
        'robotNumber': robotNumber,
        'isRedAlliance': isRedAlliance,
        'userName': userName,
        'userEmail': userEmail,
        'formData': formData,
      };

  static MatchRecord fromJson(Map<String, dynamic> json) => MatchRecord(
        recordName: json['recordName'],
        matchNumber: json['matchNumber'],
        robotNumber: json['robotNumber'],
        isRedAlliance: json['isRedAlliance'],
        userName: json['userName'],
        userEmail: json['userEmail'],
        formData: Map<String, dynamic>.from(json['formData']),
      );
}

class MatchScout extends StatefulWidget {
  const MatchScout({super.key});

  @override
  State<MatchScout> createState() => _MatchScoutState();
}

class _MatchScoutState extends State<MatchScout> {
  // Keys for SharedPreferences
  static const savedConfigsKey = 'saved_form_configs';
  static const savedRecordsKey = 'saved_match_records';

  Map<String, List<FormConfig>> _savedConfigs = {};
  List<FormConfig> _currentConfig = [];
  String? _selectedConfigName;

  Map<String, MatchRecord> _savedRecords = {};
  MatchRecord? _currentRecord;

  // User info (example hardcoded, replace with your auth/user system)
  final String _userName = "John Doe";
  final String _userEmail = "john.doe@example.com";
  
  get divisions => null;

  @override
  void initState() {
    super.initState();
    _loadConfigs();
    _loadRecords();
  }

  Future<void> _loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(savedConfigsKey);

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
      if (_savedConfigs.isNotEmpty) {
        _selectedConfigName = _savedConfigs.keys.first;
        _currentConfig = _savedConfigs[_selectedConfigName!]!;
      }
    });
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(savedRecordsKey);

    Map<String, MatchRecord> records = {};
    if (raw != null) {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      decoded.forEach((key, value) {
        records[key] = MatchRecord.fromJson(value);
      });
    }

    setState(() {
      _savedRecords = records;
    });
  }

  Future<void> _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> encoded = {};
    _savedRecords.forEach((key, record) {
      encoded[key] = record.toJson();
    });
    await prefs.setString(savedRecordsKey, jsonEncode(encoded));
  }

  void _onConfigSelected(String? name) {
    if (name == null) return;
    setState(() {
      _selectedConfigName = name;
      _currentConfig = _savedConfigs[name] ?? [];
      _currentRecord = null; // reset current record when config changes
    });
  }

  void _startNewRecord(String configName) {
    if (!_savedConfigs.containsKey(configName)) return;
    final config = _savedConfigs[configName]!;

    setState(() {
      _selectedConfigName = configName;
      _currentConfig = config;
      _currentRecord = MatchRecord(
        recordName: '',
        matchNumber: '',
        robotNumber: '',
        isRedAlliance: true,
        userName: _userName,
        userEmail: _userEmail,
        formData: {}, // empty form data initially
      );
    });
  }

  Future<bool> _promptSaveCurrentRecord() async {
    if (_currentRecord == null) return true;

    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save current record?'),
        content: const Text('You have an unsaved record open. Save before continuing?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false), child: const Text('Discard')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (save == true) {
      final tempName = await _promptTempName();
      if (tempName != null && tempName.trim().isNotEmpty) {
        _currentRecord!.recordName = tempName.trim();
        _savedRecords[tempName] = _currentRecord!;
        await _saveRecords();
        setState(() {
          _currentRecord = null;
        });
        return true;
      } else {
        return false;
      }
    }
    return save ?? false;
  }

  Future<String?> _promptTempName() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter temporary record name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Temp record name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Save')),
        ],
      ),
    );
    return result;
  }

  Future<void> _openRecordManager() async {
    final canContinue = await _promptSaveCurrentRecord();
    if (!canContinue) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Saved Records', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: _savedRecords.isEmpty
                    ? const Center(child: Text('No saved records'))
                    : ListView(
                        children: _savedRecords.values.map((record) {
                          return ListTile(
                            title: Text(record.recordName),
                            subtitle: Text('Match ${record.matchNumber}, Robot ${record.robotNumber}, '
                                '${record.isRedAlliance ? "Red" : "Blue"} Alliance'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                _currentRecord = record;
                                // Load config for this record if exists, else fallback to first config
                                if (_savedConfigs.containsKey(_selectedConfigName)) {
                                  _currentConfig = _savedConfigs[_selectedConfigName!]!;
                                }
                                _selectedConfigName ??= _savedConfigs.keys.isNotEmpty ? _savedConfigs.keys.first : null;
                              });
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Record?'),
                                    content: Text('Delete record "${record.recordName}"?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                      ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  setState(() {
                                    _savedRecords.remove(record.recordName);
                                  });
                                  await _saveRecords();
                                  if (_currentRecord?.recordName == record.recordName) {
                                    _currentRecord = null;
                                  }
                                  Navigator.pop(context); // close bottom sheet
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  // Show config selector dialog for new record
                  final selectedConfig = await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Select Config for New Record'),
                      content: DropdownButton<String>(
                        value: _selectedConfigName,
                        items: _savedConfigs.keys.map((name) {
                          return DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            Navigator.pop(context, value);
                          }
                        },
                      ),
                    ),
                  );
                  if (selectedConfig != null) {
                    setState(() {
                      _startNewRecord(selectedConfig);
                    });
                  }
                },
                child: const Text('New Record'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveCurrentRecord() async {
    if (_currentRecord == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No record to save.')));
      return;
    }

    final matchNumberController = TextEditingController(text: _currentRecord!.matchNumber);
    final robotNumberController = TextEditingController(text: _currentRecord!.robotNumber);
    bool isRedAlliance = _currentRecord!.isRedAlliance;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Record'),
        content: StatefulBuilder(
          builder: (context, setStateSB) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: matchNumberController,
                  decoration: const InputDecoration(labelText: 'Match Number'),
                ),
                TextField(
                  controller: robotNumberController,
                  decoration: const InputDecoration(labelText: 'Robot Number'),
                ),
                Row(
                  children: [
                    const Text('Alliance: '),
                    Expanded(
                      child: SwitchListTile(
                        title: Text(isRedAlliance ? 'Red' : 'Blue'),
                        value: isRedAlliance,
                        onChanged: (val) {
                          setStateSB(() => isRedAlliance = val);
                        },
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: const Text('User Name'),
                  subtitle: Text(_userName),
                ),
                ListTile(
                  title: const Text('User Email'),
                  subtitle: Text(_userEmail),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );

    if (saved == true) {
      _currentRecord!
        ..matchNumber = matchNumberController.text.trim()
        ..robotNumber = robotNumberController.text.trim()
        ..isRedAlliance = isRedAlliance
        ..userName = _userName
        ..userEmail = _userEmail;

      // Save form data before saving record
      _currentRecord!.formData = _collectFormData();

      if (_currentRecord!.recordName.trim().isEmpty) {
        final tempName = await _promptTempName();
        if (tempName == null || tempName.trim().isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('You must provide a record name.')));
          return;
        }
        _currentRecord!.recordName = tempName.trim();
      }

      _savedRecords[_currentRecord!.recordName] = _currentRecord!;
      await _saveRecords();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record saved!')));
      setState(() {});
    }
  }

  // This collects current form values into a Map keyed by label (customize as needed)
  Map<String, dynamic> _collectFormData() {
    // For demo, return empty map (you need to connect this to your actual input widgets and their states)
    // You will need to store state of each input widget (controller values, selected options, etc.)
    // and collect them here to save in the record.
    return {};
  }

  Widget _buildWidget(FormConfig config) {
    switch (config.type) {
      case FormType.counter:
        return CounterInput(label: config.label);
      case FormType.number:
        return NumberInput(label: config.label);
      case FormType.lever:
        return SwitchInput(
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
        return RadioInput(label: config.label, options: optionsList);
      case FormType.dropdown:
        final optionsList = (config.extraParams['options'] as List<String>?) ?? [];
        return DropdownInput(label: config.label, options: optionsList);
      case FormType.slider:
        return SliderInput(
          label: config.label,
          min: config.extraParams['min'] ?? 0,
          max: config.extraParams['max'] ?? 10,
          divisions: divisions,
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
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'save_btn',
            onPressed: _saveCurrentRecord,
            tooltip: 'Save Record',
            child: const Icon(Icons.save),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'record_manager_btn',
            onPressed: _openRecordManager,
            tooltip: 'Open Record Manager',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
