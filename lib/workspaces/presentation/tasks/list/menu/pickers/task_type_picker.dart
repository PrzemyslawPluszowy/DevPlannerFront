import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Predefiniowane typy zadań z ikonami i kolorami.
enum TaskPresetType {
  task(
    'Zadanie',
    Symbols.check_box_outline_blank_rounded,
    Color(0xFF3B82F6),
    'Task',
  ),
  bug('Błąd', Symbols.bug_report_rounded, Color(0xFFEF4444), 'Bug'),
  feature(
    'Funkcja',
    Symbols.auto_awesome_rounded,
    Color(0xFF8B5CF6),
    'Feature',
  ),
  story('Story', Symbols.bookmark_rounded, Color(0xFF10B981), 'Story'),
  spike('Spike', Symbols.bolt_rounded, Color(0xFFF59E0B), 'Spike');

  const TaskPresetType(this.label, this.icon, this.color, this.apiValue);

  final String label;
  final IconData icon;
  final Color color;
  final String apiValue;

  static TaskPresetType? fromName(String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final normalized = name.trim().toLowerCase();
    for (final type in values) {
      if (type.name.toLowerCase() == normalized ||
          type.label.toLowerCase() == normalized ||
          type.apiValue.toLowerCase() == normalized) {
        return type;
      }
    }
    return null;
  }
}

/// Buduje zakotwiczony selektor typu zadania i opcjonalny dialog administratora.
///
/// Klasa jest lokalnym launcherem UI: nie wykonuje I/O domenowego, a zapis
/// realizuje wyłącznie callback przekazany przez właściciela stanu.
final class TaskTypePicker {
  const TaskTypePicker._();

  static Future<void> show(
    BuildContext context, {
    required String? currentType,
    required Future<bool> Function(String type) onSave,
    Offset? position,
    bool canManage = false,
    VoidCallback? onConfigureTypes,
  }) async {
    final isCurrentCustom =
        currentType != null &&
        currentType.trim().isNotEmpty &&
        TaskPresetType.fromName(currentType) == null;

    final selected = await AppContextMenu.select<String>(
      context,
      globalPosition: position ?? AppContextMenu.positionFor(context),
      options: [
        for (final preset in TaskPresetType.values)
          AppContextMenuOption(
            sectionTitle: 'Typ zadania',
            value: preset.apiValue,
            label: preset.label,
            icon: preset.icon,
            iconColor: preset.color,
            selected:
                currentType?.toLowerCase() == preset.label.toLowerCase() ||
                currentType?.toLowerCase() == preset.apiValue.toLowerCase(),
          ),
        if (isCurrentCustom)
          AppContextMenuOption(
            value: currentType,
            label: currentType,
            icon: Symbols.label_important_rounded,
            iconColor: context.colors.primary,
            selected: true,
          ),
        if (canManage)
          const AppContextMenuOption(
            value: '__ADMIN_CONFIG__',
            label: 'Konfiguruj typy...',
            icon: Symbols.settings_rounded,
            separatorBefore: true,
          ),
        if (currentType != null && currentType.trim().isNotEmpty)
          AppContextMenuOption(
            value: '',
            label: 'Wyczyść typ',
            icon: Symbols.close_rounded,
            iconColor: context.colors.error,
            separatorBefore: true,
          ),
      ],
    );

    if (selected == null) return;
    if (selected == '__ADMIN_CONFIG__') {
      if (onConfigureTypes != null) {
        onConfigureTypes();
      } else if (context.mounted) {
        final newType = await _showAdminAddTypeDialog(context);
        if (newType != null && newType.isNotEmpty) {
          await onSave(newType);
        }
      }
    } else {
      await onSave(selected.trim());
    }
  }

  /// Dedykowany dialog dodawania własnego typu zadania dla administratora.
  static Future<String?> _showAdminAddTypeDialog(BuildContext context) async {
    final controller = TextEditingController();
    final colors = context.colors;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogCtx) => WorkspaceCreationModalWrapper(
        title: 'Konfiguracja typu zadania',
        subtitle: 'Zdefiniuj nowy typ zadania dla projektu',
        icon: Symbols.settings_rounded,
        accentColor: colors.primary,
        submitLabel: 'Zapisz',
        cancelLabel: 'Anuluj',
        maxWidth: 420,
        onSubmit: () {
          final val = controller.text.trim();
          if (val.isNotEmpty) {
            Navigator.of(dialogCtx).pop(val);
          }
        },
        body: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'np. Hotfix, Improvement, Dokumentacja',
                labelText: 'Nazwa typu',
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  Navigator.of(dialogCtx).pop(val.trim());
                }
              },
            ),
          ],
        ),
      ),
    );

    controller.dispose();
    return result;
  }
}
