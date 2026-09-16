import 'package:envied/envied.dart';
import 'package:ready_next/core/config/app_api_module.dart';

part 'app_env.g.dart';

/// Konfiguracja środowiskowa aplikacji.
///
/// Wartości są generowane przez `envied` na podstawie pliku `.env`
/// oraz mogą być nadpisywane w trakcie kompilacji przez `--dart-define`.
@Envied(path: '.env')
abstract final class AppEnv {
  /// Bazowy URL API modułu inwentaryzacji.
  @EnviedField(varName: 'INVENTORY_API_BASE_URL')
  static const String _inventoryApiBaseUrlFromFile =
      _AppEnv._inventoryApiBaseUrlFromFile;

  static const String inventoryApiBaseUrl = String.fromEnvironment(
    'INVENTORY_API_BASE_URL',
    defaultValue: _inventoryApiBaseUrlFromFile,
  );

  /// Bazowy URL API modułu BHP.
  @EnviedField(varName: 'BHP_API_BASE_URL', defaultValue: '')
  static const String _bhpApiBaseUrlFromFile = _AppEnv._bhpApiBaseUrlFromFile;

  static const String bhpApiBaseUrl = String.fromEnvironment(
    'BHP_API_BASE_URL',
    defaultValue: _bhpApiBaseUrlFromFile,
  );

  /// Bazowy URL API centralnego uwierzytelnienia Veloryn Core.
  @EnviedField(varName: 'CORE_API_BASE_URL')
  static const String _coreApiBaseUrlFromFile = _AppEnv._coreApiBaseUrlFromFile;

  /// Bazowy URL API dedykowanego modułu Veloryn Workspaces.
  @EnviedField(
    varName: 'WORKSPACES_API_BASE_URL',
    defaultValue: 'http://localhost:5072',
  )
  static const String _workspacesApiBaseUrlFromFile =
      _AppEnv._workspacesApiBaseUrlFromFile;

  /// Flaga przełączająca API Core i Workspaces na środowisko lokalne.
  @EnviedField(varName: 'USE_LOCAL_BACKEND', defaultValue: 'false')
  static const String _useLocalBackendFromFile =
      _AppEnv._useLocalBackendFromFile;

  /// Lokalny adres Core (domyślnie http://localhost:8080).
  @EnviedField(
    varName: 'LOCAL_CORE_API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  )
  static const String _localCoreApiBaseUrlFromFile =
      _AppEnv._localCoreApiBaseUrlFromFile;

  /// Lokalny adres Workspaces (domyślnie http://localhost:5072).
  @EnviedField(
    varName: 'LOCAL_WORKSPACES_API_BASE_URL',
    defaultValue: 'http://localhost:5072',
  )
  static const String _localWorkspacesApiBaseUrlFromFile =
      _AppEnv._localWorkspacesApiBaseUrlFromFile;

  /// Czy aplikacja ma domyślnie używać lokalnego backendu Core i Workspaces.
  static const bool useLocalBackend =
      bool.fromEnvironment('USE_LOCAL_BACKEND') ||
      _useLocalBackendFromFile == 'true';

  /// Lokalny adres URL Core.
  static const String localCoreApiBaseUrl = String.fromEnvironment(
    'LOCAL_CORE_API_BASE_URL',
    defaultValue: _localCoreApiBaseUrlFromFile,
  );

  /// Lokalny adres URL Workspaces.
  static const String localWorkspacesApiBaseUrl = String.fromEnvironment(
    'LOCAL_WORKSPACES_API_BASE_URL',
    defaultValue: _localWorkspacesApiBaseUrlFromFile,
  );

  /// Zwraca właściwy adres API Core (lokalny przy włączonej fladze lub produkcyjny).
  static const String coreApiBaseUrl = String.fromEnvironment(
    'CORE_API_BASE_URL',
    defaultValue:
        useLocalBackend ? localCoreApiBaseUrl : _coreApiBaseUrlFromFile,
  );

  /// Zwraca właściwy adres API Workspaces (lokalny przy włączonej fladze lub produkcyjny).
  static const String workspacesApiBaseUrl = String.fromEnvironment(
    'WORKSPACES_API_BASE_URL',
    defaultValue:
        useLocalBackend
            ? localWorkspacesApiBaseUrl
            : _workspacesApiBaseUrlFromFile,
  );

  /// DSN dla Sentry. Pusty string oznacza wyłączoną integrację.
  @EnviedField(varName: 'SENTRY_DSN', defaultValue: '')
  static const String _sentryDsnFromFile = _AppEnv._sentryDsnFromFile;

  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: _sentryDsnFromFile,
  );

  /// Zwraca bazowy URL API dla wskazanego modułu.
  ///
  /// Auth korzysta z centralnego backendu Veloryn Core.
  /// Workspaces korzysta z dedykowanego backendu Veloryn Workspaces.
  static String apiBaseUrlFor(AppApiModule module) {
    return switch (module) {
      .inventory => inventoryApiBaseUrl,
      .auth => coreApiBaseUrl,
      .bhp =>
        bhpApiBaseUrl.trim().isEmpty ? inventoryApiBaseUrl : bhpApiBaseUrl,
      .workspaces => workspacesApiBaseUrl,
    };
  }
}
