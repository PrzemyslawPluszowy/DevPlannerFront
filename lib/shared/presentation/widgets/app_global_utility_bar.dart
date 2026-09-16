import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/modules/app_modules_catalog.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_shell_metrics.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/chat_drawer.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/unread_notifications_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/global_notifications_page.dart';

part 'app_global_utility_bar_parts.dart';

/// Globalny, niezależny od modułu pasek akcji aplikacji.
///
/// Pasek zna wyłącznie kontrakt domenowy licznika powiadomień; nie wykonuje
/// wywołań Dio ani nie zawiera logiki transportowej. Czat pozostaje wejściem
/// routingowym do osobnego modułu.
class AppGlobalUtilityBar extends StatelessWidget {
  /// Tworzy globalny pasek utility bar.
  const AppGlobalUtilityBar({required this.router, super.key});

  /// Router aplikacji potrzebny wyłącznie do nawigacji po kliknięciu.
  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<NotificationsRepository?>();
    final chatRepository = context.read<ChatRepository?>();
    if (repository == null) {
      return _buildBar(context, null, chatRepository, null);
    }

    return BlocProvider(
      create: (context) {
        final cubit = UnreadNotificationsCubit(repository);
        unawaited(cubit.load());
        return cubit;
      },
      child: BlocBuilder<UnreadNotificationsCubit, int?>(
        builder: (context, count) =>
            _buildBar(context, count, chatRepository, repository),
      ),
    );
  }

  Widget _buildBar(
    BuildContext context,
    int? count,
    ChatRepository? chatRepository,
    NotificationsRepository? repository,
  ) {
    final metrics = AppShellMetrics.of(context);
    return ListenableBuilder(
      listenable: router,
      builder: (context, _) => Material(
        color: Colors.transparent,
        child: SizedBox(
          height: metrics.topBarHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.topBarHorizontalInset,
            ),
            child: Row(
              children: [
                AppGlobalBreadcrumb(router: router),
                const Spacer(),
                AppGlobalUtilityActions(
                  router: router,
                  count: count,
                  repository: repository,
                  chatRepository: chatRepository,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
