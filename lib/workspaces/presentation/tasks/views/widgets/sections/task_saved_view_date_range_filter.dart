import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/shell/overlay/app_modal_picker_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';

/// Podsekcja wyboru zakresu dat terminu wykonania (dueFrom / dueTo).
class TaskSavedViewDateRangeFilter extends StatelessWidget {
  const TaskSavedViewDateRangeFilter({
    required this.dueFrom,
    required this.dueTo,
    required this.onDueFromChanged,
    required this.onDueToChanged,
    this.errorMessage,
    super.key,
  });

  final DateTime? dueFrom;
  final DateTime? dueTo;
  final ValueChanged<DateTime?> onDueFromChanged;
  final ValueChanged<DateTime?> onDueToChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Symbols.date_range, size: 18),
              label: Text(
                dueFrom == null
                    ? l10n.myTasksDueFrom
                    : MaterialLocalizations.of(
                        context,
                      ).formatCompactDate(dueFrom!.toLocal()),
              ),
              onPressed: () async {
                final value = await AppModalPickerHost.showDate(
                  context,
                  initialDate: dueFrom?.toLocal() ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (value != null) {
                  onDueFromChanged(
                    DateTime.utc(value.year, value.month, value.day),
                  );
                }
              },
            ),
            if (dueFrom != null)
              IconButton(
                tooltip: l10n.myTasksClear,
                onPressed: () => onDueFromChanged(null),
                icon: const Icon(Symbols.close_rounded, size: 18),
              ),
            OutlinedButton.icon(
              icon: const Icon(Symbols.event, size: 18),
              label: Text(
                dueTo == null
                    ? l10n.myTasksDueTo
                    : MaterialLocalizations.of(
                        context,
                      ).formatCompactDate(dueTo!.toLocal()),
              ),
              onPressed: () async {
                final value = await AppModalPickerHost.showDate(
                  context,
                  initialDate: dueTo?.toLocal() ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (value != null) {
                  onDueToChanged(
                    DateTime.utc(
                      value.year,
                      value.month,
                      value.day,
                      23,
                      59,
                      59,
                    ),
                  );
                }
              },
            ),
            if (dueTo != null)
              IconButton(
                tooltip: l10n.myTasksClear,
                onPressed: () => onDueToChanged(null),
                icon: const Icon(Symbols.close_rounded, size: 18),
              ),
          ],
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 4),
          Text(
            errorMessage!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
