import 'package:devplanner/foundation/error/api_error.dart';

/// Zachowuje pełny błąd portu; toString nie ujawnia payloadu ani sekretów.
final class ChatAttachmentUploadException implements Exception {
  const ChatAttachmentUploadException(this.error);

  final ApiError error;

  @override
  String toString() => 'ChatAttachmentUploadException';
}
