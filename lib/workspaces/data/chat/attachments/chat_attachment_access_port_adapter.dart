import 'dart:typed_data';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_attachment_access_port.dart';
import 'package:dio/dio.dart';

/// Adapter pobierania załączników Chat na kontraktach Storage i platformy.
///
/// Storage wystawia krótkotrwały bilet pobrania z autoryzacją zasobu, a zapis
/// pliku na urządzeniu należy do platformowego transportu. Presentation nie
/// widzi ani URL-a, ani nagłówków.
final class ChatAttachmentAccessPortAdapter
    implements ChatAttachmentAccessPort {
  /// Tworzy adapter na repozytorium Storage i transporcie pobierania.
  factory ChatAttachmentAccessPortAdapter({
    required StorageRepository storageRepository,
    required DownloadTransport downloadTransport,
    required ChatApi chatApi,
  }) => ChatAttachmentAccessPortAdapter._(
    storageRepository,
    downloadTransport,
    chatApi,
  );

  ChatAttachmentAccessPortAdapter._(
    this._storageRepository,
    this._downloadTransport,
    this._chatApi,
  );

  final StorageRepository _storageRepository;
  final DownloadTransport _downloadTransport;
  final ChatApi _chatApi;

  @override
  Future<ChatAttachmentAccessFailure?> open(String storageFileId) async {
    try {
      final ticket = await _storageRepository.getDownloadTicket(storageFileId);
      return await ticket.fold(_failureFrom, _saveViaTransport);
    } on Object {
      // Platform transports can throw on unsupported platforms and plugin
      // failures. Keep the port's documented result-based contract intact.
      return const ChatAttachmentAccessFailure(
        code: 'chat.attachment.open_failed',
        message: '',
      );
    }
  }

  @override
  Future<ChatAttachmentSaveResult> saveToStorage({
    required String messageId,
    required String storageFileId,
  }) async {
    try {
      final saved = await _chatApi.saveAttachmentToStorage(
        messageId,
        storageFileId,
      );
      return ChatAttachmentSaveResult(
        storageFileId: saved.storageFileId,
        fileName: saved.fileName,
        canEditOnline: saved.canEditOnline,
      );
    } on DioException catch (error) {
      return ChatAttachmentSaveResult(failure: _failureFromDio(error));
    } on Object catch (error) {
      return ChatAttachmentSaveResult(
        failure: ChatAttachmentAccessFailure(
          code: null,
          message: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Uint8List?> thumbnail({
    required String messageId,
    required String storageFileId,
  }) async {
    try {
      final response = await _chatApi.getAttachmentThumbnail(
        messageId,
        storageFileId,
      );
      return Uint8List.fromList(response.data);
    } on Object {
      return null;
    }
  }

  @override
  Future<Uint8List?> fullImage(String storageFileId) async {
    try {
      final ticket = await _storageRepository.getDownloadTicket(storageFileId);
      final url = ticket.fold((_) => null, (value) => value.downloadUrl);
      if (url == null) return null;
      final bytes = await _downloadTransport.fetchBytes(downloadUrl: url);
      final imageBytes = bytes.fold<Uint8List?>(
        (_) => null,
        (value) => value,
      );
      return imageBytes;
    } on Object {
      return null;
    }
  }

  Future<ChatAttachmentAccessFailure?> _saveViaTransport(
    StorageDownloadTicketResponse ticket,
  ) async {
    final result = await _downloadTransport.downloadUrl(
      downloadUrl: ticket.downloadUrl,
      fileName: ticket.originalFileName,
    );
    return result.fold(_failureFrom, (_) async => null);
  }

  static Future<ChatAttachmentAccessFailure?> _failureFrom(
    ApiError error,
  ) async => ChatAttachmentAccessFailure(
    code: error.apiCode,
    message: error.message,
    traceId: error.traceId,
  );

  static ChatAttachmentAccessFailure _failureFromDio(DioException error) {
    final data = error.response?.data;
    final body = data is Map<String, dynamic>
        ? data
        : const <String, dynamic>{};
    return ChatAttachmentAccessFailure(
      code: body['code'] as String?,
      message:
          body['message'] as String? ??
          'Nie udało się zapisać pliku w Storage.',
      traceId: body['traceId'] as String?,
    );
  }
}
