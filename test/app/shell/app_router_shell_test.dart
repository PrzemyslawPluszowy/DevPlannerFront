import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_global_shell.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/auth/auth_session_storage.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/settings/application/current_user_avatar_cubit.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';

import 'support/shell_test_dependencies.dart';

/// Host prawdziwego [AppRouter] z minimalnymi zależnościami prywatnego shellu.
class _AppRouterShellHarness extends StatelessWidget {
  const _AppRouterShellHarness({
    required this.router,
    required this.authCubit,
    required this.settingsCubit,
    required this.avatarCubit,
  });

  final AppRouter router;
  final AuthCubit authCubit;
  final LocalSettingsCubit settingsCubit;
  final CurrentUserAvatarCubit avatarCubit;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: authCubit),
      BlocProvider.value(value: settingsCubit),
      BlocProvider.value(value: avatarCubit),
    ],
    child: MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(
          value: authCubit.authRepository,
        ),
        RepositoryProvider<AuthSessionStorage>.value(
          value: ShellTestAuthSessionStorage(),
        ),
        RepositoryProvider<HostLaunchContext>.value(
          value: const HostLaunchContext(
            initialRoute: '/orders',
            userId: '7',
            userDisplayName: 'Test User',
          ),
        ),
        RepositoryProvider<DashboardPreferencesRepository>.value(
          value: ShellTestDashboardPreferencesRepository(),
        ),
        RepositoryProvider<StorageRepository>.value(
          value: ShellTestAvatarStorageRepository(),
        ),
      ],
      child: ListenableProvider<AppRouter>.value(
        value: router,
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router.config,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('rzeczywisty AppRouter montuje shell tylko dla tras prywatnych', (
    tester,
  ) async {
    final cases = [
      (
        location: '/orders?filter=due',
        authenticated: true,
        state: const AuthAuthenticated(
          user: AuthUser(userId: 7, login: 'tester', displayName: 'Test User'),
        ),
        hasShell: true,
      ),
      (
        location: '/login',
        authenticated: false,
        state: const AuthUnauthenticated(),
        hasShell: false,
      ),
      (
        location: '/',
        authenticated: false,
        state: const AuthUnauthenticated(),
        hasShell: false,
      ),
      (
        location: '/storage/public/share-token',
        authenticated: true,
        state: const AuthAuthenticated(
          user: AuthUser(userId: 7, login: 'tester', displayName: 'Test User'),
        ),
        hasShell: false,
      ),
    ];

    for (final scenario in cases) {
      final authRepository = ShellTestAuthRepository(
        authenticated: scenario.authenticated,
      );
      final authCubit = AuthCubit(authRepository: authRepository)
        ..emit(scenario.state);
      final settingsCubit = LocalSettingsCubit(
        repository: ShellTestSettingsRepository(),
      );
      final avatarCubit = ShellTestDependencies.createAvatarCubit();
      final router = ShellTestDependencies.createRouter(
        authRepository: authRepository,
        initialLocation: scenario.location,
      );
      await tester.pumpWidget(
        _AppRouterShellHarness(
          router: router,
          authCubit: authCubit,
          settingsCubit: settingsCubit,
          avatarCubit: avatarCubit,
        ),
      );
      await tester.pump();

      expect(
        find.byType(AppGlobalShell),
        scenario.hasShell ? findsOneWidget : findsNothing,
        reason: scenario.location,
      );

      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
      await avatarCubit.close();
      await settingsCubit.close();
      await authCubit.close();
    }
  });
}
