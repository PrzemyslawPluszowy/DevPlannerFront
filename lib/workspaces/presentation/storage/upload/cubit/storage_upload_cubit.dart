import 'dart:async';

import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/payloads/storage_payloads.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit zarządzający asynchroniczną kolejką uploadu plików z limitem równoległości.
final class StorageUploadCubit extends Cubit<StorageUploadState> {
  /// Tworzy instancję kolejki uploadu.
  StorageUploadCubit({
    required this._repository,
    required this._uploadTransport,
    this.onUploadCompleted,
    this.maxParallelUploads = 3,
    this.maxFileSizeBytes = 20 * 1024 * 1024, // 20 MB domyślnie
  }) : super(const StorageUploadState());

  final StorageRepository _repository;
  final UploadTransport _uploadTransport;

  /// Presentation callback fired after backend confirmation of one upload.
  final Future<void> Function()? onUploadCompleted;

  /// Maksymalna liczba plików przesyłanych równolegle.
  final int maxParallelUploads;

  /// Maksymalny dozwolony rozmiar pliku w bajtach.
  final int maxFileSizeBytes;

  var _activeJobs = 0;
  int _counter = 0;

  /// Dodaje listę plików do kolejki uploadu i uruchamia przetwarzanie.
  void enqueue(List<StorageUploadInput> inputs, StorageScope scope) {
    if (inputs.isEmpty || !scope.canCreateContent) return;

    final newItems = <StorageUploadQueueItem>[];
    for (final input in inputs) {
      _counter++;
      final id = 'upload-$_counter-${DateTime.now().millisecondsSinceEpoch}';

      if (input.size > maxFileSizeBytes) {
        newItems.add(
          StorageUploadQueueItem(
            id: id,
            input: input,
            status: StorageUploadItemStatus.failed,
            errorCode: StorageUploadMessage.fileTooLarge,
          ),
        );
      } else {
        newItems.add(
          StorageUploadQueueItem(
            id: id,
            input: input,
            cancelToken: UploadCancellationToken(),
          ),
        );
      }
    }

    emit(
      state.copyWith(items: [...state.items, ...newItems], isExpanded: true),
    );
    _processQueue(scope);
  }

  /// Ponawia nieudany element z kolejki.
  void retry(String itemId, StorageScope scope) {
    final index = state.items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    final updated = [...state.items];
    updated[index] = updated[index].copyWith(
      status: StorageUploadItemStatus.queued,
      cancelToken: UploadCancellationToken(),
    );

    emit(state.copyWith(items: updated));
    _processQueue(scope);
  }

  /// Anuluje pojedynczy aktywny upload.
  void cancel(String itemId) {
    final index = state.items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;

    final item = state.items[index];
    item.cancelToken?.cancel();

    _updateItem(
      itemId,
      (i) => i.copyWith(
        status: StorageUploadItemStatus.cancelled,
        errorCode: StorageUploadMessage.cancelledByUser,
      ),
    );
  }

  /// Anuluje wszystkie aktywne zadania.
  void cancelAll() {
    for (final item in state.items) {
      if (item.isActive) {
        item.cancelToken?.cancel();
      }
    }

    final updated = state.items.map((i) {
      if (i.isActive) {
        return i.copyWith(
          status: StorageUploadItemStatus.cancelled,
          errorCode: StorageUploadMessage.uploadCancelled,
        );
      }
      return i;
    }).toList();

    emit(state.copyWith(items: updated));
  }

  /// Czyści zakończone lub anulowane pozycje z kolejki.
  void clearCompleted() {
    final remaining = state.items
        .where(
          (i) =>
              i.status != StorageUploadItemStatus.done &&
              i.status != StorageUploadItemStatus.cancelled,
        )
        .toList();
    emit(state.copyWith(items: remaining));
  }

  /// Przełącza widoczność panelu listy uploadów.
  void toggleExpanded() {
    emit(state.copyWith(isExpanded: !state.isExpanded));
  }

  /// Sterownik przetwarzania kolejki według limitu współbieżności.
  void _processQueue(StorageScope scope) {
    while (_activeJobs < maxParallelUploads) {
      final nextItem = state.items.cast<StorageUploadQueueItem?>().firstWhere(
        (i) => i != null && i.status == StorageUploadItemStatus.queued,
        orElse: () => null,
      );

      if (nextItem == null) break;

      _activeJobs++;
      unawaited(_startUpload(nextItem, scope));
    }
  }

  Future<void> _startUpload(
    StorageUploadQueueItem item,
    StorageScope scope,
  ) async {
    _updateItem(
      item.id,
      (i) => i.copyWith(status: StorageUploadItemStatus.uploading),
    );

    final resourceType = scope.uploadResourceType;
    if (resourceType == null) {
      _finishJob(
        item.id,
        (queueItem) => queueItem.copyWith(
          status: StorageUploadItemStatus.failed,
          errorCode: StorageUploadMessage.unsupportedScope,
        ),
        scope,
      );
      return;
    }

    final payload = StorageUploadTicketPayload(
      fileName: item.input.name,
      fileSizeBytes: item.input.size,
      mimeType: item.input.mimeType,
      module: scope.module ?? StorageModule.workspaces,
      resourceType: resourceType,
      resourceId: scope.uploadResourceId,
      workspaceId: scope.workspaceId,
      projectId: scope.projectId,
    );

    final ticketResult = await _repository.requestUploadTicket(payload);
    if (isClosed) return;

    if (ticketResult.isLeft()) {
      _finishJob(item.id, (i) {
        var msg = '';
        ticketResult.leftMap((err) => msg = err.message);
        return i.copyWith(
          status: StorageUploadItemStatus.failed,
          errorMessage: msg,
          errorCode: ticketResult.isLeft()
              ? StorageUploadMessage.ticketReservationFailed
              : null,
        );
      }, scope);
      return;
    }

    final ticket = ticketResult.getOrElse(
      () => throw StateError('Brak biletu'),
    );

    final uploadResult = await _uploadTransport.upload(
      ticket: ticket,
      input: item.input,
      cancelToken: item.cancelToken,
      onProgress: (sent, total) {
        if (isClosed) return;
        final prog = total > 0 ? (sent / total).clamp(0.0, 1.0) : 0.0;
        _updateItem(
          item.id,
          (i) => i.copyWith(
            bytesSent: sent,
            totalBytes: total,
            progress: prog,
          ),
        );
      },
    );
    if (isClosed) return;

    if (uploadResult.isLeft()) {
      _finishJob(item.id, (i) {
        var msg = '';
        uploadResult.leftMap((err) {
          msg = err.message;
        });
        var isCancelled = false;
        uploadResult.leftMap((error) {
          isCancelled = error.type == ApiErrorType.canceled;
        });
        final status = isCancelled
            ? StorageUploadItemStatus.cancelled
            : StorageUploadItemStatus.failed;
        return i.copyWith(
          status: status,
          errorMessage: msg,
          errorCode: isCancelled
              ? StorageUploadMessage.uploadCancelled
              : StorageUploadMessage.transferFailed,
        );
      }, scope);
      return;
    }

    _updateItem(
      item.id,
      (i) =>
          i.copyWith(status: StorageUploadItemStatus.completing, progress: 1.0),
    );

    final completeResult = await _repository.completeUpload(
      fileId: ticket.fileId,
      fileSizeBytes: item.input.size,
    );
    if (isClosed) return;

    if (completeResult.isLeft()) {
      _finishJob(item.id, (i) {
        var msg = '';
        completeResult.leftMap((err) => msg = err.message);
        return i.copyWith(
          status: StorageUploadItemStatus.failed,
          errorMessage: msg,
          errorCode: StorageUploadMessage.completionFailed,
        );
      }, scope);
      return;
    }

    final uploadedFile = completeResult.getOrElse(
      () => throw StateError('Brak pliku'),
    );

    // Jeśli upload nastąpił w kontekście folderu, upewniamy się że utworzono placement
    if (scope.folderId != null) {
      final placementResult = await _repository.createFilePlacement(
        fileId: uploadedFile.id,
        folderId: scope.folderId!,
      );
      if (isClosed) return;
      if (placementResult.isLeft()) {
        _finishJob(item.id, (queueItem) {
          var message = '';
          placementResult.leftMap((error) => message = error.message);
          return queueItem.copyWith(
            status: StorageUploadItemStatus.failed,
            uploadedFile: uploadedFile,
            errorMessage: message,
            errorCode: StorageUploadMessage.placementFailed,
          );
        }, scope);
        return;
      }
    }

    _finishJob(
      item.id,
      (i) => i.copyWith(
        status: StorageUploadItemStatus.done,
        uploadedFile: uploadedFile,
      ),
      scope,
    );
  }

  void _updateItem(
    String id,
    StorageUploadQueueItem Function(StorageUploadQueueItem) update,
  ) {
    if (isClosed) return;
    final index = state.items.indexWhere((i) => i.id == id);
    if (index == -1) return;

    final updated = [...state.items];
    updated[index] = update(updated[index]);
    emit(state.copyWith(items: updated));
  }

  void _finishJob(
    String id,
    StorageUploadQueueItem Function(StorageUploadQueueItem) update,
    StorageScope scope,
  ) {
    _updateItem(id, update);
    final completed =
        !isClosed &&
        state.items.any(
          (item) =>
              item.id == id && item.status == StorageUploadItemStatus.done,
        );
    if (completed) {
      unawaited(onUploadCompleted?.call() ?? Future<void>.value());
    }
    _activeJobs--;
    if (_activeJobs < 0) _activeJobs = 0;
    _processQueue(scope);
  }

  @override
  Future<void> close() {
    cancelAll();
    return super.close();
  }
}
