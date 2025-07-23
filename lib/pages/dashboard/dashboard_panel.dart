import 'package:flutter/material.dart';

class DashboardPanel extends StatelessWidget {
  const DashboardPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Upcoming Matches',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Match list will appear here once matches.csv is available.'),
        ],
      ),
    );
  }
}
