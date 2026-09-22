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
/// Powyżej progu 760 px panel pokazuje trzy kolumny (rail 56 px, lista
/// 304–344 px i rozmowa z minimum 360 px). Poniżej progu zostaje rail i jedna
/// kolumna: lista albo rozmowa z przyciskiem Wstecz, więc na wąskim ekranie nie
/// ma trzech ściśniętych kolumn.
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
      final compact =
          constraints.maxWidth < ChatPanelSizeController.compactBreakpoint;
      final rail = ChatPanelRail(
        compact: compact,
        pinned: pinned,
        profileAction: profileAction,
        onOpenSettings: onOpenSettings,
        onTogglePin: canPin ? onTogglePin : null,
      );
      if (compact) {
        // Na wąskim ekranie rozmowa zastępuje listę, ale wybór sekcji na railu
        // ma pierwszeństwo: inaczej kliknięcie Plików czy Kanałów nie pokazałoby
        // niczego, dopóki użytkownik nie cofnie się z rozmowy. Wstecz w rozmowie
        // także wraca do listy, bo czyści zaznaczenie.
        final showConversation =
            !context.select<ChatPanelSectionCubit, bool>(
              (cubit) => cubit.state.showList,
            ) &&
            conversationPane != null;
        return Row(
          children: [
            rail,
            Expanded(
              child: showConversation ? conversationPane! : listPane,
            ),
          ],
        );
      }
      return Row(
        children: [
          rail,
          listPane,
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
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.forum_rounded,
            size: 40,
            color: context.colors.onSurfaceVariant,
          ),
          Gaps.h12,
          Text(
            context.l10n.chatPanelSelectConversationTitle,
            style: context.text.titleSmall,
            textAlign: TextAlign.center,
          ),
          Gaps.h4,
          Text(
            context.l10n.chatPanelSelectConversationMessage,
            textAlign: TextAlign.center,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}
