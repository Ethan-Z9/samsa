import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frc_scout_app/form/form_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomizeMatchScout extends StatefulWidget {
  final List<FormConfig> formConfigs;
  final void Function(List<FormConfig>) onUpdate;

  const CustomizeMatchScout({
    super.key,
    required this.formConfigs,
    required this.onUpdate,
  });

  @override
  State<CustomizeMatchScout> createState() => _CustomizeMatchScoutState();
}

class _CustomizeMatchScoutState extends State<CustomizeMatchScout> {
  late List<FormConfig> _configs;
  final TextEditingController _nameController = TextEditingController();
  bool _setAsDefault = false;

  static const savedConfigsKey = 'saved_form_configs';
  static const defaultConfigNameKey = 'default_form_config_name';

  @override
  void initState() {
    super.initState();
    _configs = List.from(widget.formConfigs);
  }

  Future<Map<String, List<FormConfig>>> _loadAllConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(savedConfigsKey);
    if (raw == null) return {};

    final Map<String, dynamic> decoded = jsonDecode(raw);
    final Map<String, List<FormConfig>> configs = {};

    decoded.forEach((key, value) {
      final List<dynamic> listJson = value;
      final listConfigs = listJson.map((e) => FormConfig.fromJson(e)).toList();
      configs[key] = listConfigs;
    });

    return configs;
  }

  Future<void> _saveAllConfigs(Map<String, List<FormConfig>> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> encoded = {};
    configs.forEach((key, value) {
      encoded[key] = value.map((c) => c.toJson()).toList();
    });
    await prefs.setString(savedConfigsKey, jsonEncode(encoded));
  }

  Future<void> _saveDefaultConfigName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(defaultConfigNameKey, name);
  }

  Future<String?> _loadDefaultConfigName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(defaultConfigNameKey);
  }

  void _addFormInput(FormType type) async {
    final controller = TextEditingController();
    Map<String, dynamic> extraParams = {};

    final result = await showDialog<FormConfig?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Input Field'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Label'),
              ),
              if (type == FormType.switchInput) ...[
                TextField(
                  decoration: const InputDecoration(labelText: 'Left Label'),
                  onChanged: (value) => extraParams['leftLabel'] = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Right Label'),
                  onChanged: (value) => extraParams['rightLabel'] = value,
                ),
              ] else if (type == FormType.radio || type == FormType.selection) ...[
                TextField(
                  decoration: const InputDecoration(labelText: 'Options (comma separated)'),
                  onChanged: (value) => extraParams['options'] =
                      value.split(',').map((s) => s.trim()).toList(),
                ),
              ] else if (type == FormType.slider) ...[
                TextField(
                  decoration: const InputDecoration(labelText: 'Min'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => extraParams['min'] = int.tryParse(value) ?? 0,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Max'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => extraParams['max'] = int.tryParse(value) ?? 10,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final config =
                    FormConfig(type: type, label: controller.text, extraParams: extraParams);
                Navigator.pop(context, config);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _configs.add(result);
      });
    }
  }

  void _saveConfig() async {
    if (_configs.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Add some inputs before saving.')));
      return;
    }

    // Ask for config name and default option
    _nameController.clear();
    _setAsDefault = false;

    final saveResult = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Configuration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Config Name'),
            ),
            Row(
              children: [
                Checkbox(
                  value: _setAsDefault,
                  onChanged: (v) {
                    setState(() {
                      _setAsDefault = v ?? false;
                    });
                  },
                ),
                const Text('Set as default config'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.trim().isEmpty) return;
              Navigator.pop(context, true);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saveResult == true) {
      final prefs = await SharedPreferences.getInstance();
      final allConfigs = await _loadAllConfigs();

      allConfigs[_nameController.text.trim()] = _configs;

      await _saveAllConfigs(allConfigs);

      if (_setAsDefault) {
        await _saveDefaultConfigName(_nameController.text.trim());
      }

      widget.onUpdate(_configs);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('Customize Match Scout Layout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _configs.length,
            itemBuilder: (context, index) {
              final config = _configs[index];
              return ListTile(
                title: Text(config.label),
                subtitle: Text(config.type.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => _configs.removeAt(index)),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Config'),
              onPressed: _saveConfig,
            ),
            FloatingActionButton(
              onPressed: () async {
                final selectedType = await showModalBottomSheet<FormType>(
                  context: context,
                  builder: (context) => ListView(
                    shrinkWrap: true,
                    children: FormType.values.map((type) {
                      return ListTile(
                        title: Text(type.name),
                        onTap: () => Navigator.pop(context, type),
                      );
                    }).toList(),
                  ),
                );

                if (selectedType != null) {
                  _addFormInput(selectedType);
                }
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
