import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/rich_text/chat_rich_text_codec.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Renderer treści wiadomości: delta Quill albo tekst zapasowy.
///
/// Gdy delta jest nieczytelna, pokazuje tekst zapisany w wiadomości, więc
/// historia nigdy nie znika. Renderer tylko prezentuje dane — nie wykonuje
/// HTML ani skryptów, a linki pozostają stylem, nie akcją.
class ChatRichTextBody extends StatelessWidget {
  /// Tworzy renderer treści.
  const ChatRichTextBody({
    required this.text,
    this.deltaJson,
    this.style,
    super.key,
  });

  /// Tekst zapasowy, używany bez czytelnej delty.
  final String text;

  /// Opcjonalny JSON delty Quill.
  final String? deltaJson;

  /// Styl bazowy tekstu wiadomości.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final blocks = ChatRichTextCodec.tryParse(deltaJson);
    if (blocks == null) return Text(text, style: style);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: _withListNumbers(context, blocks),
    );
  }

  /// Numeruje kolejne elementy listy numerowanej w obrębie jednego ciągu.
  List<Widget> _withListNumbers(
    BuildContext context,
    List<ChatRichTextBlock> blocks,
  ) {
    final widgets = <Widget>[];
    var orderedIndex = 0;
    for (final block in blocks) {
      orderedIndex = block.kind == ChatRichTextBlockKind.orderedList
          ? orderedIndex + 1
          : 0;
      widgets.add(
        _RichTextBlock(
          block: block,
          style: style,
          orderedNumber: block.kind == ChatRichTextBlockKind.orderedList
              ? orderedIndex
              : null,
        ),
      );
    }
    return widgets;
  }
}

class _RichTextBlock extends StatelessWidget {
  const _RichTextBlock({
    required this.block,
    this.style,
    this.orderedNumber,
  });

  final ChatRichTextBlock block;
  final TextStyle? style;
  final int? orderedNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = style ?? theme.textTheme.bodyMedium;
    switch (block.kind) {
      case ChatRichTextBlockKind.paragraph:
        return RichText(text: _spans(context, block, base));
      case ChatRichTextBlockKind.bulletList:
        return _MarkerRow(marker: '•', child: _spans(context, block, base));
      case ChatRichTextBlockKind.orderedList:
        return _MarkerRow(
          marker: '${orderedNumber ?? 1}.',
          child: _spans(context, block, base),
        );
      case ChatRichTextBlockKind.quote:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: Sizes.p2),
          padding: const EdgeInsets.only(left: Sizes.p8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.outlineVariant,
                width: 3,
              ),
            ),
          ),
          child: RichText(text: _spans(context, block, base)),
        );
      case ChatRichTextBlockKind.code:
        return _CodeBlock(block: block, textStyle: base);
    }
  }

  static TextSpan _spans(
    BuildContext context,
    ChatRichTextBlock block,
    TextStyle? base,
  ) {
    final theme = Theme.of(context);
    return TextSpan(
      style: base,
      children: [
        for (final span in block.spans)
          if (span.unsupported)
            TextSpan(
              text: context.l10n.chatRichTextUnsupported,
              style: base?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            TextSpan(
              text: span.text,
              style: base?.copyWith(
                fontWeight: span.bold ? FontWeight.w600 : null,
                fontStyle: span.italic ? FontStyle.italic : null,
                decoration: _decoration(span),
                fontFamily: span.isCode ? 'monospace' : null,
                backgroundColor: span.isCode
                    ? theme.colorScheme.surfaceContainerHighest
                    : null,
                color: span.link != null ? theme.colorScheme.primary : null,
              ),
            ),
      ],
    );
  }

  static TextDecoration? _decoration(ChatRichTextSpan span) {
    final decorations = <TextDecoration>[
      if (span.underline || span.link != null) TextDecoration.underline,
      if (span.strike) TextDecoration.lineThrough,
    ];
    if (decorations.isEmpty) return null;
    return TextDecoration.combine(decorations);
  }
}

class _MarkerRow extends StatelessWidget {
  const _MarkerRow({required this.marker, required this.child});

  final String marker;
  final InlineSpan child;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(width: Sizes.p24, child: Text(marker)),
      Expanded(child: RichText(text: child)),
    ],
  );
}

/// Blok kodu: monospace, poziomy scroll, kopiowanie i zwijanie długiej treści.
class _CodeBlock extends StatefulWidget {
  const _CodeBlock({required this.block, this.textStyle});

  final ChatRichTextBlock block;
  final TextStyle? textStyle;

  @override
  State<_CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<_CodeBlock> {
  /// Od tylu linii blok startuje zwinięty, żeby nie zdominował historii.
  static const int _collapseThreshold = 12;

  bool _copied = false;
  bool _expanded = false;

  List<String> get _lines =>
      widget.block.spans.map((span) => span.text).join().split('\n');

  bool get _collapsible => _lines.length > _collapseThreshold;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: _lines.join('\n')));
    if (!mounted) return;
    setState(() => _copied = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = _lines;
    final visible = _collapsible && !_expanded
        ? lines.take(_collapseThreshold).toList(growable: false)
        : lines;
    final language = widget.block.language;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: Sizes.p4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (language != null && language.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: Sizes.p8),
                  child: Text(
                    language,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              const Spacer(),
              if (_collapsible)
                TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded
                        ? context.l10n.chatRichTextShowLess
                        : context.l10n.chatRichTextShowMore,
                  ),
                ),
              IconButton(
                tooltip: _copied
                    ? context.l10n.chatRichTextCopied
                    : context.l10n.chatRichTextCopy,
                onPressed: _copy,
                icon: Icon(
                  _copied ? Symbols.check : Symbols.content_copy,
                  size: 16,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
            child: Text(
              visible.join('\n'),
              style: (widget.textStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: Sizes.p8),
        ],
      ),
    );
  }
}
