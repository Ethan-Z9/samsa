import 'package:flutter/material.dart';
import 'package:frc_scout_app/config/config_storage.dart';  // <-- new import
import 'package:frc_scout_app/form/form_config.dart';

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
  String? _selectedConfigName;
  final TextEditingController _nameController = TextEditingController();

  Map<String, List<FormConfig>> _allConfigs = {};

  @override
  void initState() {
    super.initState();
    _configs = List.from(widget.formConfigs);
    _loadAllConfigs();
  }

  Future<void> _loadAllConfigs() async {
    final names = await ConfigStorage.getConfigNames();
    final Map<String, List<FormConfig>> loadedConfigs = {};

    for (var name in names) {
      final configs = await ConfigStorage.loadConfig(name);
      loadedConfigs[name] = configs;
    }

    setState(() {
      _allConfigs = loadedConfigs;
    });
  }

  Future<void> _refreshConfigsWithMessage() async {
    await _loadAllConfigs();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configs refreshed')),
      );
    }
  }

  Future<bool> _promptForConfigName() async {
    _nameController.clear();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Config Name'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Config Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.trim().isEmpty) return;
              Navigator.pop(context, true);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return result == true;
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
              if (type == FormType.lever) ...[
                TextField(
                  decoration: const InputDecoration(labelText: 'Left Label'),
                  onChanged: (value) => extraParams['leftLabel'] = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Right Label'),
                  onChanged: (value) => extraParams['rightLabel'] = value,
                ),
              ] else if (type == FormType.radio || type == FormType.dropdown) ...[
                TextField(
                  decoration: const InputDecoration(labelText: 'Options (comma separated)'),
                  onChanged: (value) =>
                      extraParams['options'] = value.split(',').map((s) => s.trim()).toList(),
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
                final config = FormConfig(type: type, label: controller.text, extraParams: extraParams);
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
    if (_selectedConfigName == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please add a config name first.')));
      return;
    }
    await ConfigStorage.saveConfig(_selectedConfigName!, _configs);
    await _loadAllConfigs();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!')));

    setState(() {
      _selectedConfigName = null;
      _configs = [];
    });
    widget.onUpdate(_configs);
  }

  void _deleteSelectedConfig() async {
    if (_selectedConfigName == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Configuration'),
        content: Text('Are you sure you want to delete "$_selectedConfigName"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      await ConfigStorage.deleteConfig(_selectedConfigName!);
      await _loadAllConfigs();

      setState(() {
        _selectedConfigName = null;
        _configs = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted!')));
    }
  }

  void _loadSelectedConfig(String name) {
    final selected = _allConfigs[name];
    if (selected != null) {
      setState(() {
        _configs = List.from(selected);
        _selectedConfigName = name;
      });
      widget.onUpdate(_configs);
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedConfigName,
                  isExpanded: true,
                  hint: const Text('Select a config'),
                  items: _allConfigs.keys.map((name) {
                    return DropdownMenuItem(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (name) {
                    if (name != null) _loadSelectedConfig(name);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete Config',
                onPressed: _selectedConfigName == null ? null : _deleteSelectedConfig,
              ),
            ],
          ),
        ),
        const Divider(),
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
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              onPressed: _refreshConfigsWithMessage,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Config'),
              onPressed: _saveConfig,
            ),
            FloatingActionButton(
              onPressed: () async {
                if (_selectedConfigName == null) {
                  final hasName = await _promptForConfigName();
                  if (!hasName) return;
                  setState(() {
                    _selectedConfigName = _nameController.text.trim();
                    _configs = [];
                  });
                }
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
