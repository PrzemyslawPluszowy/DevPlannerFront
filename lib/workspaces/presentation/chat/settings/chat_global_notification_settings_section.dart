import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_global_notification_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Sekcja globalnych kanałów Chat do osadzenia w preferencjach powiadomień.
///
/// Renderuje wyłącznie stan własnego cubita. Nie zna transportu ani endpointów,
/// dlatego może pozostawać małą, niezależną częścią wspólnego modala.
class ChatGlobalNotificationSettingsSection extends StatelessWidget {
  /// Tworzy sekcję kanałów globalnych Chat.
  const ChatGlobalNotificationSettingsSection({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        ChatGlobalNotificationSettingsCubit,
        ChatGlobalNotificationSettingsState
      >(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.chatNotificationSettingsGlobalTitle,
              style: context.chatTheme.authorStyle.copyWith(
                color: context.chatTheme.incomingText,
                fontSize: 14,
              ),
            ),
            Gaps.h4,
            Text(
              context.l10n.chatNotificationSettingsGlobalDescription,
              style: context.chatTheme.metadataStyle.copyWith(
                color: context.chatTheme.metadataText,
              ),
            ),
            Gaps.h12,
            switch (state) {
              ChatGlobalNotificationSettingsLoading() => const Center(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.p12),
                  child: CircularProgressIndicator(),
                ),
              ),
              ChatGlobalNotificationSettingsFailure() =>
                _ChatGlobalNotificationSettingsRetry(
                  message: context.l10n.chatActionFailureMessage,
                  onRetry: context
                      .read<ChatGlobalNotificationSettingsCubit>()
                      .load,
                ),
              ChatGlobalNotificationSettingsRevoked() =>
                _ChatGlobalNotificationSettingsMessage(
                  message: context.l10n.chatActionFailureMessage,
                ),
              ChatGlobalNotificationSettingsReady(:final settings) => Column(
                children: [
                  if (state.error != null)
                    _ChatGlobalNotificationSettingsMessage(
                      message: context.l10n.chatActionFailureMessage,
                    ),
                  _ChatGlobalNotificationChannelTile(
                    channel: ChatNotificationChannel.inApp,
                    enabled: settings.inAppEnabled,
                    isSaving: state.isSaving,
                  ),
                  _ChatGlobalNotificationChannelTile(
                    channel: ChatNotificationChannel.email,
                    enabled: settings.emailEnabled,
                    isSaving: state.isSaving,
                  ),
                  _ChatGlobalNotificationChannelTile(
                    channel: ChatNotificationChannel.push,
                    enabled: settings.pushEnabled,
                    isSaving: state.isSaving,
                  ),
                  _ChatGlobalNotificationChannelTile(
                    channel: ChatNotificationChannel.digest,
                    enabled: settings.digestEnabled,
                    isSaving: state.isSaving,
                  ),
                ],
              ),
            },
          ],
        ),
      );
}

class _ChatGlobalNotificationChannelTile extends StatelessWidget {
  const _ChatGlobalNotificationChannelTile({
    required this.channel,
    required this.enabled,
    required this.isSaving,
  });

  final ChatNotificationChannel channel;
  final bool enabled;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: chat.listSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: chat.separator.withValues(alpha: .7)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p12,
            vertical: Sizes.p4,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _title(context),
                  style: chat.contentStyle.copyWith(
                    color: chat.incomingText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ChatToggle(
                value: enabled,
                label: _title(context),
                onChanged: isSaving
                    ? null
                    : (value) => unawaited(
                        context
                            .read<ChatGlobalNotificationSettingsCubit>()
                            .updateChannel(channel, value),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _title(BuildContext context) => switch (channel) {
    ChatNotificationChannel.inApp =>
      context.l10n.chatNotificationSettingsChannelInApp,
    ChatNotificationChannel.email =>
      context.l10n.chatNotificationSettingsChannelEmail,
    ChatNotificationChannel.push =>
      context.l10n.chatNotificationSettingsChannelPush,
    ChatNotificationChannel.digest =>
      context.l10n.chatNotificationSettingsChannelDigest,
  };
}

class _ChatGlobalNotificationSettingsRetry extends StatelessWidget {
  const _ChatGlobalNotificationSettingsRetry({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _ChatGlobalNotificationSettingsMessage(message: message),
      TextButton(
        onPressed: onRetry,
        child: Text(context.l10n.workspacesRetry),
      ),
    ],
  );
}

class _ChatGlobalNotificationSettingsMessage extends StatelessWidget {
  const _ChatGlobalNotificationSettingsMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p8),
      child: Text(
        message,
        style: context.text.bodySmall?.copyWith(
          color: context.chatTheme.error,
        ),
      ),
    ),
  );
}
