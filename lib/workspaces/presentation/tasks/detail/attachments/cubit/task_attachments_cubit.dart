import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachment_batch_upload_runner.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachment_completion_mapper.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachment_recovery_scheduler.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachment_upload_batch.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/session/task_detail_section_lifecycle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'task_attachments_state.dart';

/// Orkiestruje bezpieczny wieloplikowy upload załączników pojedynczego taska.
final class TaskAttachmentsCubit extends Cubit<TaskAttachmentsState> {
  TaskAttachmentsCubit({
    required this.repository,
    required this.uploadTransport,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    this.canEdit,
    this.onAccessLost,
  }) : super(const TaskAttachmentsLoading());

  TaskAttachmentUploadBatch? _pendingBatch;
  UploadCancellationToken? _uploadCancellation;
  bool _includeDeleted = false;
  late final _recovery = TaskAttachmentRecoveryScheduler(
    onRecover: () => _load(automatic: true),
  );

  final TaskAttachmentRepository repository;
  final TaskAttachmentUploadTransport uploadTransport;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final bool Function()? canEdit;
  final void Function(ApiError)? onAccessLost;
  late final _lifecycle = TaskDetailSectionLifecycle(
    isClosed: () => isClosed,
    canEdit: canEdit,
    onAccessLost: onAccessLost,
  );

  Future<void> load() => _load();

  Future<void> setIncludeDeleted(bool includeDeleted) async {
    final current = state;
    if (isClosed ||
        _includeDeleted == includeDeleted ||
        (current is TaskAttachmentsReady && current.isUploading)) {
      return;
    }
    _includeDeleted = includeDeleted;
    await load();
  }

  /// Raportuje błąd lokalnego wyboru/odczytu bez utraty plików i bez REST.
  void reportSelectionError(ApiError error) {
    if (isClosed) return;
    final current = state;
    if (current is TaskAttachmentsReady && !current.isUploading) {
      emit(current.copyWith(error: error.message, apiError: error));
    }
  }

  Future<void> _load({bool automatic = false}) async {
    final previous = state;
    if (previous is TaskAttachmentsReady && previous.isUploading) return;
    _recovery.cancel();
    if (!automatic) _recovery.reset();
    final generation = _lifecycle.begin();
    if (generation == null) return;
    if (previous is TaskAttachmentsReady) {
      emit(
        previous.copyWith(
          includeDeleted: _includeDeleted,
          isRefreshing: true,
          clearError: true,
        ),
      );
    } else {
      emit(const TaskAttachmentsLoading());
    }
    final result = await repository.list(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      includeDeleted: _includeDeleted,
    );
    if (!_lifecycle.isCurrent(generation)) return;
    result.fold(
      (error) {
        final accessFailure =
            error.type == ApiErrorType.unauthorized ||
            error.type == ApiErrorType.forbidden ||
            error.type == ApiErrorType.notFound;
        if (previous is TaskAttachmentsReady && !accessFailure) {
          emit(
            previous.copyWith(
              includeDeleted: _includeDeleted,
              isRefreshing: false,
              error: error.message,
              apiError: error,
            ),
          );
        } else {
          emit(TaskAttachmentsFailure(error.message, apiError: error));
        }
        _lifecycle.reportError(error);
      },
      (files) => emit(
        TaskAttachmentsReady(
          files: files,
          includeDeleted: _includeDeleted,
          uploads: previous is TaskAttachmentsReady
              ? TaskAttachmentCompletionMapper.reconcile(
                  previous.uploads,
                  files,
                )
              : const [],
        ),
      ),
    );
    _recovery.schedule(state);
  }

  /// Zamraża bajty oraz klucz przed pierwszym zapytaniem o bilety.
  Future<void> upload(List<TaskAttachmentUploadInput> inputs) async {
    final current = state;
    if (!_lifecycle.canMutate ||
        current is! TaskAttachmentsReady ||
        current.isUploading ||
        inputs.isEmpty) {
      return;
    }
    if (inputs.any(
      (input) => input.name.trim().isEmpty || input.bytes.isEmpty,
    )) {
      const error = ApiError(
        type: ApiErrorType.validation,
        message: 'Plik musi mieć nazwę i nie może być pusty.',
        apiCode: 'task_upload_invalid_input',
      );
      emit(current.copyWith(error: error.message, apiError: error));
      return;
    }
    final batch = TaskAttachmentUploadBatch.freeze(inputs);
    _pendingBatch = batch;
    await _uploadBatch(batch);
  }

  /// Jawne ponowienie zachowuje te same bajty i klucz, także po timeout biletu.
  Future<void> retryUpload() async {
    final batch = _pendingBatch;
    if (batch != null) await _uploadBatch(batch);
  }

  Future<void> _uploadBatch(TaskAttachmentUploadBatch batch) async {
    final current = state;
    if (!_lifecycle.canMutate ||
        current is! TaskAttachmentsReady ||
        current.isUploading) {
      return;
    }
    final base = current.copyWith(clearError: true);
    _recovery.cancel();
    final cancellation = UploadCancellationToken();
    _uploadCancellation = cancellation;
    final validInputs = batch.inputs;
    final generation = _lifecycle.begin()!;
    final initialProgress = [
      for (final input in validInputs)
        TaskAttachmentUploadProgress(
          name: input.name,
          status: TaskAttachmentUploadStatus.queued,
        ),
    ];
    emit(
      base.copyWith(
        uploads: initialProgress,
        isUploading: true,
        clearError: true,
      ),
    );
    final ticketsResult = await repository.requestTickets(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      idempotencyKey: batch.idempotencyKey,
      payload: BulkTaskUploadTicketPayload(
        files: [
          for (final input in validInputs)
            StorageUploadTicketItemPayload(
              fileName: input.name,
              fileSizeBytes: input.bytes.length,
              mimeType: input.mimeType,
            ),
        ],
      ),
    );
    if (!_lifecycle.isCurrent(generation)) return;
    final tickets = ticketsResult.fold<List<StorageUploadTicketResponse>?>(
      (error) {
        emit(
          base.copyWith(
            uploads: _markAll(
              initialProgress,
              const {
                    ApiErrorType.connectionTimeout,
                    ApiErrorType.sendTimeout,
                    ApiErrorType.receiveTimeout,
                    ApiErrorType.connection,
                    ApiErrorType.server,
                    ApiErrorType.unknown,
                    ApiErrorType.canceled,
                  }.contains(error.type)
                  ? TaskAttachmentUploadStatus.unknown
                  : TaskAttachmentUploadStatus.failed,
              error.message,
              apiError: error,
            ),
            isUploading: false,
            error: error.message,
            apiError: error,
          ),
        );
        _lifecycle.reportError(error);
        return null;
      },
      (response) => response.tickets,
    );
    if (tickets == null) return;
    if (tickets.length != validInputs.length ||
        tickets.map((ticket) => ticket.fileId).toSet().length !=
            tickets.length) {
      emit(
        base.copyWith(
          uploads: _markAll(
            initialProgress,
            TaskAttachmentUploadStatus.failed,
            'Backend zwrócił niepełną listę biletów uploadu.',
          ),
          isUploading: false,
          error: 'Backend zwrócił niepełną listę biletów uploadu.',
        ),
      );
      return;
    }

    final uploaded = await TaskAttachmentBatchUploadRunner(uploadTransport).run(
      inputs: validInputs,
      tickets: tickets,
      initialProgress: initialProgress,
      cancellation: cancellation,
      isCurrent: () => _lifecycle.isCurrent(generation),
      onProgress: (progress) {
        if (_lifecycle.isCurrent(generation)) {
          emit(base.copyWith(uploads: progress, isUploading: true));
        }
      },
    );
    if (!_lifecycle.isCurrent(generation)) return;
    final completed = uploaded.completed;
    var progress = uploaded.progress;
    if (completed.isEmpty) {
      emit(base.copyWith(uploads: progress, isUploading: false));
      return;
    }
    progress = [
      for (final value in progress)
        if (value.status == TaskAttachmentUploadStatus.uploaded)
          value.copyWith(status: TaskAttachmentUploadStatus.completing)
        else
          value,
    ];
    emit(base.copyWith(uploads: progress, isUploading: true));
    final completeResult = await repository.complete(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: BulkCompleteUploadPayload(files: completed),
    );
    if (!_lifecycle.isCurrent(generation)) return;
    final nextProgress = completeResult.fold(
      (error) {
        _lifecycle.reportError(error);
        return [
          for (final value in progress)
            if (value.status == TaskAttachmentUploadStatus.completing)
              value.copyWith(
                status: TaskAttachmentUploadStatus.unknown,
                error: error.message,
                apiError: error,
              )
            else
              value,
        ];
      },
      (response) => TaskAttachmentCompletionMapper.map(progress, response),
    );
    final failure = completeResult.fold<ApiError?>(
      (error) => error,
      (_) => null,
    );
    if (!_lifecycle.isCurrent(generation)) return;
    emit(
      base.copyWith(
        uploads: nextProgress,
        isUploading: false,
        error: failure?.message,
        apiError: failure,
      ),
    );
    await load();
  }

  /// Anuluje PUT i odrzuca spóźnione ticket/complete odpowiedzi.
  /// Stan serwera wymaga GET; anulowanie lokalne nie usuwa rezerwacji.
  void cancelUpload() {
    final current = state;
    if (isClosed || current is! TaskAttachmentsReady || !current.isUploading) {
      return;
    }
    _recovery.cancel();
    _lifecycle.invalidate();
    _uploadCancellation?.cancel();
    const error = ApiError(
      type: ApiErrorType.canceled,
      message: 'Wysyłanie przerwano. Sprawdź stan plików na serwerze.',
      apiCode: 'task_upload_canceled',
    );
    emit(
      current.copyWith(
        isUploading: false,
        error: error.message,
        apiError: error,
        uploads: [
          for (final value in current.uploads)
            if (value.status == TaskAttachmentUploadStatus.ready ||
                value.status == TaskAttachmentUploadStatus.failed)
              value
            else
              value.copyWith(
                status: TaskAttachmentUploadStatus.unknown,
                error: error.message,
                apiError: error,
              ),
        ],
      ),
    );
  }

  List<TaskAttachmentUploadProgress> _markAll(
    List<TaskAttachmentUploadProgress> values,
    TaskAttachmentUploadStatus status,
    String error, {
    ApiError? apiError,
  }) => [
    for (final value in values)
      value.copyWith(status: status, error: error, apiError: apiError),
  ];
  @override
  Future<void> close() {
    _recovery.dispose();
    _uploadCancellation?.cancel();
    _uploadCancellation = null;
    _pendingBatch = null;
    _lifecycle.invalidate();
    return super.close();
  }
}
