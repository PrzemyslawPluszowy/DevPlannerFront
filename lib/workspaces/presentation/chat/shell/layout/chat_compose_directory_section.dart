import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/participants/cubit/chat_directory_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wyniki katalogu albo ostatnie rozmowy w popoverze tworzenia czatu.
class ChatComposeDirectorySection extends StatelessWidget {
  const ChatComposeDirectorySection({
    required this.recent,
    required this.onCreated,
    super.key,
  });

  final List<ChatInboxItem> recent;
  final ValueChanged<ChatConversation> onCreated;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChatDirectorySearchCubit, ChatDirectorySearchState>(
        builder: (context, state) {
          if (state.query.trim().isEmpty) return _recentSection(context);
          if (state.isQueryTooShort) {
            return _hint(context, context.l10n.chatCreationSearchTooShort);
          }
          if (state.failureCode != null) return _searchFailure(context);
          if (state.isSearching && state.results.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(Sizes.p16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.isEmpty) {
            return _hint(context, context.l10n.chatCreationSearchEmpty);
          }
          return _results(context, state.results);
        },
      );

  Widget _recentSection(BuildContext context) {
    final items = recent.take(6).toList(growable: false);
    if (items.isEmpty) {
      return _hint(context, context.l10n.chatComposeSearchPrompt);
    }
    final nowUtc = DateTime.now().toUtc();
    return ListView(
      shrinkWrap: true,
      children: [
        _sectionTitle(context, context.l10n.chatComposeRecentTitle),
        for (final item in items)
          ChatInboxRow(
            item: item,
            nowUtc: nowUtc,
            onTap: (selected) => onCreated(selected.conversation),
          ),
      ],
    );
  }

  Widget _searchFailure(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
    child: Row(
      children: [
        Icon(Symbols.error_outline, size: 18, color: context.chatTheme.error),
        const SizedBox(width: Sizes.p8),
        Expanded(
          child: Text(
            context.l10n.chatCreationFailureTitle,
            style: context.chatTheme.metadataStyle.copyWith(
              color: context.chatTheme.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () =>
              unawaited(context.read<ChatDirectorySearchCubit>().retry()),
          child: Text(context.l10n.chatCreationRetry),
        ),
      ],
    ),
  );

  Widget _results(BuildContext context, List<ChatDirectoryEntry> entries) {
    final chat = context.chatTheme;
    final creation = context.watch<ChatCreationCubit>().state;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.p4),
          child: Material(
            color: chat.listSurface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              key: ValueKey<String>('chat-compose-entry-${entry.userId}'),
              borderRadius: BorderRadius.circular(12),
              onTap: creation.isSubmitting
                  ? null
                  : () => unawaited(
                      context.read<ChatCreationCubit>().startDirectWith(entry),
                    ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.p8,
                  vertical: Sizes.p6,
                ),
                child: Row(
                  children: [
                    AppUserAvatar(
                      userId: entry.userId,
                      displayName: entry.label,
                      avatarUrl: entry.avatarUrl,
                      hasCustomAvatar:
                          entry.avatarUrl?.trim().isNotEmpty == true,
                      radius: 20,
                      singleInitial: true,
                    ),
                    const SizedBox(width: Sizes.p8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: chat.contentStyle.copyWith(
                              color: chat.incomingText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            entry.login,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: chat.metadataStyle.copyWith(
                              color: chat.metadataText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Sizes.p8),
                    Icon(
                      Symbols.chat_bubble_outline_rounded,
                      size: 18,
                      color: chat.linkText,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _hint(BuildContext context, String message) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
    child: Text(
      message,
      style: context.chatTheme.metadataStyle.copyWith(
        color: context.chatTheme.metadataText,
      ),
    ),
  );

  Widget _sectionTitle(BuildContext context, String label) => Padding(
    padding: const EdgeInsets.fromLTRB(Sizes.p4, Sizes.p8, Sizes.p4, Sizes.p4),
    child: Text(
      label.toUpperCase(),
      style: context.chatTheme.metadataStyle.copyWith(
        color: context.chatTheme.metadataText,
        letterSpacing: .5,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
