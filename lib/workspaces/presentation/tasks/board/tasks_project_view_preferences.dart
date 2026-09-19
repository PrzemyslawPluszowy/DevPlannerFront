import 'package:shared_preferences/shared_preferences.dart';

/// Lokalne, per-projektowe zapamiętanie ostatniego widoku zadań.
final class TasksProjectViewPreferences {
  static const _keyPrefix = 'workspaces.tasks.project-view';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<String?> read({
    required String workspaceId,
    required String projectId,
  }) => _preferences.getString(_key(workspaceId, projectId));

  Future<void> write({
    required String workspaceId,
    required String projectId,
    required String view,
  }) => _preferences.setString(_key(workspaceId, projectId), view);

  String _key(String workspaceId, String projectId) =>
      '$_keyPrefix.$workspaceId.$projectId';
}
