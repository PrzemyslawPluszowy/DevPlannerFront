import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_menu_components.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_presets.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_toggle.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Zawartość edytowalnej karty statusu; zapis pozostaje po stronie właściciela.
final class ChatStatusMenuCard extends StatelessWidget {
  const ChatStatusMenuCard({
    required this.current,
    required this.textController,
    required this.saving,
    required this.loadFailed,
    required this.isDnd,
    required this.emoji,
    required this.preset,
    required this.durationChoice,
    required this.failureMessage,
    required this.onPickEmoji,
    required this.onRetry,
    required this.onPreset,
    required this.onDuration,
    required this.onDnd,
    required this.onClear,
    required this.onSave,
    this.displayName,
    this.login,
    this.loading = false,
    super.key,
  });

  final ChatUserStatus? current;
  final TextEditingController textController;
  final bool loading;
  final bool loadFailed;
  final bool saving;
  final bool isDnd;
  final String? emoji;
  final ChatStatusPreset? preset;
  final ChatStatusDurationOption? durationChoice;
  final String? failureMessage;
  final String? displayName;
  final String? login;
  final VoidCallback onPickEmoji;
  final VoidCallback onRetry;
  final ValueChanged<ChatStatusPreset> onPreset;
  final ValueChanged<ChatStatusDurationOption> onDuration;
  final ValueChanged<bool> onDnd;
  final VoidCallback onClear;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final busy = loading || saving;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340, maxHeight: 460),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: chat.panelSurface,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: chat.separator),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChatStatusIdentityHeader(
                  current: current,
                  displayName: displayName,
                  login: login,
                ),
                const SizedBox(height: Sizes.p8),
                Divider(height: 1, color: chat.separator),
                const SizedBox(height: Sizes.p8),
                if (loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.p16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (loadFailed)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p8,
                      vertical: Sizes.p16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.chatStatusLoadFailed,
                          style: chat.contentStyle.copyWith(
                            color: chat.metadataText,
                          ),
                        ),
                        const SizedBox(height: Sizes.p8),
                        TextButton.icon(
                          onPressed: saving ? null : onRetry,
                          icon: const Icon(Symbols.refresh_rounded, size: 18),
                          label: Text(context.l10n.workspacesRetry),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Text(
                    context.l10n.chatStatusPresets,
                    style: chat.metadataStyle.copyWith(
                      color: chat.metadataText,
                    ),
                  ),
                  const SizedBox(height: Sizes.p4),
                  Wrap(
                    spacing: Sizes.p4,
                    runSpacing: Sizes.p4,
                    children: [
                      for (final value in ChatStatusPreset.values)
                        ChatStatusPresetChip(
                          preset: value,
                          selected: preset == value,
                          onTap: saving ? null : () => onPreset(value),
                        ),
                    ],
                  ),
                  const SizedBox(height: Sizes.p8),
                  Row(
                    children: [
                      SizedBox.square(
                        dimension: chat.composerActionSize,
                        child: OutlinedButton(
                          key: const ValueKey('chat-status-emoji'),
                          onPressed: saving ? null : onPickEmoji,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            emoji?.isNotEmpty ?? false ? emoji! : '🙂',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: Sizes.p8),
                      Expanded(
                        child: TextField(
                          controller: textController,
                          enabled: !saving,
                          maxLength: 240,
                          style: chat.contentStyle.copyWith(
                            color: chat.incomingText,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            counterText: '',
                            filled: true,
                            fillColor: chat.listSurface,
                            hintText: context.l10n.chatStatusText,
                            hintStyle: chat.contentStyle.copyWith(
                              color: chat.metadataText,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: chat.separator),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: chat.focusRing,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(color: chat.separator),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.p4),
                  _durationControl(context),
                  const SizedBox(height: Sizes.p4),
                  ChatToggle(
                    key: const ValueKey('chat-status-dnd-toggle'),
                    value: isDnd,
                    label: context.l10n.chatStatusDnd,
                    showLabel: true,
                    activeColor: chat.presenceDnd,
                    onChanged: saving ? null : onDnd,
                  ),
                  if (failureMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: Sizes.p8),
                      child: Text(
                        failureMessage!,
                        style: chat.metadataStyle.copyWith(color: chat.error),
                      ),
                    ),
                  const SizedBox(height: Sizes.p8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: busy ? null : onClear,
                        child: Text(context.l10n.chatStatusClear),
                      ),
                      const SizedBox(width: Sizes.p8),
                      FilledButton(
                        onPressed: busy ? null : onSave,
                        child: Text(context.l10n.chatStatusSave),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _durationControl(BuildContext context) {
    final chat = context.chatTheme;
    return Builder(
      builder: (anchorContext) => Material(
        color: Colors.transparent,
        child: InkWell(
          key: const ValueKey('chat-status-duration'),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: saving ? null : () => _chooseDuration(context, anchorContext),
          child: InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: chat.listSurface,
              labelText: context.l10n.chatStatusExpiry,
              labelStyle: chat.metadataStyle.copyWith(
                color: chat.metadataText,
              ),
              suffixIcon: Icon(
                Symbols.expand_more_rounded,
                color: chat.metadataText,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: chat.separator),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: chat.separator),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: chat.focusRing, width: 1.5),
              ),
            ),
            child: Text(
              _durationLabel(context),
              style: chat.contentStyle.copyWith(color: chat.incomingText),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _chooseDuration(
    BuildContext context,
    BuildContext anchorContext,
  ) async {
    final selected = await AppContextMenu.select<ChatStatusDurationOption>(
      anchorContext,
      globalPosition: AppContextMenu.positionFor(anchorContext),
      options: [
        AppContextMenuOption(
          value: ChatStatusDurationOption.oneHour,
          label: context.l10n.chatStatusExpiryHour,
          selected: durationChoice == ChatStatusDurationOption.oneHour,
        ),
        AppContextMenuOption(
          value: ChatStatusDurationOption.today,
          label: context.l10n.chatStatusExpiryToday,
          selected: durationChoice == ChatStatusDurationOption.today,
        ),
        AppContextMenuOption(
          value: ChatStatusDurationOption.none,
          label: context.l10n.chatStatusExpiryNone,
          selected: durationChoice == ChatStatusDurationOption.none,
        ),
      ],
    );
    if (selected != null) onDuration(selected);
  }

  String _durationLabel(BuildContext context) => switch (durationChoice) {
    ChatStatusDurationOption.oneHour => context.l10n.chatStatusExpiryHour,
    ChatStatusDurationOption.today => context.l10n.chatStatusExpiryToday,
    ChatStatusDurationOption.none => context.l10n.chatStatusExpiryNone,
    null => context.l10n.chatStatusExpiryUnchanged,
  };
}
