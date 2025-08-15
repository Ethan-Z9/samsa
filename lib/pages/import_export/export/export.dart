import 'package:flutter/material.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Export Options',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Records Export
                  const Text('Records',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Export to file */},
                    icon: const Icon(Icons.file_download),
                    label: const Text('Export Record (File)'),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Export to QR */},
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Export Record (QR Code)'),
                  ),
                  const Divider(height: 32),

                  /*
                  // Config Export
                  const Text('Configs',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Export to file */},
                    icon: const Icon(Icons.file_download),
                    label: const Text('Export Config (File)'),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Export to QR */},
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Export Config (QR Code)'),
                  ),
                  const Divider(height: 32),

                  // Database Export
                  const Text('Database',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Export to database */},
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Export to Database'),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Export database to file */},
                    icon: const Icon(Icons.file_download),
                    label: const Text('Export Database (File)'),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                    onPressed: () {/* TODO: Export database to QR */},
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Export Database (QR Code)'),
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
