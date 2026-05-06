import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kcards/data/database/database.dart';
import 'package:kcards/shared/providers/database_provider.dart';
import 'package:kcards/shared/widgets/image_strip_widget.dart';
import 'package:kcards/shared/widgets/markdown_editor_widget.dart';

class KnowledgeCardEditorScreen extends ConsumerStatefulWidget {
  /// null  → create mode (requires [directoryId])
  /// non-null → edit mode
  final String? cardId;
  final String? directoryId;

  const KnowledgeCardEditorScreen({
    super.key,
    this.cardId,
    this.directoryId,
  });

  @override
  ConsumerState<KnowledgeCardEditorScreen> createState() =>
      _KnowledgeCardEditorScreenState();
}

class _KnowledgeCardEditorScreenState
    extends ConsumerState<KnowledgeCardEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  KnowledgeCard? _existing;

  List<KnowledgeCardImage> _savedImages = [];
  final List<String> _pendingPaths = [];
  final Set<int> _deletedIds = {};

  int? get _cardIdInt =>
      widget.cardId != null ? int.tryParse(widget.cardId!) : null;
  int? get _dirIdInt =>
      widget.directoryId != null ? int.tryParse(widget.directoryId!) : null;

  bool get _isEditing => _existing != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = _cardIdInt;
    if (id != null) {
      final repo = ref.read(knowledgeCardRepositoryProvider);
      final card = await repo.getById(id);
      final imgs =
          await ref.read(appDatabaseProvider).knowledgeCardDao.getImages(id);
      if (mounted) {
        setState(() {
          _existing = card;
          _savedImages = imgs;
          _titleController.text = card?.title ?? '';
          _contentController.text = card?.contentMd ?? '';
          _loading = false;
        });
      }
    } else {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  List<String> get _visiblePaths => [
        ..._savedImages
            .where((i) => !_deletedIds.contains(i.id))
            .map((i) => i.localPath),
        ..._pendingPaths,
      ];

  void _onAddImage(String path) => setState(() => _pendingPaths.add(path));

  void _onRemoveImage(int index) {
    final visibleSaved =
        _savedImages.where((i) => !_deletedIds.contains(i.id)).toList();
    setState(() {
      if (index < visibleSaved.length) {
        _deletedIds.add(visibleSaved[index].id);
      } else {
        _pendingPaths.removeAt(index - visibleSaved.length);
      }
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final repo = ref.read(knowledgeCardRepositoryProvider);

      if (_isEditing) {
        await repo.update(
          _existing!.id,
          title: title,
          contentMd: _contentController.text,
        );
        // Remove deleted images
        for (final imgId in _deletedIds) {
          final img = _savedImages.firstWhere((i) => i.id == imgId);
          final f = io.File(img.localPath);
          if (f.existsSync()) f.deleteSync();
          await ref
              .read(appDatabaseProvider)
              .knowledgeCardDao
              .deleteImage(imgId);
        }
        // Add pending images
        final baseOrder = _savedImages.length - _deletedIds.length;
        for (int i = 0; i < _pendingPaths.length; i++) {
          await repo.addImage(_existing!.id, _pendingPaths[i], baseOrder + i);
        }
      } else {
        final card = await repo.create(
          directoryId: _dirIdInt!,
          title: title,
          contentMd: _contentController.text,
        );
        for (int i = 0; i < _pendingPaths.length; i++) {
          await repo.addImage(card.id, _pendingPaths[i], i);
        }
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isEditing ? 'Edit Knowledge Card' : 'New Knowledge Card'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: 'Save',
              onPressed: _save,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                Text(
                  'Content',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                MarkdownEditorWidget(
                  controller: _contentController,
                  label: 'Write knowledge content here\u2026',
                ),
                const SizedBox(height: 16),
                Text(
                  'Images',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                ImageStripWidget(
                  imagePaths: _visiblePaths,
                  onAddImage: _onAddImage,
                  onRemove: _onRemoveImage,
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }
}
