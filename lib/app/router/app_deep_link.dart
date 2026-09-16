import 'dart:async';

import 'package:ready_next/app/router/app_router.dart';

/// Bezpieczny, wewnętrzny deep link aplikacji.
///
/// Backend przekazuje deep link jako ścieżkę aplikacji (np.
/// `/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}`). Ten
/// parser jest wspólnym punktem wejścia dla powiadomień, dashboardu i chat
/// placementów. Nie dopuszcza adresów zewnętrznych ani ścieżek spoza
/// jawnego kontraktu routingu.
final class AppDeepLink {
  const AppDeepLink._(this.uri);

  /// Znormalizowany adres względny, gotowy do przekazania routerowi.
  final Uri uri;

  /// Zwraca link tylko wtedy, gdy jest wewnętrzną, znaną trasą aplikacji.
  static AppDeepLink? parse(String? rawValue) {
    final value = rawValue?.trim() ?? '';
    if (value.isEmpty || value.contains('\\')) {
      return null;
    }

    final rawPath = value.split('?').first.split('#').first;
    final rawSegments = rawPath.split('/');
    if (rawSegments.any((segment) => segment == '.' || segment == '..')) {
      return null;
    }

    final parsed = Uri.tryParse(value);
    if (parsed == null ||
        parsed.hasScheme ||
        parsed.hasAuthority ||
        value.startsWith('//')) {
      return null;
    }

    final path = parsed.path;
    if (path.isEmpty || !path.startsWith('/') || path.contains('//')) {
      return null;
    }

    final segments = path.split('/').skip(1).toList(growable: false);
    if (segments.any(
      (segment) => segment.isEmpty || segment == '.' || segment == '..',
    )) {
      return null;
    }
    if (!_isAllowedSegments(segments)) {
      return null;
    }

    return AppDeepLink._(
      Uri(
        path: '/${segments.join('/')}',
        query: parsed.query.isEmpty ? null : parsed.query,
        fragment: parsed.fragment.isEmpty ? null : parsed.fragment,
      ),
    );
  }

  /// Zwraca bezpieczny znormalizowany adres albo `null`.
  static String? normalize(String? rawValue) => parse(rawValue)?.uri.toString();

  /// Otwiera bezpieczny link w routerze aplikacji.
  ///
  /// Zwraca `false`, jeśli backend przesłał pusty albo nieznany link. Wywołujący
  /// powinien wtedy pokazać jawny komunikat, a nie kierować użytkownika na
  /// przypadkowy ekran zastępczy.
  static bool navigate(AppRouter router, String? rawValue) {
    final link = parse(rawValue);
    if (link == null) return false;
    unawaited(router.navigatePath(link.uri.toString()));
    return true;
  }

  static bool _isAllowedSegments(List<String> segments) {
    // Sam root (`/`) jest obsługiwany przez router aplikacji, ale nie jest
    // deep linkiem zasobu. Zakończ wcześniej, aby nie odwołać się do
    // `segments.first` na pustej liście i nie zamienić niepoprawnego adresu
    // w wyjątek parsera.
    if (segments.isEmpty) {
      return false;
    }
    if (segments.length == 1 && _knownTopLevel.contains(segments.single)) {
      return true;
    }
    if (segments.length == 2 &&
        _legacySections[segments[0]]?.contains(segments[1]) == true) {
      return true;
    }

    if (segments.first == 'me' &&
        segments.length == 2 &&
        _privateSections.contains(segments[1])) {
      return true;
    }

    if (segments.first == 'storage' &&
        segments.length == 2 &&
        segments[1] == 'files') {
      return false;
    }
    if (segments.length == 3 &&
        segments[0] == 'storage' &&
        segments[1] == 'files' &&
        _isId(segments[2])) {
      return true;
    }

    if (segments.first == 'chat' &&
        segments.length >= 3 &&
        segments[1] == 'conversations' &&
        _isId(segments[2])) {
      return segments.length == 3 ||
          (segments.length == 5 &&
              segments[3] == 'messages' &&
              _isId(segments[4]));
    }

    if (segments.length < 2 ||
        segments.first != 'workspaces' ||
        !_isId(segments[1])) {
      return false;
    }

    if (segments.length == 2) {
      return true;
    }

    final workspaceSection = segments[2];
    if (segments.length == 3 && _workspaceSections.contains(workspaceSection)) {
      return true;
    }
    if (segments.length == 4 &&
        workspaceSection == 'invitations' &&
        _isId(segments[3])) {
      return true;
    }
    if (segments.length == 4 &&
        workspaceSection == 'projects' &&
        _isId(segments[3])) {
      return true;
    }
    if (segments.length == 5 &&
        workspaceSection == 'wiki' &&
        segments[3] == 'pages' &&
        _isId(segments[4])) {
      return true;
    }
    if (segments.length == 5 &&
        workspaceSection == 'okr' &&
        (segments[3] == 'key-results' || segments[3] == 'objectives') &&
        _isId(segments[4])) {
      return true;
    }
    if (segments.length == 5 &&
        workspaceSection == 'projects' &&
        _isId(segments[3]) &&
        _projectSections.contains(segments[4])) {
      return true;
    }
    if (segments.length == 6 &&
        workspaceSection == 'projects' &&
        _isId(segments[3]) &&
        _projectSectionsWithResource.contains(segments[4]) &&
        _isId(segments[5])) {
      return true;
    }
    if (segments.length == 7 &&
        workspaceSection == 'projects' &&
        _isId(segments[3]) &&
        segments[4] == 'wiki' &&
        segments[5] == 'pages' &&
        _isId(segments[6])) {
      return true;
    }
    return false;
  }

  static bool _isId(String value) => RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  ).hasMatch(value);

  static const _knownTopLevel = <String>{
    'dashboard',
    'inventory',
    'orders',
    'bhp',
    'inne',
    'settings',
    'workspaces',
    'notifications',
    'chat',
  };
  static const _privateSections = <String>{'tasks', 'files'};
  static const _legacySections = <String, Set<String>>{
    'inventory': {'overview', 'stock', 'companies', 'archive'},
    'bhp': {'users', 'positions', 'equipment', 'operations', 'statistics'},
    'framework': {'components'},
  };
  static const _workspaceSections = <String>{
    'projects',
    'files',
    'wiki',
    'activity',
    'members',
    'settings',
    'invitations',
    'okr',
  };
  static const _projectSections = <String>{
    'overview',
    'tasks',
    'kanban',
    'whiteboards',
    'files',
    'wiki',
    'members',
    'settings',
    'automations',
    'corkboard',
    'dashboard',
  };
  static const _projectSectionsWithResource = <String>{
    'tasks',
    'whiteboards',
    'wiki',
    'files',
    'automations',
    'ai-reports',
  };
}
