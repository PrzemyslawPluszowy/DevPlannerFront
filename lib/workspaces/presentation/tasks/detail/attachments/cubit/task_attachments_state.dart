import 'dart:typed_data';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';

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

enum TaskAttachmentUploadStatus {
  queued,
  uploading,
  uploaded,
  completing,
  processing,
  ready,
  unknown,
  failed,
}

/// Widoczny wynik uploadu jednego pliku.
final class TaskAttachmentUploadProgress {
  const TaskAttachmentUploadProgress({
    required this.name,
    required this.status,
    this.error,
    this.apiError,
    this.fileId,
    this.sentBytes = 0,
    this.totalBytes = 0,
  });

  final String name;
  final TaskAttachmentUploadStatus status;
  final String? error;
  final ApiError? apiError;
  final String? fileId;
  final int sentBytes;
  final int totalBytes;

  TaskAttachmentUploadProgress copyWith({
    TaskAttachmentUploadStatus? status,
    String? error,
    ApiError? apiError,
    String? fileId,
    int? sentBytes,
    int? totalBytes,
    bool clearError = false,
  }) => TaskAttachmentUploadProgress(
    name: name,
    status: status ?? this.status,
    error: clearError ? null : error ?? this.error,
    apiError: clearError ? null : apiError ?? this.apiError,
    fileId: fileId ?? this.fileId,
    sentBytes: sentBytes ?? this.sentBytes,
    totalBytes: totalBytes ?? this.totalBytes,
  );
}

sealed class TaskAttachmentsState {
  const TaskAttachmentsState();
}

final class TaskAttachmentsLoading extends TaskAttachmentsState {
  const TaskAttachmentsLoading();
}

final class TaskAttachmentsFailure extends TaskAttachmentsState {
  const TaskAttachmentsFailure(this.message, {this.apiError});
  final String message;
  final ApiError? apiError;
}

final class TaskAttachmentsReady extends TaskAttachmentsState {
  const TaskAttachmentsReady({
    required this.files,
    this.uploads = const [],
    this.isUploading = false,
    this.includeDeleted = false,
    this.isRefreshing = false,
    this.error,
    this.apiError,
  });

  final List<StorageFileResponse> files;
  final List<TaskAttachmentUploadProgress> uploads;
  final bool isUploading;
  final bool includeDeleted;
  final bool isRefreshing;
  final String? error;
  final ApiError? apiError;

  TaskAttachmentsReady copyWith({
    List<StorageFileResponse>? files,
    List<TaskAttachmentUploadProgress>? uploads,
    bool? isUploading,
    bool? includeDeleted,
    bool? isRefreshing,
    String? error,
    ApiError? apiError,
    bool clearError = false,
  }) => TaskAttachmentsReady(
    files: files ?? this.files,
    uploads: uploads ?? this.uploads,
    isUploading: isUploading ?? this.isUploading,
    includeDeleted: includeDeleted ?? this.includeDeleted,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    error: clearError ? null : error ?? this.error,
    apiError: clearError ? null : apiError ?? this.apiError,
  );
}
