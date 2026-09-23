import 'dart:typed_data';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_attachment_access_port.dart';

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
  }) => ChatAttachmentAccessPortAdapter._(
    storageRepository,
    downloadTransport,
  );

  ChatAttachmentAccessPortAdapter._(
    this._storageRepository,
    this._downloadTransport,
  );

  final StorageRepository _storageRepository;
  final DownloadTransport _downloadTransport;

  @override
  Future<ChatAttachmentAccessFailure?> open(String storageFileId) async {
    final ticket = await _storageRepository.getDownloadTicket(storageFileId);
    return ticket.fold(_failureFrom, _saveViaTransport);
  }

  @override
  Future<Uint8List?> thumbnail(String storageFileId) async {
    final ticket = await _storageRepository.getDownloadTicket(storageFileId);
    final url = ticket.fold((_) => null, (value) => value.downloadUrl);
    if (url == null) return null;
    final bytes = await _downloadTransport.fetchBytes(downloadUrl: url);
    return bytes.fold((_) => null, (value) => value);
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
}
