import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_duration_formatter.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_duration_picker_mode.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

export 'task_duration_formatter.dart';

/// Lokalny launcher zakotwiczonej edycji czasu zadania.
final class TaskDurationEditor {
  const TaskDurationEditor._();

  static Future<void> show(
    BuildContext context, {
    required int? currentMinutes,
    required String title,
    required Future<bool> Function(int? minutes) onSave,
    Offset? position,
  }) async {
    final isActual = TaskDurationPickerMode.isActual(title);
    final hours = (currentMinutes != null && currentMinutes > 0)
        ? currentMinutes ~/ 60
        : 0;
    final minutes = (currentMinutes != null && currentMinutes > 0)
        ? currentMinutes % 60
        : 0;
    final hoursController = TextEditingController(
      text: hours > 0 ? hours.toString() : '',
    );
    final minutesController = TextEditingController(
      text: minutes > 0 ? minutes.toString() : '',
    );
    final totalMinutes = ValueNotifier((hours * 60) + minutes);
    const presets = <(int, String)>[
      (15, '15m'),
      (30, '30m'),
      (60, '1h'),
      (120, '2h'),
      (240, '4h'),
      (480, '1d (8h)'),
    ];

    int? selectedMinutes;
    await AppContextMenu.showCustom(
      context,
      globalPosition: position ?? AppContextMenu.positionFor(context),
      maxWidth: 280,
      contentBuilder: (panelContext, dismiss) {
        final colors = panelContext.colors;
        final text = panelContext.text;

        return ValueListenableBuilder<int>(
          valueListenable: totalMinutes,
          builder: (context, selectedTotalMinutes, _) {
            void synchronizeTotalMinutes() {
              final currentHours =
                  int.tryParse(hoursController.text.trim()) ?? 0;
              final currentMinutes =
                  int.tryParse(minutesController.text.trim()) ?? 0;
              totalMinutes.value = (currentHours * 60) + currentMinutes;
            }

            void applyPreset(int presetMinutes) {
              final newH = presetMinutes ~/ 60;
              final newM = presetMinutes % 60;
              hoursController.text = newH > 0 ? newH.toString() : '';
              minutesController.text = newM > 0 ? newM.toString() : '';
              synchronizeTotalMinutes();
            }

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isActual
                            ? Symbols.timer_rounded
                            : Symbols.schedule_rounded,
                        size: 18,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              title,
                              style: text.labelMedium?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              isActual
                                  ? 'Zarejestrowany czas pracy'
                                  : 'Szacowany czas wykonania',
                              style: text.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: context.tasksTheme.metaText.fontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Szybki wybór:',
                    style: text.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontSize: context.tasksTheme.metaText.fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (final preset in presets)
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          borderRadius: .circular(5),
                          onTap: () => applyPreset(preset.$1),
                          child: Container(
                            padding: const .symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: .circular(5),
                              color: selectedTotalMinutes == preset.$1
                                  ? colors.primary
                                  : colors.surfaceContainerHigh,
                              border: Border.all(
                                color: selectedTotalMinutes == preset.$1
                                    ? colors.primary
                                    : colors.outlineVariant.withValues(
                                        alpha: 0.35,
                                      ),
                              ),
                            ),
                            child: Text(
                              preset.$2,
                              style: text.labelSmall?.copyWith(
                                color: selectedTotalMinutes == preset.$1
                                    ? colors.onPrimary
                                    : colors.onSurface,
                                fontWeight: selectedTotalMinutes == preset.$1
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Godziny (h)',
                              style: text.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontSize: context.tasksTheme.metaText.fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: hoursController,
                              keyboardType: TextInputType.number,
                              style: text.bodySmall?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: '0',
                                isDense: true,
                                contentPadding: const .symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: .circular(6),
                                  borderSide: BorderSide(
                                    color: colors.outlineVariant,
                                  ),
                                ),
                                suffixText: 'h',
                              ),
                              onChanged: (_) => synchronizeTotalMinutes(),
                              onSubmitted: (_) {
                                selectedMinutes = selectedTotalMinutes;
                                dismiss();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Minuty (m)',
                              style: text.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontSize: context.tasksTheme.metaText.fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: minutesController,
                              keyboardType: TextInputType.number,
                              style: text.bodySmall?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: '0',
                                isDense: true,
                                contentPadding: const .symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: .circular(6),
                                  borderSide: BorderSide(
                                    color: colors.outlineVariant,
                                  ),
                                ),
                                suffixText: 'm',
                              ),
                              onChanged: (_) => synchronizeTotalMinutes(),
                              onSubmitted: (_) {
                                selectedMinutes = selectedTotalMinutes;
                                dismiss();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const .symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.08),
                      borderRadius: .circular(6),
                    ),
                    child: Text(
                      selectedTotalMinutes > 0
                          ? 'Łącznie: ${TaskDurationFormatter.format(selectedTotalMinutes)} ($selectedTotalMinutes min)'
                          : 'Czas nieustawiony (0m)',
                      style: text.labelSmall?.copyWith(
                        color: selectedTotalMinutes > 0
                            ? colors.primary
                            : colors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      if (currentMinutes != null && currentMinutes > 0)
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () {
                            selectedMinutes = 0;
                            dismiss();
                          },
                          child: Padding(
                            padding: const .symmetric(vertical: 4),
                            child: Text(
                              'Wyczyść czas',
                              style: text.labelSmall?.copyWith(
                                color: colors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const .symmetric(horizontal: 14),
                          minimumSize: const Size(0, 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(6),
                          ),
                        ),
                        onPressed: () {
                          selectedMinutes = selectedTotalMinutes;
                          dismiss();
                        },
                        child: const Text(
                          'Zatwierdź',
                          style: TextStyle(fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    hoursController.dispose();
    minutesController.dispose();
    totalMinutes.dispose();
    if (selectedMinutes == null) return;
    if (selectedMinutes == 0) {
      await onSave(null);
    } else {
      await onSave(selectedMinutes);
    }
  }
}
