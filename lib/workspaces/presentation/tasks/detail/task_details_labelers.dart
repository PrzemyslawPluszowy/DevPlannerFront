import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Tłumaczy częstotliwość cykliczności wyłącznie dla warstwy prezentacji.
final class TaskRecurrenceFrequencyLabeler {
  const TaskRecurrenceFrequencyLabeler._();

  static String label(
    BuildContext context,
    TaskRecurrenceFrequency frequency,
  ) => switch (frequency) {
    TaskRecurrenceFrequency.daily =>
      context.l10n.taskDetailsRecurrenceFrequencyDaily,
    TaskRecurrenceFrequency.weekly =>
      context.l10n.taskDetailsRecurrenceFrequencyWeekly,
    TaskRecurrenceFrequency.monthly =>
      context.l10n.taskDetailsRecurrenceFrequencyMonthly,
  };
}

/// Lokalizuje tryb reguły cykliczności w formularzu zadania.
final class TaskRecurrenceModeLabeler {
  const TaskRecurrenceModeLabeler._();

  static String label(BuildContext context, TaskRecurrenceMode value) =>
      switch (value) {
        TaskRecurrenceMode.scheduled =>
          context.l10n.taskDetailsRecurrenceModeScheduled,
        TaskRecurrenceMode.afterCompletion =>
          context.l10n.taskDetailsRecurrenceModeAfterCompletion,
      };
}

/// Tłumaczy typ relacji zadania tylko dla widoku zależności.
final class TaskDependencyTypeLabeler {
  const TaskDependencyTypeLabeler._();

  static String label(BuildContext context, TaskDependencyType type) =>
      switch (type) {
        TaskDependencyType.blocks => context.l10n.taskDependencyBlocks,
        TaskDependencyType.relatedTo => context.l10n.taskDependencyRelated,
        TaskDependencyType.duplicate => context.l10n.taskDependencyDuplicate,
      };
}
