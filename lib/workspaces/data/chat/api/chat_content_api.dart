import 'package:devplanner/workspaces/data/chat/models/chat_link_policy_dto.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'chat_content_api.g.dart';

/// Kontrakt polityki linków, podglądów i tekstowych załączników Chat.
@RestApi()
abstract class ChatContentApi {
  /// Tworzy klienta treści Chat na sesyjnym transporcie HTTP.
  factory ChatContentApi(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _ChatContentApi;

  /// Pobiera serwerową politykę linków i długich tekstów.
  @GET('/api/v1/chat/link-policy')
  Future<ChatLinkPolicyDtoResponse> loadLinkPolicy();

  /// Generuje bezpieczny podgląd linku.
  @GET('/api/v1/chat/conversations/{conversationId}/link-preview')
  Future<ChatLinkPreviewResponse> previewLink(
    @Path('conversationId') String conversationId,
    @Query('url') String url,
  );

  /// Przygotowuje długi tekst jako snippet.
  @POST('/api/v1/chat/conversations/{conversationId}/snippet')
  Future<ChatSnippetResponse> prepareSnippet(
    @Path('conversationId') String conversationId,
    @Body() ChatSnippetPayload payload,
  );

  /// Tworzy i dołącza snippet do wiadomości.
  @POST('/api/v1/chat/messages/{messageId}/snippet-attachment')
  Future<ChatSnippetAttachmentResponse> createSnippetAttachment(
    @Path('messageId') String messageId,
    @Body() ChatSnippetPayload payload,
  );
}
