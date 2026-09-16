import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';

part 'storage_models.freezed.dart';
part 'storage_models.g.dart';

/// Payload utworzenia nowego dokumentu z bezpiecznego szablonu backendu.
@freezed
abstract class CreateStorageDocumentPayload
    with _$CreateStorageDocumentPayload {
  /// Określa nazwę, format i zakres dokumentu.
  const factory CreateStorageDocumentPayload({
    required String name,
    required StorageDocumentFormat format,
    required StorageModule module,
    required StorageResourceType resourceType,
    String? projectId,
    String? workspaceId,
    String? folderId,
  }) = _CreateStorageDocumentPayload;

  /// Odtwarza payload z JSON.
  factory CreateStorageDocumentPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateStorageDocumentPayloadFromJson(json);
}

/// Payload żądania wygenerowania biletu uploadu do Storage.
@freezed
abstract class StorageUploadTicketPayload with _$StorageUploadTicketPayload {
  /// Opisuje plik i jego kontekst biznesowy.
  const factory StorageUploadTicketPayload({
    required StorageModule module,
    required StorageResourceType resourceType,
    String? resourceId,
    required String fileName,
    required int fileSizeBytes,
    String? mimeType,
    String? contentSha256,
    String? workspaceId,
    String? projectId,
  }) = _StorageUploadTicketPayload;

  /// Odtwarza payload z JSON.
  factory StorageUploadTicketPayload.fromJson(Map<String, dynamic> json) =>
      _$StorageUploadTicketPayloadFromJson(json);
}

/// Payload zatwierdzenia przesłanego pliku.
@freezed
abstract class CompleteStorageUploadPayload
    with _$CompleteStorageUploadPayload {
  /// Przekazuje rozmiar i opcjonalny hash faktycznie przesłanego pliku.
  const factory CompleteStorageUploadPayload({
    required int fileSizeBytes,
    String? contentSha256,
    String? changeSummary,
  }) = _CompleteStorageUploadPayload;

  /// Odtwarza payload z JSON.
  factory CompleteStorageUploadPayload.fromJson(Map<String, dynamic> json) =>
      _$CompleteStorageUploadPayloadFromJson(json);
}

/// Odpowiedź z biletem presigned URL do uploadu.
@freezed
abstract class StorageDownloadTicketResponse
    with _$StorageDownloadTicketResponse {
  /// Zawiera URL oraz czas jego wygaśnięcia.
  const factory StorageDownloadTicketResponse({
    required String fileId,
    required String originalFileName,
    required String mimeType,
    required int fileSizeBytes,
    required String downloadUrl,
    required DateTime expiresAtUtc,
    String? previewUrl,
  }) = _StorageDownloadTicketResponse;

  /// Odtwarza odpowiedź z JSON.
  factory StorageDownloadTicketResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageDownloadTicketResponseFromJson(json);
}

/// Payload utworzenia udostępnienia pliku.
@freezed
abstract class CreateStorageFileSharePayload
    with _$CreateStorageFileSharePayload {
  /// Określa odbiorcę, poziom dostępu i opcjonalne wygaśnięcie.
  const factory CreateStorageFileSharePayload({
    required StorageShareType shareType,
    required StorageShareAccessLevel accessLevel,
    String? sharedWithUserId,
    String? sharedWithWorkspaceId,
    String? sharedWithProjectId,
    String? password,
    DateTime? expiresAtUtc,
  }) = _CreateStorageFileSharePayload;

  /// Odtwarza payload z JSON.
  factory CreateStorageFileSharePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateStorageFileSharePayloadFromJson(json);
}

/// Odpowiedź z grantem udostępnienia pliku.
@freezed
abstract class StorageFileShareResponse with _$StorageFileShareResponse {
  /// Zawiera odbiorcę, poziom dostępu oraz uprawnienia efektywne.
  const factory StorageFileShareResponse({
    required String id,
    required String fileId,
    required StorageShareType shareType,
    required StorageShareAccessLevel accessLevel,
    String? sharedWithUserId,
    String? sharedWithWorkspaceId,
    String? sharedWithProjectId,
    String? shareToken,
    DateTime? expiresAtUtc,
    required String createdByUserId,
    required DateTime createdAtUtc,
    required StorageEffectiveAccessLevel effectiveAccessLevel,
    required bool canRead,
    required bool canComment,
    required bool canEdit,
    required bool canShare,
    required bool canDelete,
  }) = _StorageFileShareResponse;

  /// Odtwarza odpowiedź z JSON.
  factory StorageFileShareResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFileShareResponseFromJson(json);
}

/// Payload utworzenia wirtualnego folderu.
@freezed
abstract class CreateStorageFolderPayload with _$CreateStorageFolderPayload {
  /// Określa typ, nazwę i kontekst folderu.
  const factory CreateStorageFolderPayload({
    required StorageFolderType folderType,
    required String name,
    String? parentFolderId,
    String? ownerUserId,
    String? workspaceId,
    String? projectId,
  }) = _CreateStorageFolderPayload;

  /// Odtwarza payload z JSON.
  factory CreateStorageFolderPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateStorageFolderPayloadFromJson(json);
}

/// Odpowiedź wirtualnego folderu Storage.
@freezed
abstract class StorageFolderResponse with _$StorageFolderResponse {
  /// Zawiera metadane folderu i uprawnienia bieżącego użytkownika.
  const factory StorageFolderResponse({
    required String id,
    required String name,
    required StorageFolderType folderType,
    String? parentFolderId,
    String? workspaceId,
    String? projectId,
    required bool canRead,
    required bool canComment,
    required bool canEdit,
    required bool canShare,
    required bool canDelete,
    required int itemCount,
    required DateTime updatedAtUtc,
    required StorageEffectiveAccessLevel accessLevel,
  }) = _StorageFolderResponse;

  /// Odtwarza odpowiedź z JSON.
  factory StorageFolderResponse.fromJson(Map<String, dynamic> json) =>
      _$StorageFolderResponseFromJson(json);
}
