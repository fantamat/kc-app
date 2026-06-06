import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kcards/shared/providers/auth_providers.dart';

class BootScreen extends ConsumerWidget {
  const BootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootState = ref.watch(appBootStateProvider);
    final connectionHealth = ref.watch(firebaseConnectionHealthProvider);
    final failureDetail = connectionHealth.valueOrNull?.detail;
    final errorDetail = connectionHealth.hasError
        ? connectionHealth.error.toString()
        : null;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: switch (bootState) {
                AppBootState.offline => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Firebase connection unavailable',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'KCards could not reach Firebase during startup, so the login screen is hidden until the connection is available.',
                        textAlign: TextAlign.center,
                      ),
                      if (failureDetail != null || errorDetail != null) ...[
                        const SizedBox(height: 12),
                        SelectableText(
                          failureDetail ?? errorDetail!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () =>
                            ref.invalidate(firebaseConnectionHealthProvider),
                        child: const Text('Retry connection'),
                      ),
                    ],
                  ),
                _ => const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Checking Firebase connection...',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
              },
            ),
          ),
        ),
      ),
    );
  }
}