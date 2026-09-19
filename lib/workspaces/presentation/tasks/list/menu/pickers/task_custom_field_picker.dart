import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
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
    required Offset position,
  }) async {
    final boolValue = value is bool
        ? value
        : value is String
        ? value.toLowerCase() == 'true'
        : null;

    final options = <AppContextMenuOption<Object>>[
      AppContextMenuOption(
        value: true,
        label: '${field.name}: Tak',
        icon: Symbols.check_circle_rounded,
        iconColor: const Color(0xFF4CAF50),
        selected: boolValue == true,
      ),
      AppContextMenuOption(
        value: false,
        label: '${field.name}: Nie',
        icon: Symbols.cancel_rounded,
        iconColor: const Color(0xFF757575),
        selected: boolValue == false,
      ),
      if (!field.isRequired)
        AppContextMenuOption(
          value: customFieldClear,
          label: context.l10n.tasksListClearValue,
          icon: Symbols.close_rounded,
          iconColor: context.colors.error,
          separatorBefore: true,
        ),
    ];

    final selected = await AppContextMenu.select<Object>(
      context,
      globalPosition: position,
      options: options,
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
    required Offset position,
    bool canManage = false,
    VoidCallback? onConfigureField,
  }) async {
    final rawOptions = field.options ?? const <String>[];
    final currentStr = value?.toString();

    final options = <AppContextMenuOption<Object>>[
      for (final optionRaw in rawOptions)
        AppContextMenuOption(
          value: optionRaw,
          label: _resolveOption(field, optionRaw).label,
          icon: _resolveOption(field, optionRaw).icon ?? Symbols.circle,
          iconColor: _resolveOption(field, optionRaw).color,
          selected: _isOptionSelected(optionRaw, currentStr),
        ),
      if (!field.isRequired)
        AppContextMenuOption(
          value: customFieldClear,
          label: context.l10n.tasksListClearValue,
          icon: Symbols.close_rounded,
          iconColor: context.colors.error,
          separatorBefore: true,
        ),
      if (canManage && onConfigureField != null)
        const AppContextMenuOption(
          value: _configureFieldSentinel,
          label: 'Konfiguruj pole...',
          icon: Symbols.settings_rounded,
          separatorBefore: true,
        ),
    ];

    final selected = await AppContextMenu.select<Object>(
      context,
      globalPosition: position,
      options: options,
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
    required Offset position,
    bool canManage = false,
    VoidCallback? onConfigureField,
  }) async {
    final rawOptions = field.options ?? const <String>[];
    final selectedSet = (value is List ? value : const <Object?>[])
        .map((item) => item.toString())
        .toSet();

    final options = <AppContextMenuOption<Object>>[
      for (final optionRaw in rawOptions)
        AppContextMenuOption(
          value: optionRaw,
          label: _resolveOption(field, optionRaw).label,
          icon: _resolveOption(field, optionRaw).icon ?? Symbols.circle,
          iconColor: _resolveOption(field, optionRaw).color,
          selected: _isMultiOptionSelected(optionRaw, selectedSet),
        ),
      if (!field.isRequired)
        AppContextMenuOption(
          value: customFieldClear,
          label: context.l10n.tasksListClearValue,
          icon: Symbols.close_rounded,
          iconColor: context.colors.error,
          separatorBefore: true,
        ),
      if (canManage && onConfigureField != null)
        const AppContextMenuOption(
          value: _configureFieldSentinel,
          label: 'Konfiguruj pole...',
          icon: Symbols.settings_rounded,
          separatorBefore: true,
        ),
    ];

    final answer = await AppContextMenu.select<Object>(
      context,
      globalPosition: position,
      options: options,
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
