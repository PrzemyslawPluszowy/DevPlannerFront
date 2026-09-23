import 'package:equatable/equatable.dart';

/// Uporządkowana relacja bezpiecznego pliku Storage z wiadomością Chat.
final class ChatMessageAttachment extends Equatable {
  /// Tworzy attachment zwrócony przez backend po wysłaniu lub odczycie historii.
  const ChatMessageAttachment({
    required this.id,
    required this.messageId,
    required this.storageFileId,
    required this.attachedByUserId,
    required this.position,
    required this.createdAtUtc,
    this.fileName,
    this.fileSizeBytes,
    this.contentType,
    this.isAvailable = false,
  });

  final String id;
  final String messageId;
  final String storageFileId;
  final String attachedByUserId;
  final int position;
  final DateTime createdAtUtc;

  /// Oryginalna nazwa pliku albo `null`, gdy wpis Storage już nie istnieje.
  final String? fileName;

  /// Rozmiar pliku w bajtach albo `null`.
  final int? fileSizeBytes;

  /// Typ MIME pliku albo `null`.
  final String? contentType;

  /// Czy plik istnieje, nie został usunięty i przeszedł skan AV.
  final bool isAvailable;

  /// Etykieta do prezentacji: nazwa pliku, a bez niej identyfikator pliku.
  String get label {
    final name = fileName?.trim();
    return name != null && name.isNotEmpty ? name : storageFileId;
  }

  /// Czy plik jest obrazem, czyli czy warto pokazać miniaturę zamiast ikony.
  ///
  /// Rozstrzyga wyłącznie typ MIME potwierdzony przez serwer; brak typu albo
  /// inna kategoria nie jest zgadywana po rozszerzeniu nazwy.
  bool get isImage =>
      contentType?.toLowerCase().trim().startsWith('image/') == true;

  @override
  List<Object?> get props => [
    id,
    messageId,
    storageFileId,
    attachedByUserId,
    position,
    createdAtUtc,
    fileName,
    fileSizeBytes,
    contentType,
    isAvailable,
  ];
}
