import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frc_scout_app/record/record_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frc_scout_app/header/app_header.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/form/form_config.dart';
import 'package:frc_scout_app/form/draggable_resizable_card.dart';

import 'package:frc_scout_app/form/basic_inputs/counter_input.dart';
import 'package:frc_scout_app/form/basic_inputs/number_input.dart';
import 'package:frc_scout_app/form/basic_inputs/lever_input.dart';
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
  Map<String, dynamic> formData;

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
  static const savedConfigsKey = 'saved_form_configs';
  static const savedRecordsKey = 'saved_match_records';

  Map<String, List<FormConfig>> _savedConfigs = {};
  List<FormConfig> _currentConfig = [];
  String? _selectedConfigName;

  Map<String, MatchRecord> _savedRecords = {};
  MatchRecord? _currentRecord;

  bool _isCurrentRecordSaved = true;

  Map<String, dynamic> _formValues = {};

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
      _currentRecord = null;
      _isCurrentRecordSaved = true;
      _formValues.clear();
    });
  }

  void _startNewRecord(String configName) {
    if (!_savedConfigs.containsKey(configName)) return;
    final config = _savedConfigs[configName]!;

    setState(() {
      _selectedConfigName = configName;
      _currentConfig = config;
      _currentRecord = MatchRecord(
        recordName: 'New Record ${DateTime.now().toString()}',
        matchNumber: '',
        robotNumber: '',
        isRedAlliance: true,
        userName: _userName,
        userEmail: _userEmail,
        formData: {},
      );
      _isCurrentRecordSaved = false;
      _formValues.clear();
    });
  }

  Future<bool> _promptSaveCurrentRecord() async {
    if (_currentRecord == null || _isCurrentRecordSaved) return true;

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
      _currentRecord!.formData = _collectFormData();
      _savedRecords[_currentRecord!.recordName] = _currentRecord!;
      await _saveRecords();
      setState(() {
        _currentRecord = null;
        _isCurrentRecordSaved = true;
        _formValues.clear();
      });
      return true;
    }
    return save ?? false;
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
                                _formValues = Map<String, dynamic>.from(record.formData);
                                if (_savedConfigs.containsKey(_selectedConfigName)) {
                                  _currentConfig = _savedConfigs[_selectedConfigName!]!;
                                }
                                _selectedConfigName ??= _savedConfigs.keys.isNotEmpty ? _savedConfigs.keys.first : null;
                                _isCurrentRecordSaved = true;
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
                                    _formValues.clear();
                                    _isCurrentRecordSaved = true;
                                  }
                                  Navigator.pop(context);
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
                  onChanged: (val) => _markCurrentRecordDirty(label: 'Match Number', value: val),
                ),
                TextField(
                  controller: robotNumberController,
                  decoration: const InputDecoration(labelText: 'Robot Number'),
                  onChanged: (val) => _markCurrentRecordDirty(label: 'Robot Number', value: val),
                ),
                Row(
                  children: [
                    const Text('Alliance: '),
                    Expanded(
                      child: SwitchListTile(
                        title: Text(isRedAlliance ? 'Red' : 'Blue'),
                        value: isRedAlliance,
                        onChanged: (val) {
                          setStateSB(() {
                            isRedAlliance = val;
                          });
                          _markCurrentRecordDirty(label: 'Alliance', value: val);
                        },
                      ),
                    ),
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Record Name'),
                  controller: TextEditingController(text: _currentRecord!.recordName),
                  onChanged: (val) {
                    _currentRecord!.recordName = val;
                    _markCurrentRecordDirty(label: 'Record Name', value: val);
                  },
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

      _currentRecord!.formData = _collectFormData();

      if (_currentRecord!.recordName.trim().isEmpty) {
        _currentRecord!.recordName = 'New Record ${DateTime.now().toString()}';
      }

      _savedRecords[_currentRecord!.recordName] = _currentRecord!;

      // Save to local JSON file here:
      await RecordStorage.saveRecord(_currentRecord!.recordName, _currentRecord!.toJson());

      // Also keep the SharedPreferences backup if you want
      await _saveRecords();

      _isCurrentRecordSaved = true;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record saved!')));
      setState(() {});
    }
  }

  Map<String, dynamic> _collectFormData() {
    return _formValues;
  }

  void _markCurrentRecordDirty({required String label, dynamic value}) {
    if (_isCurrentRecordSaved) {
      setState(() {
        _isCurrentRecordSaved = false;
      });
    }
    _formValues[label] = value;
  }

  Widget _buildWidget(FormConfig config) {
    switch (config.type) {
      case FormType.counter:
        return CounterInput(
          label: config.label,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.number:
        return NumberInput(
          label: config.label,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.lever:
        return LeverInput(
          label: config.label,
          leftLabel: config.extraParams['leftLabel'] ?? 'Off',
          rightLabel: config.extraParams['rightLabel'] ?? 'On',
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.text:
        return TextInput(
          label: config.label,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.checkbox:
        return CheckboxInput(
          label: config.label,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.radio:
        final optionsList = (config.extraParams['options'] as List<String>?) ?? [];
        return RadioInput(
          label: config.label,
          options: optionsList,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.dropdown:
        final optionsList = (config.extraParams['options'] as List<String>?) ?? [];
        return DropdownInput(
          label: config.label,
          options: optionsList,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.slider:
        return SliderInput(
          label: config.label,
          min: config.extraParams['min'] ?? 0,
          max: config.extraParams['max'] ?? 10,
          divisions: divisions,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.date:
        return DateInput(
          label: config.label,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.time:
        return TimeInput(
          label: config.label,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
      case FormType.stopwatch:
        return StopwatchInput(
          label: config.label,
          onChanged: (val) => _markCurrentRecordDirty(label: config.label, value: val),
        );
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
            key: ValueKey(config.label),
            initialWidth: 250,
            initialHeight: 200,
            child: _buildWidget(config),
          );
        }).toList(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'record_manager',
            onPressed: _openRecordManager,
            tooltip: 'Manage Records',
            child: const Icon(Icons.folder_open),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'save_record',
            onPressed: _saveCurrentRecord,
            tooltip: 'Save Record',
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}