import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/task_context_menu.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

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

/// Wyświetla zakotwiczony selektor typu zadania z kolorowymi ikonami i opcją konfiguracji dla administratora.
Future<void> showTaskTypePicker(
  BuildContext context, {
  required String? currentType,
  required Future<bool> Function(String type) onSave,
  RelativeRect? menuPosition,
  bool canManage = false,
  VoidCallback? onConfigureTypes,
}) async {
  final position = menuPosition ?? TaskContextMenu.positionFor(context);
  final isCurrentCustom =
      currentType != null &&
      currentType.trim().isNotEmpty &&
      TaskPresetType.fromName(currentType) == null;

  final selected = await TaskContextMenu.show<String?>(
    context,
    position: position,
    items: [
      const TaskContextMenuHeader(title: 'Typ zadania'),
      for (final preset in TaskPresetType.values)
        TaskContextMenuItem<String>(
          value: preset.apiValue,
          title: preset.label,
          icon: preset.icon,
          iconColor: preset.color,
          isSelected:
              currentType?.toLowerCase() == preset.label.toLowerCase() ||
              currentType?.toLowerCase() == preset.apiValue.toLowerCase(),
        ),
      if (isCurrentCustom)
        TaskContextMenuItem<String>(
          value: currentType,
          title: currentType,
          icon: Symbols.label_important_rounded,
          iconColor: context.colors.primary,
          isSelected: true,
        ),
      if (canManage) ...[
        const TaskContextMenuDivider(),
        TaskContextMenuItem<String>(
          value: '__ADMIN_CONFIG__',
          title: 'Konfiguruj typy...',
          icon: Symbols.settings_rounded,
        ),
      ],
      if (currentType != null && currentType.trim().isNotEmpty) ...[
        const TaskContextMenuDivider(),
        TaskContextMenuItem<String>(
          value: '',
          title: 'Wyczyść typ',
          icon: Symbols.close_rounded,
          iconColor: context.colors.error,
        ),
      ],
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

/// Dedykowany dialog dodawania własnego typu zadania dostępny wyłącznie dla administratora.
Future<String?> _showAdminAddTypeDialog(BuildContext context) async {
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
