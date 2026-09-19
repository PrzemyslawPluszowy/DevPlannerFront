import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/notification_digest_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/notification_preferences_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/chat_global_notification_settings_section.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_global_notification_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/notifications/preferences/cubit/notification_delivery_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/notifications/preferences/cubit/notification_digest_cubit.dart';
import 'package:devplanner/workspaces/presentation/notifications/preferences/cubit/storage_notification_preference_cubit.dart';
import 'package:devplanner/workspaces/presentation/notifications/preferences/notification_preferences_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Rootowy ekran osobistych preferencji powiadomień i read-only digestu.
///
/// Porty są odczytywane przed wejściem do root navigatora, dlatego modal nie
/// zależy od przypadkowego zasięgu kontekstu aktualnej trasy.
abstract final class AppNotificationPreferencesModal {
  /// Otwiera ustawienia nad globalnym shellem bez zmiany URI bieżącej strony.
  static Future<void> show(BuildContext context) async {
    final preferencesRepository = context
        .read<NotificationPreferencesRepository>();
    final digestRepository = context.read<NotificationDigestRepository>();
    final chatSettingsRepository = context
        .read<ChatNotificationSettingsRepository>();
    await DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) {
              final cubit = NotificationDeliveryPreferencesCubit(
                preferencesRepository,
              );
              unawaited(cubit.load());
              return cubit;
            },
          ),
          BlocProvider(
            create: (_) {
              final cubit = StorageNotificationPreferenceCubit(
                preferencesRepository,
              );
              unawaited(cubit.load());
              return cubit;
            },
          ),
          BlocProvider(
            create: (_) {
              final cubit = NotificationDigestCubit(digestRepository);
              unawaited(cubit.load());
              return cubit;
            },
          ),
          BlocProvider(
            create: (_) {
              final cubit = ChatGlobalNotificationSettingsCubit(
                chatSettingsRepository,
              );
              unawaited(cubit.load());
              return cubit;
            },
          ),
        ],
        child: const _NotificationPreferencesDialog(),
      ),
    );
  }
}

class _NotificationPreferencesDialog extends StatelessWidget {
  const _NotificationPreferencesDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Row(
      children: [
        const Icon(Symbols.notifications_rounded),
        Gaps.w8,
        Expanded(child: Text(context.l10n.notificationPreferencesTitle)),
      ],
    ),
    content: const SizedBox(
      width: 620,
      child: _NotificationPreferencesContent(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).maybePop(),
        child: Text(context.l10n.frameworkClose),
      ),
    ],
  );
}

class _NotificationPreferencesContent extends StatelessWidget {
  const _NotificationPreferencesContent();

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NotificationDeliveryPreferencesSection(),
        Divider(height: Sizes.p32),
        StorageNotificationPreferencesSection(),
        Divider(height: Sizes.p32),
        ChatGlobalNotificationSettingsSection(),
        Divider(height: Sizes.p32),
        NotificationDigestSection(),
      ],
    ),
  );
}
