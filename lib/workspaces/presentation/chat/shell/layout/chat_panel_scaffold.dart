import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_rail.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_size.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Układ panelu: nawigacja → lista → rozmowa z §2.1 planu korekty.
///
/// Trzy kolumny pojawiają się po spełnieniu faktycznych minimów: rail 56 px,
/// lista 304 px, rozmowa 360 px i separatory. Przy mniejszej szerokości zostaje
/// rail i jedna kolumna, bez ściskania czy overflow.
class ChatPanelScaffold extends StatelessWidget {
  /// Tworzy układ panelu.
  const ChatPanelScaffold({
    required this.listPane,
    required this.conversationPane,
    this.pinned = false,
    this.canPin = true,
    this.profileAction,
    this.onOpenSettings,
    this.onTogglePin,
    super.key,
  });

  /// Kolumna listy (skrzynka, zakładki albo rozmowy kontekstowe).
  final Widget listPane;

  /// Kolumna rozmowy; `null` oznacza, że nic nie jest otwarte.
  final Widget? conversationPane;

  /// Czy panel rezerwuje szerokość w layoucie (tryb szeroki).
  final bool pinned;

  /// Czy w oknie jest miejsce na przypięcie panelu obok treści aplikacji.
  ///
  /// To jest niezależne od liczby kolumn czatu: wąski panel na szerokim ekranie
  /// nadal może się przypiąć, a szeroki panel w ciasnym oknie nie może.
  final bool canPin;

  /// Powierzchnia własnego profilu i statusu; brak ukrywa akcję.
  final Widget? profileAction;
  final VoidCallback? onOpenSettings;

  /// Przełącza przypięcie; brak miejsca w oknie ukrywa akcję.
  final VoidCallback? onTogglePin;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final narrow = width < ChatPanelSizeController.narrowBreakpoint;
      final twoColumns = ChatPanelSizeController.fitsTwoColumns(
        available: width,
        compactRail: false,
      );
      final showConversation =
          !context.select<ChatPanelSectionCubit, bool>(
            (cubit) => cubit.state.showList,
          ) &&
          conversationPane != null;
      if (narrow) {
        // Przy bardzo wąskim panelu belka zastępuje miejsce treści, więc wybór
        // sekcji przenosi się nad listę albo rozmowę; nic nie jest ściskane.
        return Column(
          children: [
            ChatPanelNarrowBar(
              pinned: pinned,
              profileAction: profileAction,
              onOpenSettings: onOpenSettings,
              onTogglePin: canPin ? onTogglePin : null,
            ),
            Expanded(child: showConversation ? conversationPane! : listPane),
          ],
        );
      }
      final rail = ChatPanelRail(
        pinned: pinned,
        profileAction: profileAction,
        onOpenSettings: onOpenSettings,
        onTogglePin: canPin ? onTogglePin : null,
      );
      if (!twoColumns) {
        // Jedna kolumna: rozmowa zastępuje listę, a Wstecz w rozmowie czyści
        // zaznaczenie. Wybór sekcji na belce ma pierwszeństwo, więc kliknięcie
        // Plików czy Kanałów zawsze pokazuje właściwą listę.
        return Row(
          children: [
            rail,
            Expanded(child: showConversation ? conversationPane! : listPane),
          ],
        );
      }
      return Row(
        children: [
          rail,
          SizedBox(
            width: ChatPanelSizeController.listColumnWidth(
              available: width,
              compactRail: false,
            ),
            child: listPane,
          ),
          Expanded(
            child: conversationPane ?? const ChatPanelConversationPlaceholder(),
          ),
        ],
      );
    },
  );
}

/// Stan pustej kolumny rozmowy w szerokim panelu.
class ChatPanelConversationPlaceholder extends StatelessWidget {
  /// Tworzy stan pusty kolumny rozmowy.
  const ChatPanelConversationPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.forum_rounded, size: 40, color: chat.focusRing),
            Gaps.h12,
            Text(
              context.l10n.chatPanelSelectConversationTitle,
              style: chat.contentStyle.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Gaps.h4,
            Text(
              context.l10n.chatPanelSelectConversationMessage,
              textAlign: TextAlign.center,
              style: chat.metadataStyle,
            ),
          ],
        ),
      ),
    );
  }
}
