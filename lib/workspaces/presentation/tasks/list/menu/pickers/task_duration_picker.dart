import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/task_context_menu.dart';

/// Pomocnik do formatowania i parsowania czasu trwania zadań (w minutach).
class TaskDurationFormatter {
  const TaskDurationFormatter._();

  /// Formatuje minuty do czytelnego formatu (np. 15m, 1h, 1h 30m, 1d 2h).
  static String format(int? minutes, {bool showEmptyDash = false}) {
    if (minutes == null || minutes <= 0) {
      return showEmptyDash ? '—' : '';
    }
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours >= 8 && hours % 8 == 0 && remainingMinutes == 0) {
      final days = hours ~/ 8;
      return '${days}d';
    }

    if (remainingMinutes == 0) return '${hours}h';
    return '${hours}h ${remainingMinutes}m';
  }

  /// Parsuje tekst użytkownika (np. "1h 30m", "90m", "1.5h", "2d", "120") do minut.
  static int? parse(String input) {
    final clean = input.trim().toLowerCase();
    if (clean.isEmpty) return null;

    final directNumber = int.tryParse(clean);
    if (directNumber != null) return directNumber > 0 ? directNumber : null;

    var total = 0;
    final dayMatch = RegExp(r'(\d+(?:\.\d+)?)\s*d').firstMatch(clean);
    final hourMatch = RegExp(r'(\d+(?:\.\d+)?)\s*h').firstMatch(clean);
    final minuteMatch = RegExp(r'(\d+)\s*m').firstMatch(clean);

    if (dayMatch != null) {
      final days = double.tryParse(dayMatch.group(1) ?? '') ?? 0;
      total += (days * 8 * 60).round();
    }
    if (hourMatch != null) {
      final hours = double.tryParse(hourMatch.group(1) ?? '') ?? 0;
      total += (hours * 60).round();
    }
    if (minuteMatch != null) {
      final minutes = int.tryParse(minuteMatch.group(1) ?? '') ?? 0;
      total += minutes;
    }

    return total > 0 ? total : null;
  }
}

/// Wyświetla zakotwiczony picker estymaty czasu lub czasu rzeczywistego.
Future<void> showTaskDurationPicker(
  BuildContext context, {
  required int? currentMinutes,
  required String title,
  required Future<bool> Function(int? minutes) onSave,
  RelativeRect? menuPosition,
}) async {
  final position = menuPosition ?? TaskContextMenu.positionFor(context);
  final isActual =
      title.toLowerCase().contains('rzeczywisty') ||
      title.toLowerCase().contains('logged');

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

  const presets = [
    (15, '15m'),
    (30, '30m'),
    (60, '1h'),
    (120, '2h'),
    (240, '4h'),
    (480, '1d (8h)'),
  ];

  final selectedMinutes = await showDialog<int?>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (dialogContext) {
      final colors = dialogContext.colors;
      final text = dialogContext.text;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          final h = int.tryParse(hoursController.text.trim()) ?? 0;
          final m = int.tryParse(minutesController.text.trim()) ?? 0;
          final totalMinutes = (h * 60) + m;

          void applyPreset(int presetMinutes) {
            final newH = presetMinutes ~/ 60;
            final newM = presetMinutes % 60;
            hoursController.text = newH > 0 ? newH.toString() : '';
            minutesController.text = newM > 0 ? newM.toString() : '';
            setDialogState(() {});
          }

          final mediaQuery = MediaQuery.of(dialogContext);
          final screenSize = mediaQuery.size;
          const popupWidth = 280.0;
          const estimatedHeight = 360.0;
          const margin = 12.0;

          // Dopasowanie współrzędnych do granic viewportu, by okno nie wystawało poza ekran.
          var left = position.left;
          if (left + popupWidth + margin > screenSize.width) {
            left = screenSize.width - popupWidth - margin;
          }
          if (left < margin) {
            left = margin;
          }

          var top = position.top;
          if (top + estimatedHeight + margin > screenSize.height) {
            final anchorBottom = screenSize.height - position.bottom;
            final above = anchorBottom - estimatedHeight;
            if (above >= margin) {
              top = above;
            } else {
              top = (screenSize.height - estimatedHeight - margin).clamp(
                margin,
                screenSize.height,
              );
            }
          }
          if (top < margin) {
            top = margin;
          }

          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.of(dialogContext).pop(),
                ),
              ),
              Positioned(
                left: left,
                top: top,
                child: Material(
                  elevation: 6,
                  borderRadius: .circular(8),
                  color: colors.surfaceContainerLowest,
                  shadowColor: colors.shadow.withValues(alpha: 0.2),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: popupWidth,
                      maxHeight: (screenSize.height - (margin * 2)).clamp(
                        100.0,
                        double.infinity,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        width: popupWidth,
                        padding: const .all(12),
                        decoration: BoxDecoration(
                          borderRadius: .circular(8),
                          border: Border.all(
                            color: colors.outlineVariant.withValues(alpha: 0.7),
                          ),
                        ),
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
                                          color: colors.onSurfaceVariant
                                              .withValues(
                                                alpha: 0.8,
                                              ),
                                          fontSize: 10,
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
                                fontSize: 10.5,
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
                                        color: totalMinutes == preset.$1
                                            ? colors.primary
                                            : colors.surfaceContainerHigh,
                                        border: Border.all(
                                          color: totalMinutes == preset.$1
                                              ? colors.primary
                                              : colors.outlineVariant
                                                    .withValues(
                                                      alpha: 0.35,
                                                    ),
                                        ),
                                      ),
                                      child: Text(
                                        preset.$2,
                                        style: text.labelSmall?.copyWith(
                                          color: totalMinutes == preset.$1
                                              ? colors.onPrimary
                                              : colors.onSurface,
                                          fontWeight: totalMinutes == preset.$1
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
                                          fontSize: 10.5,
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
                                        onChanged: (_) => setDialogState(() {}),
                                        onSubmitted: (_) {
                                          Navigator.of(dialogContext)
                                              .pop(totalMinutes);
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
                                          fontSize: 10.5,
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
                                        onChanged: (_) => setDialogState(() {}),
                                        onSubmitted: (_) {
                                          Navigator.of(dialogContext)
                                              .pop(totalMinutes);
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
                                totalMinutes > 0
                                    ? 'Łącznie: ${TaskDurationFormatter.format(totalMinutes)} ($totalMinutes min)'
                                    : 'Czas nieustawiony (0m)',
                                style: text.labelSmall?.copyWith(
                                  color: totalMinutes > 0
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
                                if (currentMinutes != null &&
                                    currentMinutes > 0)
                                  InkWell(
                                    mouseCursor: SystemMouseCursors.click,
                                    onTap: () =>
                                        Navigator.of(dialogContext).pop(0),
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
                                    Navigator.of(dialogContext)
                                        .pop(totalMinutes);
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
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );

  hoursController.dispose();
  minutesController.dispose();

  if (selectedMinutes == null) return;
  if (selectedMinutes == 0) {
    await onSave(null);
  } else {
    await onSave(selectedMinutes);
  }
}
