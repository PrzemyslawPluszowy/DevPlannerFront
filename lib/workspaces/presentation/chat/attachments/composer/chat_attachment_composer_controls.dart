import 'dart:async';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_drop_input_adapter.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Pasek załączników nad powierzchnią pisania.
///
/// Pokazuje karty wybranych plików z ich stanem, usuwaniem i ponowieniem po
/// błędzie; nie rysuje już formularza ani przycisku dodawania, bo wybór pliku
/// należy do menu `+` composera. Drop obsługuje osobna strefa całego composera.
final class ChatAttachmentComposerControls extends StatelessWidget {
  const ChatAttachmentComposerControls({
    required this.coordinator,
    required this.conversationId,
    super.key,
  });

  final ChatAttachmentComposerCoordinatorCubit coordinator;
  final String conversationId;

  bool get _locked =>
      coordinator.state
          is ChatAttachmentComposerCoordinatorAwaitingConfirmation;

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: coordinator,
    child:
        BlocBuilder<
          ChatAttachmentComposerCoordinatorCubit,
          ChatAttachmentComposerCoordinatorState
        >(
          builder: (_, queueState) =>
              BlocBuilder<
                ChatAttachmentSelectionCubit,
                ChatAttachmentSelectionState
              >(
                bloc: coordinator.selectionCubit,
                builder: (_, selectionState) {
                  final selection =
                      selectionState as ChatAttachmentSelectionReady;
                  if (selection.attachments.isEmpty &&
                      selection.rejections.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final chat = context.chatTheme;
                  return Container(
                    margin: const EdgeInsets.only(bottom: Sizes.p4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.p8,
                      vertical: Sizes.p4,
                    ),
                    decoration: BoxDecoration(
                      color: chat.listSurface,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      border: Border.all(
                        color: chat.separator,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final item in selection.attachments)
                          _AttachmentCard(
                            name: item.input.name,
                            status: _label(context, queueState),
                            onRemove: _locked
                                ? null
                                : () => coordinator.remove(
                                    conversationId,
                                    item.localId,
                                  ),
                          ),
                        for (final rejection in selection.rejections)
                          _AttachmentCard(
                            name: rejection.input.name,
                            status: _rejectionLabel(context, rejection.reason),
                            failed: true,
                          ),
                        if (queueState
                            is ChatAttachmentComposerCoordinatorFailed)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _locked
                                  ? null
                                  : () => coordinator.prepare(
                                      conversationId,
                                    ),
                              child: Text(
                                context.l10n.chatAttachmentRetryAction,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
        ),
  );

  String _label(
    BuildContext context,
    ChatAttachmentComposerCoordinatorState state,
  ) => switch (state) {
    ChatAttachmentComposerCoordinatorReady() ||
    ChatAttachmentComposerCoordinatorAwaitingConfirmation() =>
      context.l10n.chatAttachmentStatusClean,
    ChatAttachmentComposerCoordinatorFailed() =>
      context.l10n.chatAttachmentStatusFailed,
    _ => context.l10n.chatAttachmentStatusProcessing,
  };

  String _rejectionLabel(
    BuildContext context,
    ChatAttachmentRejectionReason reason,
  ) => switch (reason) {
    ChatAttachmentRejectionReason.tooManyFiles =>
      context.l10n.chatAttachmentTooManyFiles,
    ChatAttachmentRejectionReason.fileTooLarge =>
      context.l10n.chatAttachmentFileTooLarge,
    ChatAttachmentRejectionReason.messageTooLarge =>
      context.l10n.chatAttachmentMessageTooLarge,
  };
}

/// Stała strefa dropu obejmująca cały composer, także gdy kolejka jest pusta.
/// Sam pasek załączników jest celowo zwijany bez plików, więc nie może być
/// właścicielem hit-testu dla pierwszego przeciągnięcia.
final class ChatAttachmentDropRegion extends StatefulWidget {
  const ChatAttachmentDropRegion({
    required this.coordinator,
    required this.conversationId,
    required this.child,
    super.key,
  });

  final ChatAttachmentComposerCoordinatorCubit coordinator;
  final String conversationId;
  final Widget child;

  @override
  State<ChatAttachmentDropRegion> createState() =>
      _ChatAttachmentDropRegionState();
}

final class _ChatAttachmentDropRegionState
    extends State<ChatAttachmentDropRegion> {
  bool _dragging = false;

  bool get _locked =>
      widget.coordinator.state
          is ChatAttachmentComposerCoordinatorAwaitingConfirmation;

  Future<void> _accept(DropDoneDetails details) async {
    if (_locked) return;
    try {
      final inputs = await ChatAttachmentDropInputAdapter.fromFiles(
        details.files,
        constraints: widget.coordinator.inputConstraints,
      );
      if (!mounted || inputs.isEmpty || _locked) return;
      widget.coordinator.selectInputs(inputs);
      await widget.coordinator.prepare(widget.conversationId);
    } catch (_) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: context.l10n.chatAttachmentDropFailed,
        tone: AppToastTone.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return DropTarget(
      onDragEntered: (_) {
        if (!_locked) setState(() => _dragging = true);
      },
      onDragExited: (_) {
        if (_dragging) setState(() => _dragging = false);
      },
      onDragDone: (details) {
        setState(() => _dragging = false);
        unawaited(_accept(details));
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          widget.child,
          if (_dragging)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: chat.selectedSurface.withValues(alpha: .92),
                    borderRadius: BorderRadius.circular(chat.composerRadius),
                    border: Border.all(color: chat.focusRing, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      context.l10n.chatAttachmentDropHere,
                      style: chat.contentStyle.copyWith(
                        color: chat.incomingText,
                        fontWeight: FontWeight.w600,
                      ),
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

/// Karta jednego załącznika: nazwa, stan i usunięcie.
final class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({
    required this.name,
    required this.status,
    this.onRemove,
    this.failed = false,
  });

  final String name;
  final String status;
  final VoidCallback? onRemove;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final color = failed ? chat.error : chat.metadataText;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p2),
      child: Row(
        children: [
          Icon(
            failed ? Symbols.link_off : Symbols.insert_drive_file,
            size: Sizes.p18,
            color: color,
          ),
          const SizedBox(width: Sizes.p8),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: chat.contentStyle.copyWith(color: chat.incomingText),
            ),
          ),
          const SizedBox(width: Sizes.p8),
          Text(
            status,
            style: chat.metadataStyle.copyWith(color: color),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: Sizes.p4),
            SizedBox.square(
              dimension: Sizes.p24,
              child: IconButton(
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                iconSize: Sizes.p18,
                color: chat.metadataText,
                tooltip: context.l10n.chatAttachmentRemove,
                icon: const Icon(Symbols.close),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
