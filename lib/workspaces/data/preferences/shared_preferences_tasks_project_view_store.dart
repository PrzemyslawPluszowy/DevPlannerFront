import 'package:devplanner/workspaces/domain/ports/tasks_project_view_preference_store.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lokalny adapter preferencji widoku modułu Zadania.
///
/// Klucz zawiera użytkownika, workspace i projekt, więc przełączenie widoku
/// w jednym projekcie nie zmienia widoku w innym, a zmiana konta na tym samym
/// urządzeniu nie dziedziczy wyboru poprzedniej osoby. Preferencja pozostaje
/// lokalna dla klienta (jak wybór motywu): nie jest danymi domenowymi i nie
/// wymaga żądania do Backendu.
///
/// Platforma bez implementacji `shared_preferences` (test widgetowy, build bez
/// pluginu) zgłasza `FlutterError`, czyli `Error`, a nie `Exception`. Ta
/// granica zamienia każdą taką awarię na pusty stan i wpis w logu
/// diagnostycznym, dzięki czemu moduł Zadania nie zależy od persistence UI.
final class SharedPreferencesTasksProjectViewStore
    implements TasksProjectViewPreferenceStore {
  SharedPreferencesTasksProjectViewStore({required this.currentUserId});

  static const _prefix = 'devplanner.tasks-view.';

  /// Tożsamość czytana w momencie operacji, a nie raz na starcie klienta.
  ///
  /// Dzięki temu wylogowanie i zalogowanie innego konta w tej samej sesji
  /// aplikacji nie wymaga restartu, żeby preferencja przestała przeciekać.
  final String? Function() currentUserId;

  final Map<String, String> _views = <String, String>{};

  String? _loadedForUserId;

  String _key(String userId, String workspaceId, String projectId) =>
      '$_prefix$userId.$workspaceId.$projectId';

  String _userPrefix(String userId) => '$_prefix$userId.';

  @override
  String? viewFor({required String workspaceId, required String projectId}) {
    final userId = currentUserId();
    if (userId == null) return null;
    // Cache innego konta nie może oddać cudzego wyboru; świeży zestaw wczytuje
    // właściciel sesji (router) po zmianie użytkownika, a nie ten odczyt.
    if (_loadedForUserId != userId) return null;
    return _views[_key(userId, workspaceId, projectId)];
  }

  @override
  Future<void> load() async {
    final userId = currentUserId();
    if (userId == null) {
      _views.clear();
      _loadedForUserId = null;
      return;
    }
    try {
      final preferences = await SharedPreferences.getInstance();
      final userPrefix = _userPrefix(userId);
      _views.clear();
      for (final key in preferences.getKeys()) {
        if (!key.startsWith(userPrefix)) continue;
        final view = preferences.getString(key);
        if (view != null) _views[key] = view;
      }
      _loadedForUserId = userId;
    } on Object catch (error) {
      _views.clear();
      _loadedForUserId = null;
      _report('load', error);
    }
  }

  @override
  Future<void> write({
    required String workspaceId,
    required String projectId,
    required String view,
  }) async {
    final userId = currentUserId();
    if (userId == null) return;
    final key = _key(userId, workspaceId, projectId);
    _views[key] = view;
    _loadedForUserId = userId;
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(key, view);
    } on Object catch (error) {
      _report('write', error);
    }
  }

  void _report(String operation, Object error) {
    if (kDebugMode) {
      debugPrint(
        '[tasks.view] preference $operation unavailable: ${error.runtimeType}',
      );
    }
  }
}
