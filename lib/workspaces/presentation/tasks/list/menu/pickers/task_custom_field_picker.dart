import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/task_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Specjalny znacznik anulowania wyboru pola.
const Object customFieldCancelled = Object();

/// Specjalny znacznik wyczyszczenia wartości pola.
const Object customFieldClear = Object();

/// Specjalny znacznik otwarcia konfiguracji pola.
const Object _configureFieldSentinel = Object();

/// Standaryzowane pickery pól niestandardowych w tabeli zadań.
abstract final class TaskCustomFieldPicker {
  /// Wybór wartości logicznej (Tak / Nie).
  static Future<Object?> pickBoolean(
    BuildContext context, {
    required TaskCustomFieldResponse field,
    required Object? value,
    required RelativeRect menuPosition,
  }) async {
    final boolValue = value is bool
        ? value
        : value is String
        ? value.toLowerCase() == 'true'
        : null;

    final items = <PopupMenuEntry<Object?>>[
      TaskContextMenuItem<Object?>(
        value: true,
        title: '${field.name}: Tak',
        icon: Symbols.check_circle_rounded,
        iconColor: const Color(0xFF4CAF50),
        isSelected: boolValue == true,
      ),
      TaskContextMenuItem<Object?>(
        value: false,
        title: '${field.name}: Nie',
        icon: Symbols.cancel_rounded,
        iconColor: const Color(0xFF757575),
        isSelected: boolValue == false,
      ),
      if (!field.isRequired) ...[
        const TaskContextMenuDivider(),
        TaskContextMenuItem<Object?>(
          value: customFieldClear,
          title: context.l10n.tasksListClearValue,
          icon: Symbols.close_rounded,
          iconColor: context.colors.error,
        ),
      ],
    ];

    final selected = await TaskContextMenu.show<Object?>(
      context,
      position: menuPosition,
      items: items,
    );

    if (selected == null) return customFieldCancelled;
    if (selected == customFieldClear) return null;
    return selected;
  }

  /// Wybór pojedynczej opcji z listy rozwijanej (SingleSelect).
  static Future<Object?> pickSingleSelect(
    BuildContext context, {
    required TaskCustomFieldResponse field,
    required Object? value,
    required RelativeRect menuPosition,
    bool canManage = false,
    VoidCallback? onConfigureField,
  }) async {
    final rawOptions = field.options ?? const <String>[];
    final currentStr = value?.toString();

    final items = <PopupMenuEntry<Object?>>[
      for (final optionRaw in rawOptions)
        TaskContextMenuItem<Object?>(
          value: optionRaw,
          title: _resolveOption(field, optionRaw).label,
          icon: _resolveOption(field, optionRaw).icon ?? Symbols.circle,
          iconColor: _resolveOption(field, optionRaw).color,
          isSelected: _isOptionSelected(optionRaw, currentStr),
          trailing: _isOptionSelected(optionRaw, currentStr)
              ? Icon(
                  Symbols.check_rounded,
                  size: 15,
                  color: context.colors.primary,
                )
              : null,
        ),
      if (!field.isRequired) ...[
        const TaskContextMenuDivider(),
        TaskContextMenuItem<Object?>(
          value: customFieldClear,
          title: context.l10n.tasksListClearValue,
          icon: Symbols.close_rounded,
          iconColor: context.colors.error,
        ),
      ],
      if (canManage && onConfigureField != null) ...[
        const TaskContextMenuDivider(),
        TaskContextMenuItem<Object?>(
          value: _configureFieldSentinel,
          title: 'Konfiguruj pole...',
          icon: Symbols.settings_rounded,
        ),
      ],
    ];

    final selected = await TaskContextMenu.show<Object?>(
      context,
      position: menuPosition,
      items: items,
    );

    if (selected == null) return customFieldCancelled;
    if (selected == _configureFieldSentinel) {
      onConfigureField?.call();
      return customFieldCancelled;
    }
    if (selected == customFieldClear) return null;
    return selected;
  }

  /// Wybór wielu opcji z listy (MultiSelect).
  static Future<Object?> pickMultiSelect(
    BuildContext context, {
    required TaskCustomFieldResponse field,
    required Object? value,
    required RelativeRect menuPosition,
    bool canManage = false,
    VoidCallback? onConfigureField,
  }) async {
    final rawOptions = field.options ?? const <String>[];
    final selectedSet = (value is List ? value : const <Object?>[])
        .map((item) => item.toString())
        .toSet();

    final items = <PopupMenuEntry<Object?>>[
      for (final optionRaw in rawOptions)
        TaskContextMenuItem<Object?>(
          value: optionRaw,
          title: _resolveOption(field, optionRaw).label,
          icon: _resolveOption(field, optionRaw).icon ?? Symbols.circle,
          iconColor: _resolveOption(field, optionRaw).color,
          isSelected: _isMultiOptionSelected(optionRaw, selectedSet),
          trailing: _isMultiOptionSelected(optionRaw, selectedSet)
              ? Icon(
                  Symbols.check_rounded,
                  size: 15,
                  color: context.colors.primary,
                )
              : null,
        ),
      if (!field.isRequired) ...[
        const TaskContextMenuDivider(),
        TaskContextMenuItem<Object?>(
          value: customFieldClear,
          title: context.l10n.tasksListClearValue,
          icon: Symbols.close_rounded,
          iconColor: context.colors.error,
        ),
      ],
      if (canManage && onConfigureField != null) ...[
        const TaskContextMenuDivider(),
        TaskContextMenuItem<Object?>(
          value: _configureFieldSentinel,
          title: 'Konfiguruj pole...',
          icon: Symbols.settings_rounded,
        ),
      ],
    ];

    final answer = await TaskContextMenu.show<Object?>(
      context,
      position: menuPosition,
      items: items,
    );

    if (answer == null) return customFieldCancelled;
    if (answer == _configureFieldSentinel) {
      onConfigureField?.call();
      return customFieldCancelled;
    }
    if (answer == customFieldClear) return <String>[];

    final next = Set<String>.from(selectedSet);
    final clickedRaw = answer.toString();
    final clickedLabel = _resolveOption(field, clickedRaw).label.toLowerCase();

    final matching = next
        .where(
          (s) =>
              s == clickedRaw ||
              _resolveOption(field, s).label.toLowerCase() == clickedLabel,
        )
        .toList();

    if (matching.isNotEmpty) {
      next.removeAll(matching);
    } else {
      next.add(clickedRaw);
    }
    return next.toList(growable: false);
  }

  /// Pomocnicza metoda wyszukiwania definicji opcji w polu.
  static CustomFieldOption _resolveOption(
    TaskCustomFieldResponse field,
    String rawVal,
  ) {
    for (final optRaw in field.options ?? const <String>[]) {
      final parsed = CustomFieldOption.fromRaw(optRaw);
      if (optRaw == rawVal ||
          parsed.label.toLowerCase() == rawVal.toLowerCase()) {
        return parsed;
      }
    }
    return CustomFieldOption.fromRaw(rawVal);
  }

  static bool _isOptionSelected(String optionRaw, String? currentVal) {
    if (currentVal == null) return false;
    final opt = CustomFieldOption.fromRaw(optionRaw);
    final cur = CustomFieldOption.fromRaw(currentVal);
    return optionRaw == currentVal ||
        opt.label.toLowerCase() == currentVal.toLowerCase() ||
        opt.label.toLowerCase() == cur.label.toLowerCase();
  }

  static bool _isMultiOptionSelected(
    String optionRaw,
    Set<String> selectedSet,
  ) {
    final opt = CustomFieldOption.fromRaw(optionRaw);
    return selectedSet.contains(optionRaw) ||
        selectedSet.contains(opt.label) ||
        selectedSet.any(
          (s) =>
              CustomFieldOption.fromRaw(s).label.toLowerCase() ==
              opt.label.toLowerCase(),
        );
  }
}
