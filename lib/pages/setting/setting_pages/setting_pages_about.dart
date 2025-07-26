import 'package:flutter/material.dart';

class SettingPagesAbout extends StatelessWidget {
  const SettingPagesAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                child: Text(
                  "FRC Scouting Tool\n"
                  "Built for the 2025-26 season by the Strategy Off-Season team\n\n"
                  
                  "Purpose\n"
                  "This app aims to Streamlines match data collection with offline-first reliability for competition environments.\n\n"
                  
                  "Technical Stack\n"
                  "Framework: Flutter ()\n"
                  "Data Storage: [Hive/SQLite], Google Sheets\n"
                  "Special Thanks: [Key Libraries/Packages]\n\n"

                  "Contact:\n"
                  "Bug Report: Ethan Zheng, ez3@icsd.k12.ny.us\n",
                  
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              )
              ),
            ),
          ],
        ),
      ),
    );
  }
}