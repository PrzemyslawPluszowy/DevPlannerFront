import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_conversation_notification_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Rootowy modal polityki powiadomień pojedynczej rozmowy Chat.
///
/// Wybór nie zmienia URI i nie tworzy lokalnego `showDialog`, więc zachowuje
/// regułę overlay rootowego shellu oraz obsługę focusu i Escape.
abstract final class ChatConversationNotificationSettingsModal {
  /// Otwiera ustawienia wskazanej rozmowy nad globalnym shellem.
  static Future<void> show(
    BuildContext context, {
    required String conversationId,
  }) async {
    final repository = context.read<ChatNotificationSettingsRepository>();
    await DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => BlocProvider(
        create: (_) {
          final cubit = ChatConversationNotificationSettingsCubit(
            repository,
            conversationId,
          );
          unawaited(cubit.load());
          return cubit;
        },
        child: const _ChatConversationNotificationSettingsDialog(),
      ),
    );
  }
}

class _ChatConversationNotificationSettingsDialog extends StatelessWidget {
  const _ChatConversationNotificationSettingsDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Row(
      children: [
        const Icon(Symbols.notifications_rounded),
        Gaps.w8,
        Expanded(
          child: Text(context.l10n.chatConversationNotificationSettingsTitle),
        ),
      ],
    ),
    content: const SizedBox(
      width: 420,
      child: _ChatConversationNotificationSettingsContent(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).maybePop(),
        child: Text(context.l10n.frameworkClose),
      ),
    ],
  );
}

class _ChatConversationNotificationSettingsContent extends StatelessWidget {
  const _ChatConversationNotificationSettingsContent();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        ChatConversationNotificationSettingsCubit,
        ChatConversationNotificationSettingsState
      >(
        builder: (context, state) => switch (state) {
          ChatConversationNotificationSettingsLoading() => const Center(
            child: Padding(
              padding: EdgeInsets.all(Sizes.p12),
              child: CircularProgressIndicator(),
            ),
          ),
          ChatConversationNotificationSettingsFailure(:final error) =>
            _ChatConversationNotificationRetry(
              message: error.message,
              onRetry: context
                  .read<ChatConversationNotificationSettingsCubit>()
                  .load,
            ),
          ChatConversationNotificationSettingsRevoked(:final error) =>
            _ChatConversationNotificationMessage(message: error.message),
          ChatConversationNotificationSettingsReady(:final setting) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.chatConversationNotificationSettingsDescription,
                style: context.text.bodySmall,
              ),
              Gaps.h12,
              if (state.error case final error?)
                _ChatConversationNotificationMessage(message: error.message),
              DropdownButtonFormField<ChatConversationNotificationMode>(
                initialValue: setting.mode,
                decoration: InputDecoration(
                  labelText: context.l10n.chatConversationNotificationModeLabel,
                ),
                onChanged: state.isSaving
                    ? null
                    : (mode) {
                        if (mode == null) return;
                        unawaited(
                          context
                              .read<ChatConversationNotificationSettingsCubit>()
                              .updateMode(mode),
                        );
                      },
                items: ChatConversationNotificationMode.values
                    .map(
                      (mode) => DropdownMenuItem(
                        value: mode,
                        child: Text(_label(context, mode)),
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ),
        },
      );

  String _label(
    BuildContext context,
    ChatConversationNotificationMode mode,
  ) => switch (mode) {
    ChatConversationNotificationMode.all =>
      context.l10n.chatConversationNotificationModeAll,
    ChatConversationNotificationMode.mentionsOnly =>
      context.l10n.chatConversationNotificationModeMentionsOnly,
    ChatConversationNotificationMode.muted =>
      context.l10n.chatConversationNotificationModeMuted,
    ChatConversationNotificationMode.highOnly =>
      context.l10n.chatConversationNotificationModeHighOnly,
  };
}

class _ChatConversationNotificationRetry extends StatelessWidget {
  const _ChatConversationNotificationRetry({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _ChatConversationNotificationMessage(message: message),
      TextButton(
        onPressed: onRetry,
        child: Text(context.l10n.workspacesRetry),
      ),
    ],
  );
}

class _ChatConversationNotificationMessage extends StatelessWidget {
  const _ChatConversationNotificationMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Text(
      message,
      style: context.text.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    ),
  );
}
