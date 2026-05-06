import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kcards/data/database/database.dart';
import 'package:kcards/features/study/flip_card_widget.dart';
import 'package:kcards/features/study/study_providers.dart';
import 'package:kcards/shared/providers/database_provider.dart';

class StudySessionScreen extends ConsumerStatefulWidget {
  final String directoryId;
  final bool subtree;

  const StudySessionScreen({
    super.key,
    required this.directoryId,
    this.subtree = false,
  });

  @override
  ConsumerState<StudySessionScreen> createState() => _StudySessionScreenState();
}

class _StudySessionScreenState extends ConsumerState<StudySessionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  List<QuestionCard>? _originalCards;
  List<QuestionCard>? _remaining;
  int _totalCount = 0;
  int _correctCount = 0;
  bool _flipped = false;
  bool _loaded = false;

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

  // Call only inside setState.
  void _resetFlip() {
    _flipped = false;
    _controller.reset();
  }

  Future<void> _onAgain() async {
    final card = _remaining![0];
    setState(() {
      _remaining!.removeAt(0);
      _remaining!.add(card);
      _resetFlip();
    });
    await ref
        .read(studyProgressRepositoryProvider)
        .recordReview(card.id, correct: false);
  }

  Future<void> _onGotIt() async {
    final card = _remaining![0];
    setState(() {
      _remaining!.removeAt(0);
      _correctCount++;
      _resetFlip();
    });
    await ref
        .read(studyProgressRepositoryProvider)
        .recordReview(card.id, correct: true);
  }

  void _restart() {
    setState(() {
      _remaining = List<QuestionCard>.from(_originalCards!)..shuffle(Random());
      _correctCount = 0;
      _resetFlip();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dirId = int.tryParse(widget.directoryId);
    if (dirId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Invalid directory ID')),
      );
    }

    // Phase 1: load the shuffled queue once.
    if (!_loaded) {
      final queueAsync = ref.watch(
        studyQueueProvider(
          StudySessionParams(directoryId: dirId, subtree: widget.subtree),
        ),
      );
      return queueAsync.when(
        loading: () => _buildLoadingScaffold(),
        error: (e, _) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('$e')),
        ),
        data: (cards) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_loaded) {
              setState(() {
                _originalCards = List<QuestionCard>.from(cards);
                _remaining = List<QuestionCard>.from(cards);
                _totalCount = cards.length;
                _loaded = true;
              });
            }
          });
          return _buildLoadingScaffold();
        },
      );
    }

    // No question cards in this directory.
    if (_totalCount == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study Session')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No question cards in this directory.'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
      );
    }

    // Session complete.
    if (_remaining!.isEmpty) return _buildDoneScreen();

    // Active session.
    final currentCard = _remaining![0];
    final kcAsync =
        ref.watch(knowledgeCardByIdProvider(currentCard.knowledgeCardId));
    final kc = kcAsync.valueOrNull;
    final qcImagesAsync = ref.watch(questionCardImagesProvider(currentCard.id));
    final kcImagesAsync =
        kc != null ? ref.watch(knowledgeCardImagesProvider(kc.id)) : null;

    final resolved = _totalCount - _remaining!.length;
    final progress = resolved / _totalCount;
    final qcImages =
        qcImagesAsync.valueOrNull?.map((i) => i.localPath).toList() ?? [];
    final kcImages =
        kcImagesAsync?.valueOrNull?.map((i) => i.localPath).toList() ?? [];
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Session'),
        actions: [
          if (_flipped)
            IconButton(
              icon: const Icon(Icons.flip_outlined),
              tooltip: 'Flip back',
              onPressed: _flip,
            ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'shuffle') _restart();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'shuffle',
                child: Row(
                  children: [
                    Icon(Icons.shuffle),
                    SizedBox(width: 8),
                    Text('Restart & Shuffle'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(child: LinearProgressIndicator(value: progress)),
                const SizedBox(width: 12),
                Text(
                  '$resolved / $_totalCount',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: GestureDetector(
                onTap: _flip,
                child: FlipCardWidget(
                  animation: _animation,
                  front: CardFace(
                    label: 'Question',
                    title: currentCard.title,
                    markdown: currentCard.questionMd,
                    imagePaths: qcImages,
                    color: cs.primaryContainer,
                  ),
                  back: CardFace(
                    label: 'Answer',
                    title: kc?.title,
                    markdown: kc?.contentMd ?? '',
                    imagePaths: kcImages,
                    color: cs.secondaryContainer,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_flipped)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Tap the card to reveal the answer',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: cs.outline,
                          ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _onAgain,
                        icon: const Icon(Icons.close),
                        label: const Text('Wrong'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _onGotIt,
                        icon: const Icon(Icons.check),
                        label: const Text('Correct'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Session')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildDoneScreen() {
    final percent =
        _totalCount > 0 ? (_correctCount / _totalCount * 100).round() : 0;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Session Complete')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percent >= 80 ? Icons.star_rounded : Icons.school_outlined,
              size: 80,
              color: percent >= 80 ? Colors.amber : cs.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '$percent%',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$_correctCount of $_totalCount correct',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: _restart,
                  icon: const Icon(Icons.replay),
                  label: const Text('Study Again'),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.check),
                  label: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
