import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_link_preview.dart';

/// Pobiera metadane wyłącznie przez autoryzowany endpoint backendu Chat.
// ignore: one_member_abstracts
abstract interface class ChatLinkPreviewRepository {
  /// Zwraca bezpieczny podgląd albo typowany błąd backendu.
  Future<Either<ApiError, ChatLinkPreview>> loadPreview({
    required String conversationId,
    required String url,
  });
}
