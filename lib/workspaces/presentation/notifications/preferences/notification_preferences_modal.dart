import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/models/notification_preferences.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_digest_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_preferences_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/settings/chat_global_notification_settings_section.dart';
import 'package:ready_next/workspaces/presentation/chat/settings/cubit/chat_global_notification_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/preferences/cubit/notification_delivery_preferences_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/preferences/cubit/notification_digest_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/preferences/cubit/storage_notification_preference_cubit.dart';

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
    await AppModalHost.showDialog<void>(
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
        _DeliveryPreferencesSection(),
        Divider(height: Sizes.p32),
        _StoragePreferenceSection(),
        Divider(height: Sizes.p32),
        ChatGlobalNotificationSettingsSection(),
        Divider(height: Sizes.p32),
        _DigestSection(),
      ],
    ),
  );
}

class _DeliveryPreferencesSection extends StatelessWidget {
  const _DeliveryPreferencesSection();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        NotificationDeliveryPreferencesCubit,
        NotificationDeliveryPreferencesState
      >(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.notificationPreferencesDeliveryTitle,
              style: context.text.titleMedium,
            ),
            Gaps.h4,
            Text(
              context.l10n.notificationPreferencesDeliveryDescription,
              style: context.text.bodySmall,
            ),
            Gaps.h12,
            switch (state) {
              NotificationDeliveryPreferencesLoading() => const Center(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.p12),
                  child: CircularProgressIndicator(),
                ),
              ),
              NotificationDeliveryPreferencesFailure(:final error) =>
                _RetryMessage(
                  message: error.message,
                  onRetry: context
                      .read<NotificationDeliveryPreferencesCubit>()
                      .load,
                ),
              NotificationDeliveryPreferencesReady(:final preferences) =>
                Column(
                  children: [
                    if (state.error case final error?)
                      _InlineError(message: error.message),
                    ...NotificationDeliveryCategory.values.map(
                      (category) => _DeliveryCategoryRow(
                        category: category,
                        selected:
                            preferences.modes[category] ??
                            NotificationEmailDeliveryMode.none,
                        isSaving: state.isSaving,
                      ),
                    ),
                  ],
                ),
            },
          ],
        ),
      );
}

class _DeliveryCategoryRow extends StatelessWidget {
  const _DeliveryCategoryRow({
    required this.category,
    required this.selected,
    required this.isSaving,
  });

  final NotificationDeliveryCategory category;
  final NotificationEmailDeliveryMode selected;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Sizes.p8),
    child: Row(
      children: [
        Expanded(child: Text(_labelFor(context))),
        Gaps.w12,
        DropdownButton<NotificationEmailDeliveryMode>(
          value: selected,
          hint: Text(context.l10n.notificationPreferencesDeliveryMode),
          onChanged: isSaving
              ? null
              : (mode) {
                  if (mode == null) return;
                  unawaited(
                    context
                        .read<NotificationDeliveryPreferencesCubit>()
                        .updateMode(category, mode),
                  );
                },
          items: NotificationEmailDeliveryMode.values
              .map(
                (mode) => DropdownMenuItem(
                  value: mode,
                  child: Text(_modeLabel(context, mode)),
                ),
              )
              .toList(growable: false),
        ),
      ],
    ),
  );

  String _labelFor(BuildContext context) => switch (category) {
    NotificationDeliveryCategory.invitation =>
      context.l10n.notificationPreferencesCategoryInvitation,
    NotificationDeliveryCategory.membership =>
      context.l10n.notificationPreferencesCategoryMembership,
    NotificationDeliveryCategory.workspace =>
      context.l10n.notificationPreferencesCategoryWorkspace,
    NotificationDeliveryCategory.project =>
      context.l10n.notificationPreferencesCategoryProject,
    NotificationDeliveryCategory.task =>
      context.l10n.notificationPreferencesCategoryTask,
    NotificationDeliveryCategory.comment =>
      context.l10n.notificationPreferencesCategoryComment,
    NotificationDeliveryCategory.chat =>
      context.l10n.notificationPreferencesCategoryChat,
    NotificationDeliveryCategory.storage =>
      context.l10n.notificationPreferencesCategoryStorage,
    NotificationDeliveryCategory.system =>
      context.l10n.notificationPreferencesCategorySystem,
  };

  String _modeLabel(
    BuildContext context,
    NotificationEmailDeliveryMode mode,
  ) => switch (mode) {
    NotificationEmailDeliveryMode.none =>
      context.l10n.notificationPreferencesModeNone,
    NotificationEmailDeliveryMode.immediate =>
      context.l10n.notificationPreferencesModeImmediate,
    NotificationEmailDeliveryMode.dailyDigest =>
      context.l10n.notificationPreferencesModeDailyDigest,
    NotificationEmailDeliveryMode.digest =>
      context.l10n.notificationPreferencesModeDigest,
  };
}

class _StoragePreferenceSection extends StatelessWidget {
  const _StoragePreferenceSection();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        StorageNotificationPreferenceCubit,
        StorageNotificationPreferenceState
      >(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.notificationPreferencesStorageTitle,
              style: context.text.titleMedium,
            ),
            Gaps.h4,
            Text(
              context.l10n.notificationPreferencesStorageDescription,
              style: context.text.bodySmall,
            ),
            Gaps.h12,
            switch (state) {
              StorageNotificationPreferenceLoading() => const Center(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.p12),
                  child: CircularProgressIndicator(),
                ),
              ),
              StorageNotificationPreferenceFailure(:final error) =>
                _RetryMessage(
                  message: error.message,
                  onRetry: context
                      .read<StorageNotificationPreferenceCubit>()
                      .load,
                ),
              StorageNotificationPreferenceReady(:final preference) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.error case final error?)
                    _InlineError(message: error.message),
                  DropdownButton<StorageNotificationMode>(
                    value: preference.mode,
                    hint: Text(context.l10n.notificationPreferencesStorageMode),
                    onChanged: state.isSaving
                        ? null
                        : (mode) {
                            if (mode == null) return;
                            unawaited(
                              context
                                  .read<StorageNotificationPreferenceCubit>()
                                  .updateMode(mode),
                            );
                          },
                    items: StorageNotificationMode.values
                        .map(
                          (mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(_labelFor(context, mode)),
                          ),
                        )
                        .toList(growable: false),
                  ),
                  if (preference.isDefault)
                    Text(
                      context.l10n.notificationPreferencesStorageInherited,
                      style: context.text.bodySmall,
                    ),
                ],
              ),
            },
          ],
        ),
      );

  String _labelFor(BuildContext context, StorageNotificationMode mode) =>
      switch (mode) {
        StorageNotificationMode.immediate =>
          context.l10n.notificationPreferencesStorageImmediate,
        StorageNotificationMode.digest =>
          context.l10n.notificationPreferencesStorageDigest,
        StorageNotificationMode.mentionsOnly =>
          context.l10n.notificationPreferencesStorageMentionsOnly,
        StorageNotificationMode.disabled =>
          context.l10n.notificationPreferencesStorageDisabled,
      };
}

class _DigestSection extends StatelessWidget {
  const _DigestSection();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NotificationDigestCubit, NotificationDigestState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.notificationPreferencesDigestTitle,
                    style: context.text.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.workspacesRefresh,
                  onPressed: () => unawaited(
                    context.read<NotificationDigestCubit>().load(),
                  ),
                  icon: const Icon(Symbols.refresh_rounded),
                ),
              ],
            ),
            Text(
              context.l10n.notificationPreferencesDigestDescription,
              style: context.text.bodySmall,
            ),
            Gaps.h12,
            switch (state) {
              NotificationDigestLoading() => const Center(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.p12),
                  child: CircularProgressIndicator(),
                ),
              ),
              NotificationDigestFailure(:final error) => _RetryMessage(
                message: error.message,
                onRetry: context.read<NotificationDigestCubit>().load,
              ),
              NotificationDigestEmpty() => Text(
                context.l10n.notificationPreferencesDigestEmpty,
              ),
              NotificationDigestReady(:final digest) => Semantics(
                label: context.l10n.notificationPreferencesDigestSummary(
                  digest.groups.length,
                ),
                child: Column(
                  children: digest.groups
                      .map(
                        (group) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(group.latest.title),
                          subtitle: Text(
                            group.preview ?? group.latest.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            context.l10n.notificationPreferencesDigestCount(
                              group.count,
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            },
          ],
        ),
      );
}

class _RetryMessage extends StatelessWidget {
  const _RetryMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _InlineError(message: message),
      TextButton.icon(
        onPressed: onRetry,
        icon: const Icon(Symbols.refresh_rounded),
        label: Text(context.l10n.workspacesRetry),
      ),
    ],
  );
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p8),
      child: Text(
        message,
        style: context.text.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    ),
  );
}
