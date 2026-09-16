import 'package:flutter/foundation.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';

/// Jednolita referencja kolumny listy zadań (zarówno systemowej, jak i pola własnego).
///
/// Umożliwia dowolne przeplatanie kolumn systemowych i własnych w jednej
/// sekwencji nagłówków oraz w panelu konfiguracji kolumn.
@immutable
sealed class TaskColumnReference {
  const TaskColumnReference();

  /// Tworzy referencję do kolumny systemowej.
  const factory TaskColumnReference.system(TaskSavedViewColumn column) =
      SystemColumnReference;

  /// Tworzy referencję do pola własnego projektu.
  const factory TaskColumnReference.customField(String fieldId) =
      CustomFieldColumnReference;

  /// Tworzy referencję na podstawie tekstowego klucza.
  factory TaskColumnReference.fromId(String id) {
    if (id.startsWith('sys:')) {
      final name = id.substring(4);
      final col = TaskSavedViewColumn.values.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
        orElse: () => TaskSavedViewColumn.title,
      );
      return SystemColumnReference(col);
    } else if (id.startsWith('cf:')) {
      return CustomFieldColumnReference(id.substring(3));
    }
    final col = TaskSavedViewColumn.values.firstWhere(
      (c) => c.name.toLowerCase() == id.toLowerCase(),
      orElse: () => TaskSavedViewColumn.title,
    );
    return SystemColumnReference(col);
  }

  /// Unikalny identyfikator tekstowy (np. `sys:title` lub `cf:019139a0...`).
  String get id;

  /// Czy referencja dotyczy kolumny systemowej.
  bool get isSystem;

  /// Czy referencja dotyczy pola własnego (custom field).
  bool get isCustomField;
}

/// Referencja do kolumny systemowej widoku zadań.
@immutable
final class SystemColumnReference extends TaskColumnReference {
  const SystemColumnReference(this.column);

  /// Kolumna systemowa z enumu kontraktu.
  final TaskSavedViewColumn column;

  @override
  String get id => 'sys:${column.name}';

  @override
  bool get isSystem => true;

  @override
  bool get isCustomField => false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SystemColumnReference && other.column == column;

  @override
  int get hashCode => column.hashCode;

  @override
  String toString() => id;
}

/// Referencja do pola niestandardowego (custom field) projektu.
@immutable
final class CustomFieldColumnReference extends TaskColumnReference {
  const CustomFieldColumnReference(this.fieldId);

  /// UUID pola niestandardowego.
  final String fieldId;

  @override
  String get id => 'cf:$fieldId';

  @override
  bool get isSystem => false;

  @override
  bool get isCustomField => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomFieldColumnReference && other.fieldId == fieldId;

  @override
  int get hashCode => fieldId.hashCode;

  @override
  String toString() => id;
}
