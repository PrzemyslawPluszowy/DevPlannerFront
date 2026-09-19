import 'package:devplanner/shared/presentation/widgets/app_action_button.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';

export 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';

/// Wspolny przycisk z menu kontekstowym dla calej aplikacji.
///
/// Uzycie:
/// - klik lewym otwiera menu,
/// - klik prawym (web/desktop) tez otwiera menu,
/// - trigger korzysta z `AppActionButton`, wiec wyglad jest spojny.
class AppContextMenuButton extends StatefulWidget {
  /// Tworzy przycisk otwierający wspólne menu kontekstowe.
  const AppContextMenuButton({
    required this.label,
    required this.icon,
    required this.actions,
    super.key,
    this.style = AppContextMenuStyle.flat,
    this.variant = AppActionButtonVariant.outlined,
    this.tone = AppActionButtonTone.primary,
    this.dense = false,
    this.menuHeaderTitle,
    this.menuHeaderSubtitle,
  });

  final String label;
  final IconData icon;
  final List<AppContextMenuAction> actions;
  final AppContextMenuStyle style;
  final AppActionButtonVariant variant;
  final AppActionButtonTone tone;
  final bool dense;
  final String? menuHeaderTitle;
  final String? menuHeaderSubtitle;

  @override
  State<AppContextMenuButton> createState() => _AppContextMenuButtonState();
}

/// Stan przycisku wyznaczający pozycję menu względem aktywatora.
class _AppContextMenuButtonState extends State<AppContextMenuButton> {
  final GlobalKey<State<StatefulWidget>> triggerKey = GlobalKey();

  Offset _menuPosition({Offset? fromPointer}) {
    if (fromPointer case final pointer?) {
      return pointer;
    }

    final triggerBox =
        triggerKey.currentContext!.findRenderObject()! as RenderBox;
    final offset = triggerBox.localToGlobal(Offset.zero);
    return offset + Offset(0, triggerBox.size.height);
  }

  Future<void> _openMenu({Offset? fromPointer}) async {
    if (widget.actions.isEmpty) {
      return;
    }

    await AppContextMenu.show(
      context,
      globalPosition: _menuPosition(fromPointer: fromPointer),
      actions: widget.actions,
      style: widget.style,
      headerTitle: widget.menuHeaderTitle,
      headerSubtitle: widget.menuHeaderSubtitle,
    );
  }

  Widget _buildTrigger() {
    switch (widget.variant) {
      case AppActionButtonVariant.text:
        return AppActionButton.text(
          label: widget.label,
          icon: widget.icon,
          tone: widget.tone,
          dense: widget.dense,
          onPressed: _openMenu,
        );
      case AppActionButtonVariant.outlined:
        return AppActionButton.outlined(
          label: widget.label,
          icon: widget.icon,
          tone: widget.tone,
          dense: widget.dense,
          onPressed: _openMenu,
        );
      case AppActionButtonVariant.filled:
        return AppActionButton.filled(
          label: widget.label,
          icon: widget.icon,
          tone: widget.tone,
          dense: widget.dense,
          onPressed: _openMenu,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: triggerKey,
        behavior: HitTestBehavior.opaque,
        onSecondaryTapUp: (details) =>
            _openMenu(fromPointer: details.globalPosition),
        child: _buildTrigger(),
      ),
    );
  }
}
