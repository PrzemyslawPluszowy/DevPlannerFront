import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_message_link.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_plain_text_link_codec.dart';
import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:devplanner/workspaces/domain/chat/rich_text/chat_rich_text_codec.dart';
import 'package:devplanner/workspaces/presentation/chat/links/chat_external_link_port.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_display_policy.dart';
import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_rich_text_code_block.dart';
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
    this.mentionLabels = const <String, String>{},
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

  /// Etykiety wzmianek z odpowiedzi backendu; UUID nigdy nie jest etykietą UI.
  final Map<String, String> mentionLabels;

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
          mentionLabels: mentionLabels,
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
    required this.mentionLabels,
    this.style,
    this.orderedNumber,
  });

  final ChatRichTextBlock block;
  final List<ChatMessageLink> links;
  final Map<String, String> mentionLabels;
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
        return _MarkerRow(
          marker: '•',
          markerStyle: _markerStyle(base, chat),
          child: _spans(context, base),
        );
      case ChatRichTextBlockKind.orderedList:
        return _MarkerRow(
          marker: '${widget.orderedNumber ?? 1}.',
          markerStyle: _markerStyle(base, chat),
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
        return ChatRichTextCodeBlock(block: widget.block, textStyle: base);
    }
  }

  static TextStyle _markerStyle(TextStyle? base, DevPlannerChatTheme chat) =>
      (base ?? chat.contentStyle).copyWith(
        color: base?.color ?? chat.incomingText,
        fontWeight: FontWeight.w700,
      );

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
                        ChatMentionCodec.renderText(
                          segment.text,
                          widget.mentionLabels,
                          fallbackLabel: context.l10n.chatMentionUnknownMember,
                        ),
                      )
                    : ChatMessageDisplayPolicy.addLinkWrapOpportunities(
                        segment.text,
                      ),
                recognizer: segment.url == null
                    ? null
                    : _links.elementAtOrNull(linkIndex++)?.recognizer,
                style: base?.copyWith(
                  fontWeight: span.bold ? FontWeight.w700 : null,
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
  const _MarkerRow({
    required this.marker,
    required this.markerStyle,
    required this.child,
  });

  final String marker;
  final TextStyle markerStyle;
  final InlineSpan child;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Keep a readable gutter while letting 10., 100. and longer counters
      // claim their intrinsic width instead of clipping inside a 24 px box.
      ConstrainedBox(
        constraints: const BoxConstraints(minWidth: Sizes.p24),
        child: Text(
          marker,
          style: markerStyle,
          textAlign: TextAlign.end,
        ),
      ),
      Expanded(child: Text.rich(child)),
    ],
  );
}
