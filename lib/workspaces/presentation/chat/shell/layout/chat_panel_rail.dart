import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_section.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_size.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nawigacja panelu komunikatora: sekcje listy oraz status i ustawienia.
///
/// Rail jest jedynym miejscem wyboru sekcji — nie ukrywa Kanałów w kreatorze i
/// nie zależy od tego, co przyszło w pierwszej stronie skrzynki. Każda pozycja
/// ma tooltip, etykietę semantyczną, focus i stan aktywny; przy niskim oknie
/// lista pozycji jest przewijalna, więc żadna nie znika bez drogi dostępu.
class ChatPanelRail extends StatelessWidget {
  const ChatPanelRail({
    required this.compact,
    required this.pinned,
    this.profileAction,
    this.onOpenSettings,
    this.onTogglePin,
    super.key,
  });

  /// Tryb compact: węższy rail, jedna kolumna treści.
  final bool compact;

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
    final theme = Theme.of(context);
    final width = compact
        ? ChatPanelSizeController.compactRailWidth
        : ChatPanelSizeController.wideRailWidth;
    return BlocBuilder<ChatPanelSectionCubit, ChatPanelSectionState>(
      builder: (context, state) => SizedBox(
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            border: Border(
              right: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: .6),
              ),
            ),
          ),
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final section in _sections)
                          _ChatPanelRailItem(
                            section: section,
                            active: section == state.section,
                            onSelected: () => context
                                .read<ChatPanelSectionCubit>()
                                .select(section),
                          ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
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
      ),
    );
  }

  /// Pozycje sekcji listy w kolejności z §2.2.
  static const List<ChatPanelSection> _sections = <ChatPanelSection>[
    ChatPanelSection.chats,
    ChatPanelSection.groups,
    ChatPanelSection.channels,
    ChatPanelSection.files,
    ChatPanelSection.tasks,
    ChatPanelSection.archived,
    ChatPanelSection.saved,
  ];
}

class _ChatPanelRailItem extends StatelessWidget {
  const _ChatPanelRailItem({
    required this.section,
    required this.active,
    required this.onSelected,
  });

  final ChatPanelSection section;
  final bool active;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = section.label(context);
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: active,
        label: label,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p8,
            vertical: Sizes.p2,
          ),
          child: Material(
            color: active
                ? theme.colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: InkWell(
              key: ValueKey<String>('chat-rail-${section.name}'),
              onTap: onSelected,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SizedBox(
                height: Sizes.p44,
                child: Icon(
                  section.icon,
                  size: 22,
                  color: active
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
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
  Widget build(BuildContext context) => Tooltip(
    message: label,
    child: Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p8,
          vertical: Sizes.p2,
        ),
        child: IconButton(
          onPressed: onTap,
          iconSize: 22,
          tooltip: '',
          color: active
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          icon: Icon(icon),
        ),
      ),
    ),
  );
}
