import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_shell_metrics.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/shared/presentation/widgets/app_global_utility_bar.dart';

/// Lewa sekcja identyfikująca aktywny moduł bez poziomego overflow w compact.
class AppShellTopBarBreadcrumb extends StatelessWidget {
  const AppShellTopBarBreadcrumb({
    required this.router,
    required this.viewport,
    super.key,
  });

  final AppRouter router;
  final AppShellViewport viewport;

  @override
  Widget build(BuildContext context) {
    if (viewport != AppShellViewport.compact) {
      return AppGlobalBreadcrumb(router: router);
    }

    return Tooltip(
      message: context.l10n.appShellBrandName,
      child: Semantics(
        button: true,
        label: context.l10n.appShellBrandName,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => unawaited(router.navigatePath(AppRoutePaths.dashboard)),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(AppIcons.workspaces, size: 18),
          ),
        ),
      ),
    );
  }
}
