import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_label.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_presets.dart';
import 'package:flutter/material.dart';

final class ChatStatusIdentityHeader extends StatelessWidget {
  const ChatStatusIdentityHeader({
    required this.current,
    this.displayName,
    this.login,
    super.key,
  });

  final ChatUserStatus? current;
  final String? displayName;
  final String? login;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final name = displayName?.trim();
    final fallback = login?.trim();
    final label = name != null && name.isNotEmpty
        ? name
        : (fallback != null && fallback.isNotEmpty ? fallback : null);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppUserAvatar(
          isCurrentUser: true,
          displayName: label,
          radius: 22,
          singleInitial: true,
        ),
        const SizedBox(width: Sizes.p8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                Text(
                  label,
                  style: chat.authorStyle.copyWith(color: chat.incomingText),
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: Sizes.p2),
              if (current != null)
                ChatStatusLabel(
                  status: current,
                  style: chat.metadataStyle.copyWith(color: chat.metadataText),
                )
              else
                Text(
                  context.l10n.chatStatusNone,
                  style: chat.metadataStyle.copyWith(color: chat.metadataText),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

final class ChatStatusPresetChip extends StatelessWidget {
  const ChatStatusPresetChip({
    required this.preset,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final ChatStatusPreset preset;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return InkWell(
      key: ValueKey<String>('chat-status-preset-${preset.name}'),
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p8,
          vertical: Sizes.p4,
        ),
        decoration: BoxDecoration(
          color: selected ? chat.selectedSurface : chat.hoverSurface,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: selected ? chat.focusRing : chat.separator),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(preset.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: Sizes.p4),
            Text(
              chatStatusPresetLabel(context, preset),
              style: chat.metadataStyle.copyWith(color: chat.incomingText),
            ),
          ],
        ),
      ),
    );
  }
}

String chatStatusPresetLabel(BuildContext context, ChatStatusPreset preset) =>
    switch (preset) {
      ChatStatusPreset.focus => context.l10n.chatStatusPresetFocus,
      ChatStatusPreset.inMeeting => context.l10n.chatStatusPresetInMeeting,
      ChatStatusPreset.brb => context.l10n.chatStatusPresetBrb,
      ChatStatusPreset.commuting => context.l10n.chatStatusPresetCommuting,
      ChatStatusPreset.lunch => context.l10n.chatStatusPresetLunch,
    };
