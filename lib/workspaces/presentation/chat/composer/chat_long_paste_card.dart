import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_message_attachments.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_long_paste_decision.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Karta decyzji dla długiego wklejenia nad powierzchnią pisania.
///
/// Nic nie dzieje się po cichu: użytkownik widzi nazwę i rozmiar pliku oraz
/// pierwsze linie treści, a wybór należy do niego. „Zostaw jako tekst” jest
/// zablokowane z powodem, gdy treść przekracza limit wejścia snippet-u — wtedy
/// jedyną drogą jest plik, a nie obcięta wiadomość.
class ChatLongPasteCard extends StatelessWidget {
  /// Tworzy kartę decyzji.
  const ChatLongPasteCard({
    required this.assessment,
    required this.fileName,
    required this.onSendAsFile,
    required this.onKeepAsText,
    required this.onCancel,
    this.busy = false,
    this.failureMessage,
    this.notice,
    super.key,
  });

  /// Ocena wklejenia: rozmiar, znaki i podgląd.
  final ChatLongPasteAssessment assessment;

  /// Nazwa pliku proponowana przez backend.
  final String fileName;

  /// Wysyła tekst jako plik TXT; brak oznacza brak akcji.
  final VoidCallback? onSendAsFile;

  /// Zostawia tekst w wiadomości; `null` blokuje akcję (przekroczony limit).
  final VoidCallback? onKeepAsText;

  /// Anuluje wklejenie bez zmiany szkicu.
  final VoidCallback onCancel;

  /// Czy trwa przygotowanie pliku.
  final bool busy;

  /// Komunikat błędu przygotowania pliku.
  final String? failureMessage;

  /// Informacja, np. o skróceniu treści przez backend.
  final String? notice;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final keepEnabled = onKeepAsText != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: chat.listSurface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: chat.separator),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Symbols.description,
                    size: Sizes.p18,
                    color: chat.metadataText,
                  ),
                  const SizedBox(width: Sizes.p8),
                  Expanded(
                    child: Text(
                      context.l10n.chatLongPasteTitle,
                      style: chat.authorStyle.copyWith(
                        color: chat.incomingText,
                      ),
                    ),
                  ),
                  if (busy)
                    const SizedBox.square(
                      dimension: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: Sizes.p4),
              Text(
                context.l10n.chatLongPasteFileDetails(
                  fileName,
                  formatChatFileSize(assessment.byteLength),
                ),
                style: chat.metadataStyle.copyWith(color: chat.metadataText),
              ),
              if (assessment.previewLines.isNotEmpty) ...[
                const SizedBox(height: Sizes.p4),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: chat.codeSurface,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final line in assessment.previewLines)
                          Text(
                            line.isEmpty ? ' ' : line,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: chat.monospaceStyle.copyWith(
                              fontSize: 12,
                              color: chat.incomingText,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              if (notice != null) ...[
                const SizedBox(height: Sizes.p4),
                Text(
                  notice!,
                  style: chat.metadataStyle.copyWith(color: chat.metadataText),
                ),
              ],
              if (failureMessage != null) ...[
                const SizedBox(height: Sizes.p4),
                Text(
                  failureMessage!,
                  style: chat.metadataStyle.copyWith(color: chat.error),
                ),
              ],
              const SizedBox(height: Sizes.p4),
              Wrap(
                spacing: Sizes.p4,
                runSpacing: Sizes.p4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton(
                    key: const ValueKey('chat-long-paste-as-file'),
                    onPressed: busy ? null : onSendAsFile,
                    child: Text(context.l10n.chatLongPasteSendAsFile),
                  ),
                  Tooltip(
                    message: keepEnabled
                        ? context.l10n.chatLongPasteKeepAsText
                        : context.l10n.chatLongPasteOverLimit,
                    child: TextButton(
                      key: const ValueKey('chat-long-paste-keep'),
                      onPressed: busy ? null : onKeepAsText,
                      child: Text(context.l10n.chatLongPasteKeepAsText),
                    ),
                  ),
                  TextButton(
                    key: const ValueKey('chat-long-paste-cancel'),
                    onPressed: busy ? null : onCancel,
                    child: Text(context.l10n.chatLongPasteCancel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
