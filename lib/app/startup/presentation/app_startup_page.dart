import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/modules/app_modules_catalog.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/router/auth_redirect_policy.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';

/// Ekran pośredni wyświetlany podczas startu aplikacji.
/// Automatycznie podejmuje decyzję o tym, do jakiego modułu skierować użytkownika.
class AppStartupPage extends StatefulWidget {
  /// Tworzy ekran startowy.
  const AppStartupPage({super.key});

  @override
  State<AppStartupPage> createState() => _AppStartupPageState();
}

class _AppStartupPageState extends State<AppStartupPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkSessionAndNavigate());
    });
  }

  Future<void> _checkSessionAndNavigate() async {
    final authCubit = context.read<AuthCubit>();
    var state = authCubit.state;

    if (state is AuthLoading) {
      await authCubit.stream.firstWhere(
        (s) => s is AuthAuthenticated || s is AuthUnauthenticated,
      );
      state = authCubit.state;
    }

    if (!mounted) {
      return;
    }

    if (state is AuthUnauthenticated) {
      final launchContext = context.read<HostLaunchContext>();
      await context.router.replacePath(
        buildLoginPath(redirectTo: launchContext.initialRoute),
      );
      return;
    }

    if (state is AuthAuthenticated) {
      final launchContext = context.read<HostLaunchContext>();
      final readyUserId = resolveReadyUserId(
        user: state.user,
        hostUserId: launchContext.userId,
      );

      final repository = context.read<DashboardPreferencesRepository>();
      final preferences = await repository.getPreferences(
        readyUserId: readyUserId,
      );

      if (!mounted) {
        return;
      }

      // Domyślne „Pulpit” nie jest świadomym żądaniem przekierowania. Pozwala
      // to zachować moduł wskazany przez hosta przy pierwszym uruchomieniu;
      // zapisany, nie-domyślny moduł nadal ma pierwszeństwo.
      final target =
          preferences.startupModule == DashboardStartupModule.dashboard
          ? launchContext.initialRoute
          : AppModulesCatalog.findByStartupModule(
                  preferences.startupModule,
                  state.user?.permissions ?? const <String>{},
                )?.routePath ??
                AppRoutePaths.dashboard;

      await context.router.replacePath(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox.square(
              dimension: Sizes.p28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            Gaps.h16,
            Text(
              context.l10n.frameworkLoadingDataTitle,
              textAlign: TextAlign.center,
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
