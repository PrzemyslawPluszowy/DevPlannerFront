import 'dart:typed_data';

import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachments_ready.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_attachments_feedback.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class TaskAttachmentsBody extends StatefulWidget {
  const TaskAttachmentsBody({
    required this.isEditable,
    this.selectFiles,
    this.readFileBytes,
    super.key,
  });
  final bool isEditable;
  final Future<List<XFile>?> Function()? selectFiles;
  final Future<Uint8List> Function(XFile file)? readFileBytes;
  @override
  State<TaskAttachmentsBody> createState() => TaskAttachmentsBodyState();
}

class TaskAttachmentsBodyState extends State<TaskAttachmentsBody> {
  final ValueNotifier<bool> _isDragging = ValueNotifier(false);
  final ValueNotifier<bool> _isPreparing = ValueNotifier(false);
  TaskAttachmentsCubit? _observedCubit;
  TaskDetailDraftRegistration? _draftRegistration;
  StreamSubscription<TaskAttachmentsState>? _stateSubscription;
  bool _ownsPendingBatch = false;
  int _scopeGeneration = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.watch<TaskAttachmentsCubit>();
    final registry = TaskDetailDraftScope.maybeOf(context);
    if (identical(cubit, _observedCubit) &&
        identical(registry, _draftRegistry)) {
      return;
    }
    _scopeGeneration++;
    unawaited(_stateSubscription?.cancel());
    _draftRegistration?.dispose();
    _draftRegistry = registry;
    _observedCubit = cubit;
    _ownsPendingBatch = false;
    _isPreparing.value = false;
    _draftRegistration = registry?.registerDraft(
      label: context.l10n.taskDetailsAttachments,
    );
    final generation = _scopeGeneration;
    _stateSubscription = cubit.stream.listen(
      (state) => _onAttachmentState(cubit, generation, state),
    );
    _syncDraftWithState(cubit.state);
  }

  TaskDetailDraftRegistry? _draftRegistry;

  @override
  void dispose() {
    _scopeGeneration++;
    unawaited(_stateSubscription?.cancel());
    _draftRegistration?.dispose();
    _isDragging.dispose();
    _isPreparing.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<TaskAttachmentsCubit, TaskAttachmentsState>(
    builder: (context, state) => ValueListenableBuilder<bool>(
      valueListenable: _isPreparing,
      builder: (context, isPreparing, _) => ValueListenableBuilder<bool>(
        valueListenable: _isDragging,
        builder: (context, isDragging, _) {
          final isUploading =
              state is TaskAttachmentsReady && state.isUploading;
          final canPick =
              widget.isEditable &&
              state is TaskAttachmentsReady &&
              !isUploading &&
              !isPreparing;
          final canToggleDeleted =
              state is TaskAttachmentsReady && !isUploading && !isPreparing;
          return DropTarget(
            onDragEntered: canPick ? (_) => _isDragging.value = true : null,
            onDragExited: canPick ? (_) => _isDragging.value = false : null,
            onDragDone: canPick ? _onFilesDropped : null,
            child: Section(
              title: context.l10n.taskDetailsAttachments,
              action: Wrap(
                spacing: 4,
                children: [
                  if (state is TaskAttachmentsReady)
                    TextButton.icon(
                      onPressed: canToggleDeleted
                          ? () => _toggleDeleted(!state.includeDeleted)
                          : null,
                      icon: Icon(
                        state.includeDeleted
                            ? Symbols.visibility_off_rounded
                            : Symbols.visibility_rounded,
                        size: 18,
                      ),
                      label: Text(
                        state.includeDeleted
                            ? context.l10n.taskDetailsAttachmentsHideDeleted
                            : context.l10n.taskDetailsAttachmentsShowDeleted,
                      ),
                    ),
                  if (isUploading)
                    IconButton(
                      tooltip: context.l10n.cancel,
                      onPressed: _cancelUpload,
                      icon: const Icon(Symbols.cancel_rounded, size: 18),
                    ),
                  if (isPreparing)
                    Tooltip(
                      message: context.l10n.taskDetailsAttachmentsPreparing,
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  TextButton.icon(
                    onPressed: canPick ? _pickFiles : null,
                    icon: const Icon(Symbols.upload_file_rounded, size: 18),
                    label: Text(context.l10n.taskDetailsAttachmentsAdd),
                  ),
                ],
              ),
              child: switch (state) {
                TaskAttachmentsLoading() => const Padding(
                  padding: EdgeInsets.all(18),
                  child: Center(child: CircularProgressIndicator()),
                ),
                TaskAttachmentsFailure(:final message, :final apiError) =>
                  AttachmentsError(message: message, apiError: apiError),
                TaskAttachmentsReady() => AttachmentsReady(
                  state: state,
                  onPickFiles: canPick ? _pickFiles : null,
                  isDragging: isDragging,
                ),
              },
            ),
          );
        },
      ),
    ),
  );

  Future<void> _pickFiles() async {
    final cubit = _observedCubit;
    final generation = _scopeGeneration;
    if (!_canStart(cubit)) return;
    final capturedCubit = cubit!;
    _beginPreparation();
    final pickerFailureMessage =
        context.l10n.taskDetailsAttachmentsPickerFailed;
    final readFailureMessage = context.l10n.taskDetailsAttachmentsReadFailed;
    final uploadFailureMessage = context.l10n.taskDetailsAttachmentsFailed;
    List<XFile>? files;
    try {
      files = await (widget.selectFiles?.call() ?? openFiles());
    } catch (_) {
      if (_isCurrentScope(capturedCubit, generation)) {
        capturedCubit.reportSelectionError(
          ApiError(
            type: ApiErrorType.unknown,
            message: pickerFailureMessage,
            apiCode: 'task_upload_picker_failed',
          ),
        );
        _ownsPendingBatch = false;
        _finishPreparation();
      }
      return;
    }
    if (!_isCurrentScope(capturedCubit, generation)) return;
    if (files == null || files.isEmpty) {
      _ownsPendingBatch = false;
      _finishPreparation();
      return;
    }
    await _readAndUpload(
      files,
      capturedCubit,
      generation,
      readFailureMessage,
      uploadFailureMessage,
    );
  }

  Future<void> _toggleDeleted(bool includeDeleted) async {
    final cubit = _observedCubit;
    final generation = _scopeGeneration;
    if (cubit == null || !_isCurrentScope(cubit, generation)) return;
    final current = cubit.state;
    if (current is! TaskAttachmentsReady || current.isUploading) return;
    await cubit.setIncludeDeleted(includeDeleted);
    if (!_isCurrentScope(cubit, generation)) return;
  }

  Future<void> _onFilesDropped(DropDoneDetails details) async {
    final cubit = _observedCubit;
    final generation = _scopeGeneration;
    if (!_canStart(cubit)) return;
    final capturedCubit = cubit!;
    _isDragging.value = false;
    _beginPreparation();
    await _readAndUpload(
      details.files,
      capturedCubit,
      generation,
      context.l10n.taskDetailsAttachmentsReadFailed,
      context.l10n.taskDetailsAttachmentsFailed,
    );
  }

  Future<void> _readAndUpload(
    List<XFile> files,
    TaskAttachmentsCubit cubit,
    int generation,
    String readFailureMessage,
    String uploadFailureMessage,
  ) async {
    if (files.isEmpty) {
      _ownsPendingBatch = false;
      _finishPreparation();
      return;
    }
    _ownsPendingBatch = true;
    try {
      final readBytes = widget.readFileBytes ?? _readFileBytes;
      late final List<TaskAttachmentUploadInput> inputs;
      try {
        inputs = await Future.wait(
          files.map(
            (file) async => TaskAttachmentUploadInput(
              name: file.name,
              bytes: await readBytes(file),
            ),
          ),
        );
      } catch (_) {
        if (_isCurrentScope(cubit, generation)) {
          cubit.reportSelectionError(
            ApiError(
              type: ApiErrorType.unknown,
              message: readFailureMessage,
              apiCode: 'task_upload_read_failed',
            ),
          );
          _ownsPendingBatch = false;
        }
        return;
      }
      if (!_isCurrentScope(cubit, generation)) return;
      try {
        await cubit.upload(inputs);
      } catch (_) {
        final current = cubit.state;
        if (_isCurrentScope(cubit, generation) &&
            current is TaskAttachmentsReady &&
            !current.isUploading) {
          cubit.reportSelectionError(
            ApiError(
              type: ApiErrorType.unknown,
              message: uploadFailureMessage,
              apiCode: 'task_upload_start_failed',
            ),
          );
          _ownsPendingBatch = false;
        }
      }
    } finally {
      if (_isCurrentScope(cubit, generation)) _finishPreparation();
    }
  }

  Future<Uint8List> _readFileBytes(XFile file) => file.readAsBytes();

  bool _canStart(TaskAttachmentsCubit? cubit) {
    if (!mounted || !widget.isEditable || cubit == null) return false;
    final current = cubit.state;
    return !_isPreparing.value &&
        current is TaskAttachmentsReady &&
        !current.isUploading;
  }

  bool _isCurrentScope(TaskAttachmentsCubit? cubit, int generation) =>
      mounted &&
      cubit != null &&
      identical(cubit, _observedCubit) &&
      generation == _scopeGeneration &&
      cubit.workspaceId == _observedCubit?.workspaceId &&
      cubit.projectId == _observedCubit?.projectId &&
      cubit.taskId == _observedCubit?.taskId;

  void _beginPreparation() {
    _ownsPendingBatch = true;
    _draftRegistration?.markDirty();
    _isPreparing.value = true;
  }

  void _finishPreparation() {
    _isPreparing.value = false;
    if (!_ownsPendingBatch) _draftRegistration?.clear();
  }

  void _cancelUpload() {
    final cubit = _observedCubit;
    if (cubit == null || !mounted) return;
    cubit.cancelUpload();
    _ownsPendingBatch = false;
    _draftRegistration?.clear();
  }

  void _onAttachmentState(
    TaskAttachmentsCubit source,
    int generation,
    TaskAttachmentsState state,
  ) {
    if (!_isCurrentScope(source, generation)) return;
    _syncDraftWithState(state);
  }

  void _syncDraftWithState(TaskAttachmentsState state) {
    if (state is TaskAttachmentsReady) {
      if (state.isUploading) {
        _ownsPendingBatch = true;
        _draftRegistration?.markDirty();
        return;
      }
      if (state.uploads.isEmpty) {
        if (_ownsPendingBatch) {
          _draftRegistration?.markDirty();
        } else {
          _draftRegistration?.clear();
        }
        return;
      }
      final isTerminal = state.uploads.every(
        (upload) => upload.status == TaskAttachmentUploadStatus.ready,
      );
      if (isTerminal) {
        _ownsPendingBatch = false;
        if (!_isPreparing.value) _draftRegistration?.clear();
      } else {
        if (_ownsPendingBatch) {
          _draftRegistration?.markDirty();
        } else {
          _draftRegistration?.clear();
        }
      }
      return;
    }
    if (_ownsPendingBatch) {
      _draftRegistration?.markDirty();
    } else {
      _draftRegistration?.clear();
    }
  }
}
