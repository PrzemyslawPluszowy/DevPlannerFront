import 'package:devplanner/workspaces/data/chat/models/chat_members_presence_response.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_api.g.dart';

/// Klient Retrofit kontraktu Chat backendu Workspaces.
@RestApi()
abstract class ChatApi {
  /// Tworzy klienta API Chat.
  factory ChatApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _ChatApi;

  /// Rozwiązuje albo tworzy rozmowę dla Scope.
  @POST('/api/v1/chat/conversations/resolve')
  Future<ChatConversationResponse> resolve(
    @Body() ResolveChatConversationPayload payload,
  );

  /// Pobiera aktywne rozmowy bieżącego użytkownika.
  @GET('/api/v1/chat/conversations')
  Future<List<ChatConversationResponse>> listConversations();

  /// Pobiera zarchiwizowane rozmowy bieżącego użytkownika.
  @GET('/api/v1/chat/conversations/archived')
  Future<List<ChatConversationResponse>> listArchivedConversations();

  /// Pobiera szczegóły rozmowy po jej identyfikatorze.
  @GET('/api/v1/chat/conversations/{conversationId}')
  Future<ChatConversationResponse> getConversation(
    @Path('conversationId') String conversationId,
  );

  /// Aktualizuje nazwę i politykę publikacji rozmowy.
  @PATCH('/api/v1/chat/conversations/{conversationId}')
  Future<ChatConversationResponse> updateConversation(
    @Path('conversationId') String conversationId,
    @Body() UpdateChatConversationPayload payload,
  );

  /// Archiwizuje rozmowę.
  @DELETE('/api/v1/chat/conversations/{conversationId}')
  Future<void> archiveConversation(
    @Path('conversationId') String conversationId,
  );

  /// Przywraca zarchiwizowaną rozmowę.
  @POST('/api/v1/chat/conversations/{conversationId}/restore')
  Future<void> restoreConversation(
    @Path('conversationId') String conversationId,
  );

  /// Oznacza członkostwo bieżącego użytkownika jako opuszczone.
  @POST('/api/v1/chat/conversations/{conversationId}/leave')
  Future<void> leaveConversation(@Path('conversationId') String conversationId);

  /// Pobiera placementy rozmowy.
  @GET('/api/v1/chat/conversations/{conversationId}/placements')
  Future<List<ChatPlacementResponse>> listPlacements(
    @Path('conversationId') String conversationId,
  );

  /// Dodaje placement zasobu do rozmowy.
  @POST('/api/v1/chat/conversations/{conversationId}/placements')
  Future<ChatPlacementResponse> addPlacement(
    @Path('conversationId') String conversationId,
    @Body() AddChatPlacementPayload payload,
  );

  /// Usuwa placement rozmowy.
  @DELETE(
    '/api/v1/chat/conversations/{conversationId}/placements/{placementId}',
  )
  Future<void> removePlacement(
    @Path('conversationId') String conversationId,
    @Path('placementId') String placementId,
  );

  /// Pobiera cursorową historię rozmowy.
  @GET('/api/v1/chat/conversations/{conversationId}/messages')
  Future<CursorPageResponse<ChatMessageResponse>> listMessages(
    @Path('conversationId') String conversationId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Pobiera historię edycji wiadomości.
  @GET('/api/v1/chat/messages/{messageId}/revisions')
  Future<List<ChatMessageRevisionResponse>> listRevisions(
    @Path('messageId') String messageId,
  );

  /// Wydaje tymczasową sesję uploadu załączników dla jednej rozmowy.
  @POST('/api/v1/chat/conversations/{conversationId}/attachment-sessions')
  Future<ChatTemporaryAttachmentSessionResponse> createAttachmentSession(
    @Path('conversationId') String conversationId,
  );

  /// Anuluje niezużytą tymczasową sesję uploadu załączników.
  @DELETE(
    '/api/v1/chat/conversations/{conversationId}/attachment-sessions/{sessionId}',
  )
  Future<void> cancelAttachmentSession(
    @Path('conversationId') String conversationId,
    @Path('sessionId') String sessionId,
  );

  /// Kopiuje prywatny plik do istniejącej sesji tymczasowych załączników.
  @POST(
    '/api/v1/chat/conversations/{conversationId}/attachment-sessions/{sessionId}/private-files',
  )
  Future<CopyPrivateFileToChatAttachmentResponse>
  copyPrivateFileToAttachmentSession(
    @Path('conversationId') String conversationId,
    @Path('sessionId') String sessionId,
    @Body() CopyPrivateFileToChatAttachmentPayload payload,
  );

  /// Pobiera cursorową historię odpowiedzi wątku.
  @GET(
    '/api/v1/chat/conversations/{conversationId}/threads/{threadRootMessageId}/messages',
  )
  Future<CursorPageResponse<ChatMessageResponse>> listThreadMessages(
    @Path('conversationId') String conversationId,
    @Path('threadRootMessageId') String threadRootMessageId, {
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  /// Pobiera skompaktowany kontekst rozmowy.
  @GET('/api/v1/chat/conversations/{conversationId}/context')
  Future<ChatContextResponse> getContext(
    @Path('conversationId') String conversationId, {
    @Query('recentLimit') int? recentLimit,
  });

  /// Pobiera okno wiadomości wokół wskazanej wiadomości.
  @GET(
    '/api/v1/chat/conversations/{conversationId}/messages/{messageId}/window',
  )
  Future<ChatMessageWindowResponse> getMessageWindow(
    @Path('conversationId') String conversationId,
    @Path('messageId') String messageId, {
    @Query('before') int? before,
    @Query('after') int? after,
  });

  /// Dodaje członków do rozmowy.
  @POST('/api/v1/chat/conversations/{conversationId}/members')
  Future<List<ChatMemberResponse>> addMembers(
    @Path('conversationId') String conversationId,
    @Body() AddChatMembersPayload payload,
  );

  /// Listuje aktywnych członków rozmowy.
  @GET('/api/v1/chat/conversations/{conversationId}/members')
  Future<List<ChatMemberResponse>> listMembers(
    @Path('conversationId') String conversationId,
  );

  /// Odczytuje obecność aplikacyjną uczestników bez zmiany członkostwa.
  @GET('/api/v1/chat/conversations/{conversationId}/members/presence')
  Future<ChatMembersPresenceResponse> loadMembersPresence(
    @Path('conversationId') String conversationId,
  );

  /// Zmienia rolę członka rozmowy.
  @PATCH(
    '/api/v1/chat/conversations/{conversationId}/members/{targetUserId}/role',
  )
  Future<ChatMemberResponse> updateMemberRole(
    @Path('conversationId') String conversationId,
    @Path('targetUserId') String targetUserId,
    @Body() UpdateChatMemberRolePayload payload,
  );

  /// Usuwa członka z rozmowy.
  @DELETE('/api/v1/chat/conversations/{conversationId}/members/{targetUserId}')
  Future<void> removeMember(
    @Path('conversationId') String conversationId,
    @Path('targetUserId') String targetUserId,
  );

  /// Wysyła wiadomość w rozmowie.
  @POST('/api/v1/chat/conversations/{conversationId}/messages')
  Future<ChatMessageResponse> sendMessage(
    @Path('conversationId') String conversationId,
    @Body() SendChatMessagePayload payload,
  );

  /// Potwierdza odczyt wiadomości w rozmowie.
  @POST('/api/v1/chat/conversations/{conversationId}/messages/{messageId}/read')
  Future<void> markRead(
    @Path('conversationId') String conversationId,
    @Path('messageId') String messageId,
  );

  /// Edytuje wiadomość.
  @PATCH('/api/v1/chat/messages/{messageId}')
  Future<ChatMessageResponse> editMessage(
    @Path('messageId') String messageId,
    @Body() UpdateChatMessagePayload payload,
  );

  /// Usuwa logicznie wiadomość z kontrolą wersji.
  @DELETE('/api/v1/chat/messages/{messageId}')
  Future<void> deleteMessage(
    @Path('messageId') String messageId,
    @Query('version') int version,
  );

  /// Przekazuje wiadomość do innej rozmowy.
  @POST('/api/v1/chat/messages/{messageId}/forward')
  Future<ChatMessageResponse> forwardMessage(
    @Path('messageId') String messageId,
    @Body() ForwardChatMessagePayload payload,
  );

  /// Wycisza rozmowę dla bieżącego użytkownika.
  @PUT('/api/v1/chat/conversations/{conversationId}/mute')
  Future<void> muteConversation(
    @Path('conversationId') String conversationId,
    @Body() ChatMutePayload payload,
  );

  /// Wycisza wątek wiadomości.
  @PUT(
    '/api/v1/chat/conversations/{conversationId}/threads/{threadRootMessageId}/mute',
  )
  Future<void> muteThread(
    @Path('conversationId') String conversationId,
    @Path('threadRootMessageId') String threadRootMessageId,
    @Body() ChatThreadMutePayload payload,
  );

  /// Usuwa wyciszenie wątku.
  @DELETE(
    '/api/v1/chat/conversations/{conversationId}/threads/{threadRootMessageId}/mute',
  )
  Future<void> unmuteThread(
    @Path('conversationId') String conversationId,
    @Path('threadRootMessageId') String threadRootMessageId,
  );

  /// Pobiera przypięte wiadomości rozmowy.
  @GET('/api/v1/chat/conversations/{conversationId}/pins')
  Future<List<ChatPinnedMessageResponse>> listPins(
    @Path('conversationId') String conversationId,
  );

  /// Przypina wiadomość w rozmowie.
  @POST('/api/v1/chat/conversations/{conversationId}/messages/{messageId}/pin')
  Future<ChatPinnedMessageResponse> pinMessage(
    @Path('conversationId') String conversationId,
    @Path('messageId') String messageId,
  );

  /// Odpina wiadomość w rozmowie.
  @DELETE(
    '/api/v1/chat/conversations/{conversationId}/messages/{messageId}/pin',
  )
  Future<void> unpinMessage(
    @Path('conversationId') String conversationId,
    @Path('messageId') String messageId,
  );

  /// Pobiera prywatne zakładki użytkownika.
  @GET('/api/v1/chat/bookmarks')
  Future<List<ChatBookmarkResponse>> listBookmarks();

  /// Zapisuje wiadomość w prywatnych zakładkach.
  @PUT('/api/v1/chat/messages/{messageId}/bookmark')
  Future<ChatBookmarkResponse> bookmark(
    @Path('messageId') String messageId,
    @Body() ChatBookmarkPayload payload,
  );

  /// Usuwa wiadomość z prywatnych zakładek.
  @DELETE('/api/v1/chat/messages/{messageId}/bookmark')
  Future<void> removeBookmark(@Path('messageId') String messageId);

  /// Pobiera załączniki wiadomości.
  @GET('/api/v1/chat/messages/{messageId}/attachments')
  Future<List<ChatAttachmentResponse>> listAttachments(
    @Path('messageId') String messageId,
  );

  /// Pobiera miniaturę JPEG załącznika przez autoryzowany endpoint Chat.
  @GET(
    '/api/v1/chat/messages/{messageId}/attachments/{storageFileId}/thumbnail',
  )
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> getAttachmentThumbnail(
    @Path('messageId') String messageId,
    @Path('storageFileId') String storageFileId,
  );

  /// Dołącza plik Storage do wiadomości.
  @POST('/api/v1/chat/messages/{messageId}/attachments')
  Future<ChatAttachmentResponse> attachFile(
    @Path('messageId') String messageId,
    @Body() AttachChatFilePayload payload,
  );

  /// Kopiuje załącznik aktywnej wiadomości do prywatnego Storage.
  @POST(
    '/api/v1/chat/messages/{messageId}/attachments/{storageFileId}/save-to-storage',
  )
  Future<SaveChatAttachmentToStorageResponse> saveAttachmentToStorage(
    @Path('messageId') String messageId,
    @Path('storageFileId') String storageFileId,
  );

  /// Odłącza plik Storage od wiadomości.
  @DELETE('/api/v1/chat/messages/{messageId}/attachments/{storageFileId}')
  Future<void> detachFile(
    @Path('messageId') String messageId,
    @Path('storageFileId') String storageFileId,
  );

  /// Pobiera stany doręczenia wiadomości.
  @GET('/api/v1/chat/messages/{messageId}/delivery')
  Future<List<ChatMessageDeliveryResponse>> listDelivery(
    @Path('messageId') String messageId,
  );

  /// Oznacza wiadomość jako doręczoną.
  @POST('/api/v1/chat/messages/{messageId}/delivered')
  Future<void> markDelivered(@Path('messageId') String messageId);

  /// Pobiera reakcje wiadomości.
  @GET('/api/v1/chat/messages/{messageId}/reactions')
  Future<List<ChatReactionResponse>> listReactions(
    @Path('messageId') String messageId,
  );

  /// Dodaje reakcję emoji do wiadomości.
  @POST('/api/v1/chat/messages/{messageId}/reactions')
  Future<ChatReactionResponse> addReaction(
    @Path('messageId') String messageId,
    @Body() AddChatReactionPayload payload,
  );

  /// Usuwa reakcję emoji użytkownika.
  @DELETE('/api/v1/chat/messages/{messageId}/reactions/{emoji}')
  Future<void> removeReaction(
    @Path('messageId') String messageId,
    @Path('emoji') String emoji,
  );

  /// Pobiera szkic wiadomości rozmowy.
  @GET('/api/v1/chat/conversations/{conversationId}/draft')
  Future<ChatDraftResponse?> getDraft(
    @Path('conversationId') String conversationId,
  );

  /// Zapisuje albo aktualizuje szkic wiadomości.
  @PUT('/api/v1/chat/conversations/{conversationId}/draft')
  Future<ChatDraftResponse> upsertDraft(
    @Path('conversationId') String conversationId,
    @Body() UpsertChatDraftPayload payload,
  );

  /// Usuwa szkic wiadomości rozmowy.
  @DELETE('/api/v1/chat/conversations/{conversationId}/draft')
  Future<void> deleteDraft(@Path('conversationId') String conversationId);
}

/// Zgłasza błędy dekodowania odpowiedzi, które powstają już po interceptorach Dio.
final class ChatParseErrorLogger implements ParseErrorLogger {
  const ChatParseErrorLogger();

  @override
  void logError(
    Object error,
    StackTrace stackTrace,
    RequestOptions options, {
    Response<dynamic>? response,
  }) {
    if (!kDebugMode) return;
    debugPrint(
      '[CHAT][PARSING] ${options.method} ${options.path} | '
      'error=${error.runtimeType} | status=${response?.statusCode}',
    );
    debugPrintStack(label: '[CHAT][PARSING]', stackTrace: stackTrace);
  }
}
