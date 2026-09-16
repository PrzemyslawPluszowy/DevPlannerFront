import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';

/// Pojedyncza opcja ikony dostępna do wyboru w UI i zapisu na backendzie.
class WorkspaceIconEntry {
  const WorkspaceIconEntry({
    required this.id,
    required this.label,
    required this.icon,
  });

  /// Unikalny identyfikator tekstowy zapisywany w bazie (np. 'rocket', 'tasks').
  final String id;

  /// Czytelna polska nazwa dla użytkownika.
  final String label;

  /// Odpowiadający obiekt [IconData].
  final IconData icon;
}

/// Centralny helper mapowania i wyboru ikon dla modułu Workspaces.
abstract final class WorkspaceIconHelper {
  const WorkspaceIconHelper._();

  /// Zdefiniowany, estetyczny zestaw ikon biznesowych i projektowych.
  static const List<WorkspaceIconEntry> allIcons = [
    WorkspaceIconEntry(
      id: 'workspaces',
      label: 'Domyślna',
      icon: Symbols.workspaces_rounded,
    ),
    WorkspaceIconEntry(
      id: 'rocket',
      label: 'Projekt / Start',
      icon: Symbols.rocket_launch_rounded,
    ),
    WorkspaceIconEntry(
      id: 'tasks',
      label: 'Zadania',
      icon: Symbols.task_alt_rounded,
    ),
    WorkspaceIconEntry(
      id: 'folder',
      label: 'Katalog',
      icon: Symbols.folder_rounded,
    ),
    WorkspaceIconEntry(
      id: 'briefcase',
      label: 'Biznes',
      icon: Symbols.business_center_rounded,
    ),
    WorkspaceIconEntry(
      id: 'chart',
      label: 'Analityka',
      icon: Symbols.bar_chart_rounded,
    ),
    WorkspaceIconEntry(
      id: 'code',
      label: 'Development',
      icon: Symbols.code_rounded,
    ),
    WorkspaceIconEntry(
      id: 'terminal',
      label: 'Terminal',
      icon: Symbols.terminal_rounded,
    ),
    WorkspaceIconEntry(
      id: 'database',
      label: 'Baza danych',
      icon: Symbols.storage_rounded,
    ),
    WorkspaceIconEntry(
      id: 'palette',
      label: 'Design',
      icon: Symbols.palette_rounded,
    ),
    WorkspaceIconEntry(
      id: 'layers',
      label: 'Warstwy',
      icon: Symbols.layers_rounded,
    ),
    WorkspaceIconEntry(
      id: 'globe',
      label: 'Globalne',
      icon: Symbols.language_rounded,
    ),
    WorkspaceIconEntry(
      id: 'cloud',
      label: 'Chmura',
      icon: Symbols.cloud_rounded,
    ),
    WorkspaceIconEntry(
      id: 'shield',
      label: 'Bezpieczeństwo',
      icon: Symbols.security_rounded,
    ),
    WorkspaceIconEntry(
      id: 'book',
      label: 'Dokumentacja',
      icon: Symbols.menu_book_rounded,
    ),
    WorkspaceIconEntry(
      id: 'wiki',
      label: 'Baza wiedzy',
      icon: Symbols.auto_stories_rounded,
    ),
    WorkspaceIconEntry(
      id: 'whiteboard',
      label: 'Tablica',
      icon: Symbols.draw_rounded,
    ),
    WorkspaceIconEntry(
      id: 'chat',
      label: 'Komunikacja',
      icon: Symbols.chat_bubble_outline_rounded,
    ),
    WorkspaceIconEntry(
      id: 'sparkles',
      label: 'AI / Innowacja',
      icon: Symbols.auto_awesome_rounded,
    ),
    WorkspaceIconEntry(
      id: 'trophy',
      label: 'Cele i sukces',
      icon: Symbols.emoji_events_rounded,
    ),
    WorkspaceIconEntry(
      id: 'target',
      label: 'Target / OKR',
      icon: Symbols.track_changes_rounded,
    ),
    WorkspaceIconEntry(
      id: 'star',
      label: 'Wyróżnione',
      icon: Symbols.star_border_rounded,
    ),
    WorkspaceIconEntry(
      id: 'flag',
      label: 'Kamień milowy',
      icon: Symbols.flag_rounded,
    ),
    WorkspaceIconEntry(
      id: 'zap',
      label: 'Szybkie akcje',
      icon: Symbols.bolt_rounded,
    ),
    WorkspaceIconEntry(
      id: 'grid',
      label: 'Struktura',
      icon: Symbols.grid_view_rounded,
    ),
    WorkspaceIconEntry(
      id: 'cube',
      label: 'Komponenty',
      icon: Symbols.category_rounded,
    ),
    WorkspaceIconEntry(
      id: 'compass',
      label: 'Strategia',
      icon: Symbols.explore_rounded,
    ),
    WorkspaceIconEntry(
      id: 'heart',
      label: 'Zespół',
      icon: Symbols.favorite_border_rounded,
    ),
  ];

  /// Zwraca właściwy [IconData] na podstawie klucza tekstowego z backendu.
  static IconData iconFor(
    String? id, {
    IconData fallback = Symbols.workspaces_rounded,
  }) {
    if (id == null || id.trim().isEmpty) return fallback;
    final normalized = id.trim().toLowerCase();
    for (final entry in allIcons) {
      if (entry.id == normalized) return entry.icon;
    }
    return switch (normalized) {
      'dashboard' => WorkspaceIcons.dashboard,
      'folders' || 'katalog' => WorkspaceIcons.folders,
      'tasks' || 'zadania' => WorkspaceIcons.tasks,
      'wiki' || 'dokumenty' => WorkspaceIcons.wiki,
      'whiteboard' || 'tablica' => WorkspaceIcons.whiteboard,
      'private' || 'lock' => WorkspaceIcons.privateSpace,
      _ => fallback,
    };
  }

  /// Zwraca ikonę dla klucza zapisanego w workspace.
  static IconData getIcon(String? id) => iconFor(id);

  /// Odczytuje kolor HEX, zachowując bezpieczny fallback dla niepoprawnych danych.
  static Color parseColor(
    String? value, {
    Color fallback = const Color(0xFF0B57D0),
  }) {
    final normalized = value?.replaceFirst('#', '');
    if (normalized == null ||
        (normalized.length != 6 && normalized.length != 8)) {
      return fallback;
    }
    final parsed = int.tryParse(normalized, radix: 16);
    return parsed == null
        ? fallback
        : Color(normalized.length == 6 ? 0xFF000000 | parsed : parsed);
  }

  /// Zwraca identyfikator ikony na podstawie [IconData].
  static String? idForIcon(IconData icon) {
    for (final entry in allIcons) {
      if (entry.icon == icon) return entry.id;
    }
    return null;
  }
}

/// Interaktywny selektor ikon do formularzy tworzenia i edycji workspace'u/projektu.
class WorkspaceIconPicker extends StatelessWidget {
  const WorkspaceIconPicker({
    required this.selectedIconId,
    required this.onIconSelected,
    super.key,
  });

  final String? selectedIconId;
  final ValueChanged<String?> onIconSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const icons = WorkspaceIconHelper.allIcons;

    return Wrap(
      spacing: Sizes.p8,
      runSpacing: Sizes.p8,
      children: [
        for (final entry in icons)
          Tooltip(
            message: entry.label,
            child: InkWell(
              onTap: () {
                if (selectedIconId == entry.id) {
                  onIconSelected(null);
                } else {
                  onIconSelected(entry.id);
                }
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: selectedIconId == entry.id
                      ? colors.primary.withValues(alpha: isDark ? .28 : .15)
                      : (isDark
                            ? Colors.white.withValues(alpha: .04)
                            : colors.surfaceContainerHighest.withValues(
                                alpha: .45,
                              )),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: selectedIconId == entry.id
                        ? colors.primary
                        : (isDark
                              ? Colors.white.withValues(alpha: .08)
                              : colors.outlineVariant.withValues(alpha: .4)),
                    width: selectedIconId == entry.id ? 1.8 : 1,
                  ),
                ),
                child: Icon(
                  entry.icon,
                  size: 20,
                  color: selectedIconId == entry.id
                      ? colors.primary
                      : colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
