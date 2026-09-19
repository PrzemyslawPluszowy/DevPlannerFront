import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/chat/attachments/ports/chat_attachment_session_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';

/// Data-layer adapter sesji Chat i Storage; nie udostępnia presigned URL UI.
final class ChatAttachmentUploadPortAdapter
    implements ChatAttachmentUploadPort {
  /// Tworzy adapter na kontraktach sesji Chat, Storage oraz binarnego uploadu.
  factory ChatAttachmentUploadPortAdapter({
    required ChatAttachmentSessionRepository sessionRepository,
    required StorageRepository storageRepository,
    required UploadTransport uploadTransport,
  }) => ChatAttachmentUploadPortAdapter._(
    sessionRepository,
    storageRepository,
    uploadTransport,
  );

  ChatAttachmentUploadPortAdapter._(
    this._sessionRepository,
    this._storageRepository,
    this._uploadTransport,
  );

  final ChatAttachmentSessionRepository _sessionRepository;
  final StorageRepository _storageRepository;
  final UploadTransport _uploadTransport;
  final _reservations = <String, _ChatAttachmentUploadReservation>{};

  @override
  Future<ChatAttachmentUploadSession> createSession(
    String conversationId,
  ) async {
    final session = await _unwrap(
      _sessionRepository.createAttachmentSession(conversationId),
    );
    return ChatAttachmentUploadSession(session.id);
  }

  @override
  Future<ChatAttachmentTicket> createTicket({
    required String sessionId,
    required StorageUploadInput input,
  }) async {
    final ticket = await _unwrap(
      _storageRepository.requestUploadTicket(
        StorageUploadTicketPayload(
          module: StorageModule.workspaces,
          resourceType: StorageResourceType.comment,
          resourceId: sessionId,
          fileName: input.name,
          fileSizeBytes: input.size,
          mimeType: input.mimeType,
        ),
      ),
    );
    _reservations[ticket.fileId] = _ChatAttachmentUploadReservation(
      sessionId: sessionId,
      ticket: ticket,
      fileSizeBytes: input.size,
    );
    return ChatAttachmentTicket(ticket.fileId);
  }

  @override
  Future<void> upload(
    ChatAttachmentTicket ticket,
    StorageUploadInput input,
  ) async {
    final reservation = _reservationFor(ticket.storageFileId);
    await _unwrap(
      _uploadTransport.upload(ticket: reservation.ticket, input: input),
    );
  }

  @override
  Future<void> complete(String storageFileId) async {
    final reservation = _reservationFor(storageFileId);
    await _unwrap(
      _storageRepository.completeUpload(
        fileId: storageFileId,
        fileSizeBytes: reservation.fileSizeBytes,
      ),
    );
    _reservations.remove(storageFileId);
  }

  @override
  Future<ChatAttachmentRemoteStatus> status(String storageFileId) async {
    final details = await _unwrap(
      _storageRepository.getFileDetails(storageFileId),
    );
    return _mapStatus(details);
  }

  @override
  Future<void> cancelSession(String conversationId, String sessionId) async {
    await _unwrap(
      _sessionRepository.cancelAttachmentSession(
        conversationId: conversationId,
        sessionId: sessionId,
      ),
    );
    _reservations.removeWhere(
      (_, reservation) => reservation.sessionId == sessionId,
    );
  }

  _ChatAttachmentUploadReservation _reservationFor(String storageFileId) {
    final reservation = _reservations[storageFileId];
    if (reservation == null) {
      throw StateError('Nieznany ticket uploadu załącznika Chat.');
    }
    return reservation;
  }

  static Future<T> _unwrap<T>(Future<Either<ApiError, T>> result) async =>
      (await result).fold(
        (error) => throw _ChatAttachmentUploadPortException(error),
        (value) => value,
      );

  static ChatAttachmentRemoteStatus _mapStatus(
    StorageFileDetailsResponse details,
  ) {
    final file = details.file;
    if (file.scanStatus == StorageScanStatus.infected) {
      return ChatAttachmentRemoteStatus.infected;
    }
    if (file.processingStatus == StorageProcessingStatus.failed ||
        file.scanStatus == StorageScanStatus.skipped) {
      return ChatAttachmentRemoteStatus.failed;
    }
    if (file.scanStatus == StorageScanStatus.clean &&
        file.processingStatus == StorageProcessingStatus.ready) {
      return ChatAttachmentRemoteStatus.cleanReady;
    }
    if (file.processingStatus == StorageProcessingStatus.queued ||
        file.processingStatus == StorageProcessingStatus.processing) {
      return ChatAttachmentRemoteStatus.processing;
    }
    return ChatAttachmentRemoteStatus.pending;
  }
}

final class _ChatAttachmentUploadPortException implements Exception {
  const _ChatAttachmentUploadPortException(this.error);

  final ApiError error;

  @override
  String toString() => error.message;
}

final class _ChatAttachmentUploadReservation {
  const _ChatAttachmentUploadReservation({
    required this.sessionId,
    required this.ticket,
    required this.fileSizeBytes,
  });

  final String sessionId;
  final StorageUploadTicketResponse ticket;
  final int fileSizeBytes;
}
