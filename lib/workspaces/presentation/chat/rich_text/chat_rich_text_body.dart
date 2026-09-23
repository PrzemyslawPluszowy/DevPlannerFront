import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_message_link.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_plain_text_link_codec.dart';
import 'package:devplanner/workspaces/domain/chat/rich_text/chat_rich_text_codec.dart';
import 'package:devplanner/workspaces/presentation/chat/links/chat_external_link_port.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_display_policy.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Renderer treści wiadomości: delta Quill albo tekst zapasowy.
///
/// Gdy delta jest nieczytelna, pokazuje tekst zapisany w wiadomości, więc
/// historia nigdy nie znika. Renderer tylko prezentuje dane — nie wykonuje
/// HTML ani skryptów. Klient klika wyłącznie adresy zwrócone przez backend lub
/// bezpieczne linki zapisane jako atrybut delty.
class ChatRichTextBody extends StatelessWidget {
  /// Tworzy renderer treści.
  const ChatRichTextBody({
    required this.text,
    this.deltaJson,
    this.style,
    this.links = const <ChatMessageLink>[],
    super.key,
  });

  /// Tekst zapasowy, używany bez czytelnej delty.
  final String text;

  /// Opcjonalny JSON delty Quill.
  final String? deltaJson;

  /// Styl bazowy tekstu wiadomości.
  final TextStyle? style;

  /// Linki rozpoznane przez backend w kanonicznym tekście wiadomości.
  final List<ChatMessageLink> links;

  @override
  Widget build(BuildContext context) {
    final blocks =
        ChatRichTextCodec.tryParse(deltaJson) ??
        <ChatRichTextBlock>[
          ChatRichTextBlock(
            kind: ChatRichTextBlockKind.paragraph,
            spans: <ChatRichTextSpan>[ChatRichTextSpan(text: text)],
          ),
        ];
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
          links: links,
          orderedNumber: block.kind == ChatRichTextBlockKind.orderedList
              ? orderedIndex
              : null,
        ),
      );
    }
    return widgets;
  }
}

class _RichTextBlock extends StatefulWidget {
  const _RichTextBlock({
    required this.block,
    required this.links,
    this.style,
    this.orderedNumber,
  });

  final ChatRichTextBlock block;
  final List<ChatMessageLink> links;
  final TextStyle? style;
  final int? orderedNumber;

  @override
  State<_RichTextBlock> createState() => _RichTextBlockState();
}

class _RichTextBlockState extends State<_RichTextBlock> {
  /// Pary adres–rozpoznawacz dla klikalnych linków bloku.
  List<({String url, TapGestureRecognizer recognizer})> _links =
      const <({String url, TapGestureRecognizer recognizer})>[];

  @override
  void initState() {
    super.initState();
    _links = _createLinks();
  }

  @override
  void didUpdateWidget(covariant _RichTextBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block != widget.block || oldWidget.links != widget.links) {
      _disposeLinks();
      _links = _createLinks();
    }
  }

  @override
  void dispose() {
    _disposeLinks();
    super.dispose();
  }

  List<({String url, TapGestureRecognizer recognizer})> _createLinks() {
    final links = <({String url, TapGestureRecognizer recognizer})>[];
    for (final span in widget.block.spans) {
      if (span.unsupported) continue;
      for (final segment in _segmentsFor(span)) {
        final url = segment.url;
        if (url == null) continue;
        final recognizer = TapGestureRecognizer()
          ..onTapUp = (details) => _openLinkMenu(url, details.globalPosition);
        links.add((url: url, recognizer: recognizer));
      }
    }
    return links;
  }

  void _disposeLinks() {
    for (final link in _links) {
      link.recognizer.dispose();
    }
    _links = const <({String url, TapGestureRecognizer recognizer})>[];
  }

  /// Menu linku zakotwiczone w miejscu kliknięcia: otwarcie i kopiowanie adresu.
  Future<void> _openLinkMenu(String url, Offset position) async {
    if (!mounted) return;
    await AppContextMenu.show(
      context,
      globalPosition: position,
      headerTitle: url,
      actions: <AppContextMenuAction>[
        AppContextMenuAction(
          label: context.l10n.chatLinkOpen,
          icon: Symbols.open_in_new,
          onTap: (menuContext) => unawaited(_openLink(menuContext, url)),
        ),
        AppContextMenuAction(
          label: context.l10n.chatLinkCopy,
          icon: Symbols.content_copy,
          onTap: (_) => unawaited(_copyLink(url)),
        ),
      ],
    );
  }

  Future<void> _openLink(BuildContext context, String url) async {
    // Zależności czytamy przed awaitem, żeby nie używać BuildContext po przerwie.
    final port = context.read<ChatExternalLinkPort?>();
    final failureText = context.l10n.chatLinkOpenFailed;
    final opened = await port?.open(url) ?? false;
    if (!opened && context.mounted) {
      AppToast.show(context, message: failureText, tone: AppToastTone.error);
    }
  }

  Future<void> _copyLink(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final base = widget.style ?? chat.contentStyle;
    switch (widget.block.kind) {
      case ChatRichTextBlockKind.paragraph:
        return Text.rich(_spans(context, base));
      case ChatRichTextBlockKind.bulletList:
        return _MarkerRow(marker: '•', child: _spans(context, base));
      case ChatRichTextBlockKind.orderedList:
        return _MarkerRow(
          marker: '${widget.orderedNumber ?? 1}.',
          child: _spans(context, base),
        );
      case ChatRichTextBlockKind.quote:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: Sizes.p4),
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p8,
            vertical: Sizes.p4,
          ),
          decoration: BoxDecoration(
            color: chat.hoverSurface,
            border: Border(left: BorderSide(color: chat.focusRing, width: 3)),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Text.rich(_spans(context, base)),
        );
      case ChatRichTextBlockKind.code:
        return _CodeBlock(block: widget.block, textStyle: base);
    }
  }

  TextSpan _spans(BuildContext context, TextStyle? base) {
    final chat = context.chatTheme;
    var linkIndex = 0;
    return TextSpan(
      style: base,
      children: [
        for (final span in widget.block.spans)
          if (span.unsupported)
            TextSpan(
              text: context.l10n.chatRichTextUnsupported,
              style: base?.copyWith(
                color: chat.metadataText,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            for (final segment in _segmentsFor(span))
              TextSpan(
                // Długie URL-e często nie mają punktu łamania (np. token w
                // ścieżce lub query). Zera szerokości pozwalają zawinąć
                // wyłącznie renderowany tekst; recognizer i adres docelowy
                // pozostają dokładnie takie jak potwierdzone przez backend.
                text: segment.url == null
                    ? ChatMessageDisplayPolicy.addPlainTextUrlWrapOpportunities(
                        segment.text,
                      )
                    : ChatMessageDisplayPolicy.addLinkWrapOpportunities(
                        segment.text,
                      ),
                recognizer: segment.url == null
                    ? null
                    : _links.elementAtOrNull(linkIndex++)?.recognizer,
                style: base?.copyWith(
                  fontWeight: span.bold ? FontWeight.w900 : null,
                  fontStyle: span.italic ? FontStyle.italic : null,
                  decoration: _decoration(span),
                  fontFamily: span.isCode
                      ? chat.monospaceStyle.fontFamily
                      : null,
                  backgroundColor: span.isCode ? chat.codeSurface : null,
                  color: segment.url != null ? chat.linkText : null,
                ),
              ),
      ],
    );
  }

  List<({String text, String? url})> _segmentsFor(ChatRichTextSpan span) {
    if (span.link case final url?) {
      return <({String text, String? url})>[(text: span.text, url: url)];
    }
    return ChatPlainTextLinkCodec.split(span.text, widget.links);
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
      Expanded(child: Text.rich(child)),
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
              _highlightCode(
                visible.join('\n'),
                language: language,
                baseStyle: (widget.textStyle ?? chat.contentStyle).copyWith(
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

/// Lightweight, deterministic syntax coloring for common code languages.
/// Unknown identifiers and unsupported languages remain readable in the base
/// color; no source content is interpreted or executed.
TextSpan _highlightCode(
  String source, {
  required String? language,
  required TextStyle baseStyle,
}) {
  const keywords = <String, Set<String>>{
    'python': {
      'and',
      'as',
      'assert',
      'async',
      'await',
      'break',
      'class',
      'continue',
      'def',
      'del',
      'elif',
      'else',
      'except',
      'False',
      'finally',
      'for',
      'from',
      'global',
      'if',
      'import',
      'in',
      'is',
      'lambda',
      'nonlocal',
      'not',
      'or',
      'pass',
      'raise',
      'return',
      'True',
      'try',
      'while',
      'with',
      'yield',
      'None',
    },
    'dart': {
      'abstract',
      'as',
      'assert',
      'async',
      'await',
      'break',
      'case',
      'catch',
      'class',
      'const',
      'continue',
      'default',
      'do',
      'else',
      'enum',
      'extends',
      'factory',
      'false',
      'final',
      'finally',
      'for',
      'if',
      'implements',
      'import',
      'in',
      'is',
      'late',
      'library',
      'mixin',
      'new',
      'null',
      'of',
      'on',
      'operator',
      'part',
      'required',
      'rethrow',
      'return',
      'sealed',
      'set',
      'static',
      'super',
      'switch',
      'this',
      'throw',
      'true',
      'try',
      'typedef',
      'var',
      'void',
      'when',
      'while',
      'with',
      'yield',
    },
    'javascript': {
      'async',
      'await',
      'break',
      'case',
      'catch',
      'class',
      'const',
      'continue',
      'debugger',
      'default',
      'delete',
      'do',
      'else',
      'export',
      'extends',
      'false',
      'finally',
      'for',
      'from',
      'function',
      'if',
      'import',
      'in',
      'instanceof',
      'let',
      'new',
      'null',
      'of',
      'return',
      'static',
      'super',
      'switch',
      'this',
      'throw',
      'true',
      'try',
      'typeof',
      'var',
      'void',
      'while',
      'yield',
    },
    'typescript': {
      'as',
      'async',
      'await',
      'break',
      'case',
      'catch',
      'class',
      'const',
      'continue',
      'default',
      'delete',
      'do',
      'else',
      'enum',
      'export',
      'extends',
      'false',
      'finally',
      'for',
      'from',
      'function',
      'if',
      'implements',
      'import',
      'in',
      'instanceof',
      'interface',
      'keyof',
      'let',
      'new',
      'null',
      'of',
      'private',
      'protected',
      'public',
      'readonly',
      'return',
      'static',
      'super',
      'switch',
      'this',
      'throw',
      'true',
      'try',
      'type',
      'typeof',
      'var',
      'void',
      'while',
      'yield',
    },
    'csharp': {
      'abstract',
      'as',
      'async',
      'await',
      'base',
      'bool',
      'break',
      'byte',
      'case',
      'catch',
      'char',
      'checked',
      'class',
      'const',
      'continue',
      'decimal',
      'default',
      'delegate',
      'do',
      'double',
      'else',
      'enum',
      'event',
      'explicit',
      'extern',
      'false',
      'finally',
      'float',
      'for',
      'foreach',
      'if',
      'implicit',
      'in',
      'int',
      'interface',
      'internal',
      'is',
      'lock',
      'long',
      'namespace',
      'new',
      'null',
      'object',
      'operator',
      'out',
      'override',
      'params',
      'private',
      'protected',
      'public',
      'readonly',
      'ref',
      'return',
      'sealed',
      'short',
      'sizeof',
      'static',
      'string',
      'struct',
      'switch',
      'this',
      'throw',
      'true',
      'try',
      'typeof',
      'using',
      'var',
      'virtual',
      'void',
      'while',
    },
    'sql': {
      'all',
      'alter',
      'and',
      'as',
      'asc',
      'begin',
      'between',
      'by',
      'case',
      'commit',
      'create',
      'delete',
      'desc',
      'distinct',
      'drop',
      'else',
      'end',
      'from',
      'group',
      'having',
      'in',
      'insert',
      'into',
      'is',
      'join',
      'left',
      'like',
      'limit',
      'not',
      'null',
      'on',
      'or',
      'order',
      'right',
      'rollback',
      'select',
      'set',
      'table',
      'then',
      'union',
      'update',
      'values',
      'when',
      'where',
    },
  };
  final normalized = switch (language?.toLowerCase().replaceAll(' ', '')) {
    'py' || 'python3' => 'python',
    'js' || 'jsx' || 'mjs' => 'javascript',
    'ts' || 'tsx' => 'typescript',
    'cs' || 'c#' => 'csharp',
    'sh' || 'bash' || 'zsh' || 'shell' => 'shell',
    final value => value ?? '',
  };
  final languageKeywords = keywords[normalized] ?? const <String>{};
  final pattern = RegExp(
    r'''(?:"{3}[\s\S]*?"{3}|//[^\n]*|#[^\n]*|--[^\n]*|/\*[\s\S]*?\*/|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|`(?:\\.|[^`\\])*`|\b\d+(?:\.\d+)?\b|[A-Za-z_$][A-Za-z0-9_$]*|[^\s])''',
  );
  final spans = <TextSpan>[];
  var cursor = 0;
  for (final match in pattern.allMatches(source)) {
    if (match.start > cursor) {
      spans.add(TextSpan(text: source.substring(cursor, match.start)));
    }
    final token = match.group(0)!;
    final isComment =
        token.startsWith('//') ||
        token.startsWith('#') ||
        token.startsWith('--') ||
        token.startsWith('/*');
    final isString =
        token.startsWith('"') || token.startsWith("'") || token.startsWith('`');
    final isNumber = RegExp(r'^\d').hasMatch(token);
    final isIdentifier = RegExp(r'^[A-Za-z_$]').hasMatch(token);
    final color = isComment
        ? const Color(0xff8b949e)
        : isString
        ? const Color(0xffa5d6ff)
        : isNumber
        ? const Color(0xff79c0ff)
        : isIdentifier && languageKeywords.contains(token)
        ? const Color(0xffff7b72)
        : isIdentifier &&
              token.isNotEmpty &&
              token.codeUnitAt(0) >= 65 &&
              token.codeUnitAt(0) <= 90
        ? const Color(0xffd2a8ff)
        : isIdentifier
        ? baseStyle.color
        : const Color(0xffffa657);
    spans.add(
      TextSpan(
        text: token,
        style: TextStyle(color: color),
      ),
    );
    cursor = match.end;
  }
  if (cursor < source.length) {
    spans.add(TextSpan(text: source.substring(cursor)));
  }
  return TextSpan(style: baseStyle, children: spans);
}
