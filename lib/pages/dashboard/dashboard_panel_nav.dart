import 'package:flutter/material.dart';
import 'package:frc_scout_app/data/csv_loader.dart';

class DashboardPanelNav extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> matchDataFuture;
  final ScrollController scrollController;
  final String? currentUserEmail;
  final Function(int?)? onTeamHighlight;
  final Function(String?)? onScoutHighlight;
  final Function(bool)? onUserScoutToggle;
  final String selectedDatasetKey;
  final Function(String) onDatasetSelected;

  // Callback to notify parent to reload data after refresh
  final Future<void> Function()? onRefresh;

  const DashboardPanelNav({
    super.key,
    required this.matchDataFuture,
    required this.scrollController,
    this.currentUserEmail,
    this.onTeamHighlight,
    this.onScoutHighlight,
    this.onUserScoutToggle,
    required this.selectedDatasetKey,
    required this.onDatasetSelected,
    this.onRefresh,
  });

  @override
  State<DashboardPanelNav> createState() => _DashboardPanelNavState();
}

class _DashboardPanelNavState extends State<DashboardPanelNav> {
  final _teamSearchController = TextEditingController();
  final _scoutSearchController = TextEditingController();
  bool _highlightUserScout = false;
  bool _isRefreshing = false;

  late String _selectedDataset;

  @override
  void initState() {
    super.initState();
    _selectedDataset = widget.selectedDatasetKey;
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollToBottom() async {
    final data = await widget.matchDataFuture;
    final rowHeight = 48.0;
    final position = data.length * rowHeight;
    widget.scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _refreshCsvs() async {
    setState(() => _isRefreshing = true);

    // Refresh only matches CSVs and update Hive boxes
    await CSVLoader.fetchAllAndCache();

    // Call the parent callback so it reloads the table
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    }

    setState(() => _isRefreshing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV data refreshed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(right: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dataset Selector
          const Text('Dataset', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _selectedDataset,
            isExpanded: true,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedDataset = value);
                widget.onDatasetSelected(value);
              }
            },
            items: const [
              DropdownMenuItem(value: 'flr', child: Text('FLR')),
              DropdownMenuItem(value: 'tvr', child: Text('TVR')),
              DropdownMenuItem(value: 'champs', child: Text('Champs')),
              DropdownMenuItem(value: 'worlds', child: Text('Worlds')),
            ],
          ),
          const SizedBox(height: 8),

          // Refresh Button
          ElevatedButton.icon(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh, size: 16),
            label: Text(_isRefreshing ? 'Refreshing...' : 'Refresh CSVs'),
            onPressed: _isRefreshing ? null : _refreshCsvs,
          ),

          const Divider(height: 32),

          // Navigation Controls
          const Text('Navigation', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_upward, size: 16),
                label: const Text('Top'),
                onPressed: _scrollToTop,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_downward, size: 16),
                label: const Text('Bottom'),
                onPressed: _scrollToBottom,
              ),
            ],
          ),
          const Divider(height: 32),

          // Team Search
          const Text('Team Search', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _teamSearchController,
            decoration: InputDecoration(
              hintText: 'Enter team number',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () {
                  _teamSearchController.clear();
                  widget.onTeamHighlight?.call(null);
                },
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final team = int.tryParse(value);
              widget.onTeamHighlight?.call(team);
            },
          ),
          const Divider(height: 32),

          // Scout Search
          const Text('Scout Search', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _scoutSearchController,
            decoration: InputDecoration(
              hintText: 'Enter scout initials',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () {
                  _scoutSearchController.clear();
                  widget.onScoutHighlight?.call(null);
                },
              ),
            ),
            onChanged: (value) {
              final scout = value.isNotEmpty ? value.toLowerCase() : null;
              widget.onScoutHighlight?.call(scout);
            },
          ),
          const SizedBox(height: 8),

          // Highlight User Scout
          if (widget.currentUserEmail != null) ...[
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Highlight my assignments'),
              value: _highlightUserScout,
              onChanged: (value) {
                setState(() {
                  _highlightUserScout = value ?? false;
                });
                widget.onUserScoutToggle?.call(_highlightUserScout);
              },
            ),
            const Divider(height: 32),
          ],
        ],
      ),
    );
  }
}
