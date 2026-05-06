import 'dart:convert';
import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kcards/data/export_import/subtree_serializer.dart';
import 'package:kcards/shared/providers/database_provider.dart';

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  bool _importing = false;
  String? _error;
  String? _success;

  Future<void> _pickAndImport() async {
    setState(() {
      _error = null;
      _success = null;
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null) return;

    setState(() => _importing = true);

    try {
      final content = await io.File(path).readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      final db = ref.read(appDatabaseProvider);
      final serializer = SubtreeSerializer(
        db: db,
        dirRepo: ref.read(directoryRepositoryProvider),
        kcRepo: ref.read(knowledgeCardRepositoryProvider),
        qcRepo: ref.read(questionCardRepositoryProvider),
      );

      await serializer.importSubtree(json, null);

      setState(() => _success = 'Import complete.');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.download_for_offline,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Pick a .json file exported from KCards.\n'
              'Existing directories and cards with the same names are skipped.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (_error != null) ...
              [
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            if (_success != null) ...
              [
                const SizedBox(height: 16),
                Text(
                  _success!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _importing ? null : _pickAndImport,
              icon: _importing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.folder_open),
              label: Text(_importing ? 'Importing…' : 'Pick JSON File'),
            ),
          ],
        ),
      ),
    );
  }
}
