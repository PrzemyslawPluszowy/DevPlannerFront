import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_context_source.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Lista rozmów kontekstowych (Pliki, Zadania / Kanban) z §2.7 planu korekty.
///
/// Do czasu podłączenia integracji zakładka pokazuje uczciwy stan: bez
/// fałszywego zera nieprzeczytanych, bez spinnera bez końca i bez przycisku
/// tworzenia, który nic nie robi. Pełne wiersze ogląda się w oznaczonym
/// podglądzie z danymi syntetycznymi — podgląd jest lokalny dla tego widoku i
/// nie trafia do żadnego repozytorium, bo nie jest danymi użytkownika.
class ChatContextConversationsPane extends StatefulWidget {
  /// Tworzy pane dla wskazanego rodzaju źródła.
  const ChatContextConversationsPane({required this.kind, super.key});

  final ChatContextSourceKind kind;

  @override
  State<ChatContextConversationsPane> createState() =>
      _ChatContextConversationsPaneState();
}

class _ChatContextConversationsPaneState
    extends State<ChatContextConversationsPane> {
  bool _preview = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final title = switch (widget.kind) {
      ChatContextSourceKind.file => l10n.chatFilesNotConnectedTitle,
      ChatContextSourceKind.task => l10n.chatTasksNotConnectedTitle,
    };
    final message = switch (widget.kind) {
      ChatContextSourceKind.file => l10n.chatFilesNotConnectedMessage,
      ChatContextSourceKind.task => l10n.chatTasksNotConnectedMessage,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(Sizes.p16),
            children: [
              Icon(
                widget.kind == ChatContextSourceKind.file
                    ? Symbols.folder_rounded
                    : Symbols.view_kanban_rounded,
                size: 40,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              Gaps.h12,
              Text(title, style: theme.textTheme.titleSmall),
              Gaps.h4,
              Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Gaps.h12,
              if (_preview) ...[
                const _ChatContextPreviewBadge(),
                Gaps.h8,
                for (final view in _previewRows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Sizes.p4),
                    child: ChatContextConversationRow(view: view),
                  ),
              ],
            ],
          ),
        ),
        if (!_preview)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p16,
              0,
              Sizes.p16,
              Sizes.p16,
            ),
            child: OutlinedButton.icon(
              key: const ValueKey('chat-context-preview-open'),
              onPressed: () => setState(() => _preview = true),
              icon: const Icon(Symbols.visibility_rounded, size: 18),
              label: Text(l10n.chatContextPreviewOpen),
            ),
          ),
      ],
    );
  }

  /// Syntetyczne pozycje podglądu: wzmianka, długi tytuł, unread i brak dostępu.
  List<ChatContextConversationView> get _previewRows => switch (widget.kind) {
    ChatContextSourceKind.file => _filePreviewRows,
    ChatContextSourceKind.task => _taskPreviewRows,
  };

  static final List<ChatContextConversationView> _filePreviewRows =
      <ChatContextConversationView>[
        ChatContextConversationView(
          conversationId: 'preview-file-1',
          resourceId: 'file-1',
          kind: ChatContextSourceKind.file,
          title: 'Specyfikacja integracji Storage.pdf',
          secondaryLabel: 'Rozmowa przy pliku',
          breadcrumb: 'DevPlanner / Projekt Atlas / Umowy',
          lastAuthorLabel: 'Anna Kowalska',
          previewText: '@Ty sprawdź proszę załącznik z aneksem',
          atUtc: DateTime.utc(2026, 9, 21, 11, 40),
          unreadCount: 3,
          mentionedMe: true,
        ),
        ChatContextConversationView(
          conversationId: 'preview-file-2',
          resourceId: 'file-2',
          kind: ChatContextSourceKind.file,
          title: 'Bardzo długa nazwa pliku z wersją, datą i opisem zakresu prac końcowych 2026-09-21.xlsx',
          breadcrumb: 'DevPlanner / Projekt Atlas',
          lastAuthorLabel: 'Ty',
          previewText: 'Wysłałem wersję po korekcie',
          atUtc: DateTime.utc(2026, 9, 20, 9, 5),
          unreadCount: 1,
        ),
        const ChatContextConversationView(
          conversationId: 'preview-file-3',
          resourceId: 'file-3',
          kind: ChatContextSourceKind.file,
          title: 'Umowa ramowa (bez dostępu)',
          breadcrumb: 'DevPlanner / Projekt Kronos',
          sourceAvailable: false,
        ),
      ];

  static final List<ChatContextConversationView> _taskPreviewRows =
      <ChatContextConversationView>[
        ChatContextConversationView(
          conversationId: 'preview-task-1',
          resourceId: 'task-1',
          kind: ChatContextSourceKind.task,
          title: 'Podłączyć resolver rozmów plików',
          secondaryLabel: 'ATLAS-142',
          breadcrumb: 'Projekt Atlas / Tablica Sprint 42',
          lastAuthorLabel: 'Piotr Zieliński',
          previewText: '@Ty potrzebujemy decyzji o kontrakcie',
          atUtc: DateTime.utc(2026, 9, 21, 8, 15),
          unreadCount: 5,
          mentionedMe: true,
        ),
        ChatContextConversationView(
          conversationId: 'preview-task-2',
          resourceId: 'task-2',
          kind: ChatContextSourceKind.task,
          title: 'Bardzo długi tytuł zadania opisujący cały zakres migracji danych i weryfikacji uprawnień',
          secondaryLabel: 'ATLAS-118',
          breadcrumb: 'Projekt Atlas / Tablica Backlog',
          lastAuthorLabel: 'Ty',
          previewText: 'Zostało sprawdzenie ACL',
          atUtc: DateTime.utc(2026, 9, 19, 15, 30),
        ),
        const ChatContextConversationView(
          conversationId: 'preview-task-3',
          resourceId: 'task-3',
          kind: ChatContextSourceKind.task,
          title: 'Zadanie w projekcie bez dostępu',
          secondaryLabel: 'KRONOS-7',
          breadcrumb: 'Projekt Kronos',
          sourceAvailable: false,
        ),
      ];
}

/// Etykieta podglądu; widoczna, żeby syntetyczne dane nie udawały produkcji.
class _ChatContextPreviewBadge extends StatelessWidget {
  const _ChatContextPreviewBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p8,
        vertical: Sizes.p4,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        context.l10n.chatContextPreviewLabel,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Wiersz listy rozmów kontekstowych: źródło, kontekst, autor, czas i wzmianka.
class ChatContextConversationRow extends StatelessWidget {
  /// Tworzy wiersz rozmowy kontekstowej.
  const ChatContextConversationRow({required this.view, this.onTap, super.key});

  final ChatContextConversationView view;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!view.sourceAvailable) {
      return ListTile(
        dense: true,
        enabled: false,
        leading: const Icon(Symbols.visibility_off_rounded, size: 20),
        title: Text(
          context.l10n.chatContextSourceUnavailable,
          style: theme.textTheme.bodyMedium,
        ),
        subtitle: Text(
          view.breadcrumb ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p8,
          vertical: Sizes.p10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              view.kind == ChatContextSourceKind.file
                  ? Symbols.description_rounded
                  : Symbols.checklist_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            Gaps.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          view.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: view.unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (view.atUtc case final atUtc?) ...[
                        Gaps.w8,
                        Text(
                          _shortTime(atUtc),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (view.unreadCount > 0) ...[
                        Gaps.w8,
                        _ChatContextUnreadBadge(count: view.unreadCount),
                      ],
                    ],
                  ),
                  if (view.secondaryLabel != null || view.breadcrumb != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        <String?>[
                          view.secondaryLabel,
                          view.breadcrumb,
                        ].whereType<String>().join(' • '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  if (view.previewText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          if (view.mentionedMe) ...[
                            Icon(
                              Symbols.alternate_email_rounded,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            Gaps.w4,
                          ],
                          Expanded(
                            child: Text(
                              <String?>[
                                view.lastAuthorLabel,
                                view.previewText,
                              ].whereType<String>().join(': '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Krótki czas wiersza podglądu; data bez roku, bo wiersz jest jednoliniowy.
String _shortTime(DateTime atUtc) {
  final at = atUtc.toLocal();
  final day = at.day.toString().padLeft(2, '0');
  final month = at.month.toString().padLeft(2, '0');
  final hour = at.hour.toString().padLeft(2, '0');
  final minute = at.minute.toString().padLeft(2, '0');
  return '$day.$month $hour:$minute';
}

class _ChatContextUnreadBadge extends StatelessWidget {
  const _ChatContextUnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p6, vertical: 1),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
