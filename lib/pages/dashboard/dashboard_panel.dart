import 'package:flutter/material.dart';
import 'package:frc_scout_app/data/csv_loader.dart';

class DashboardPanel extends StatefulWidget {
  const DashboardPanel({super.key});

  @override
  State<DashboardPanel> createState() => _DashboardPanelState();
}

class _DashboardPanelState extends State<DashboardPanel> {
  late Future<List<Map<String, dynamic>>> _matchDataFuture;

  final Map<String, String> _columnDisplayNames = {
    'match': 'Match #',
    'red1robot': 'Red Robot 1',
    'red2robot': 'Red Robot 2',
    'red3robot': 'Red Robot 3',
    'blue1robot': 'Blue Robot 1',
    'blue2robot': 'Blue Robot 2',
    'blue3robot': 'Blue Robot 3',
    'red1scout': 'Red Scout 1',
    'red2scout': 'Red Scout 2',
    'red3scout': 'Red Scout 3',
    'blue1scout': 'Blue Scout 1',
    'blue2scout': 'Blue Scout 2',
    'blue3scout': 'Blue Scout 3',
  };

  @override
  void initState() {
    super.initState();
    _matchDataFuture = CSVLoader.loadMatchsFLR();
  }

  /// Helper to shorten scout email string like "eqz03@example.com"
  /// into first 2 letters + first digit, e.g. "eq3"
  String shortenScoutEmail(String email) {
    final prefix = email.split('@')[0]; // "eqz03"
    final letters = prefix.replaceAll(RegExp(r'\d'), ''); // "eqz"
    final firstTwoLetters = letters.length >= 2 ? letters.substring(0, 2) : letters;
    final digits = prefix.replaceAll(RegExp(r'\D'), ''); // "03"
    final firstDigit = digits.isNotEmpty ? digits[0] : '';
    return '$firstTwoLetters$firstDigit';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 900,
        height: 600,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _matchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error loading data: ${snapshot.error}'));
            }
            final data = snapshot.data ?? [];

            if (data.isEmpty) {
              return const Center(child: Text('No match data available.'));
            }

            final headers = data.first.keys.toList();

            return Column(
              children: [
                // Header Row
                Container(
                  color: Colors.grey[200],
                  child: Table(
                    border: TableBorder.symmetric(
                      inside: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    columnWidths: Map.fromIterables(
                      List.generate(headers.length, (i) => i),
                      List.generate(headers.length, (i) => const FlexColumnWidth(1)),
                    ),
                    children: [
                      TableRow(
                        children: headers.map((key) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: Text(
                              _columnDisplayNames[key] ?? key,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Data Rows with vertical scroll
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        border: TableBorder.all(color: Colors.grey, width: 1),
                        columnWidths: Map.fromIterables(
                          List.generate(headers.length, (i) => i),
                          List.generate(headers.length, (i) => const FlexColumnWidth(1)),
                        ),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: data.map((row) {
                          return TableRow(
                            children: headers.map((key) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                alignment: Alignment.center,
                                child: Text(
                                  (key.contains('scout'))
                                      ? shortenScoutEmail(row[key].toString())
                                      : row[key].toString(),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
