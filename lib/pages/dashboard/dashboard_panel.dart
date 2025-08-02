import 'package:flutter/material.dart';
import 'package:frc_scout_app/data/csv_loader.dart';
import 'package:frc_scout_app/auth/auth_service.dart';
import 'dashboard_panel_nav.dart';
import 'dashboard_panel_nav_commands.dart';

class DashboardPanel extends StatefulWidget {
  const DashboardPanel({super.key});

  @override
  State<DashboardPanel> createState() => _DashboardPanelState();
}

class _DashboardPanelState extends State<DashboardPanel> {
  late Future<List<Map<String, dynamic>>> _matchDataFuture;
  final ScrollController _scrollController = ScrollController();
  int? _highlightedTeam;
  String? _highlightedScout;
  bool _highlightUserScout = false;
  late Future<String?> _currentUserScoutFuture;
  String _selectedDataset = 'flr';

  final Map<String, String> _columnDisplayNames = {
    'match': 'Match',
    'red1robot': 'R.Bot.1',
    'red2robot': 'R.Bot.2',
    'red3robot': 'R.Bot.3',
    'blue1robot': 'B.Bot.1',
    'blue2robot': 'B.Bot.2',
    'blue3robot': 'B.Bot.3',
    'red1scout': 'R.Sct.1',
    'red2scout': 'R.Sct.2',
    'red3scout': 'R.Sct.3',
    'blue1scout': 'B.Sct.1',
    'blue2scout': 'B.Sct.2',
    'blue3scout': 'B.Sct.3',
  };

  @override
  void initState() {
    super.initState();
    _currentUserScoutFuture = AuthService().getCurrentEmail();
    _matchDataFuture = _loadDataForDataset(_selectedDataset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _loadDataForDataset(String datasetKey) {
    switch (datasetKey) {
      case 'tvr':
        return CSVLoader.loadMatchsTVR();
      case 'champs':
        return CSVLoader.loadMatchsChamps();
      case 'flr':
      default:
        return CSVLoader.loadMatchsFLR();
    }
  }

  String shortenScoutEmail(String email) {
    final prefix = email.split('@')[0];
    final letters = prefix.replaceAll(RegExp(r'\d'), '');
    final firstTwoLetters = letters.length >= 2 ? letters.substring(0, 2) : letters;
    final digits = prefix.replaceAll(RegExp(r'\D'), '');
    final firstDigit = digits.isNotEmpty ? digits[0] : '';
    return '$firstTwoLetters$firstDigit';
  }

  void _onDatasetSelected(String key) {
    setState(() {
      _selectedDataset = key;
      _matchDataFuture = _loadDataForDataset(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _currentUserScoutFuture,
      builder: (context, scoutSnapshot) {
        final currentUserScout = scoutSnapshot.data;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardPanelNav(
              matchDataFuture: _matchDataFuture,
              scrollController: _scrollController,
              currentUserEmail: currentUserScout,
              onTeamHighlight: (team) => setState(() => _highlightedTeam = team),
              onScoutHighlight: (scout) => setState(() => _highlightedScout = scout),
              onUserScoutToggle: (value) => setState(() {
                _highlightUserScout = value ?? false;
                _highlightedScout = _highlightUserScout ? currentUserScout : null;
              }),
              selectedDatasetKey: _selectedDataset,
              onDatasetSelected: _onDatasetSelected,
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 1000,
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
                          Container(
                            color: Colors.grey[200],
                            child: Table(
                              border: TableBorder.symmetric(
                                inside: const BorderSide(color: Colors.grey, width: 1),
                              ),
                              columnWidths: {
                                for (int i = 0; i < headers.length; i++) i: const FlexColumnWidth(1)
                              },
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
                          Expanded(
                            child: Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                child: Table(
                                  border: TableBorder.all(color: Colors.grey, width: 1),
                                  columnWidths: {
                                    for (int i = 0; i < headers.length; i++) i: const FlexColumnWidth(1)
                                  },
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  children: data.map((row) {
                                    return TableRow(
                                      decoration: BoxDecoration(
                                        color: data.indexOf(row) % 2 == 0 ? Colors.white : Colors.grey[50],
                                      ),
                                      children: headers.map((key) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                          alignment: Alignment.center,
                                          color: DashboardPanelNavCommands.getCellColor(
                                            columnKey: key,
                                            cellValue: row[key],
                                            highlightedTeam: _highlightedTeam,
                                            highlightedScout: _highlightedScout,
                                            currentUserEmail: currentUserScout,
                                            highlightUserScout: _highlightUserScout,
                                          ),
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
              ),
            ),
          ],
        );
      },
    );
  }
}
