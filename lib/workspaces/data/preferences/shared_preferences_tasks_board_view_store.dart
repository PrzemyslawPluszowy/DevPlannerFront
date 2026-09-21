import 'dart:convert';

import 'package:devplanner/workspaces/domain/models/tasks_board_assignee_columns_preference.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_board_view_preference_store.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lokalny adapter osobistych preferencji widoku tablicy Kanban.
///
/// Preferencje są lokalne dla klienta, tak jak wybór motywu czy widok modułu
/// Zadania: nie są danymi domenowymi i nie wymagają żądania do Backendu.
/// Platforma bez implementacji `shared_preferences` (test widgetowy, build bez
/// pluginu) zgłasza `FlutterError`, czyli `Error`; ta granica zamienia każdą
/// taką awarię na brak preferencji i wpis diagnostyczny.
final class SharedPreferencesTasksBoardViewStore
    implements TasksBoardViewPreferenceStore {
  SharedPreferencesTasksBoardViewStore({required this.currentUserId});

  static const _prefix = 'devplanner.tasks-board-grouping.';
  static const _columnsSuffix = '.assignee-columns';

  /// Tożsamość czytana w momencie operacji, a nie raz na starcie klienta.
  final String? Function() currentUserId;

  String _key(String userId, String workspaceId, String projectId) =>
      '$_prefix$userId.$workspaceId.$projectId';

  String _columnsKey(String userId, String workspaceId, String projectId) =>
      '${_key(userId, workspaceId, projectId)}$_columnsSuffix';

  @override
  Future<TasksBoardGrouping?> readGrouping({
    required String workspaceId,
    required String projectId,
  }) async {
    final userId = currentUserId();
    if (userId == null) return null;
    try {
      final preferences = await SharedPreferences.getInstance();
      return TasksBoardGrouping.fromWire(
        preferences.getString(_key(userId, workspaceId, projectId)),
      );
    } on Object catch (error) {
      _report('read', error);
      return null;
    }
  }

  @override
  Future<void> writeGrouping({
    required String workspaceId,
    required String projectId,
    required TasksBoardGrouping grouping,
  }) async {
    final userId = currentUserId();
    if (userId == null) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        _key(userId, workspaceId, projectId),
        grouping.wireValue,
      );
    } on Object catch (error) {
      _report('write', error);
    }
  }

  @override
  Future<TasksBoardAssigneeColumnsPreference> readAssigneeColumns({
    required String workspaceId,
    required String projectId,
  }) async {
    final userId = currentUserId();
    if (userId == null) return const TasksBoardAssigneeColumnsPreference();
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString(
        _columnsKey(userId, workspaceId, projectId),
      );
      if (raw == null) return const TasksBoardAssigneeColumnsPreference();
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, Object?>) {
        return const TasksBoardAssigneeColumnsPreference();
      }
      final hidden = decoded['hidden'];
      return TasksBoardAssigneeColumnsPreference(
        hiddenAssigneeUserIds: hidden is List
            ? hidden.whereType<String>().toSet()
            : const <String>{},
        hideEmpty: decoded['hideEmpty'] == true,
      );
    } on Object catch (error) {
      _report('read columns', error);
      return const TasksBoardAssigneeColumnsPreference();
    }
  }

  @override
  Future<void> writeAssigneeColumns({
    required String workspaceId,
    required String projectId,
    required TasksBoardAssigneeColumnsPreference preference,
  }) async {
    final userId = currentUserId();
    if (userId == null) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      final key = _columnsKey(userId, workspaceId, projectId);
      if (preference.isDefault) {
        await preferences.remove(key);
        return;
      }
      await preferences.setString(
        key,
        jsonEncode({
          'hidden': preference.hiddenAssigneeUserIds.toList(growable: false)
            ..sort(),
          'hideEmpty': preference.hideEmpty,
        }),
      );
    } on Object catch (error) {
      _report('write columns', error);
    }
  }

  void _report(String operation, Object error) {
    if (kDebugMode) {
      debugPrint(
        '[tasks.board.view] preference $operation unavailable: '
        '${error.runtimeType}',
      );
    }
  }
}
