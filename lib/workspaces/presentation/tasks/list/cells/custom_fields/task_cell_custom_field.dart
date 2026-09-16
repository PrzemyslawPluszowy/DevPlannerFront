import 'package:flutter/material.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/custom_fields/task_cell_custom_primitive.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/custom_fields/task_cell_custom_select.dart';

/// Komponent rozdzielający renderowanie i edycję komórki pola niestandardowego.
///
/// W zależności od typu pola deleguje wyświetlanie do `TaskCellCustomSelect`
/// lub `TaskCellCustomPrimitive`.
class TaskCellCustomField extends StatelessWidget {
  const TaskCellCustomField({
    required this.field,
    required this.value,
    required this.profiles,
    super.key,
    this.onChanged,
    this.width,
    this.canManage = false,
    this.onConfigureField,
  });

  /// Definicja pola niestandardowego.
  final TaskCustomFieldResponse field;

  /// Wartość pola w zadaniu.
  final Object? value;

  /// Słownik profili członków projektu.
  final Map<String, ProjectMemberProfile> profiles;

  /// Callback wywoływany przy zmianie wartości pola.
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onChanged;

  /// Szerokość komórki w pikselach.
  final double? width;

  /// Czy użytkownik posiada uprawnienia zarządcze w projekcie.
  final bool canManage;

  /// Callback konfiguracji pola w projekcie.
  final VoidCallback? onConfigureField;

  @override
  Widget build(BuildContext context) {
    final child =
        (field.type == TaskCustomFieldType.singleSelect ||
            field.type == TaskCustomFieldType.multiSelect)
        ? TaskCellCustomSelect(
            field: field,
            value: value,
            onChanged: onChanged,
            canManage: canManage,
            onConfigureField: onConfigureField,
          )
        : TaskCellCustomPrimitive(
            field: field,
            value: value,
            profiles: profiles,
            onChanged: onChanged,
          );

    if (width != null) {
      return SizedBox(width: width, child: child);
    }
    return child;
  }
}
