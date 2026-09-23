import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/chat_selection_tile.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/validation/chat_creation_validation_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Krok szczegółów: nazwa rozmowy i zasady publikacji.
class ChatCreationDetailsStep extends StatelessWidget {
  /// Tworzy krok szczegółów.
  const ChatCreationDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatCreationCubit>().state;
    final cubit = context.read<ChatCreationCubit>();
    final theme = Theme.of(context);
    final chat = context.chatTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state.requiresName) ...[
          TextField(
            autofocus: true,
            maxLength: ChatCreationCubit.maxNameLength,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: chat.composerSurface,
              labelText: context.l10n.chatCreationNameLabel,
              hintText: context.l10n.chatCreationNameHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: chat.separator),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: chat.separator),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: chat.focusRing),
              ),
            ),
            style: chat.contentStyle.copyWith(color: chat.incomingText),
            onChanged: cubit.setName,
          ),
          const SizedBox(height: Sizes.p8),
        ],
        Text(
          context.l10n.chatCreationPostingPermission,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: Sizes.p4),
        ChatSelectionTile(
          title: context.l10n.chatCreationPostingEveryone,
          subtitle: context.l10n.chatCreationPostingEveryoneHint,
          selected: state.postingPermission == 'Everyone',
          enabled: !state.postingPermissionLocked,
          icon: Symbols.group,
          onTap: state.postingPermissionLocked
              ? null
              : () => cubit.setPostingPermission('Everyone'),
        ),
        const SizedBox(height: Sizes.p8),
        ChatSelectionTile(
          title: context.l10n.chatCreationPostingAdminsOnly,
          subtitle: context.l10n.chatCreationPostingAdminsOnlyHint,
          selected: state.postingPermission == 'AdminsOnly',
          enabled: !state.postingPermissionLocked,
          icon: Symbols.admin_panel_settings,
          onTap: state.postingPermissionLocked
              ? null
              : () => cubit.setPostingPermission('AdminsOnly'),
        ),
        if (state.postingPermissionLocked)
          Text(
            context.l10n.chatCreationKindBroadcastHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: chat.metadataText,
            ),
          ),
        if (state.kind == ChatConversationKind.direct)
          Text(
            context.l10n.chatCreationKindDirectHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: chat.metadataText,
            ),
          ),
        if (state.validationErrors.isNotEmpty) ...[
          const SizedBox(height: Sizes.p8),
          for (final error in state.validationErrors)
            ChatCreationValidationText(
              validation: error,
              style: theme.textTheme.bodySmall?.copyWith(
                color: chat.error,
              ),
            ),
        ],
      ],
    );
  }
}
