import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_upload_error.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_forward_targets_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_forward_targets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wyniki fallbacku oparte na migawce przekazanej przez starszy call site.
final class ChatForwardTargetFallbackResults extends StatelessWidget {
  const ChatForwardTargetFallbackResults({
    required this.items,
    required this.onSelected,
    super.key,
  });

  final List<ChatInboxItem> items;
  final ValueChanged<ChatInboxItem> onSelected;

  @override
  Widget build(BuildContext context) => items.isEmpty
      ? const ChatForwardTargetEmpty()
      : ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ChatForwardTargetTile(
            item: items[index],
            onSelected: onSelected,
          ),
        );
}

/// Renderuje jawne loading, failure, empty i cursor states pickera.
final class ChatForwardTargetRemoteResults extends StatelessWidget {
  const ChatForwardTargetRemoteResults({
    required this.onSelected,
    super.key,
  });

  final ValueChanged<ChatInboxItem> onSelected;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChatForwardTargetsCubit, ChatForwardTargetsState>(
        builder: (context, state) => switch (state) {
          ChatForwardTargetsLoading() => const ChatForwardTargetLoading(),
          ChatForwardTargetsFailure(:final error) =>
            ChatForwardTargetsFirstPageError(
              error: error,
              onRetry: () => context.read<ChatForwardTargetsCubit>().retry(),
            ),
          ChatForwardTargetsEmpty() => const ChatForwardTargetEmpty(),
          ChatForwardTargetsReady(
            :final items,
            :final hasMore,
            :final isLoadingMore,
            :final loadMoreError,
          ) =>
            ChatForwardTargetReadyList(
              items: items,
              hasMore: hasMore,
              isLoadingMore: isLoadingMore,
              loadMoreError: loadMoreError,
              onSelected: onSelected,
              onLoadMore: () =>
                  context.read<ChatForwardTargetsCubit>().loadMore(),
            ),
        },
      );
}

/// Ograniczona, przewijalna lista wyników i stopka dalszej strony.
final class ChatForwardTargetReadyList extends StatelessWidget {
  const ChatForwardTargetReadyList({
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
    required this.loadMoreError,
    required this.onSelected,
    required this.onLoadMore,
    super.key,
  });

  final List<ChatInboxItem> items;
  final bool hasMore;
  final bool isLoadingMore;
  final ApiError? loadMoreError;
  final ValueChanged<ChatInboxItem> onSelected;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final hasEmptyPageHint = items.isEmpty && hasMore;
    final hasFooter = hasMore || loadMoreError != null;
    return ListView.builder(
      itemCount:
          items.length + (hasEmptyPageHint ? 1 : 0) + (hasFooter ? 1 : 0),
      itemBuilder: (context, index) {
        if (hasEmptyPageHint && index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
            child: Text(
              context.l10n.chatInboxEmptyPageMore,
              textAlign: TextAlign.center,
              style: context.chatTheme.metadataStyle.copyWith(
                color: context.chatTheme.metadataText,
              ),
            ),
          );
        }
        final itemIndex = index - (hasEmptyPageHint ? 1 : 0);
        if (itemIndex < items.length) {
          return ChatForwardTargetTile(
            item: items[itemIndex],
            onSelected: onSelected,
          );
        }
        return ChatForwardTargetsLoadMoreFooter(
          error: loadMoreError,
          isLoading: isLoadingMore,
          onRetry: onLoadMore,
        );
      },
    );
  }
}

/// Jedna rozmowa możliwa do wybrania jako cel przekazania.
final class ChatForwardTargetTile extends StatelessWidget {
  const ChatForwardTargetTile({
    required this.item,
    required this.onSelected,
    super.key,
  });

  final ChatInboxItem item;
  final ValueChanged<ChatInboxItem> onSelected;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final preview = item.lastMessage?.text;
    return ListTile(
      dense: true,
      leading: Icon(Symbols.forum, color: chat.metadataText),
      title: Text(
        item.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: chat.contentStyle.copyWith(
          color: chat.incomingText,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: preview == null
          ? null
          : Text(
              preview,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: chat.metadataStyle.copyWith(color: chat.metadataText),
            ),
      onTap: () => onSelected(item),
    );
  }
}

/// Czytelny stan braku dostępnych rozmów.
final class ChatForwardTargetEmpty extends StatelessWidget {
  const ChatForwardTargetEmpty({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      context.l10n.chatMessageForwardEmpty,
      textAlign: TextAlign.center,
      style: context.chatTheme.metadataStyle.copyWith(
        color: context.chatTheme.metadataText,
      ),
    ),
  );
}

/// Wskaźnik pobierania pierwszej strony.
final class ChatForwardTargetLoading extends StatelessWidget {
  const ChatForwardTargetLoading({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );
}

/// Diagnostyka błędu pierwszej strony z możliwością ponowienia.
final class ChatForwardTargetsFirstPageError extends StatelessWidget {
  const ChatForwardTargetsFirstPageError({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final ApiError error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 156),
          child: ChatAttachmentUploadError(error: error),
        ),
        TextButton(
          onPressed: onRetry,
          child: Text(context.l10n.chatInboxRetry),
        ),
      ],
    ),
  );
}

/// Dalsza strona, jej błąd diagnostyczny albo akcja pobrania.
final class ChatForwardTargetsLoadMoreFooter extends StatelessWidget {
  const ChatForwardTargetsLoadMoreFooter({
    required this.error,
    required this.isLoading,
    required this.onRetry,
    super.key,
  });

  final ApiError? error;
  final bool isLoading;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(Sizes.p8),
        child: Center(
          child: SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    final failure = error;
    if (failure != null) {
      return Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 128),
            child: ChatAttachmentUploadError(error: failure),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.chatInboxRetry),
          ),
        ],
      );
    }
    return Center(
      child: TextButton(
        onPressed: onRetry,
        child: Text(context.l10n.chatInboxLoadMore),
      ),
    );
  }
}
