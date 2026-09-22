import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/validation/chat_creation_validation_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Krok szczegółów: nazwa rozmowy i zasady publikacji.
class ChatCreationDetailsStep extends StatelessWidget {
  /// Tworzy krok szczegółów.
  const ChatCreationDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatCreationCubit>().state;
    final cubit = context.read<ChatCreationCubit>();
    final theme = Theme.of(context);
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
              labelText: context.l10n.chatCreationNameLabel,
              hintText: context.l10n.chatCreationNameHint,
            ),
            onChanged: cubit.setName,
          ),
          const SizedBox(height: Sizes.p8),
        ],
        Text(
          context.l10n.chatCreationPostingPermission,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: Sizes.p4),
        RadioGroup<String>(
          groupValue: state.postingPermission,
          onChanged: (value) {
            if (value != null) cubit.setPostingPermission(value);
          },
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'Everyone',
                title: Text(context.l10n.chatCreationPostingEveryone),
              ),
              RadioListTile<String>(
                value: 'AdminsOnly',
                title: Text(context.l10n.chatCreationPostingAdminsOnly),
              ),
            ],
          ),
        ),
        if (state.postingPermissionLocked)
          Text(
            context.l10n.chatCreationKindBroadcastHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        if (state.kind == ChatConversationKind.direct)
          Text(
            context.l10n.chatCreationKindDirectHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        if (state.validationErrors.isNotEmpty) ...[
          const SizedBox(height: Sizes.p8),
          for (final error in state.validationErrors)
            ChatCreationValidationText(
              validation: error,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ],
    );
  }
}
