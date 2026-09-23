import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/presentation/chat/mentions/chat_mention_picker_controller.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Zakotwiczona lista podpowiedzi wzmianki nad polem composera.
///
/// Pokazuje kandydatów z endpointu sugestii, stan ładowania, brak wyników oraz
/// odmowę/offline z ponowieniem. Wybór należy do composera — lista tylko
/// prezentuje stan kontrolera.
class ChatMentionSuggestions extends StatelessWidget {
  /// Tworzy listę podpowiedzi.
  const ChatMentionSuggestions({
    required this.controller,
    required this.onSelected,
    this.onSelectAll,
    super.key,
  });

  final ChatMentionPickerController controller;
  final ValueChanged<ChatMentionSuggestion> onSelected;

  /// Wybór wzmianki `@all`; `null` ukrywa tę propozycję.
  final VoidCallback? onSelectAll;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      if (!controller.isOpen) return const SizedBox.shrink();
      final chat = context.chatTheme;
      final Widget body;
      if (controller.failureCode != null) {
        body = _Message(
          icon: Symbols.error_outline,
          label: context.l10n.chatActionFailureMessage,
          onRetry: () => unawaited(controller.retry()),
        );
      } else if (controller.isQueryTooShort) {
        body = _Message(
          icon: Symbols.keyboard,
          label: context.l10n.chatMentionPickerHint,
        );
      } else if (controller.isLoading) {
        body = const Padding(
          padding: EdgeInsets.all(Sizes.p12),
          child: Center(child: CircularProgressIndicator()),
        );
      } else if (controller.suggestions.isEmpty &&
          !(controller.suggestsAll && onSelectAll != null)) {
        body = _Message(
          icon: Symbols.search_off,
          label: context.l10n.chatMentionPickerEmpty,
        );
      } else {
        body = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.suggestsAll && onSelectAll != null)
              _AllTokenTile(onTap: onSelectAll!),
            for (final (index, suggestion) in controller.suggestions.indexed)
              _SuggestionTile(
                suggestion: suggestion,
                active: index == controller.activeIndex,
                onTap: () => onSelected(suggestion),
              ),
          ],
        );
      }
      return Container(
        margin: const EdgeInsets.only(bottom: Sizes.p4),
        decoration: BoxDecoration(
          color: chat.panelSurface,
          border: Border.all(color: chat.separator),
          borderRadius: BorderRadius.circular(chat.composerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220),
          child: SingleChildScrollView(child: body),
        ),
      );
    },
  );
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.suggestion,
    required this.active,
    required this.onTap,
  });

  final ChatMentionSuggestion suggestion;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final label = ChatMentionCodec.labelFor(
      userId: suggestion.userId,
      displayName: suggestion.displayName,
      login: suggestion.login,
      fallbackLabel: context.l10n.chatMentionUnknownMember,
    );
    return Material(
      color: active ? chat.selectedSurface : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p12,
            vertical: Sizes.p8,
          ),
          child: Row(
            children: [
              AppUserAvatar(
                userId: suggestion.userId,
                displayName: label,
                avatarUrl: suggestion.avatarUrl,
                hasCustomAvatar:
                    suggestion.avatarUrl?.trim().isNotEmpty == true,
                radius: 18,
                singleInitial: true,
              ),
              const SizedBox(width: Sizes.p10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: chat.contentStyle.copyWith(
                        color: chat.incomingText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (suggestion.login.trim().isNotEmpty &&
                        !ChatMentionCodec.isUuid(suggestion.login))
                      Text(
                        '@${suggestion.login}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chat.metadataStyle.copyWith(
                          color: chat.metadataText,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Symbols.alternate_email, size: 18, color: chat.linkText),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllTokenTile extends StatelessWidget {
  const _AllTokenTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Material(
      color: chat.mentionSurface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p12,
            vertical: Sizes.p10,
          ),
          child: Row(
            children: [
              Icon(Symbols.campaign, size: 20, color: chat.mentionText),
              const SizedBox(width: Sizes.p10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ChatMentionCodec.allToken,
                      style: chat.contentStyle.copyWith(
                        color: chat.mentionText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      context.l10n.chatMentionAllOption,
                      style: chat.metadataStyle.copyWith(
                        color: chat.metadataText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.label, this.onRetry});

  final IconData icon;
  final String label;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Padding(
      padding: const EdgeInsets.all(Sizes.p12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: chat.metadataText),
          const SizedBox(width: Sizes.p8),
          Expanded(
            child: Text(
              label,
              style: chat.metadataStyle.copyWith(color: chat.metadataText),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.chatInboxRetry),
            ),
        ],
      ),
    );
  }
}
