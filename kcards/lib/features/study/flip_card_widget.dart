import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:kcards/shared/widgets/image_strip_widget.dart';

/// Animated flip card driven by [animation] (0.0 → front visible,
/// 1.0 → back visible). Rotates around the Y axis with perspective.
class FlipCardWidget extends StatelessWidget {
  final Animation<double> animation;
  final Widget front;
  final Widget back;

  const FlipCardWidget({
    super.key,
    required this.animation,
    required this.front,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final angle = animation.value * pi;
        final showFront = animation.value < 0.5;

        final transform = showFront
            ? (Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle))
            : (Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle - pi));

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: showFront ? front : back,
        );
      },
    );
  }
}

/// A single face of a flip card (question or answer side).
class CardFace extends StatelessWidget {
  final String label;
  final String? title;
  final String markdown;
  final List<String> imagePaths;
  final Color color;

  const CardFace({
    super.key,
    required this.label,
    this.title,
    required this.markdown,
    this.imagePaths = const [],
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(label),
              side: BorderSide.none,
              backgroundColor: Colors.transparent,
            ),
            if (title != null) ...[
              const SizedBox(height: 4),
              Text(title!, style: Theme.of(context).textTheme.titleLarge),
            ],
            const SizedBox(height: 12),
            if (markdown.isEmpty)
              Text(
                '(no content)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              )
            else
              MarkdownBody(data: markdown),
            if (imagePaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              ImageStripWidget(
                imagePaths: imagePaths,
                onAddImage: (_) {},
                onRemove: (_) {},
                readOnly: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
