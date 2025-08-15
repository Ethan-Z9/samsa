import 'package:flutter/material.dart';

class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Import Options',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Records Import
                  const Text('Records',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Import from file */},
                    icon: const Icon(Icons.file_open),
                    label: const Text('Import Record (File)'),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Import from QR */},
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Import Record (QR Code)'),
                  ),
                  const Divider(height: 32),

                  /*
                  // Config Import
                  const Text('Configs',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Import from file */},
                    icon: const Icon(Icons.file_open),
                    label: const Text('Import Config (File)'),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Import from QR */},
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Import Config (QR Code)'),
                  ),
                  const Divider(height: 32),

                  // Database Import
                  const Text('Database',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Import from database */},
                    icon: const Icon(Icons.cloud_download),
                    label: const Text('Import from Database'),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Import from file */},
                    icon: const Icon(Icons.file_open),
                    label: const Text('Import Database (File)'),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Import from QR */},
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Import Database (QR Code)'),
                  ),
                  */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
