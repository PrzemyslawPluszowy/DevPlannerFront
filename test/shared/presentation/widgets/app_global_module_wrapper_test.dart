import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_global_shell.dart';
import 'package:ready_next/app/shell/app_shell_metrics.dart';
import 'package:ready_next/app/shell/top_bar/top_bar_export.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/settings/application/current_user_avatar_cubit.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/shared/presentation/widgets/app_global_module_rail.dart';

import '../../../app/shell/support/shell_test_dependencies.dart';

/// Host rzeczywistego shellu używany przez snapshoty geometrii chrome'u.
class _ShellChromeHarness extends StatefulWidget {
  const _ShellChromeHarness({required this.brightness});

  final Brightness brightness;

  @override
  State<_ShellChromeHarness> createState() => _ShellChromeHarnessState();
}

class _ShellChromeHarnessState extends State<_ShellChromeHarness> {
  late final AuthCubit _authCubit;
  late final LocalSettingsCubit _settingsCubit;
  late final CurrentUserAvatarCubit _currentUserAvatarCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit(authRepository: ShellTestAuthRepository())
      ..emit(
        const AuthAuthenticated(
          user: AuthUser(
            userId: 7,
            login: 'tester',
            displayName: 'Test User',
          ),
        ),
      );
    _settingsCubit = LocalSettingsCubit(
      repository: ShellTestSettingsRepository(),
    );
    _currentUserAvatarCubit = ShellTestDependencies.createAvatarCubit();
    _appRouter = ShellTestDependencies.createRouter();
  }

  @override
  void dispose() {
    unawaited(_authCubit.close());
    unawaited(_settingsCubit.close());
    unawaited(_currentUserAvatarCubit.close());
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: widget.brightness,
        colorSchemeSeed: const Color(0xff6366f1),
        extensions: const [AppShellMetrics.standard()],
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authCubit),
          BlocProvider.value(value: _settingsCubit),
          BlocProvider.value(value: _currentUserAvatarCubit),
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>.value(
              value: ShellTestAuthRepository(),
            ),
            RepositoryProvider<HostLaunchContext>.value(
              value: const HostLaunchContext(
                initialRoute: '/dashboard',
                userId: '7',
                userDisplayName: 'Test User',
              ),
            ),
            RepositoryProvider<DashboardPreferencesRepository>.value(
              value: ShellTestDashboardPreferencesRepository(),
            ),
          ],
          child: AppGlobalShell(
            appRouter: _appRouter,
            child: const ColoredBox(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('rail pokazuje zwijany przycisk modułów', (tester) async {
    final authCubit = AuthCubit(authRepository: ShellTestAuthRepository())
      ..emit(
        const AuthAuthenticated(
          user: AuthUser(
            userId: 7,
            login: 'tester',
            displayName: 'Test User',
          ),
        ),
      );
    final settingsCubit = LocalSettingsCubit(
      repository: ShellTestSettingsRepository(),
    );
    final avatarCubit = ShellTestDependencies.createAvatarCubit();
    addTearDown(authCubit.close);
    addTearDown(settingsCubit.close);
    addTearDown(avatarCubit.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authCubit),
            BlocProvider.value(value: settingsCubit),
            BlocProvider.value(value: avatarCubit),
          ],
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<AuthRepository>.value(
                value: ShellTestAuthRepository(),
              ),
              RepositoryProvider<HostLaunchContext>.value(
                value: const HostLaunchContext(
                  initialRoute: '/dashboard',
                  userId: '7',
                  userDisplayName: 'Test User',
                ),
              ),
              RepositoryProvider<DashboardPreferencesRepository>.value(
                value: ShellTestDashboardPreferencesRepository(),
              ),
            ],
            child: AppGlobalShell(
              appRouter: ShellTestDependencies.createRouter(),
              child: const ColoredBox(color: Colors.white),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final menuButton = find.byIcon(Icons.menu_rounded);
    expect(menuButton, findsOneWidget);
  });

  testWidgets('rozwinięty rail zachodzi nad treść bez overflow', (
    tester,
  ) async {
    final authCubit = AuthCubit(authRepository: ShellTestAuthRepository())
      ..emit(
        const AuthAuthenticated(
          user: AuthUser(
            userId: 7,
            login: 'tester',
            displayName: 'Test User',
          ),
        ),
      );
    final settingsCubit = LocalSettingsCubit(
      repository: ShellTestSettingsRepository(),
    );
    final avatarCubit = ShellTestDependencies.createAvatarCubit();
    addTearDown(authCubit.close);
    addTearDown(settingsCubit.close);
    addTearDown(avatarCubit.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authCubit),
            BlocProvider.value(value: settingsCubit),
            BlocProvider.value(value: avatarCubit),
          ],
          child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<AuthRepository>.value(
                value: ShellTestAuthRepository(),
              ),
              RepositoryProvider<HostLaunchContext>.value(
                value: const HostLaunchContext(
                  initialRoute: '/dashboard',
                  userId: '7',
                  userDisplayName: 'Test User',
                ),
              ),
              RepositoryProvider<DashboardPreferencesRepository>.value(
                value: ShellTestDashboardPreferencesRepository(),
              ),
            ],
            child: AppGlobalShell(
              appRouter: ShellTestDependencies.createRouter(),
              child: const ColoredBox(color: Colors.white),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    expect(
      settingsCubit.state.sideMenuCollapsed,
      containsPair(
        'global.moduleRail:7',
        false,
      ),
    );
  });

  for (final snapshot in [
    (
      name: 'desktop jasny zwinięty',
      brightness: Brightness.light,
      expand: false,
    ),
    (
      name: 'desktop ciemny rozwinięty',
      brightness: Brightness.dark,
      expand: true,
    ),
    (
      name: 'compact jasny zwinięty',
      brightness: Brightness.light,
      expand: false,
    ),
    (
      name: 'compact ciemny rozwinięty',
      brightness: Brightness.dark,
      expand: true,
    ),
  ]) {
    testWidgets('snapshot geometrii shellu: ${snapshot.name}', (tester) async {
      final isCompact = snapshot.name.startsWith('compact');
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(isCompact ? 390 : 1280, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _ShellChromeHarness(brightness: snapshot.brightness),
      );
      await tester.pumpAndSettle();
      final initialTopBarRect = tester.getRect(
        find.byKey(AppShellMetrics.topBarSlotKey),
      );
      final initialContentRect = tester.getRect(
        find.byKey(AppShellMetrics.routedContentKey),
      );
      if (snapshot.expand) {
        await tester.tap(find.byIcon(Icons.menu_rounded));
        await tester.pumpAndSettle();
      }

      final metrics = AppShellMetrics.of(
        tester.element(find.byKey(AppShellMetrics.topBarSlotKey)),
      );
      final topBarRect = tester.getRect(
        find.byKey(AppShellMetrics.topBarSlotKey),
      );
      final railRect = tester.getRect(find.byType(AppGlobalModuleRail));
      final contentRect = tester.getRect(
        find.byKey(AppShellMetrics.routedContentKey),
      );
      expect(topBarRect, initialTopBarRect);
      expect(contentRect, initialContentRect);
      expect(railRect.top, topBarRect.bottom);
      expect(contentRect.left, metrics.collapsedRailWidth);
      expect(
        railRect.width,
        snapshot.expand
            ? metrics.expandedRailWidth
            : metrics.collapsedRailWidth,
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final scenario in [
    (width: 599.0, expected: AppShellViewport.compact),
    (width: 600.0, expected: AppShellViewport.medium),
    (width: 601.0, expected: AppShellViewport.medium),
    (width: 1023.0, expected: AppShellViewport.medium),
    (width: 1024.0, expected: AppShellViewport.wide),
    (width: 1025.0, expected: AppShellViewport.wide),
  ]) {
    testWidgets(
      'AppGlobalShell renderuje ${scenario.expected.name} dla viewportu ${scenario.width}',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(scenario.width, 800);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          const _ShellChromeHarness(brightness: Brightness.light),
        );
        await tester.pumpAndSettle();

        final breadcrumb = tester.widget<AppShellTopBarBreadcrumb>(
          find.byType(AppShellTopBarBreadcrumb),
        );
        expect(breadcrumb.viewport, scenario.expected);
        expect(
          tester.getRect(find.byKey(AppShellMetrics.routedContentKey)).top,
          tester.getRect(find.byKey(AppShellMetrics.topBarSlotKey)).bottom,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
