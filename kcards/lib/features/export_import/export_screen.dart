import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:kcards/data/export_import/subtree_serializer.dart';
import 'package:kcards/shared/providers/database_provider.dart';

class ExportScreen extends ConsumerStatefulWidget {
  final String? directoryId;

  const ExportScreen({super.key, this.directoryId});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  bool _exporting = false;
  String? _error;

  Future<void> _export() async {
    final dirIdStr = widget.directoryId;
    if (dirIdStr == null) return;

    setState(() {
      _exporting = true;
      _error = null;
    });

    try {
      final serializer = SubtreeSerializer(
        dirRepo: ref.read(directoryRepositoryProvider),
        kcRepo: ref.read(knowledgeCardRepositoryProvider),
        qcRepo: ref.read(questionCardRepositoryProvider),
        imageService: ref.read(imageServiceProvider),
      );

      final json = await serializer.exportSubtree(dirIdStr);
      final bytes = utf8.encode(jsonEncode(json));

      final tmpDir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final file = io.File(p.join(tmpDir.path, 'kcards_export_$ts.json'));
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/json')],
        text: 'KCards export',
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDir = widget.directoryId != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Export')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.upload_file,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              hasDir
                  ? 'Export this directory and all its contents as a JSON file.'
                  : 'No directory selected.',
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
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: hasDir && !_exporting ? _export : null,
              icon: _exporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.share),
              label: Text(_exporting ? 'Exporting…' : 'Export & Share'),
            ),
          ],
        ),
      ),
    );
  }
}
