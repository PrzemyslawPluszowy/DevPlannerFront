import 'dart:async';

import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/app/theme/shared_preferences_theme_preference_store.dart';
import 'package:devplanner/app/theme/theme_preference.dart';
import 'package:devplanner/app/theme/theme_preference_cubit.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/bootstrap/host_launch_context.dart';
import 'package:devplanner/foundation/http/http.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/me/me.dart';
import 'package:devplanner/workspaces/data/standalone/devplanner_standalone_runtime.dart';
import 'package:devplanner/workspaces/data/standalone/devplanner_storage_composition.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Główny korzeń kompozycji aplikacji DevPlanner w trybie autonomicznym (standalone).
///
/// Zarządza routingiem, motywem wizualnym oraz lokalizacją aplikacji.
class DevPlannerApp extends StatefulWidget {
  const DevPlannerApp({
    required this.launchContext,
    this.auth,
    this.adminUsers,
    this.meGateway,
    this.httpTransport,
    this.storageRepository,
    this.themePreferenceStore,
    super.key,
  });

  /// Kontekst startowy aplikacji (np. początkowa trasa).
  final HostLaunchContext launchContext;

  /// Opcjonalna kompozycja uwierzytelniania i sesji.
  final AuthComposition? auth;

  /// Opcjonalna kompozycja administracji użytkownikami.
  final AdminUsersComposition? adminUsers;

  /// Opcjonalna brama profilu i sesji użytkownika (/me).
  final MeGateway? meGateway;

  /// Opcjonalny transport sesji HTTP dla zapytań API.
  final DevPlannerHttpTransport? httpTransport;

  /// Opcjonalne repozytorium Files złożone jawnie przez hosta aplikacji.
  final StorageRepository? storageRepository;

  /// Opcjonalny port preferencji motywu, przekazywany przez testy lub hosta.
  final ThemePreferenceStore? themePreferenceStore;

  @override
  State<DevPlannerApp> createState() => _DevPlannerAppState();
}

class _DevPlannerAppState extends State<DevPlannerApp> {
  late final DevPlannerRouter _router;
  late final DevPlannerStorageComposition _storage;
  late final ThemePreferenceCubit _themePreferenceCubit;
  DevPlannerStandaloneRuntime? _standaloneRuntime;
  final MaterialTheme _theme = MaterialTheme.crm();

  @override
  void initState() {
    super.initState();
    _storage = DevPlannerStorageComposition.resolve(
      transport: widget.httpTransport,
      explicitRepository: widget.storageRepository,
    );
    _router = DevPlannerRouter(
      initialLocation: widget.launchContext.initialRoute,
      auth: widget.auth,
      adminUsers: widget.adminUsers,
      meGateway: widget.meGateway,
      httpTransport: widget.httpTransport,
      storageRepository: _storage.repository,
    );
    _themePreferenceCubit = ThemePreferenceCubit(
      widget.themePreferenceStore ?? SharedPreferencesThemePreferenceStore(),
    );
    unawaited(_themePreferenceCubit.load());
    final auth = widget.auth;
    final transport = widget.httpTransport;
    if (auth != null && transport != null) {
      // Ticket i finalizacja idą przez sesyjny transport API (cookie+CSRF na
      // Web/BFF, token wyłącznie na desktopie). Osobny transport PUT dostaje
      // tylko krótkotrwały presigned URL, nigdy cookie ani access token.
      _standaloneRuntime = DevPlannerStandaloneRuntime(
        auth: auth,
        transport: transport,
        storageRepository: _storage.repository,
        attachmentUploadTransport: _storage.uploadTransport,
      );
    }
  }

  @override
  void dispose() {
    unawaited(_standaloneRuntime?.dispose() ?? Future<void>.value());
    unawaited(_themePreferenceCubit.close());
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _themePreferenceCubit,
    child: BlocBuilder<ThemePreferenceCubit, DevPlannerThemePreference>(
      builder: (context, preference) => MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('pl'), Locale('en')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
        theme: _theme.light(),
        darkTheme: _theme.dark(),
        themeMode: preference.themeMode,
        routerConfig: _router.config,
        builder: (context, child) {
          final content = child ?? const SizedBox.shrink();
          final session = widget.auth?.session;
          if (session == null) {
            return _buildPanelsHost(content);
          }
          return AnimatedBuilder(
            animation: session,
            builder: (context, _) => _buildPanelsHost(content),
          );
        },
      ),
    ),
  );

  Widget _buildPanelsHost(Widget child) {
    final runtime = _standaloneRuntime;
    return DevPlannerGlobalPanelsHost(
      navigation: DevPlannerNavigation(_router.config),
      chat: runtime?.chatComposition,
      notifications: runtime?.notificationsComposition,
      authSession: widget.auth?.session,
      child: child,
    );
  }
}
