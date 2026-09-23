import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_attachment.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_attachment_access_port.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Formatuje rozmiar pliku do krótkiej etykiety (B/KB/MB/GB).
///
/// Zaokrąglenie jest deterministyczne i niezależne od locale, bo rozmiar jest
/// daną techniczną; jednostkę pokazujemy obok w kartach załączników.
String formatChatFileSize(int bytes) {
  if (bytes < 0) return '—';
  if (bytes < 1024) return '$bytes B';
  final kilobytes = bytes / 1024;
  if (kilobytes < 1024) {
    return '${kilobytes.toStringAsFixed(kilobytes < 10 ? 1 : 0)} KB';
  }
  final megabytes = kilobytes / 1024;
  if (megabytes < 1024) {
    return '${megabytes.toStringAsFixed(megabytes < 10 ? 1 : 0)} MB';
  }
  final gigabytes = megabytes / 1024;
  return '${gigabytes.toStringAsFixed(1)} GB';
}

/// Karty załączników wiadomości w historii.
///
/// Pokazuje nazwę, rozmiar i typ pliku z metadanych serwera. Usunięty albo
/// nieczysty plik ma własny, jawny stan niedostępny zamiast znikania lub
/// udawania, że da się go pobrać.
class ChatMessageAttachments extends StatelessWidget {
  /// Tworzy listę kart załączników.
  const ChatMessageAttachments({required this.attachments, super.key});

  final List<ChatMessageAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final attachment in attachments)
          Padding(
            padding: const EdgeInsets.only(top: Sizes.p4),
            child: _AttachmentCard(
              key: ValueKey<String>('chat-attachment-card:${attachment.id}'),
              attachment: attachment,
            ),
          ),
      ],
    );
  }
}

class _AttachmentCard extends StatefulWidget {
  const _AttachmentCard({required this.attachment, super.key});

  final ChatMessageAttachment attachment;

  @override
  State<_AttachmentCard> createState() => _AttachmentCardState();
}

class _AttachmentCardState extends State<_AttachmentCard> {
  bool _opening = false;
  Future<Uint8List?>? _thumbnail;
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(covariant _AttachmentCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attachment.storageFileId != widget.attachment.storageFileId) {
      _thumbnail = null;
      _thumbnailBytes = null;
      _loadThumbnail();
    }
  }

  /// Miniatura tylko dla obrazów i tylko przez autoryzowany port Storage.
  ///
  /// Brak portu albo brak obrazu zostawia ikonę pliku; nie zgadujemy adresu
  /// ani nie pokazujemy podglądu bez potwierdzenia dostępności pliku.
  void _loadThumbnail() {
    final attachment = widget.attachment;
    if (!attachment.isAvailable || !attachment.isImage) return;
    final port = context.read<ChatAttachmentAccessPort?>();
    if (port == null) return;
    final request = port.thumbnail(attachment.storageFileId);
    _thumbnail = request;
    unawaited(_captureThumbnail(request));
  }

  Future<void> _captureThumbnail(Future<Uint8List?> request) async {
    Uint8List? bytes;
    try {
      bytes = await request;
    } on Object {
      // Miniatura jest tylko ulepszeniem UI; przy błędzie karta zostaje plikiem.
    }
    if (!mounted || !identical(_thumbnail, request)) return;
    setState(() {
      _thumbnailBytes = bytes == null || bytes.isEmpty ? null : bytes;
    });
  }

  /// Akcje menu załącznika: tylko te, które naprawdę da się wykonać.
  ///
  /// Obraz ma podgląd i pobranie, dokument ma otwarcie przez autoryzowaną
  /// ścieżkę; „Kopiuj nazwę” działa zawsze, bo nazwa pochodzi z serwera.
  List<AppContextMenuAction> _menuActions(BuildContext context) {
    final port = context.read<ChatAttachmentAccessPort?>();
    final attachment = widget.attachment;
    final canUse = attachment.isAvailable && port != null;
    return <AppContextMenuAction>[
      if (canUse && _thumbnailBytes != null)
        AppContextMenuAction(
          label: context.l10n.chatAttachmentPreview,
          icon: Symbols.visibility,
          onTap: (_) => unawaited(_open()),
        ),
      if (canUse && _thumbnailBytes == null)
        AppContextMenuAction(
          label: context.l10n.chatAttachmentOpen,
          icon: Symbols.open_in_new,
          onTap: (_) => unawaited(_download(port)),
        ),
      if (canUse && _thumbnailBytes != null)
        AppContextMenuAction(
          label: context.l10n.chatAttachmentDownload,
          icon: Symbols.download,
          onTap: (_) => unawaited(_download(port)),
        ),
      AppContextMenuAction(
        label: context.l10n.chatAttachmentCopyName,
        icon: Symbols.content_copy,
        onTap: (_) => unawaited(_copyName()),
      ),
    ];
  }

  Future<void> _copyName() => Clipboard.setData(
    ClipboardData(text: widget.attachment.label),
  );

  /// Otwiera załącznik: obraz dostaje podgląd w aplikacji, reszta idzie do systemu.
  ///
  /// Bajty miniatury są jednym, memoizowanym future, więc galeria nie pobiera
  /// tego samego pliku drugi raz.
  Future<void> _open() async {
    final port = context.read<ChatAttachmentAccessPort?>();
    if (port == null) return;
    if (_thumbnailBytes case final bytes?) {
      await DevPlannerModalHost.showDialog<void>(
        context,
        builder: (_) => _ChatImagePreviewDialog(
          attachment: widget.attachment,
          bytes: Future<Uint8List?>.value(bytes),
          port: port,
        ),
      );
      return;
    }
    await _download(port);
  }

  /// Zapisuje plik na urządzeniu przez autoryzowaną ścieżkę Storage.
  ///
  /// Brak portu oznacza środowisko bez bezpiecznego pobierania — karta nie
  /// udaje wtedy akcji, a porażka jest pokazana z komunikatem serwera.
  Future<void> _download(ChatAttachmentAccessPort port) async {
    if (_opening) return;
    setState(() => _opening = true);
    final failure = await port.open(widget.attachment.storageFileId);
    if (!mounted) return;
    setState(() => _opening = false);
    if (failure == null) return;
    AppToast.show(
      context,
      message: failure.message,
      tone: AppToastTone.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final attachment = widget.attachment;
    final available = attachment.isAvailable;
    final muted = chat.metadataText;
    final canOpen =
        available && context.watch<ChatAttachmentAccessPort?>() != null;
    final details = <String>[
      if (attachment.fileSizeBytes case final size?) formatChatFileSize(size),
      if (attachment.contentType?.trim() case final type? when type.isNotEmpty)
        type,
    ].join(' · ');
    return AppContextMenuRegion(
      actionsBuilder: _menuActions,
      headerTitle: attachment.label,
      child: Material(
        color: chat.listSurface,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: BorderSide(
            color: available ? chat.separator : chat.error,
          ),
        ),
        child: InkWell(
          key: ValueKey<String>('chat-attachment-${attachment.id}'),
          onTap: canOpen ? _open : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Row(
              children: [
                _AttachmentThumbnail(
                  future: _thumbnail,
                  fallback: Icon(
                    available ? Symbols.insert_drive_file : Symbols.link_off,
                    size: 18,
                    color: available ? muted : chat.error,
                  ),
                ),
                const SizedBox(width: Sizes.p8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chat.contentStyle.copyWith(
                          color: chat.incomingText,
                        ),
                      ),
                      Text(
                        available
                            ? details
                            : context.l10n.chatAttachmentUnavailable,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chat.metadataStyle.copyWith(
                          color: available ? muted : chat.error,
                        ),
                      ),
                    ],
                  ),
                ),
                if (canOpen) ...[
                  const SizedBox(width: Sizes.p8),
                  if (_opening)
                    const SizedBox.square(
                      dimension: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Tooltip(
                      message: context.l10n.chatAttachmentOpen,
                      child: Icon(
                        _thumbnailBytes == null
                            ? Symbols.download
                            : Symbols.visibility,
                        size: 18,
                        color: muted,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Miniatura obrazu pobrana autoryzowanym portem; brak danych wraca do ikony.
class _AttachmentThumbnail extends StatelessWidget {
  const _AttachmentThumbnail({required this.future, required this.fallback});

  final Future<Uint8List?>? future;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    final pending = future;
    if (pending == null) return fallback;
    return SizedBox.square(
      dimension: 36,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: FutureBuilder<Uint8List?>(
          future: pending,
          builder: (context, snapshot) {
            final bytes = snapshot.data;
            if (bytes == null || bytes.isEmpty) return fallback;
            return Image.memory(bytes, fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}

/// Pełnoekranowy podgląd obrazu z już pobranych, autoryzowanych bajtów.
///
/// Galeria pokazuje wyłącznie bajty uzyskane portem Storage; pobranie pliku na
/// urządzenie zostaje osobną akcją, żeby podgląd nie zapisywał nic po cichu.
class _ChatImagePreviewDialog extends StatefulWidget {
  const _ChatImagePreviewDialog({
    required this.attachment,
    required this.bytes,
    required this.port,
  });

  final ChatMessageAttachment attachment;
  final Future<Uint8List?> bytes;
  final ChatAttachmentAccessPort port;

  @override
  State<_ChatImagePreviewDialog> createState() =>
      _ChatImagePreviewDialogState();
}

class _ChatImagePreviewDialogState extends State<_ChatImagePreviewDialog> {
  bool _downloading = false;

  Future<void> _download() async {
    if (_downloading) return;
    setState(() => _downloading = true);
    final failure = await widget.port.open(widget.attachment.storageFileId);
    if (!mounted) return;
    setState(() => _downloading = false);
    if (failure == null) return;
    AppToast.show(
      context,
      message: failure.message,
      tone: AppToastTone.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChatSurfaceDialog(
      title: widget.attachment.label,
      maxWidth: 720,
      content: SizedBox(
        height: 440,
        child: FutureBuilder<Uint8List?>(
          future: widget.bytes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final bytes = snapshot.data;
            if (bytes == null || bytes.isEmpty) {
              return Center(
                child: Text(
                  context.l10n.chatAttachmentUnavailable,
                  textAlign: TextAlign.center,
                ),
              );
            }
            return InteractiveViewer(
              child: Image.memory(bytes, fit: BoxFit.contain),
            );
          },
        ),
      ),
      actions: [
        if (_downloading)
          const Padding(
            padding: EdgeInsets.all(Sizes.p8),
            child: SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          TextButton.icon(
            onPressed: _download,
            icon: const Icon(Symbols.download),
            label: Text(context.l10n.chatAttachmentOpen),
          ),
      ],
    );
  }
}
