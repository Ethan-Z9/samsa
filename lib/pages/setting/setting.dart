import 'package:flutter/material.dart';
import 'package:frc_scout_app/drawer/app_drawer.dart';
import 'package:frc_scout_app/header/app_header.dart';
import 'package:frc_scout_app/pages/setting/setting_pages/setting_pages_customize_match_scout';
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
    'Appearance',
    'Customize Match Scout',
    'Disclaimer',
    'About',
  ];
  
  final List<Widget> _pages = const [
    SettingPagesAppearance(),
    CustomizeMatchScout(),
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
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      title: Text(
                        _titles[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _selectedIndex == index ? Colors.green[800] : Colors.black87,
                        ),
                      ),
                      selected: _selectedIndex == index,
                      selectedTileColor: Colors.green[100],
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                    if (index != _titles.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 8,
                        endIndent: 8,
                        color: Colors.grey,
                      ),
                  ],
                );
              },
            )

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
