import 'package:dio/dio.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:retrofit/retrofit.dart';

part 'bhp_api.g.dart';

/// Klient Retrofit dla endpointow modułu BHP.
///
/// Kontrakty sa oparte o lokalny backend `veloryn-bhp`:
/// - `GET /api/v1/bhp/dashboard/issue-alerts`
/// - `GET /api/v1/bhp/dashboard/issue-operations`
/// - `GET /api/v1/bhp/users`
/// - `GET /api/v1/bhp/users/{id}`
/// - `GET /api/v1/bhp/stanowiska`
/// - `GET /api/v1/bhp/equipment`
@RestApi()
abstract class BhpApi {
  /// Tworzy klienta `BhpApi` opartego o `Dio`.
  factory BhpApi(Dio dio, {String? baseUrl}) = _BhpApi;

  /// Pobiera dane dashboardu alertów terminów.
  @GET('/api/v1/bhp/dashboard/issue-alerts')
  Future<GetBhpDashboardResponseData> getIssueAlerts({
    @Query('months_ahead') int? monthsAhead,
  });

  /// Pobiera globalną historię operacji BHP dla wybranego roku.
  @GET('/api/v1/bhp/dashboard/issue-operations')
  Future<GetBhpIssueOperationsResponseData> getIssueOperations({
    @Query('year') int? year,
  });

  /// Pobiera globalne braki wyposażenia względem aktywnych standardów.
  @GET('/api/v1/bhp/dashboard/missing-equipment')
  Future<GetBhpMissingEquipmentResponseData> getMissingEquipment();

  /// Pobiera listę pracowników BHP.
  @GET('/api/v1/bhp/users')
  Future<List<GetBhpUserListItem>> getUsers({
    @Query('active') bool? active,
    @Query('q') String? query,
  });

  /// Tworzy nową kartę pracownika BHP.
  @POST('/api/v1/bhp/users')
  Future<GetBhpUserListItem> createUser(@Body() PostBhpUserRequest request);

  /// Aktualizuje dane istniejącego pracownika BHP.
  @PATCH('/api/v1/bhp/users/{id}')
  Future<GetBhpUserListItem> updateUser(
    @Path('id') int userId,
    @Body() PostBhpUserRequest request,
  );

  /// Masowo aktualizuje stanowisko dla pracowników BHP.
  @PATCH('/api/v1/bhp/users/bulk/position')
  Future<void> bulkUpdatePosition(
    @Body() PostBhpUsersBulkPositionRequest request,
  );

  /// Archiwizuje pracownika BHP bez fizycznego usunięcia rekordu.
  @POST('/api/v1/bhp/users/{id}/archive')
  Future<GetBhpUserListItem> archiveUser(@Path('id') int userId);

  /// Przywraca zarchiwizowanego pracownika BHP.
  @POST('/api/v1/bhp/users/{id}/unarchive')
  Future<GetBhpUserListItem> unarchiveUser(@Path('id') int userId);

  /// Usuwa zarchiwizowanego pracownika BHP z bazy danych (hard delete).
  @DELETE('/api/v1/bhp/users/{id}')
  Future<void> destroyUser(@Path('id') int userId);

  /// Pobiera listę stanowisk BHP.
  @GET('/api/v1/bhp/stanowiska')
  Future<List<GetBhpPositionListItem>> getPositions({
    @Query('active') bool? active,
    @Query('q') String? query,
  });

  /// Tworzy nowe stanowisko BHP.
  @POST('/api/v1/bhp/stanowiska')
  Future<GetBhpPositionListItem> createPosition(
    @Body() PostBhpPositionRequest request,
  );

  /// Aktualizuje istniejące stanowisko BHP.
  @PATCH('/api/v1/bhp/stanowiska/{id}')
  Future<GetBhpPositionListItem> updatePosition(
    @Path('id') int positionId,
    @Body() PostBhpPositionRequest request,
  );

  /// Archiwizuje stanowisko BHP.
  @POST('/api/v1/bhp/stanowiska/{id}/archive')
  Future<GetBhpPositionListItem> archivePosition(@Path('id') int positionId);

  /// Przywraca zarchiwizowane stanowisko BHP.
  @POST('/api/v1/bhp/stanowiska/{id}/unarchive')
  Future<GetBhpPositionListItem> unarchivePosition(@Path('id') int positionId);

  /// Duplikuje stanowisko BHP z nową nazwą.
  @POST('/api/v1/bhp/stanowiska/{id}/duplicate')
  Future<GetBhpPositionListItem> duplicatePosition(
    @Path('id') int positionId,
    @Body() Map<String, dynamic> body,
  );

  /// Usuwa stanowisko BHP z bazy danych.
  @DELETE('/api/v1/bhp/stanowiska/{id}')
  Future<void> destroyPosition(@Path('id') int positionId);

  /// Pobiera standard wyposażenia przypisany do stanowiska BHP.
  @GET('/api/v1/bhp/stanowiska/{id}/users')
  Future<List<GetBhpUserListItem>> getPositionUsers(
    @Path('id') int positionId, {
    @Query('active') bool? active,
    @Query('q') String? query,
  });

  /// Pobiera standard wyposażenia przypisany do stanowiska BHP.
  @GET('/api/v1/bhp/stanowiska/{id}/standard')
  Future<List<GetBhpUserStandardItem>> getPositionStandards(
    @Path('id') int positionId,
  );

  /// Dodaje pozycję do standardu stanowiska BHP.
  @POST('/api/v1/bhp/stanowiska/{id}/standard')
  Future<GetBhpUserStandardItem> createPositionStandard(
    @Path('id') int positionId,
    @Body() PostBhpPositionStandardRequest request,
  );

  /// Aktualizuje pozycję standardu stanowiska BHP.
  @PATCH('/api/v1/bhp/stanowiska/{id}/standard/{standardId}')
  Future<GetBhpUserStandardItem> updatePositionStandard(
    @Path('id') int positionId,
    @Path('standardId') int standardId,
    @Body() PatchBhpPositionStandardRequest request,
  );

  /// Archiwizuje pozycję standardu stanowiska BHP.
  @POST('/api/v1/bhp/stanowiska/{id}/standard/{standardId}/archive')
  Future<GetBhpUserStandardItem> archivePositionStandard(
    @Path('id') int positionId,
    @Path('standardId') int standardId,
  );

  /// Przywraca zarchiwizowaną pozycję standardu stanowiska BHP.
  @POST('/api/v1/bhp/stanowiska/{id}/standard/{standardId}/unarchive')
  Future<GetBhpUserStandardItem> unarchivePositionStandard(
    @Path('id') int positionId,
    @Path('standardId') int standardId,
  );

  /// Usuwa nieaktywną pozycję standardu stanowiska BHP.
  @DELETE('/api/v1/bhp/stanowiska/{id}/standard/{standardId}')
  Future<void> deletePositionStandard(
    @Path('id') int positionId,
    @Path('standardId') int standardId,
  );

  /// Pobiera szczegóły pojedynczego pracownika BHP.
  @GET('/api/v1/bhp/users/{id}')
  Future<GetBhpUserDetail> getUserDetails(@Path('id') int userId);

  /// Pobiera katalog wyposażenia BHP.
  @GET('/api/v1/bhp/equipment')
  Future<List<GetBhpEquipmentListItem>> getEquipment({
    @Query('active') bool? active,
    @Query('q') String? query,
  });

  /// Pobiera szczegóły pojedynczej karty wyposażenia BHP.
  @GET('/api/v1/bhp/equipment/{id}')
  Future<GetBhpEquipmentDetails> getEquipmentDetails(@Path('id') int id);

  /// Tworzy nową kartę wyposażenia BHP.
  @POST('/api/v1/bhp/equipment')
  Future<GetBhpEquipmentDetails> createEquipment(
    @Body() PostBhpEquipmentRequest request,
  );

  /// Aktualizuje istniejącą kartę wyposażenia BHP.
  @PATCH('/api/v1/bhp/equipment/{id}')
  Future<GetBhpEquipmentDetails> updateEquipment(
    @Path('id') int id,
    @Body() PostBhpEquipmentRequest request,
  );

  /// Archiwizuje kartę wyposażenia BHP.
  @POST('/api/v1/bhp/equipment/{id}/archive')
  Future<GetBhpEquipmentDetails> archiveEquipment(@Path('id') int id);

  /// Pobiera wpływ zmiany statusu karty na przypisania stanowisk.
  @GET('/api/v1/bhp/equipment/{id}/activation-impact')
  Future<GetBhpEquipmentActivationImpact> getEquipmentActivationImpact(
    @Path('id') int id,
  );

  /// Przywraca nieaktywną kartę wyposażenia BHP.
  @POST('/api/v1/bhp/equipment/{id}/unarchive')
  Future<GetBhpEquipmentDetails> unarchiveEquipment(
    @Path('id') int id,
    @Body() PostBhpEquipmentActivationRequest request,
  );

  /// Pobiera historię wydań wyposażenia dla konkretnego pracownika.
  @GET('/api/v1/bhp/users/{id}/issues')
  Future<List<GetBhpUserIssue>> getUserIssues(@Path('id') int userId);

  /// Tworzy ręczne wydanie wyposażenia dla pracownika.
  @POST('/api/v1/bhp/users/{id}/issues')
  Future<GetBhpUserIssue> createUserIssue(
    @Path('id') int userId,
    @Body() PostBhpUserIssueRequest request,
  );

  /// Aktualizuje ręczne wydanie wyposażenia pracownika.
  @PATCH('/api/v1/bhp/users/{userId}/issues/{issueId}')
  Future<GetBhpUserIssue> updateUserIssue(
    @Path('userId') int userId,
    @Path('issueId') int issueId,
    @Body() PatchBhpUserIssueRequest request,
  );

  /// Usuwa błędnie zapisane wydanie wyposażenia pracownika.
  @DELETE('/api/v1/bhp/users/{userId}/issues/{issueId}')
  Future<void> deleteUserIssue(
    @Path('userId') int userId,
    @Path('issueId') int issueId,
  );

  /// Generuje wydania ze standardu stanowiska pracownika.
  @POST('/api/v1/bhp/users/{id}/issues/from-standard')
  Future<List<GetBhpUserIssue>> assignIssuesFromStandard(
    @Path('id') int userId,
    @Body() PostBhpUserIssuesFromStandardRequest request,
  );

  /// Zbiorczo powtarza zakończone wydania wyposażenia pracownika.
  @POST('/api/v1/bhp/users/{id}/issues/repeat')
  Future<List<GetBhpUserIssue>> repeatUserIssues(
    @Path('id') int userId,
    @Body() PostBhpUserIssuesRepeatRequest request,
  );

  /// Powtarza zakończone wydanie wyposażenia pracownika.
  @POST('/api/v1/bhp/users/{userId}/issues/{issueId}/repeat')
  Future<GetBhpUserIssue> repeatUserIssue(
    @Path('userId') int userId,
    @Path('issueId') int issueId,
  );

  /// Zamyka aktywne wydanie wyposażenia pracownika.
  @POST('/api/v1/bhp/users/{userId}/issues/{issueId}/close')
  Future<GetBhpUserIssue> closeIssue(
    @Path('userId') int userId,
    @Path('issueId') int issueId,
    @Body() PostCloseBhpUserIssueRequest request,
  );

  /// Rejestruje ekwiwalent dla istniejącego wydania.
  @POST('/api/v1/bhp/users/{userId}/issues/{issueId}/equivalent')
  Future<GetBhpUserIssue> registerIssueEquivalent(
    @Path('userId') int userId,
    @Path('issueId') int issueId,
    @Body() PostBhpUserIssueEquivalentRequest request,
  );

  /// Usuwa zarejestrowany ekwiwalent z istniejącego wydania.
  @DELETE('/api/v1/bhp/users/{userId}/issues/{issueId}/equivalent')
  Future<GetBhpUserIssue> deleteIssueEquivalent(
    @Path('userId') int userId,
    @Path('issueId') int issueId,
  );
}
