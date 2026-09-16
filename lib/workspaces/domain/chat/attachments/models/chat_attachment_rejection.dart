import 'package:equatable/equatable.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';

/// Przyczyna lokalnego odrzucenia jeszcze przed żądaniem uploadu.
enum ChatAttachmentRejectionReason {
  tooManyFiles,
  fileTooLarge,
  messageTooLarge,
}

/// Odrzucony kandydat wraz z typowaną przyczyną.
final class ChatAttachmentRejection extends Equatable {
  /// Tworzy wynik walidacji jednego wejściowego pliku.
  const ChatAttachmentRejection({required this.input, required this.reason});

  final StorageUploadInput input;
  final ChatAttachmentRejectionReason reason;

  @override
  List<Object?> get props => [input, reason];
}
