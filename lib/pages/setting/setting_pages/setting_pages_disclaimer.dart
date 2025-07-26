import 'package:flutter/material.dart';

class SettingPagesDisclaimer extends StatelessWidget {
  const SettingPagesDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Disclaimer',
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
                  "Data Usage Policy\n\n"
                  
                  "1. Purpose\n"
                  "This app is a student-built tool for collecting and analyzing match data during FIRST Robotics Competition events.\n"
                  "It is not affiliated with or endorsed by FIRST®.\n\n"
                  
                  "2. Data Collection\n"
                  "We store:\n"
                  "• Scout names and school emails (for assignment tracking)\n"
                  "• Match performance metrics (scores, timings, etc.)\n"
                  "• Device info (for sync)\n\n"
                  
                  "3. Storage & Access\n"
                  "• Active data: Stored locally on school-managed devices\n"
                  "• Shared data: Uploaded to team-controlled Google Sheets\n"
                  "• Access restricted to:\n"
                  "   - Approved team members\n"
                  "   - Staff & Mentors\n\n"
                  "(Data sheet access, contact strategy head, or officers)\n"

                  "Violations of Data:\n"
                  "• Using another user's credentials\n"
                  "• Adding unauthorized accounts\n"
                  "• Bypassing authentication methods\n\n"

                  "4. Data Maintenance\n"
                  "• Annual review: All scout accounts are purged after each season\n"
                  "• New members: Added at start of competition season\n"
                  "• Archived data: Anonymized after 2 years\n\n"
                  
                  "5. Acceptable Use\n"
                  "You agree to:\n"
                  "• Use data only for team strategy development\n"
                  "• Never share raw data outside the team\n"
                  "• Report discrepancies to team captains\n\n"
                  
                  "6. Limitations\n"
                  "• Data accuracy depends on scout input\n"
                  "• Historical records may be corrected\n"
                  
                  "Policy last updated: ${DateTime.now().year}",
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