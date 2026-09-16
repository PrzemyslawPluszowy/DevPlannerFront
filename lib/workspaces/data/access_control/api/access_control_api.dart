import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/access_control/models/access_control_models.dart';
import 'package:retrofit/retrofit.dart';

part 'access_control_api.g.dart';

/// Klient Retrofit bezpośrednich grantów ACL Wiki i whiteboardów.
@RestApi()
abstract class AccessControlApi {
  /// Tworzy lub zmienia grant użytkownika dla whiteboardu.
  factory AccessControlApi(Dio dio, {String? baseUrl}) = _AccessControlApi;

  /// Pobiera bezpośrednie granty whiteboardu.
  @GET('/api/v1/whiteboards/{whiteboardId}/access')
  Future<List<WhiteboardAccessGrantResponse>> listWhiteboardAccess(
    @Path('whiteboardId') String whiteboardId,
  );

  /// Nadaje albo zmienia dostęp użytkownika do whiteboardu.
  @PUT('/api/v1/whiteboards/{whiteboardId}/access/{targetUserId}')
  Future<WhiteboardAccessGrantResponse> grantWhiteboardAccess(
    @Path('whiteboardId') String whiteboardId,
    @Path('targetUserId') String targetUserId,
    @Body() GrantResourceAccessPayload payload,
  );

  /// Cofa bezpośredni grant whiteboardu.
  @DELETE('/api/v1/whiteboards/{whiteboardId}/access/{targetUserId}')
  Future<void> revokeWhiteboardAccess(
    @Path('whiteboardId') String whiteboardId,
    @Path('targetUserId') String targetUserId,
    @Query('expectedVersion') int expectedVersion,
  );

  /// Pobiera bezpośrednie granty strony Wiki.
  @GET('/api/v1/wiki/pages/{pageId}/access')
  Future<List<WikiPageAccessGrantResponse>> listWikiPageAccess(
    @Path('pageId') String pageId,
  );

  /// Nadaje albo zmienia dostęp użytkownika do strony Wiki.
  @PUT('/api/v1/wiki/pages/{pageId}/access/{targetUserId}')
  Future<WikiPageAccessGrantResponse> grantWikiPageAccess(
    @Path('pageId') String pageId,
    @Path('targetUserId') String targetUserId,
    @Body() GrantResourceAccessPayload payload,
  );

  /// Cofa bezpośredni grant strony Wiki.
  @DELETE('/api/v1/wiki/pages/{pageId}/access/{targetUserId}')
  Future<void> revokeWikiPageAccess(
    @Path('pageId') String pageId,
    @Path('targetUserId') String targetUserId,
    @Query('expectedVersion') int expectedVersion,
  );
}
