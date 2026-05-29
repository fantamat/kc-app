import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kcards/data/models/card_image_model.dart';
import 'package:kcards/data/models/knowledge_card_model.dart';
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

    KnowledgeCardModel? _existing;

    List<CardImageModel> _savedImages = [];
  final List<String> _pendingPaths = [];
    final Set<String> _deletedIds = {};

    String? get _cardId =>
      widget.cardId != null && widget.cardId!.isNotEmpty ? widget.cardId : null;
    String? get _dirId =>
      widget.directoryId != null && widget.directoryId!.isNotEmpty
        ? widget.directoryId
        : null;

  bool get _isEditing => _existing != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = _cardId;
    if (id != null) {
      final repo = ref.read(knowledgeCardRepositoryProvider);
      final card = await repo.getById(id);
      final imgs = await repo.getImages(id);
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
              .map((i) => i.imagePath),
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
          await ref.read(imageServiceProvider).delete(img.imagePath);
          await repo.removeImage(img);
        }
        // Add pending images
        final baseOrder = _savedImages.length - _deletedIds.length;
        for (int i = 0; i < _pendingPaths.length; i++) {
          await repo.addImage(_existing!.id, _pendingPaths[i], baseOrder + i);
        }
      } else {
        final card = await repo.create(
          directoryId: _dirId!,
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
