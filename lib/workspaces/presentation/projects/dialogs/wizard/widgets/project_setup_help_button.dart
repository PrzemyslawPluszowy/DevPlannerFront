import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Znak zapytania otwierający objaśnienie pojęcia kreatora.
///
/// Objaśnienie jest dostępne trzema drogami: podpowiedzią po najechaniu myszą,
/// kliknięciem albo tapnięciem dla dotyku i klawiatury (przycisk da się
/// aktywować z klawiatury, a treść zostaje w drzewie dostępności). Sam znak
/// zapytania nie jest jedynym źródłem informacji potrzebnej do decyzji —
/// jednozdaniowy skutek ustawienia zostaje pod etykietą.
class ProjectSetupHelpButton extends StatefulWidget {
  /// Tworzy przycisk pomocy.
  const ProjectSetupHelpButton({
    required this.title,
    required this.body,
    this.size = 20,
    super.key,
  });

  /// Minimalne pole trafienia przycisku wymagane przez plan.
  static const double minTapTarget = 32;

  /// Nagłówek objaśnienia.
  final String title;

  /// Treść objaśnienia.
  final String body;

  /// Rozmiar ikony znaku zapytania.
  final double size;

  @override
  State<ProjectSetupHelpButton> createState() => _ProjectSetupHelpButtonState();
}

class _ProjectSetupHelpButtonState extends State<ProjectSetupHelpButton> {
  final MenuController _controller = MenuController();

  void _toggle() {
    if (_controller.isOpen) {
      _controller.close();
    } else {
      _controller.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MenuAnchor(
      controller: _controller,
      onOpen: () => setState(() {}),
      onClose: () => setState(() {}),
      alignmentOffset: const Offset(-160, Sizes.p4),
      style: MenuStyle(
        elevation: const WidgetStatePropertyAll(6),
        backgroundColor: WidgetStatePropertyAll(colors.surfaceContainerLowest),
        side: WidgetStatePropertyAll(BorderSide(color: colors.outlineVariant)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Sizes.p12)),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: Sizes.p12,
            vertical: Sizes.p10,
          ),
        ),
      ),
      menuChildren: [
        SizedBox(
          width: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: context.text.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.h4,
              Text(
                widget.body,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
      builder: (context, controller, child) => AppTooltip(
        message: widget.body,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: ProjectSetupHelpButton.minTapTarget,
            minHeight: ProjectSetupHelpButton.minTapTarget,
          ),
          child: IconButton(
            onPressed: _toggle,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            iconSize: widget.size,
            constraints: const BoxConstraints(
              minWidth: ProjectSetupHelpButton.minTapTarget,
              minHeight: ProjectSetupHelpButton.minTapTarget,
            ),
            icon: Icon(
              Symbols.help,
              size: widget.size,
              semanticLabel: context.l10n.projectSetupHelpSemantics(
                widget.title,
              ),
              color: controller.isOpen
                  ? colors.primary
                  : colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
