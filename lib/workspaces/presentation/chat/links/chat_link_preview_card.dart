import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_link_preview.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_link_preview_repository.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_message_link.dart';
import 'package:devplanner/workspaces/presentation/chat/links/chat_external_link_port.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Kompaktowa karta metadanych pobrana i zsanityzowana przez backend.
///
/// Nie wykonuje żądań do URL-a z widgetu. Błąd lub brak integracji pozostawia
/// sam klikalny adres w treści wiadomości.
class ChatLinkPreviewCard extends StatefulWidget {
  /// Tworzy podgląd dozwolonego zewnętrznego linku.
  const ChatLinkPreviewCard({
    required this.conversationId,
    required this.link,
    super.key,
  });

  final String conversationId;
  final ChatMessageLink link;

  @override
  State<ChatLinkPreviewCard> createState() => _ChatLinkPreviewCardState();
}

class _ChatLinkPreviewCardState extends State<ChatLinkPreviewCard> {
  late Future<ChatLinkPreview?> _preview;

  @override
  void initState() {
    super.initState();
    _preview = _load();
  }

  @override
  void didUpdateWidget(covariant ChatLinkPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversationId != widget.conversationId ||
        oldWidget.link.url != widget.link.url) {
      _preview = _load();
    }
  }

  Future<ChatLinkPreview?> _load() async {
    final repository = context.read<ChatLinkPreviewRepository?>();
    if (repository == null || !widget.link.previewAllowed) return null;
    final result = await repository.loadPreview(
      conversationId: widget.conversationId,
      url: widget.link.url,
    );
    return result.fold((_) => null, (preview) => preview);
  }

  Future<void> _open(BuildContext context) async {
    final port = context.read<ChatExternalLinkPort?>();
    final failureText = context.l10n.chatLinkOpenFailed;
    final opened = await port?.open(widget.link.url) ?? false;
    if (!opened && context.mounted) {
      AppToast.show(context, message: failureText, tone: AppToastTone.error);
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<ChatLinkPreview?>(
    future: _preview,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(height: 4);
      }
      final preview = snapshot.data;
      if (preview == null) return const SizedBox.shrink();
      final chat = context.chatTheme;
      final host = Uri.tryParse(preview.finalUrl)?.host;
      final title =
          _textOrNull(preview.title) ??
          _textOrNull(host) ??
          widget.link.host ??
          widget.link.url;
      final description = _textOrNull(preview.description);
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Material(
          color: chat.codeSurface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: InkWell(
            onTap: () => _open(context),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              constraints: const BoxConstraints(minHeight: 54, maxWidth: 520),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: chat.separator),
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3,
                    constraints: const BoxConstraints(minHeight: 34),
                    decoration: BoxDecoration(
                      color: chat.linkText,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Symbols.link_rounded,
                    size: 18,
                    color: chat.metadataText,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: chat.contentStyle.copyWith(
                            color: chat.incomingText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (description != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: chat.metadataStyle.copyWith(
                              color: chat.metadataText,
                            ),
                          ),
                        ],
                        const SizedBox(height: 2),
                        Text(
                          widget.link.host ?? host ?? widget.link.url,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: chat.metadataStyle.copyWith(
                            color: chat.linkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Symbols.open_in_new,
                    size: 16,
                    color: chat.metadataText,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  String? _textOrNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
