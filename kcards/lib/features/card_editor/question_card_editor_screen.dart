import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kcards/data/database/database.dart';
import 'package:kcards/shared/providers/database_provider.dart';
import 'package:kcards/shared/widgets/image_strip_widget.dart';
import 'package:kcards/shared/widgets/markdown_editor_widget.dart';

class QuestionCardEditorScreen extends ConsumerStatefulWidget {
  /// null  → create mode (requires [directoryId])
  /// non-null → edit mode
  final String? cardId;
  final String? knowledgeCardId;
  final String? directoryId;

  const QuestionCardEditorScreen({
    super.key,
    this.cardId,
    this.knowledgeCardId,
    this.directoryId,
  });

  @override
  ConsumerState<QuestionCardEditorScreen> createState() =>
      _QuestionCardEditorScreenState();
}

class _QuestionCardEditorScreenState
    extends ConsumerState<QuestionCardEditorScreen> {
  final _titleController = TextEditingController();
  final _questionController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  QuestionCard? _existing;
  int? _directoryId;
  int? _selectedKcId;
  List<KnowledgeCard> _knowledgeCards = [];

  List<QuestionCardImage> _savedImages = [];
  final List<String> _pendingPaths = [];
  final Set<int> _deletedIds = {};

  int? get _cardIdInt =>
      widget.cardId != null ? int.tryParse(widget.cardId!) : null;

  bool get _isEditing => _existing != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final qRepo = ref.read(questionCardRepositoryProvider);
    final kcRepo = ref.read(knowledgeCardRepositoryProvider);

    final id = _cardIdInt;
    if (id != null) {
      // Edit mode: load existing card
      final card = await qRepo.getById(id);
      if (card != null) {
        _directoryId = card.directoryId;
        _selectedKcId = card.knowledgeCardId;
        _titleController.text = card.title;
        _questionController.text = card.questionMd;
        _existing = card;
        _savedImages =
            await ref.read(appDatabaseProvider).questionCardDao.getImages(id);
      }
    } else {
      // Create mode
      _directoryId = widget.directoryId != null
          ? int.tryParse(widget.directoryId!)
          : null;
      _selectedKcId = widget.knowledgeCardId != null
          ? int.tryParse(widget.knowledgeCardId!)
          : null;
    }

    if (_directoryId != null) {
      _knowledgeCards = await kcRepo.getByDirectory(_directoryId!);
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _questionController.dispose();
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
    final question = _questionController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }
    if (_selectedKcId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a knowledge card')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final repo = ref.read(questionCardRepositoryProvider);

      if (_isEditing) {
        await repo.update(
          _existing!.id,
          title: title,
          questionMd: question,
          knowledgeCardId: _selectedKcId,
        );
        for (final imgId in _deletedIds) {
          final img = _savedImages.firstWhere((i) => i.id == imgId);
          final f = io.File(img.localPath);
          if (f.existsSync()) f.deleteSync();
          await ref
              .read(appDatabaseProvider)
              .questionCardDao
              .deleteImage(imgId);
        }
        final baseOrder = _savedImages.length - _deletedIds.length;
        for (int i = 0; i < _pendingPaths.length; i++) {
          await repo.addImage(_existing!.id, _pendingPaths[i], baseOrder + i);
        }
      } else {
        final card = await repo.create(
          directoryId: _directoryId!,
          knowledgeCardId: _selectedKcId!,
          title: title,
          questionMd: question,
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
        title:
            Text(_isEditing ? 'Edit Question Card' : 'New Question Card'),
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
                // ── Knowledge card picker ──────────────────────────────
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Knowledge Card',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: DropdownButton<int>(
                    value: _knowledgeCards.any((kc) => kc.id == _selectedKcId)
                        ? _selectedKcId
                        : null,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    hint: _knowledgeCards.isEmpty
                        ? const Text('No knowledge cards in this directory')
                        : const Text('Select a knowledge card'),
                    items: _knowledgeCards
                        .map(
                          (kc) => DropdownMenuItem(
                            value: kc.id,
                            child: Text(
                              kc.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedKcId = v),
                  ),
                ),
                const SizedBox(height: 16),
                // ── Title ─────────────────────────────────────────────
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // ── Question markdown editor ───────────────────────────
                Text(
                  'Question (optional)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                MarkdownEditorWidget(
                  controller: _questionController,
                  label: 'Write your question here\u2026',
                ),
                const SizedBox(height: 16),
                // ── Images ────────────────────────────────────────────
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
