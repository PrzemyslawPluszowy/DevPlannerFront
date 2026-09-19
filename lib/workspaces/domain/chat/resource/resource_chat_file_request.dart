import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';

/// Świeży, autoryzowany kontekst pliku przekazywany do resolvera Resource Chat.
///
/// Identyfikatory workspace i projektu muszą pochodzić z bieżących szczegółów
/// Storage. Provider backendu porównuje je z rekordem pliku przed utworzeniem
/// albo zwróceniem rozmowy.
final class ResourceChatFileRequest {
  const ResourceChatFileRequest({
    required this.fileId,
    required this.workspaceId,
    required this.projectId,
    required this.fileContext,
  });

  final String fileId;
  final String? workspaceId;
  final String? projectId;
  final ResourceChatFileContext fileContext;

  /// Klucz zgodny z wynikiem kanonikalizacji `StorageChatScopeProvider`.
  String get canonicalScopeKey =>
      'resource:files:${fileId.replaceAll('-', '').toLowerCase()}';
}
