import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/data/changelog_loader.dart';

/// Ciało modalu changeloga, oddzielone od odpowiedzialności globalnego shellu.
class AppShellChangelogBody extends StatelessWidget {
  const AppShellChangelogBody({required this.assetPath, super.key});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadFreshChangelog(assetPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(Sizes.p12),
            child: Text(context.l10n.appShellChangelogLoadError),
          );
        }
        final markdown = snapshot.data ?? '';
        if (markdown.trim().isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(Sizes.p12),
            child: Text(context.l10n.appShellChangelogEmpty),
          );
        }
        final styleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context))
            .copyWith(
              p: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurface,
                height: 1.45,
              ),
              h2: context.text.titleMedium?.copyWith(
                color: context.colors.onSurface,
                fontWeight: .w700,
              ),
              blockquote: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontStyle: .italic,
              ),
              code: context.text.bodySmall?.copyWith(
                color: context.colors.primary,
              ),
            );
        return _ChangelogEntries(
          entries: _ChangelogEntryParser(markdown).entries,
          styleSheet: styleSheet,
        );
      },
    );
  }
}

/// Parser wpisów changeloga pozostający poza widgetem prezentacyjnym.
class _ChangelogEntryParser {
  const _ChangelogEntryParser(this.markdown);

  final String markdown;

  List<String> get entries {
    final lines = markdown.split('\n');
    final headers = [
      for (var index = 0; index < lines.length; index++)
        if (lines[index].startsWith('## ')) index,
    ];
    if (headers.isEmpty) return [markdown];
    return [
      for (var index = 0; index < headers.length; index++)
        lines
            .sublist(
              headers[index],
              index + 1 < headers.length ? headers[index + 1] : lines.length,
            )
            .join('\n'),
    ];
  }
}

/// Zwięzły widok wpisów changeloga z lokalną kontrolą rozwinięcia.
class _ChangelogEntries extends StatefulWidget {
  const _ChangelogEntries({required this.entries, required this.styleSheet});

  final List<String> entries;
  final MarkdownStyleSheet styleSheet;

  @override
  State<_ChangelogEntries> createState() => _ChangelogEntriesState();
}

/// Lokalny stan rozwinięcia listy wpisów changeloga.
class _ChangelogEntriesState extends State<_ChangelogEntries> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final visible = _showAll ? widget.entries : widget.entries.take(2).toList();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          for (final entry in visible)
            Padding(
              padding: const .only(bottom: Sizes.p12),
              child: MarkdownBody(data: entry, styleSheet: widget.styleSheet),
            ),
          if (widget.entries.length > visible.length)
            Align(
              alignment: .centerLeft,
              child: TextButton(
                onPressed: () => setState(() => _showAll = true),
                child: Text(context.l10n.appShellChangelogShowAll),
              ),
            ),
        ],
      ),
    );
  }
}
