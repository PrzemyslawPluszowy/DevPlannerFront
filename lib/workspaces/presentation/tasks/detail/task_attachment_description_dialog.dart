import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_detail_editor_close_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class TaskAttachmentDescriptionDialog extends StatefulWidget {
  const TaskAttachmentDescriptionDialog({
    required this.file,
    required this.onSaved,
    super.key,
  });

  final StorageFileResponse file;
  final Future<void> Function() onSaved;

  static Future<void> show(
    BuildContext context,
    StorageFileResponse file,
  ) async {
    final mutationCubit = context.read<StorageFileMutationCubit>();
    final attachmentsCubit = context.read<TaskAttachmentsCubit>();
    final key = GlobalKey<_TaskAttachmentDescriptionDialogState>();
    await DevPlannerModalHost.showDialog<void>(
      context,
      onDismissAttempt: () => unawaited(key.currentState?._requestClose()),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: mutationCubit),
          BlocProvider.value(value: attachmentsCubit),
        ],
        child: TaskAttachmentDescriptionDialog(
          key: key,
          file: file,
          onSaved: attachmentsCubit.load,
        ),
      ),
    );
  }

  @override
  State<TaskAttachmentDescriptionDialog> createState() =>
      _TaskAttachmentDescriptionDialogState();
}

final class _TaskAttachmentDescriptionDialogState
    extends State<TaskAttachmentDescriptionDialog> {
  late final TextEditingController _controller;
  TaskDetailDraftRegistration? _registration;
  bool _isDirty = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.file.manualDescription ?? '',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registration ??= TaskDetailDraftScope.maybeOf(
      context,
    )?.registerDraft(label: 'attachment description');
  }

  @override
  void dispose() {
    _registration?.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _requestClose() async {
    if (_isSaving) return;
    final allowed = await TaskDetailEditorCloseGuard.canClose(
      context,
      _registration,
    );
    if (!mounted || !allowed) return;
    Navigator.of(context).pop();
  }

  Future<void> _save() async {
    if (_isSaving || !_isDirty) return;
    setState(() => _isSaving = true);
    await context.read<StorageFileMutationCubit>().updateDescription(
      fileId: widget.file.id,
      description: _controller.text,
    );
    if (!mounted) return;
    final mutation = context.read<StorageFileMutationCubit>().state;
    if (mutation case StorageFileMutationSuccess(
      type: StorageFileMutationType.descriptionUpdated,
    )) {
      _registration?.clear();
      await widget.onSaved();
      if (!mounted) return;
      Navigator.of(context).pop();
      return;
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    return Dialog(
      backgroundColor: tasks.canvas,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tasks.panelRadius),
        side: BorderSide(color: tasks.canvasBorder),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TaskAttachmentDescriptionHeader(onClose: _requestClose),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                minLines: 4,
                maxLines: 8,
                enabled: !_isSaving,
                decoration: InputDecoration(
                  labelText: context.l10n.taskAttachmentDescriptionHint,
                  alignLabelWithHint: true,
                ),
                onChanged: (_) {
                  _registration?.markDirty();
                  setState(() => _isDirty = true);
                },
              ),
              BlocBuilder<StorageFileMutationCubit, StorageFileMutationState>(
                builder: (context, state) => switch (state) {
                  StorageFileMutationFailure(
                    :final message,
                    :final apiCode,
                    :final backendCode,
                    :final statusCode,
                    :final traceId,
                  ) =>
                    _TaskAttachmentMutationError(
                      message: message,
                      apiCode: apiCode,
                      backendCode: backendCode,
                      statusCode: statusCode,
                      traceId: traceId,
                    ),
                  _ => const SizedBox.shrink(),
                },
              ),
              const SizedBox(height: 16),
              _TaskAttachmentDescriptionActions(
                isSaving: _isSaving,
                canSave: _isDirty,
                onCancel: _requestClose,
                onSave: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _TaskAttachmentDescriptionHeader extends StatelessWidget {
  const _TaskAttachmentDescriptionHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          context.l10n.taskAttachmentDescriptionTitle,
          style: context.tasksTheme.dataStrongText,
        ),
      ),
      IconButton(
        tooltip: context.l10n.close,
        onPressed: onClose,
        icon: const Icon(Icons.close_rounded),
      ),
    ],
  );
}

final class _TaskAttachmentDescriptionActions extends StatelessWidget {
  const _TaskAttachmentDescriptionActions({
    required this.isSaving,
    required this.canSave,
    required this.onCancel,
    required this.onSave,
  });

  final bool isSaving;
  final bool canSave;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: isSaving ? null : onCancel,
        child: Text(context.l10n.cancel),
      ),
      const SizedBox(width: 8),
      FilledButton(
        onPressed: isSaving || !canSave ? null : onSave,
        child: isSaving
            ? const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(context.l10n.taskAttachmentDescriptionSave),
      ),
    ],
  );
}

final class _TaskAttachmentMutationError extends StatelessWidget {
  const _TaskAttachmentMutationError({
    required this.message,
    this.apiCode,
    this.backendCode,
    this.statusCode,
    this.traceId,
  });

  final String message;
  final String? apiCode;
  final int? backendCode;
  final int? statusCode;
  final String? traceId;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message, style: TextStyle(color: context.colors.error)),
        if (apiCode case final code?)
          Text('${context.l10n.taskDetailsErrorCode}: $code'),
        if (backendCode case final code?)
          Text('${context.l10n.taskDetailsErrorBackendCode}: $code'),
        if (statusCode case final code?)
          Text('${context.l10n.taskDetailsErrorHttpStatus}: $code'),
        if (traceId case final id?)
          Text('${context.l10n.taskDetailsErrorTraceId}: $id'),
      ],
    ),
  );
}
