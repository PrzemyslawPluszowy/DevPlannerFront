import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_request.dart';

/// Autoryzowany resolver rozmowy związanej z zasobem zewnętrznym.
///
/// Backend jest źródłem prawdy dostępu. Lokalny widok pliku może wyłącznie
/// zdecydować, czy pokazać kandydacką akcję; nie może sam nadać dostępu.
// ignore: one_member_abstracts
abstract interface class ResourceChatRepository {
  /// Idempotentnie rozwiązuje rozmowę dla świeżego kontekstu pliku Storage.
  Future<Either<ApiError, ChatConversation>> resolveFileConversation(
    ResourceChatFileRequest request,
  );
}
