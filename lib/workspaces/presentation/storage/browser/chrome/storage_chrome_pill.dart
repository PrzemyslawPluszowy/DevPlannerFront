import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Wspólna kontrolka paska poleceń Plików.
///
/// Odtwarza geometrię pigułki poleceń modułów danych (28 px wysokości, promień
/// 8, ikona 16, etykieta 12 px z wagą 600), więc wiersz poleceń Files nie jest
/// drugim, lokalnym stylem. Wariant [isPrimary] służy do głównego CTA.
final class StorageChromePill extends StatelessWidget {
  /// Tworzy pigułkę paska poleceń.
  const StorageChromePill({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.label,
    this.isActive = false,
    this.isPrimary = false,
    this.showCaret = false,
    this.trailing,
    super.key,
  });

  /// Ikona wiodąca.
  final IconData icon;

  /// Etykieta; brak etykiety oznacza kontrolkę ikonową.
  final String? label;

  /// Podpowiedź i zarazem dostępna nazwa kontrolki.
  final String tooltip;

  /// Akcja kontrolki; `null` czyni ją nieaktywną.
  final VoidCallback? onTap;

  /// Czy kontrolka reprezentuje aktywny wybór.
  final bool isActive;

  /// Czy kontrolka jest głównym CTA modułu.
  final bool isPrimary;

  /// Czy pokazać caret rozwijania menu.
  final bool showCaret;

  /// Dodatkowy element po etykiecie, np. licznik.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    final enabled = onTap != null;

    final background = isPrimary
        ? colors.primary
        : isActive
        ? common.rowSelected
        : common.commandBarSurface;
    final foreground = isPrimary
        ? colors.onPrimary
        : isActive
        ? colors.primary
        : colors.onSurface;
    final border = isPrimary
        ? colors.primary
        : isActive
        ? common.selectionAccent.withValues(alpha: 0.45)
        : common.commandBarBorder.withValues(alpha: 0.6);

    return Tooltip(
      message: tooltip,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Material(
          color: background,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(common.controlRadius),
            side: BorderSide(color: border),
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 28,
              padding: EdgeInsets.symmetric(horizontal: common.controlGap),
              constraints: label == null
                  ? const BoxConstraints(minWidth: 28)
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: foreground),
                  if (label case final label?) ...[
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 190),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: common.controlText.copyWith(color: foreground),
                      ),
                    ),
                  ],
                  if (trailing case final trailing?) ...[
                    const SizedBox(width: 4),
                    trailing,
                  ],
                  if (showCaret) ...[
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 18,
                      color: isPrimary
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
