import 'dart:async';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/details/chat_creation_details_step.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/participants/chat_creation_participants_step.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/participants/cubit/chat_directory_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';


/// Modalny kreator nowej rozmowy Chat.
///
/// Kreator jest montowany w rootowym hoście modali, więc Escape, barrier i focus
/// pochodzą z foundation, a panel zachowuje bieżącą trasę. Po utworzeniu
/// rozmowy kreator zwraca jej identyfikator, żeby panel mógł ją otworzyć.
abstract final class ChatCreationSheet {
  /// Otwiera kreator dla wskazanej kompozycji rozmów.
  static Future<ChatConversation?> show(
    BuildContext context, {
    required ChatConversationManagementRepository repository,
    required ChatDirectoryRepository directoryRepository,
    Set<String> existingDirectConversationIds = const <String>{},
    ChatConversationKind? initialKind,
  }) => DevPlannerModalHost.showDialog<ChatConversation>(
    context,
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = ChatCreationCubit(
              repository: repository,
              existingDirectConversationIds: existingDirectConversationIds,
            );
            // Popover „Nowy czat” wybiera typ od razu, więc kreator startuje
            // we właściwym kroku, a nie od pytania, na które już odpowiedziano.
            if (initialKind != null) cubit.selectKind(initialKind);
            return cubit;
          },
        ),
        // Katalog dostaje własny Cubit wydany jawnie przez flow, z lifecycle
        // zamkniętym razem z arkuszem; wyszukiwanie nie może zależeć od tego,
        // co przypadkiem jest w kontekście panelu.
        BlocProvider(
          create: (_) => ChatDirectorySearchCubit(
            repository: directoryRepository,
          ),
        ),
      ],
      child: const _ChatCreationDialog(),
    ),
  );
}

class _ChatCreationDialog extends StatelessWidget {
  const _ChatCreationDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return BlocListener<ChatCreationCubit, ChatCreationState>(
      listenWhen: (previous, current) =>
          current.created != null && previous.created != current.created,
      listener: (context, state) => Navigator.of(context).pop(state.created),
      child: BlocBuilder<ChatCreationCubit, ChatCreationState>(
        builder: (context, state) => AlertDialog(
          title: Text(l10n.chatCreationTitle),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_stepLabel(l10n, state), style: theme.textTheme.titleSmall),
                  const SizedBox(height: Sizes.p12),
                  switch (state.step) {
                    ChatCreationStep.chooser => const _ChatCreationKindStep(),
                    ChatCreationStep.participants =>
                      const ChatCreationParticipantsStep(),
                    ChatCreationStep.details =>
                      const ChatCreationDetailsStep(),
                  },
                  if (state.failureCode != null) ...[
                    const SizedBox(height: Sizes.p8),
                    _ChatCreationFailureBanner(code: state.failureCode!),
                  ],
                ],
              ),
            ),
          ),
          actions: _actions(context, state),
        ),
      ),
    );
  }

  static String _stepLabel(AppLocalizations l10n, ChatCreationState state) =>
      switch (state.step) {
        ChatCreationStep.chooser => l10n.chatCreationStepChooser,
        ChatCreationStep.participants => l10n.chatCreationStepParticipants,
        ChatCreationStep.details => l10n.chatCreationStepDetails,
      };

  static List<Widget> _actions(BuildContext context, ChatCreationState state) {
    final l10n = context.l10n;
    final cubit = context.read<ChatCreationCubit>();
    final isDetails = state.step == ChatCreationStep.details;
    return [
      TextButton(
        onPressed: state.isSubmitting
            ? null
            : () => Navigator.of(context).pop(),
        child: Text(l10n.chatCreationCancel),
      ),
      if (state.step != ChatCreationStep.chooser)
        TextButton(
          onPressed: state.isSubmitting ? null : cubit.back,
          child: Text(l10n.chatCreationBack),
        ),
      if (state.step == ChatCreationStep.participants &&
          state.kind == ChatConversationKind.group)
        FilledButton(
          onPressed: cubit.continueToDetails,
          child: Text(l10n.chatCreationNext),
        ),
      if (isDetails)
        FilledButton(
          onPressed: state.isSubmitting ? null : () => unawaited(cubit.submit()),
          child: state.isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.chatCreationSubmit),
        ),
    ];
  }
}

class _ChatCreationFailureBanner extends StatelessWidget {
  const _ChatCreationFailureBanner({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(Sizes.p8),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Icon(Symbols.error_outline, size: 18, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: Sizes.p8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.chatCreationFailureTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
                // Kod domenowy zostaje widoczny dla diagnostyki; użytkownik
                // dostaje tekst z ARB, a nie techniczny identyfikator.
                Text(
                  code,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatCreationKindStep extends StatelessWidget {
  const _ChatCreationKindStep();

  @override
  Widget build(BuildContext context) => RadioGroup<ChatConversationKind>(
    groupValue: context.watch<ChatCreationCubit>().state.kind,
    onChanged: (selected) {
      if (selected != null) {
        context.read<ChatCreationCubit>().selectKind(selected);
      }
    },
    child: Column(
      children: [
        for (final kind in ChatConversationKind.values)
          RadioListTile<ChatConversationKind>(
            value: kind,
            title: Text(_kindLabel(context.l10n, kind)),
            subtitle: Text(_kindHint(context.l10n, kind)),
          ),
      ],
    ),
  );

  static String _kindLabel(AppLocalizations l10n, ChatConversationKind kind) =>
      switch (kind) {
        ChatConversationKind.direct => l10n.chatCreationKindDirect,
        ChatConversationKind.group => l10n.chatCreationKindGroup,
        ChatConversationKind.channel => l10n.chatCreationKindChannel,
        ChatConversationKind.broadcast => l10n.chatCreationKindBroadcast,
      };

  static String _kindHint(AppLocalizations l10n, ChatConversationKind kind) =>
      switch (kind) {
        ChatConversationKind.direct => l10n.chatCreationKindDirectHint,
        ChatConversationKind.group => l10n.chatCreationKindGroupHint,
        ChatConversationKind.channel => l10n.chatCreationKindChannelHint,
        ChatConversationKind.broadcast => l10n.chatCreationKindBroadcastHint,
      };
}
