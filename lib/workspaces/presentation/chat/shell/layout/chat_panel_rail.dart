import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_section.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_size.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nawigacja panelu komunikatora: sekcje listy oraz status i ustawienia.
///
/// Belka ma stałą szerokość 56 px i nie skaluje się z oknem: przyciski mają
/// 40×40, ikony 22 i odstęp 8. Przy naprawdę wąskim panelu belkę zastępuje
/// [ChatPanelNarrowBar], żeby nie ściskać ikon do kilku pikseli.
class ChatPanelRail extends StatelessWidget {
  /// Tworzy belkę sekcji.
  const ChatPanelRail({
    required this.pinned,
    this.profileAction,
    this.onOpenSettings,
    this.onTogglePin,
    super.key,
  });

  /// Czy panel rezerwuje szerokość w layoucie.
  final bool pinned;

  /// Przełącza przypięcie; brak akcji oznacza tryb bez rezerwacji miejsca.
  final VoidCallback? onTogglePin;

  /// Powierzchnia własnego profilu i statusu; brak oznacza brak akcji.
  ///
  /// Jest widgetem, a nie callbackiem, bo status otwiera zakotwiczony popover,
  /// który musi mieć własne miejsce w drzewie, żeby się prawidłowo ustawić.
  final Widget? profileAction;

  /// Otwiera ustawienia powiadomień komunikatora; brak portu oznacza brak akcji.
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return SizedBox(
      width: ChatPanelSizeController.wideRailWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: chat.panelSurface,
          border: Border(right: BorderSide(color: chat.separator)),
        ),
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final section in ChatPanelSection.listSections)
                        _ChatPanelRailItem(section: section),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: chat.separator),
              if (onTogglePin case final toggle?)
                _ChatPanelRailAction(
                  icon: Symbols.push_pin_rounded,
                  label: pinned
                      ? context.l10n.chatPanelUnpinAction
                      : context.l10n.chatPanelPinAction,
                  active: pinned,
                  onTap: toggle,
                ),
              ?profileAction,
              _ChatPanelRailAction(
                icon: ChatPanelSection.settings.icon,
                label: ChatPanelSection.settings.label(context),
                onTap: onOpenSettings,
              ),
              const SizedBox(height: Sizes.p8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pasek sekcji dla panelu węższego niż 400 px.
///
/// Zastępuje pionową belkę, bo przy tak wąskim oknie 56-pikselowa kolumna
/// zabierałaby treść; wybór sekcji, przypięcie, profil i ustawienia zostają
/// osiągalne z jednego miejsca, a wybrana sekcja jest widoczna na przycisku.
class ChatPanelNarrowBar extends StatelessWidget {
  /// Tworzy poziomy pasek sekcji.
  const ChatPanelNarrowBar({
    required this.pinned,
    this.profileAction,
    this.onOpenSettings,
    this.onTogglePin,
    super.key,
  });

  /// Czy panel rezerwuje szerokość w layoucie.
  final bool pinned;

  /// Przełącza przypięcie; brak akcji oznacza tryb bez rezerwacji miejsca.
  final VoidCallback? onTogglePin;

  /// Powierzchnia własnego profilu i statusu; brak oznacza brak akcji.
  final Widget? profileAction;

  /// Otwiera ustawienia powiadomień komunikatora.
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final state = context.watch<ChatPanelSectionCubit>().state;
    final label = state.section.label(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: chat.panelSurface,
        border: Border(bottom: BorderSide(color: chat.separator)),
      ),
      child: SafeArea(
        right: false,
        bottom: false,
        child: SizedBox(
          height: Sizes.p48,
          child: Row(
            children: [
              const SizedBox(width: Sizes.p4),
              Tooltip(
                message: label,
                child: Builder(
                  builder: (anchorContext) => IconButton(
                    key: const ValueKey('chat-panel-section-button'),
                    tooltip: label,
                    splashRadius: ChatPanelRailMetrics.iconSize,
                    icon: Icon(
                      state.section.icon,
                      size: ChatPanelRailMetrics.iconSize,
                    ),
                    onPressed: () => unawaited(() async {
                      final selected = await AppContextMenu.select(
                        anchorContext,
                        globalPosition: AppContextMenu.positionFor(
                          anchorContext,
                        ),
                        options: [
                          for (final section in ChatPanelSection.listSections)
                            AppContextMenuOption<ChatPanelSection>(
                              value: section,
                              label: section.label(context),
                              icon: section.icon,
                              selected: state.section == section,
                            ),
                        ],
                      );
                      if (selected != null && context.mounted) {
                        context.read<ChatPanelSectionCubit>().select(selected);
                      }
                    }()),
                  ),
                ),
              ),
              const Spacer(),
              if (onTogglePin case final toggle?)
                _ChatPanelRailAction(
                  icon: Symbols.push_pin_rounded,
                  label: pinned
                      ? context.l10n.chatPanelUnpinAction
                      : context.l10n.chatPanelPinAction,
                  active: pinned,
                  onTap: toggle,
                ),
              ?profileAction,
              _ChatPanelRailAction(
                icon: ChatPanelSection.settings.icon,
                label: ChatPanelSection.settings.label(context),
                onTap: onOpenSettings,
              ),
              const SizedBox(width: Sizes.p4),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stałe miary belki sekcji wspólne dla pionowej i poziomej wersji.
abstract final class ChatPanelRailMetrics {
  /// Bok przycisku belki.
  static const double buttonSize = 40;

  /// Rozmiar ikony pozycji belki.
  static const double iconSize = 22;

  /// Odstęp między pozycjami belki.
  static const double gap = 8;
}

class _ChatPanelRailItem extends StatelessWidget {
  const _ChatPanelRailItem({required this.section});

  final ChatPanelSection section;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final label = section.label(context);
    final active = context.select<ChatPanelSectionCubit, bool>(
      (cubit) => cubit.state.section == section,
    );
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: active,
        label: label,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p8,
            vertical: ChatPanelRailMetrics.gap / 2,
          ),
          child: Material(
            color: active ? chat.selectedSurface : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: InkWell(
              key: ValueKey<String>('chat-rail-${section.name}'),
              onTap: () =>
                  context.read<ChatPanelSectionCubit>().select(section),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SizedBox.square(
                dimension: ChatPanelRailMetrics.buttonSize,
                child: Icon(
                  section.icon,
                  size: ChatPanelRailMetrics.iconSize,
                  color: active ? chat.focusRing : chat.metadataText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatPanelRailAction extends StatelessWidget {
  const _ChatPanelRailAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  /// Czy akcja jest włączona (np. panel przypięty).
  final bool active;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        enabled: onTap != null,
        label: label,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p8,
            vertical: ChatPanelRailMetrics.gap / 2,
          ),
          child: SizedBox.square(
            dimension: ChatPanelRailMetrics.buttonSize,
            child: IconButton(
              onPressed: onTap,
              padding: EdgeInsets.zero,
              iconSize: ChatPanelRailMetrics.iconSize,
              tooltip: '',
              color: active ? chat.focusRing : chat.metadataText,
              icon: Icon(icon),
            ),
          ),
        ),
      ),
    );
  }
}
