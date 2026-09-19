import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/models/workspace_list_item.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Wspólne mapowanie danych wizualnych workspace'u z backendu i zasobów.
///
/// Backend może zwrócić nazwę ikony albo kolor w formacie HEX. Nieznane
/// wartości są bezpiecznie zastępowane ikoną i kolorem z Material Theme.
/// Zasoby (zadania, whiteboardy, wiki itd.) otrzymują żywe, dedykowane
/// kolory akcentowe dostosowane do jasnego i ciemnego motywu.
abstract final class WorkspaceVisualHelpers {
  const WorkspaceVisualHelpers._();

  /// Zwraca właściwą ikonę produktu na podstawie tekstu z backendu.
  static IconData iconFor(String? value) => WorkspaceIconHelper.iconFor(value);

  /// Mapuje kolor HEX workspace'u do obiektu [Color] z fallbackiem na `primary`.
  static Color accentFor(BuildContext context, String? value) {
    final normalized = value?.replaceFirst('#', '');
    if (normalized == null ||
        (normalized.length != 6 && normalized.length != 8)) {
      return context.colors.primary;
    }
    final parsed = int.tryParse(normalized, radix: 16);
    if (parsed == null) return context.colors.primary;
    return Color(normalized.length == 6 ? 0xFF000000 | parsed : parsed);
  }

  /// Zwraca nasycony, czytelny kolor akcentowy dla typu zasobu w stylu Monday/ClickUp.
  static Color resourceColor(BuildContext context, dynamic resource) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final key = switch (resource) {
      ProjectResourceKind.tasks => 'tasks',
      ProjectResourceKind.whiteboards => 'whiteboards',
      ProjectResourceKind.wiki => 'wiki',
      ProjectResourceKind.files => 'files',
      ProjectResourceKind.automations => 'automations',
      final String str => str.toLowerCase(),
      _ => 'default',
    };

    return switch (key) {
      'tasks' ||
      'zadania' => isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
      'kanban' => isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED),
      'whiteboard' ||
      'whiteboards' ||
      'tablice' => isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
      'wiki' ||
      'dokumenty' => isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488),
      'file' ||
      'files' ||
      'pliki' => isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
      'automations' || 'automatyzacje' =>
        isDark ? const Color(0xFFF472B6) : const Color(0xFFDB2777),
      'activity' ||
      'aktywność' => isDark ? const Color(0xFFA3E635) : const Color(0xFF65A30D),
      'members' || 'członkowie' =>
        isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
      'okr' ||
      'cele' => isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
      'invitations' || 'zaproszenia' =>
        isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2),
      'settings' || 'ustawienia' =>
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
      'overview' ||
      'dashboard' ||
      'przegląd' => isDark ? const Color(0xFF818CF8) : const Color(0xFF4338CA),
      _ => context.colors.primary,
    };
  }

  /// Buduje miniaturową kolorową kapsułkę ikony zasobu.
  static Widget resourceIconBadge(
    BuildContext context, {
    required IconData icon,
    Color? color,
    double size = 24,
    double iconSize = 14,
  }) {
    final effectiveColor = color ?? context.colors.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: isDark ? .24 : .14),
        borderRadius: const BorderRadius.all(Radius.circular(7)),
        border: Border.all(
          color: effectiveColor.withValues(alpha: isDark ? .48 : .30),
        ),
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Icon(icon, size: iconSize, color: effectiveColor),
        ),
      ),
    );
  }

  /// Nowoczesny awatar / badge workspace'u z akcentem i subtelnym obramowaniem.
  static Widget badge(
    BuildContext context,
    WorkspaceListItem item, {
    double size = 28,
    bool isSelected = false,
  }) {
    final accent = accentFor(context, item.primaryColor);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? .28 : .18),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: isSelected
              ? accent
              : accent.withValues(alpha: isDark ? .55 : .38),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: .35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          iconFor(item.icon),
          size: size * .52,
          color: accent,
        ),
      ),
    );
  }

  /// Tworzy pełny i poprawny link URL do workspace'u (zarówno dla Web jak i Desktopu).
  static String workspaceUrlFor(String workspaceId) {
    final routePath = '/workspaces/$workspaceId';
    if (kIsWeb) {
      final base = Uri.base;
      if (base.hasScheme && (base.scheme == 'http' || base.scheme == 'https')) {
        final origin = base.origin;
        if (base.fragment.isNotEmpty) {
          return '$origin/#$routePath';
        }
        return '$origin$routePath';
      }
    }
    return routePath;
  }
}
