import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';

/// Pomocnik wizualny dla statusów zadań w widokach listy i tabeli.
abstract final class TaskStatusVisualHelper {
  /// Zwraca zlokalizowaną etykietę dla statusu zadania.
  static String label(BuildContext context, ProjectTaskStatus status) =>
      switch (status) {
        ProjectTaskStatus.backlog => context.l10n.tasksListStatusBacklog,
        ProjectTaskStatus.todo => context.l10n.tasksListStatusTodo,
        ProjectTaskStatus.inProgress => context.l10n.tasksListStatusInProgress,
        ProjectTaskStatus.done => context.l10n.tasksListStatusDone,
        ProjectTaskStatus.blocked => context.l10n.tasksListStatusBlocked,
        ProjectTaskStatus.cancelled => context.l10n.tasksListStatusCancelled,
      };

  /// Zwraca kolor semantyczny dla danego statusu zadania.
  static Color color(ProjectTaskStatus status) => switch (status) {
    ProjectTaskStatus.backlog => const Color(0xFF64748B),
    ProjectTaskStatus.todo => const Color(0xFF2563EB),
    ProjectTaskStatus.inProgress => const Color(0xFFF59E0B),
    ProjectTaskStatus.done => const Color(0xFF10B981),
    ProjectTaskStatus.blocked => const Color(0xFFEF4444),
    ProjectTaskStatus.cancelled => const Color(0xFF94A3B8),
  };

  /// Zwraca ikonę reprezentującą dany status zadania.
  static IconData icon(ProjectTaskStatus status) => switch (status) {
    ProjectTaskStatus.backlog => Symbols.inbox_rounded,
    ProjectTaskStatus.todo => Symbols.radio_button_unchecked,
    ProjectTaskStatus.inProgress => Symbols.timelapse,
    ProjectTaskStatus.blocked => Symbols.block_rounded,
    ProjectTaskStatus.done => Symbols.check_circle,
    ProjectTaskStatus.cancelled => Symbols.cancel,
  };
}
