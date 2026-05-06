import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// A tabbed widget with a "Write" (raw text) tab and a "Preview" (rendered
/// Markdown) tab. Pass in a [TextEditingController] that the parent owns.
class MarkdownEditorWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const MarkdownEditorWidget({
    super.key,
    required this.controller,
    this.label = 'Content (Markdown supported)',
  });

  @override
  State<MarkdownEditorWidget> createState() => _MarkdownEditorWidgetState();
}

class _MarkdownEditorWidgetState extends State<MarkdownEditorWidget>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Rebuild to update Preview when text changes.
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Write'),
            Tab(text: 'Preview'),
          ],
        ),
        SizedBox(
          height: 240,
          child: TabBarView(
            controller: _tabController,
            children: [
              // ── Write ──────────────────────────────────────────────────
              TextField(
                controller: widget.controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: widget.label,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              // ── Preview ────────────────────────────────────────────────
              widget.controller.text.trim().isEmpty
                  ? Center(
                      child: Text(
                        'Nothing to preview',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  : Markdown(
                      data: widget.controller.text,
                      padding: const EdgeInsets.all(12),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
