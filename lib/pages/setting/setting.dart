import 'package:flutter/material.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/header/app_header.dart';
import 'setting_pages/setting_pages_general.dart';
import 'setting_pages/setting_pages_appearance.dart';
import 'setting_pages/setting_pages_about.dart';
import 'setting_pages/setting_pages_disclaimer.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    'General',
    'Appearance',
    'Disclaimer',
    'About',
  ];
  
  final List<Widget> _pages = const [
    SettingPagesGeneral(),
    SettingPagesAppearance(),
    SettingPagesDisclaimer(),
    SettingPagesAbout(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(title: 'Setting'),
      drawer: const AppDrawer(),
      body: Row(
        children: [
          // Left shelf using percentage width
          Container(
            width: MediaQuery.of(context).size.width * 0.2, // % of screen
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: _titles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_titles[index]),
                  selected: _selectedIndex == index,
                  selectedTileColor: Colors.green[100],
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),

          // Right content area (fills remaining space)
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
