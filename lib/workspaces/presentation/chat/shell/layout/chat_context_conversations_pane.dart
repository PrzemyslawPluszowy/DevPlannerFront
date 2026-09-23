import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_context_source.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Stan zakładek rozmów powiązanych z plikami i zadaniami.
///
/// Sekcje mają własne, docelowe miejsce w panelu czatu. Gdy backend i moduły
/// źródłowe udostępnią rozmowy kontekstowe, lista zostanie podłączona tutaj.
/// Do tego czasu nie pokazujemy przykładowych danych, które mogłyby wyglądać
/// jak prawdziwe rozmowy użytkownika.
class ChatContextConversationsPane extends StatelessWidget {
  /// Tworzy pane dla wskazanego rodzaju źródła.
  const ChatContextConversationsPane({required this.kind, super.key});

  final ChatContextSourceKind kind;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final l10n = context.l10n;
    final isFile = kind == ChatContextSourceKind.file;
    final title = isFile
        ? l10n.chatFilesNotConnectedTitle
        : l10n.chatTasksNotConnectedTitle;
    final message = isFile
        ? l10n.chatFilesNotConnectedMessage
        : l10n.chatTasksNotConnectedMessage;
    final icon = isFile ? Symbols.folder_rounded : Symbols.view_kanban_rounded;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 420;
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Sizes.p24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: chat.selectedSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 32, color: chat.linkText),
                  ),
                  SizedBox(height: compact ? Sizes.p16 : Sizes.p24),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: chat.contentStyle.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gaps.h8,
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: chat.metadataStyle.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
