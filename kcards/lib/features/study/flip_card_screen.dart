import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kcards/features/study/flip_card_widget.dart';
import 'package:kcards/features/study/study_providers.dart';
import 'package:kcards/shared/providers/database_provider.dart';

/// Standalone flip card for a single QuestionCard.
/// Navigated to from KnowledgeCardDetailScreen or tree browser.
class FlipCardScreen extends ConsumerStatefulWidget {
  final String questionCardId;

  const FlipCardScreen({super.key, required this.questionCardId});

  @override
  ConsumerState<FlipCardScreen> createState() => _FlipCardScreenState();
}

class _FlipCardScreenState extends ConsumerState<FlipCardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    setState(() => _flipped = !_flipped);
    if (_flipped) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Future<void> _record(bool correct) async {
    await ref
        .read(studyProgressRepositoryProvider)
        .recordReview(widget.questionCardId, correct: correct);
    if (mounted) context.pop(correct);
  }

  @override
  Widget build(BuildContext context) {
    final qcId = widget.questionCardId;
    if (qcId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Invalid card ID')),
      );
    }

    final qcAsync = ref.watch(questionCardByIdProvider(qcId));
    final qc = qcAsync.valueOrNull;
    final kcAsync = qc != null
        ? ref.watch(knowledgeCardByIdProvider(qc.knowledgeCardId))
        : null;
    final kc = kcAsync?.valueOrNull;
    final qcImagesAsync =
        qc != null ? ref.watch(questionCardImagesProvider(qc.id)) : null;
    final kcImagesAsync =
        kc != null ? ref.watch(knowledgeCardImagesProvider(kc.id)) : null;

    if (!qcAsync.hasValue || kcAsync == null || !kcAsync.hasValue) {
      if (qcAsync.hasError || kcAsync?.hasError == true) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('${qcAsync.error ?? kcAsync?.error}')),
        );
      }
      return Scaffold(
        appBar: AppBar(title: const Text('Study')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final loadedQC = qcAsync.value!;
    final loadedKC = kcAsync.value;
    final qcImages =
      qcImagesAsync?.valueOrNull?.map((i) => i.imagePath).toList() ?? [];
    final kcImages =
      kcImagesAsync?.valueOrNull?.map((i) => i.imagePath).toList() ?? [];
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
        actions: [
          if (_flipped)
            IconButton(
              icon: const Icon(Icons.flip_outlined),
              tooltip: 'Flip back',
              onPressed: _flip,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: GestureDetector(
                onTap: _flip,
                child: FlipCardWidget(
                  animation: _animation,
                  front: CardFace(
                    label: 'Question',
                    title: loadedQC.title,
                    markdown: loadedQC.questionMd,
                    imagePaths: qcImages,
                    color: cs.primaryContainer,
                  ),
                  back: CardFace(
                    label: 'Answer',
                    title: loadedKC?.title,
                    markdown: loadedKC?.contentMd ?? '',
                    imagePaths: kcImages,
                    color: cs.secondaryContainer,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            child: _flipped
                ? Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _record(false),
                          icon: const Icon(Icons.replay),
                          label: const Text('Again'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _record(true),
                          icon: const Icon(Icons.check),
                          label: const Text('Got it'),
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Tap the card to reveal the answer',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.outline,
                        ),
                  ),
          ),
        ],
      ),
    );
  }
}
