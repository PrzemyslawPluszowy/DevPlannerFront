import 'package:flutter/foundation.dart';

/// Osobista preferencja widoczności kolumn osób na tablicy Kanban.
///
/// W widoku „Według osoby” osoba jest osią kolumny, a nie filtrem kart, więc
/// użytkownik nie filtruje tu zadań po wykonawcy — pokazuje i ukrywa całe
/// kolumny. Preferencja jest lokalna dla klienta i per użytkownik, workspace
/// oraz projekt, tak samo jak wybór grupowania.
@immutable
final class TasksBoardAssigneeColumnsPreference {
  const TasksBoardAssigneeColumnsPreference({
    this.hiddenAssigneeUserIds = const <String>{},
    this.hideEmpty = false,
  });

  /// Klucze ukrytych kolumn (identyfikator osoby albo klucz grupy
  /// „Nieprzypisane”).
  ///
  /// Trzymamy ukryte, a nie widoczne: nowy członek projektu pojawia się na
  /// tablicy od razu, zamiast znikać, dopóki ktoś nie zmieni zapisanej listy.
  final Set<String> hiddenAssigneeUserIds;

  /// Czy kolumny bez zadań mają być ukryte.
  final bool hideEmpty;

  bool get isDefault => hiddenAssigneeUserIds.isEmpty && !hideEmpty;

  TasksBoardAssigneeColumnsPreference copyWith({
    Set<String>? hiddenAssigneeUserIds,
    bool? hideEmpty,
  }) => TasksBoardAssigneeColumnsPreference(
    hiddenAssigneeUserIds: hiddenAssigneeUserIds ?? this.hiddenAssigneeUserIds,
    hideEmpty: hideEmpty ?? this.hideEmpty,
  );

  @override
  bool operator ==(Object other) =>
      other is TasksBoardAssigneeColumnsPreference &&
      other.hideEmpty == hideEmpty &&
      other.hiddenAssigneeUserIds.length == hiddenAssigneeUserIds.length &&
      other.hiddenAssigneeUserIds.containsAll(hiddenAssigneeUserIds);

  @override
  int get hashCode => Object.hash(
    hideEmpty,
    Object.hashAllUnordered(hiddenAssigneeUserIds),
  );

  @override
  String toString() =>
      'TasksBoardAssigneeColumnsPreference(hidden: '
      '${hiddenAssigneeUserIds.length}, hideEmpty: $hideEmpty)';
}
