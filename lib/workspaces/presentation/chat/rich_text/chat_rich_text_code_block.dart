import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/rich_text/chat_rich_text_codec.dart';
import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_code_syntax_highlighter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Blok kodu: monospace, poziomy scroll, kopiowanie i zwijanie długiej treści.
final class ChatRichTextCodeBlock extends StatefulWidget {
  const ChatRichTextCodeBlock({
    required this.block,
    this.textStyle,
    super.key,
  });

  final ChatRichTextBlock block;
  final TextStyle? textStyle;

  @override
  State<ChatRichTextCodeBlock> createState() => _ChatRichTextCodeBlockState();
}

final class _ChatRichTextCodeBlockState extends State<ChatRichTextCodeBlock> {
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
    final chat = context.chatTheme;
    final lines = _lines;
    final visible = _collapsible && !_expanded
        ? lines.take(_collapseThreshold).toList(growable: false)
        : lines;
    final language = widget.block.language;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: Sizes.p4),
      decoration: BoxDecoration(
        color: const Color(0xff0d1117),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: chat.separator),
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
                    style: chat.metadataStyle.copyWith(
                      color: chat.metadataText,
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
            child: Text.rich(
              ChatCodeSyntaxHighlighter.highlight(
                visible.join('\n'),
                language: language,
                baseStyle: (widget.textStyle ?? chat.contentStyle).copyWith(
                  // Keep code compact in the conversation while preserving
                  // legibility at normal desktop and mobile text scales.
                  fontSize: 12,
                  height: 1.35,
                  fontFamily: chat.monospaceStyle.fontFamily,
                  fontFamilyFallback: chat.monospaceStyle.fontFamilyFallback,
                  color: const Color(0xffe6edf3),
                ),
              ),
            ),
          ),
          const SizedBox(height: Sizes.p8),
        ],
      ),
    );
  }
}
