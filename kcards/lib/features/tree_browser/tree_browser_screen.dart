import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kcards/data/models/directory_model.dart';
import 'package:kcards/data/models/knowledge_card_model.dart';
import 'package:kcards/features/tree_browser/tree_browser_providers.dart';
import 'package:kcards/shared/providers/auth_providers.dart';
import 'package:kcards/shared/providers/database_provider.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────

enum _AppBarAction {
  studyDir,
  studySubtree,
  export,
  importCards,
  switchToSignIn,
  signOut,
}

enum _DirAction { rename, delete }

enum _CardAction { edit, addQuestion, delete }

// ── Dialogs ───────────────────────────────────────────────────────────────────

Future<void> _showCreateDirDialog(
  BuildContext context,
  WidgetRef ref,
  String? parentId,
) async {
  final ctrl = TextEditingController();
  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('New Directory'),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(labelText: 'Name'),
        onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
          child: const Text('Create'),
        ),
      ],
    ),
  );
  if (name == null || name.isEmpty) return;
  await ref
      .read(directoryRepositoryProvider)
      .create(name: name, parentId: parentId);
}

Future<void> _showRenameDirDialog(
  BuildContext context,
  WidgetRef ref,
  DirectoryModel dir,
) async {
  final ctrl = TextEditingController(text: dir.name);
  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Rename Directory'),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(labelText: 'New name'),
        onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
          child: const Text('Rename'),
        ),
      ],
    ),
  );
  if (name == null || name.isEmpty || name == dir.name) return;
  await ref.read(directoryRepositoryProvider).rename(dir.id, name);
}

Future<void> _showDeleteDirDialog(
  BuildContext context,
  WidgetRef ref,
  DirectoryModel dir,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Directory'),
      content: Text(
        'Delete "${dir.name}" and all its contents? This cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(ctx).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  await ref.read(directoryRepositoryProvider).deleteSubtree(dir.id);
}

Future<void> _showDeleteCardDialog(
  BuildContext context,
  WidgetRef ref,
  KnowledgeCardModel card,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Knowledge Card'),
      content: Text('Delete "${card.title}"? This cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(ctx).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  try {
    await ref.read(knowledgeCardRepositoryProvider).delete(card.id);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class TreeBrowserScreen extends ConsumerWidget {
  final String? directoryId;

  const TreeBrowserScreen({super.key, this.directoryId});

  String? get _dirId =>
      directoryId != null && directoryId!.isNotEmpty ? directoryId : null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dirId = _dirId;
    final authStatus = ref.watch(authStatusProvider);
    final user = ref.watch(currentUserProvider).valueOrNull;

    final subdirs = ref.watch(childDirsProvider(dirId));
    final cards = dirId == null
      ? const AsyncData<List<KnowledgeCardModel>>([])
        : ref.watch(dirKnowledgeCardsProvider(dirId));
    final breadcrumbs = ref.watch(breadcrumbProvider(dirId));

    final currentDirName = breadcrumbs.valueOrNull?.lastOrNull?.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentDirName ?? 'KCards'),
        actions: [
          if (authStatus != AuthStatus.loading)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _AccountStatusChip(
                status: authStatus,
                email: user?.email,
              ),
            ),
          PopupMenuButton<_AppBarAction>(
            onSelected: (action) =>
                _handleAppBarAction(context, ref, action, dirId),
            itemBuilder: (_) => [
              if (dirId != null) ...[
                const PopupMenuItem(
                  value: _AppBarAction.studyDir,
                  child: Text('Study this directory'),
                ),
                const PopupMenuItem(
                  value: _AppBarAction.studySubtree,
                  child: Text('Study subtree'),
                ),
                const PopupMenuDivider(),
              ],
              const PopupMenuItem(
                value: _AppBarAction.export,
                child: Text('Export'),
              ),
              const PopupMenuItem(
                value: _AppBarAction.importCards,
                child: Text('Import'),
              ),
              const PopupMenuDivider(),
              if (authStatus == AuthStatus.guest)
                const PopupMenuItem(
                  value: _AppBarAction.switchToSignIn,
                  child: Text('Sign in to cloud account'),
                ),
              if (authStatus == AuthStatus.authenticated)
                const PopupMenuItem(
                  value: _AppBarAction.signOut,
                  child: Text('Sign out'),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BreadcrumbBar(breadcrumbs: breadcrumbs),
          Expanded(
            child: _buildBody(context, ref, subdirs, cards, dirId),
          ),
        ],
      ),
      floatingActionButton: _ExpandableFab(
        actions: [
          (
            icon: Icons.create_new_folder_outlined,
            label: 'New Directory',
            onTap: () => _showCreateDirDialog(context, ref, dirId),
          ),
          if (dirId != null)
            (
              icon: Icons.style_outlined,
              label: 'New Knowledge Card',
              onTap: () => context.push('/knowledge-card/new?dirId=$dirId'),
            ),
        ],
      ),
    );
  }

  void _handleAppBarAction(
    BuildContext context,
    WidgetRef ref,
    _AppBarAction action,
    String? dirId,
  ) async {
    switch (action) {
      case _AppBarAction.studyDir:
        context.push('/study/session?dirId=$dirId');
      case _AppBarAction.studySubtree:
        context.push('/study/session?dirId=$dirId&subtree=true');
      case _AppBarAction.export:
        context.push(dirId != null ? '/export?dirId=$dirId' : '/export');
      case _AppBarAction.importCards:
        context.push('/import');
      case _AppBarAction.switchToSignIn:
        await ref.read(guestModeProvider.notifier).setGuestMode(false);
      case _AppBarAction.signOut:
        await ref.read(firebaseAuthProvider).signOut();
        await ref.read(guestModeProvider.notifier).setGuestMode(false);
    }
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<DirectoryModel>> subdirs,
    AsyncValue<List<KnowledgeCardModel>> cards,
    String? dirId,
  ) {
    if (subdirs.isLoading || cards.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final error = subdirs.error ?? cards.error;
    if (error != null) {
      return Center(child: Text('Error: $error'));
    }

    final dirs = subdirs.valueOrNull ?? [];
    final knowledgeCards = cards.valueOrNull ?? [];

    if (dirs.isEmpty && knowledgeCards.isEmpty) {
      return Center(
        child: Text(
          dirId == null
              ? 'No directories yet.\nTap + to create one.'
              : 'Empty directory.\nTap + to add content.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView(
      children: [
        if (dirs.isNotEmpty) ...[
          const _SectionHeader(title: 'Directories'),
          for (final dir in dirs) _DirTile(dir: dir),
        ],
        if (knowledgeCards.isNotEmpty) ...[
          const _SectionHeader(title: 'Knowledge Cards'),
          for (final card in knowledgeCards) _KnowledgeCardTile(card: card),
        ],
      ],
    );
  }
}

class _AccountStatusChip extends StatelessWidget {
  const _AccountStatusChip({
    required this.status,
    required this.email,
  });

  final AuthStatus status;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isGuest = status == AuthStatus.guest;
    final label = isGuest ? 'Guest' : (email ?? 'Signed in');

    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: Icon(
        isGuest ? Icons.person_outline : Icons.cloud_done_outlined,
        size: 16,
        color: colorScheme.onSecondaryContainer,
      ),
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 140),
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      side: BorderSide.none,
      backgroundColor: colorScheme.secondaryContainer,
      labelStyle: TextStyle(color: colorScheme.onSecondaryContainer),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

// ── Breadcrumb bar ────────────────────────────────────────────────────────────

class _BreadcrumbBar extends StatelessWidget {
  final AsyncValue<List<DirectoryModel>> breadcrumbs;
  const _BreadcrumbBar({required this.breadcrumbs});

  @override
  Widget build(BuildContext context) {
    final dirs = breadcrumbs.valueOrNull;
    if (dirs == null || dirs.isEmpty) return const SizedBox.shrink();

    final style = Theme.of(context).textTheme.bodySmall;
    final boldStyle = style?.copyWith(fontWeight: FontWeight.w600);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.go('/'),
            borderRadius: BorderRadius.circular(4),
            child: const Icon(Icons.home_outlined, size: 18),
          ),
          for (int i = 0; i < dirs.length; i++) ...[
            const Icon(Icons.chevron_right, size: 18),
            InkWell(
              onTap: i < dirs.length - 1
                  ? () => context.go('/dir/${dirs[i].id}')
                  : null,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  dirs[i].name,
                  style: i == dirs.length - 1 ? boldStyle : style,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Directory tile ────────────────────────────────────────────────────────────

class _DirTile extends ConsumerWidget {
  final DirectoryModel dir;
  const _DirTile({required this.dir});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.folder_outlined),
      title: Text(dir.name),
      trailing: PopupMenuButton<_DirAction>(
        onSelected: (action) => _handleAction(context, ref, action),
        itemBuilder: (_) => [
          const PopupMenuItem(
            value: _DirAction.rename,
            child: Text('Rename'),
          ),
          PopupMenuItem(
            value: _DirAction.delete,
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
      onTap: () => context.push('/dir/${dir.id}'),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, _DirAction action) {
    switch (action) {
      case _DirAction.rename:
        _showRenameDirDialog(context, ref, dir);
      case _DirAction.delete:
        _showDeleteDirDialog(context, ref, dir);
    }
  }
}

// ── Knowledge card tile ───────────────────────────────────────────────────────

class _KnowledgeCardTile extends ConsumerWidget {
  final KnowledgeCardModel card;
  const _KnowledgeCardTile({required this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.style_outlined),
      title: Text(card.title),
      subtitle: card.contentMd.isNotEmpty
          ? Text(
              card.contentMd,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: PopupMenuButton<_CardAction>(
        onSelected: (action) => _handleAction(context, ref, action),
        itemBuilder: (_) => [
          const PopupMenuItem(
            value: _CardAction.edit,
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: _CardAction.addQuestion,
            child: Text('Add Question Card'),
          ),
          PopupMenuItem(
            value: _CardAction.delete,
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
      onTap: () => context.push('/knowledge-card/${card.id}/detail'),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, _CardAction action) {
    switch (action) {
      case _CardAction.edit:
        context.push('/knowledge-card/${card.id}');
      case _CardAction.addQuestion:
        context.push(
          '/question-card/new?dirId=${card.directoryId}&knowledgeCardId=${card.id}',
        );
      case _CardAction.delete:
        _showDeleteCardDialog(context, ref, card);
    }
  }
}

// ── Expandable FAB ────────────────────────────────────────────────────────────

typedef _FabAction = ({IconData icon, String label, VoidCallback onTap});

class _ExpandableFab extends StatefulWidget {
  final List<_FabAction> actions;
  const _ExpandableFab({required this.actions});

  @override
  State<_ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<_ExpandableFab> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_open)
          for (final action in widget.actions.reversed)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(6),
                    color: colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        action.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton.small(
                    heroTag: action.label,
                    onPressed: () {
                      setState(() => _open = false);
                      action.onTap();
                    },
                    child: Icon(action.icon),
                  ),
                ],
              ),
            ),
        FloatingActionButton(
          heroTag: 'main_fab',
          onPressed: () => setState(() => _open = !_open),
          child: AnimatedRotation(
            turns: _open ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

