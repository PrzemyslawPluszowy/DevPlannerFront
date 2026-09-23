import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_conversation_notification_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
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
  Widget build(BuildContext context) => ChatSurfaceDialog(
    title: context.l10n.chatConversationNotificationSettingsTitle,
    leading: Icon(
      Symbols.notifications_rounded,
      color: context.chatTheme.focusRing,
    ),
    content: const _ChatConversationNotificationSettingsContent(),
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
          ChatConversationNotificationSettingsFailure() =>
            _ChatConversationNotificationRetry(
              message: context.l10n.chatActionFailureMessage,
              onRetry: context
                  .read<ChatConversationNotificationSettingsCubit>()
                  .load,
            ),
          ChatConversationNotificationSettingsRevoked() =>
            _ChatConversationNotificationMessage(
              message: context.l10n.chatActionFailureMessage,
            ),
          ChatConversationNotificationSettingsReady(:final setting) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.chatConversationNotificationSettingsDescription,
                style: context.text.bodySmall,
              ),
              Gaps.h12,
              if (state.error != null)
                _ChatConversationNotificationMessage(
                  message: context.l10n.chatActionFailureMessage,
                ),
              Builder(
                builder: (anchorContext) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const ValueKey('chat-notification-mode'),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    onTap: state.isSaving
                        ? null
                        : () => unawaited(() async {
                            final selected =
                                await AppContextMenu.select<
                                  ChatConversationNotificationMode
                                >(
                                  anchorContext,
                                  globalPosition: AppContextMenu.positionFor(
                                    anchorContext,
                                  ),
                                  options: [
                                    for (final mode
                                        in ChatConversationNotificationMode
                                            .values)
                                      AppContextMenuOption(
                                        value: mode,
                                        label: _label(context, mode),
                                        selected: setting.mode == mode,
                                      ),
                                  ],
                                );
                            if (selected != null && context.mounted) {
                              await context
                                  .read<
                                    ChatConversationNotificationSettingsCubit
                                  >()
                                  .updateMode(selected);
                            }
                          }()),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: context.chatTheme.composerSurface,
                        labelText:
                            context.l10n.chatConversationNotificationModeLabel,
                        labelStyle: context.chatTheme.metadataStyle.copyWith(
                          color: context.chatTheme.metadataText,
                        ),
                        suffixIcon: Icon(
                          Symbols.expand_more_rounded,
                          size: 20,
                          color: context.chatTheme.metadataText,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: context.chatTheme.separator,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: context.chatTheme.separator,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: context.chatTheme.focusRing,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(
                        _label(context, setting.mode),
                        style: context.chatTheme.contentStyle.copyWith(
                          color: context.chatTheme.incomingText,
                        ),
                      ),
                    ),
                  ),
                ),
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
        color: context.chatTheme.error,
      ),
    ),
  );
}
