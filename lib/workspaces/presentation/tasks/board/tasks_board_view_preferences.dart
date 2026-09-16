part of 'tasks_board_page.dart';

/// Lokalne, per-projektowe zapamiętanie ostatnio wybranego widoku Tasks.
///
/// Parametr deep linku ma pierwszeństwo nad tą preferencją, dlatego wspólny
/// adres zawsze otwiera widok wskazany przez autora linku.
final class _TasksProjectViewPreferences {
  static const _keyPrefix = 'workspaces.tasks.project-view';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<_TasksProjectView?> read({
    required String workspaceId,
    required String projectId,
  }) async {
    final value = await _preferences.getString(_key(workspaceId, projectId));
    return switch (value) {
      'list' => _TasksProjectView.list,
      'timeline' => _TasksProjectView.timeline,
      'workload' => _TasksProjectView.workload,
      'recurrence' => _TasksProjectView.recurrence,
      'board' => _TasksProjectView.board,
      _ => null,
    };
  }

  Future<void> write({
    required String workspaceId,
    required String projectId,
    required _TasksProjectView view,
  }) => _preferences.setString(
    _key(workspaceId, projectId),
    switch (view) {
      _TasksProjectView.board => 'board',
      _TasksProjectView.list => 'list',
      _TasksProjectView.timeline => 'timeline',
      _TasksProjectView.workload => 'workload',
      _TasksProjectView.recurrence => 'recurrence',
    },
  );

  String _key(String workspaceId, String projectId) =>
      '$_keyPrefix.$workspaceId.$projectId';
}
