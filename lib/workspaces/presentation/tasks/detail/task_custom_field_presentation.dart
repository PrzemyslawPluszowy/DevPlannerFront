import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Mapuje wartości pól własnych na elementy prezentacji detalu zadania.
final class TaskCustomFieldPresentation {
  const TaskCustomFieldPresentation._();

  static IconData icon(TaskCustomFieldType type) => switch (type) {
    TaskCustomFieldType.text => Symbols.text_fields_rounded,
    TaskCustomFieldType.number => Symbols.numbers_rounded,
    TaskCustomFieldType.date => Symbols.event,
    TaskCustomFieldType.boolean => Symbols.toggle_on,
    TaskCustomFieldType.singleSelect ||
    TaskCustomFieldType.multiSelect => Symbols.list_alt_rounded,
    TaskCustomFieldType.user => Symbols.person_outline_rounded,
  };

  static String displayValue(BuildContext context, dynamic value) =>
      switch (value) {
        null => '—',
        final List<Object?> values when values.isEmpty => '—',
        final List<Object?> values =>
          values
              .map((item) => CustomFieldOption.fromRaw(item.toString()).label)
              .join(', '),
        true => context.l10n.yes,
        false => context.l10n.no,
        _ => CustomFieldOption.fromRaw(value.toString()).label,
      };

  static List<TaskCustomFieldDefinitionValueResponse> sorted(
    List<TaskCustomFieldDefinitionValueResponse> fields,
  ) => [...fields]..sort((a, b) => a.position.compareTo(b.position));
}
