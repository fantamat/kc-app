import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/features/study/study_providers.dart';
import 'package:kcards/shared/providers/database_provider.dart';
import 'package:kcards/shared/widgets/image_strip_widget.dart';

class KnowledgeCardDetailScreen extends ConsumerWidget {
  final String cardId;

  const KnowledgeCardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(cardId);
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Invalid card ID')),
      );
    }

    final cardAsync = ref.watch(knowledgeCardByIdProvider(id));
    return cardAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
      data: (card) {
        if (card == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(child: Text('Card not found')),
          );
        }
        return _KnowledgeCardDetailBody(card: card);
      },
    );
  }
}

class _KnowledgeCardDetailBody extends ConsumerWidget {
  final KnowledgeCard card;

  const _KnowledgeCardDetailBody({required this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagesAsync = ref.watch(knowledgeCardImagesProvider(card.id));
    final linkedQCsAsync = ref.watch(linkedQuestionCardsProvider(card.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(card.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => context.push('/knowledge-card/${card.id}'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(
          '/question-card/new?dirId=${card.directoryId}&knowledgeCardId=${card.id}',
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Question'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (card.contentMd.isNotEmpty) MarkdownBody(data: card.contentMd),
          imagesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, st) => const SizedBox.shrink(),
            data: (images) {
              if (images.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ImageStripWidget(
                  imagePaths: images.map((i) => i.localPath).toList(),
                  onAddImage: (p) {},
                  onRemove: (i) {},
                  readOnly: true,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.quiz_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'Question Cards',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          linkedQCsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (qcs) {
              if (qcs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No question cards yet. Tap "Add Question" to create one.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return Column(
                children: [for (final qc in qcs) _QuestionCardTile(qc: qc)],
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _QuestionCardTile extends ConsumerWidget {
  final QuestionCard qc;

  const _QuestionCardTile({required this.qc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(studyProgressByQCProvider(qc.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.help_outline),
        title: Text(
          qc.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: progressAsync.maybeWhen(
          data: (p) => p == null
              ? const Text('Not reviewed yet')
              : Text('${p.timesCorrect}/${p.timesReviewed} correct'),
          orElse: () => null,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
              onPressed: () => context.push('/question-card/${qc.id}'),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
        onTap: () => context.push('/study/flip/${qc.id}'),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Question Card'),
        content: const Text(
          'This will also delete study progress for this card.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(questionCardRepositoryProvider).delete(qc.id);
    }
  }
}
