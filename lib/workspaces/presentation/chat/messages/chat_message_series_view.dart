import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_bubble.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_grouping.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/cubit/chat_conversation_presence_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Seria dymków jednego autora z awatarem i nazwą tylko na jej początku.
class ChatMessageSeriesView extends StatelessWidget {
  const ChatMessageSeriesView({
    required this.series,
    required this.maxWidth,
    this.authorLabel,
    this.authorAvatarUrl,
    this.showIdentity = false,
    this.compact = false,
    this.bubbleBuilder,
    super.key,
  });

  final ChatMessageSeries series;

  /// Limit szerokości dymka w tej historii.
  final double maxWidth;

  /// Etykieta autora serii z katalogu; brak ukrywa tożsamość.
  final String? authorLabel;

  /// Zdjęcie profilu autora z katalogu uczestników.
  final String? authorAvatarUrl;

  /// Czy pokazać awatar i nazwę (grupa/kanał); w DM tożsamość jest w nagłówku.
  final bool showIdentity;

  /// Tryb compact: mniejszy gutter historii.
  final bool compact;

  /// Buduje dymek dla wiadomości serii; panel dostarcza menu i reakcje.
  final Widget Function(
    ChatMessage message,
    bool isFirstInSeries,
    ChatMessageSeriesPosition position,
  )?
  bubbleBuilder;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final label = authorLabel?.trim();
    final showIdentityHere =
        showIdentity &&
        !series.isOwnAuthor &&
        label != null &&
        label.isNotEmpty;
    final avatarSize = chat.avatarBubble;
    final bubbles = <Widget>[
      for (var index = 0; index < series.messages.length; index++) ...[
        if (index > 0) SizedBox(height: chat.seriesGap),
        (bubbleBuilder ?? _defaultBubble)(
          series.messages[index],
          index == 0,
          series.messages.length == 1
              ? ChatMessageSeriesPosition.standalone
              : index == 0
              ? ChatMessageSeriesPosition.first
              : index == series.messages.length - 1
              ? ChatMessageSeriesPosition.last
              : ChatMessageSeriesPosition.middle,
        ),
      ],
    ];
    return Padding(
      padding: EdgeInsets.only(top: chat.authorGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: series.isOwnAuthor
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!series.isOwnAuthor) ...[
            if (showIdentityHere)
              _ChatAuthorAvatar(
                userId: series.authorUserId,
                displayName: label,
                avatarUrl: authorAvatarUrl,
                size: avatarSize,
              )
            else
              SizedBox(width: avatarSize),
            SizedBox(width: chat.seriesGap + Sizes.p4),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: series.isOwnAuthor
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: bubbles,
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultBubble(
    ChatMessage message,
    bool isFirst,
    ChatMessageSeriesPosition position,
  ) => ChatMessageBubble(
    message: message,
    isOwn: series.isOwnAuthor,
    maxWidth: maxWidth,
    seriesPosition: position,
    authorLabel: authorLabel,
    showAuthor: isFirst,
  );
}

/// Awatar autora w grupie z obecnością potwierdzoną snapshotem rozmowy.
class _ChatAuthorAvatar extends StatelessWidget {
  const _ChatAuthorAvatar({
    required this.userId,
    required this.displayName,
    required this.size,
    this.avatarUrl,
  });

  final String userId;
  final String displayName;
  final String? avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final presence = context
        .select<ChatConversationPresenceCubit?, ChatPeerLivePresence>(
          (cubit) =>
              cubit?.state.forUser(userId) ?? ChatPeerLivePresence.unknown,
        );
    final chat = context.chatTheme;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AppUserAvatar(
              userId: userId,
              displayName: displayName,
              avatarUrl: avatarUrl,
              hasCustomAvatar: avatarUrl?.trim().isNotEmpty == true,
              radius: size / 2,
              singleInitial: true,
              semanticsLabel: displayName,
            ),
          ),
          if (presence == ChatPeerLivePresence.online)
            Positioned(
              right: -1,
              bottom: -1,
              child: Tooltip(
                message: context.l10n.chatPeerOnline,
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: chat.presenceOnline,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: chat.conversationSurface,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
