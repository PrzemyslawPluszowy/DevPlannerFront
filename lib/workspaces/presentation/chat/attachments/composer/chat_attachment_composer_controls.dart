import 'package:desktop_drop/desktop_drop.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_drop_input_adapter.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

final class ChatAttachmentComposerControls extends StatefulWidget {
  const ChatAttachmentComposerControls({
    required this.coordinator,
    required this.conversationId,
    required this.filePickerPort,
    super.key,
  });
  final ChatAttachmentComposerCoordinatorCubit coordinator;
  final String conversationId;
  final FilePickerPort? filePickerPort;
  @override
  State<ChatAttachmentComposerControls> createState() =>
      _ChatAttachmentComposerControlsState();
}

final class _ChatAttachmentComposerControlsState
    extends State<ChatAttachmentComposerControls> {
  final ValueNotifier<bool> _dragging = ValueNotifier(false);

  @override
  void dispose() {
    _dragging.dispose();
    super.dispose();
  }

  bool get _locked =>
      widget.coordinator.state
          is ChatAttachmentComposerCoordinatorAwaitingConfirmation;
  Future<void> _add(List<StorageUploadInput> inputs) async {
    if (_locked || inputs.isEmpty) return;
    widget.coordinator.selectInputs(inputs);
    await widget.coordinator.prepare(widget.conversationId);
  }

  Future<void> _pick() async {
    final port = widget.filePickerPort;
    if (port != null && !_locked) await _add(await port.pickFiles());
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: widget.coordinator,
    child: DropTarget(
      onDragEntered: (_) => _dragging.value = true,
      onDragExited: (_) => _dragging.value = false,
      onDragDone: (details) async {
        _dragging.value = false;
        await _add(
          await ChatAttachmentDropInputAdapter.fromFiles(details.files),
        );
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _dragging,
        builder: (context, isDragging, _) =>
            BlocBuilder<
              ChatAttachmentComposerCoordinatorCubit,
              ChatAttachmentComposerCoordinatorState
            >(
              builder: (_, queueState) =>
                  BlocBuilder<
                    ChatAttachmentSelectionCubit,
                    ChatAttachmentSelectionState
                  >(
                    bloc: widget.coordinator.selectionCubit,
                    builder: (_, selectionState) {
                      final selection =
                          selectionState as ChatAttachmentSelectionReady;
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDragging
                                ? context.colors.primary
                                : context.colors.outline,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: _locked ? null : _pick,
                              icon: const Icon(Symbols.attach_file_rounded),
                              label: Text(context.l10n.chatAttachmentsAdd),
                            ),
                            for (final item in selection.attachments)
                              Chip(
                                label: Text(
                                  '${item.input.name} · ${_label(context, queueState)}',
                                ),
                                onDeleted: _locked
                                    ? null
                                    : () => widget.coordinator.remove(
                                        widget.conversationId,
                                        item.localId,
                                      ),
                              ),
                            for (final rejection in selection.rejections)
                              Chip(
                                label: Text(
                                  '${rejection.input.name} · ${context.l10n.chatAttachmentStatusFailed}',
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
            ),
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
}
