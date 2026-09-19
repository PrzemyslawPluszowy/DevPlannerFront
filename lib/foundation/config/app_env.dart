import 'package:devplanner/foundation/config/app_api_module.dart';

/// Runtime configuration for the standalone DevPlanner application.
///
/// There is deliberately one API origin. It is supplied at build time with
/// `DEVPLANNER_API_BASE_URL`; the local default is safe for development and
/// prevents a fresh checkout from contacting a legacy environment. Ten
/// kontrakt reprezentuje wyłącznie standalone origin.
abstract final class AppEnv {
  static const apiBaseUrl = String.fromEnvironment(
    'DEVPLANNER_API_BASE_URL',
    defaultValue: 'http://localhost:5072',
  );

  /// Optional diagnostics destination. It is empty unless explicitly set.
  static const sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// Resolves every logical client to the one standalone backend origin.
  static String apiBaseUrlFor(AppApiModule module) => apiBaseUrl;

  /// Zwraca bezwzględny URL do awatara użytkownika o podanym identyfikatorze UserId.
  static String userAvatarUrl(String userId) {
    final cleanId = userId.trim();
    if (cleanId.isEmpty) return '';
    final base = apiBaseUrl.endsWith('/') ? apiBaseUrl : '$apiBaseUrl/';
    return Uri.parse(base).resolve('api/v1/users/$cleanId/avatar').toString();
  }

  /// Zwraca bezwzględny URL do awatara bieżącego zalogowanego użytkownika.
  static String currentUserAvatarUrl() {
    final base = apiBaseUrl.endsWith('/') ? apiBaseUrl : '$apiBaseUrl/';
    return Uri.parse(base).resolve('api/v1/me/avatar').toString();
  }
}
