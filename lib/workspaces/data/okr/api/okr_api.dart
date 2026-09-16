import 'package:dio/dio.dart';
import 'package:ready_next/workspaces/data/okr/models/okr_models.dart';
import 'package:retrofit/retrofit.dart';

part 'okr_api.g.dart';

/// Klient Retrofit celów i kluczowych rezultatów OKR.
@RestApi()
abstract class OkrApi {
  /// Tworzy klienta API OKR.
  factory OkrApi(Dio dio, {String? baseUrl}) = _OkrApi;

  /// Pobiera cele OKR workspace z opcjonalnymi filtrami.
  @GET('/api/v1/workspaces/{workspaceId}/okr/objectives')
  Future<List<ObjectiveResponse>> listObjectives(
    @Path('workspaceId') String workspaceId, {
    @Query('query') String? query,
    @Query('targetDateFrom') DateTime? targetDateFrom,
    @Query('targetDateTo') DateTime? targetDateTo,
  });

  /// Tworzy nowy cel OKR w workspace.
  @POST('/api/v1/workspaces/{workspaceId}/okr/objectives')
  Future<ObjectiveResponse> createObjective(
    @Path('workspaceId') String workspaceId,
    @Body() CreateObjectivePayload payload,
  );

  /// Pobiera cel OKR wraz z rezultatami.
  @GET('/api/v1/workspaces/{workspaceId}/okr/objectives/{objectiveId}')
  Future<ObjectiveResponse> getObjective(
    @Path('workspaceId') String workspaceId,
    @Path('objectiveId') String objectiveId,
  );

  /// Aktualizuje dane celu OKR.
  @PATCH('/api/v1/workspaces/{workspaceId}/okr/objectives/{objectiveId}')
  Future<ObjectiveResponse> updateObjective(
    @Path('workspaceId') String workspaceId,
    @Path('objectiveId') String objectiveId,
    @Body() UpdateObjectivePayload payload,
  );

  /// Usuwa cel OKR wraz z jego rezultatami.
  @DELETE('/api/v1/workspaces/{workspaceId}/okr/objectives/{objectiveId}')
  Future<void> deleteObjective(
    @Path('workspaceId') String workspaceId,
    @Path('objectiveId') String objectiveId,
  );

  /// Dodaje kluczowy rezultat do celu OKR.
  @POST(
    '/api/v1/workspaces/{workspaceId}/okr/objectives/{objectiveId}/key-results',
  )
  Future<ObjectiveResponse> createKeyResult(
    @Path('workspaceId') String workspaceId,
    @Path('objectiveId') String objectiveId,
    @Body() CreateKeyResultPayload payload,
  );

  /// Aktualizuje kluczowy rezultat celu OKR.
  @PATCH(
    '/api/v1/workspaces/{workspaceId}/okr/objectives/{objectiveId}/key-results/{keyResultId}',
  )
  Future<ObjectiveResponse> updateKeyResult(
    @Path('workspaceId') String workspaceId,
    @Path('objectiveId') String objectiveId,
    @Path('keyResultId') String keyResultId,
    @Body() UpdateKeyResultPayload payload,
  );

  /// Usuwa kluczowy rezultat celu OKR.
  @DELETE(
    '/api/v1/workspaces/{workspaceId}/okr/objectives/{objectiveId}/key-results/{keyResultId}',
  )
  Future<ObjectiveResponse> deleteKeyResult(
    @Path('workspaceId') String workspaceId,
    @Path('objectiveId') String objectiveId,
    @Path('keyResultId') String keyResultId,
  );
}
