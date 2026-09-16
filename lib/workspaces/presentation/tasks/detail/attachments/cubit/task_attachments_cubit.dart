import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:ready_next/workspaces/domain/services/task_attachment_upload_transport.dart';

/// Dane wybranego pliku niezależne od platformowego pickera.
final class TaskAttachmentUploadInput {
  const TaskAttachmentUploadInput({
    required this.name,
    required this.bytes,
    this.mimeType,
  });

  final String name;
  final Uint8List bytes;
  final String? mimeType;
}

enum TaskAttachmentUploadStatus { queued, uploading, uploaded, failed }

/// Widoczny wynik uploadu jednego pliku.
final class TaskAttachmentUploadProgress {
  const TaskAttachmentUploadProgress({
    required this.name,
    required this.status,
    this.error,
  });

  final String name;
  final TaskAttachmentUploadStatus status;
  final String? error;

  TaskAttachmentUploadProgress copyWith({
    TaskAttachmentUploadStatus? status,
    String? error,
    bool clearError = false,
  }) => TaskAttachmentUploadProgress(
    name: name,
    status: status ?? this.status,
    error: clearError ? null : error ?? this.error,
  );
}

sealed class TaskAttachmentsState {
  const TaskAttachmentsState();
}

final class TaskAttachmentsLoading extends TaskAttachmentsState {
  const TaskAttachmentsLoading();
}

final class TaskAttachmentsFailure extends TaskAttachmentsState {
  const TaskAttachmentsFailure(this.message);
  final String message;
}

final class TaskAttachmentsReady extends TaskAttachmentsState {
  const TaskAttachmentsReady({
    required this.files,
    this.uploads = const [],
    this.isUploading = false,
    this.error,
  });

  final List<StorageFileResponse> files;
  final List<TaskAttachmentUploadProgress> uploads;
  final bool isUploading;
  final String? error;

  TaskAttachmentsReady copyWith({
    List<StorageFileResponse>? files,
    List<TaskAttachmentUploadProgress>? uploads,
    bool? isUploading,
    String? error,
    bool clearError = false,
  }) => TaskAttachmentsReady(
    files: files ?? this.files,
    uploads: uploads ?? this.uploads,
    isUploading: isUploading ?? this.isUploading,
    error: clearError ? null : error ?? this.error,
  );
}

/// Orkiestruje bezpieczny wieloplikowy upload załączników pojedynczego taska.
final class TaskAttachmentsCubit extends Cubit<TaskAttachmentsState> {
  TaskAttachmentsCubit({
    required this.repository,
    required this.uploadTransport,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  }) : super(const TaskAttachmentsLoading());

  final TaskAttachmentRepository repository;
  final TaskAttachmentUploadTransport uploadTransport;
  final String workspaceId;
  final String projectId;
  final String taskId;

  Future<void> load() async {
    emit(const TaskAttachmentsLoading());
    final result = await repository.list(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(TaskAttachmentsFailure(error.message)),
      (files) => emit(TaskAttachmentsReady(files: files)),
    );
  }

  /// Wysyła pliki kolejno, aby zachować korelację biletu z wejściem API.
  Future<void> upload(List<TaskAttachmentUploadInput> inputs) async {
    final current = state;
    final validInputs = inputs
        .where(
          (input) => input.name.trim().isNotEmpty && input.bytes.isNotEmpty,
        )
        .toList(growable: false);
    if (current is! TaskAttachmentsReady ||
        current.isUploading ||
        validInputs.isEmpty) {
      return;
    }

    final initialProgress = [
      for (final input in validInputs)
        TaskAttachmentUploadProgress(
          name: input.name,
          status: TaskAttachmentUploadStatus.queued,
        ),
    ];
    emit(
      current.copyWith(
        uploads: initialProgress,
        isUploading: true,
        clearError: true,
      ),
    );
    final ticketsResult = await repository.requestTickets(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
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
    if (isClosed) return;
    final tickets = ticketsResult.fold<List<StorageUploadTicketResponse>?>(
      (error) {
        emit(current.copyWith(isUploading: false, error: error.message));
        return null;
      },
      (response) => response.tickets,
    );
    if (tickets == null) return;
    if (tickets.length != validInputs.length) {
      emit(
        current.copyWith(
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

    final completed = <BulkCompleteFileItemPayload>[];
    var progress = initialProgress;
    for (var index = 0; index < validInputs.length; index++) {
      progress = _replaceProgress(
        progress,
        index,
        status: TaskAttachmentUploadStatus.uploading,
      );
      emit(current.copyWith(uploads: progress, isUploading: true));
      final input = validInputs[index];
      final ticket = tickets[index];
      final uploadResult = await uploadTransport.upload(
        ticket: ticket,
        bytes: input.bytes,
        mimeType: input.mimeType,
      );
      if (isClosed) return;
      uploadResult.fold(
        (error) {
          progress = _replaceProgress(
            progress,
            index,
            status: TaskAttachmentUploadStatus.failed,
            error: error.message,
          );
        },
        (_) {
          progress = _replaceProgress(
            progress,
            index,
            status: TaskAttachmentUploadStatus.uploaded,
          );
          completed.add(
            BulkCompleteFileItemPayload(
              fileId: ticket.fileId,
              fileSizeBytes: input.bytes.length,
            ),
          );
        },
      );
      emit(current.copyWith(uploads: progress, isUploading: true));
    }
    if (completed.isEmpty) {
      emit(current.copyWith(uploads: progress, isUploading: false));
      return;
    }
    final completeResult = await repository.complete(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: BulkCompleteUploadPayload(files: completed),
    );
    if (isClosed) return;
    await completeResult.fold<Future<void>>(
      (error) async {
        emit(
          current.copyWith(
            uploads: progress,
            isUploading: false,
            error: error.message,
          ),
        );
      },
      (_) => load(),
    );
  }

  List<TaskAttachmentUploadProgress> _replaceProgress(
    List<TaskAttachmentUploadProgress> values,
    int index, {
    required TaskAttachmentUploadStatus status,
    String? error,
  }) => [
    for (var currentIndex = 0; currentIndex < values.length; currentIndex++)
      if (currentIndex == index)
        values[currentIndex].copyWith(
          status: status,
          error: error,
          clearError: error == null,
        )
      else
        values[currentIndex],
  ];

  List<TaskAttachmentUploadProgress> _markAll(
    List<TaskAttachmentUploadProgress> values,
    TaskAttachmentUploadStatus status,
    String error,
  ) => [
    for (final value in values) value.copyWith(status: status, error: error),
  ];
}
