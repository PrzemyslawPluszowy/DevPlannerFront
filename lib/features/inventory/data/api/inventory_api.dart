import 'package:dio/dio.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/endpoints.dart';
import 'package:ready_next/shared/data/models/data_response.dart';
import 'package:ready_next/shared/data/models/data_response_list.dart';
import 'package:retrofit/retrofit.dart';

part 'inventory_api.g.dart';

/// Klient Retrofit dla endpointow inwentaryzacji.
///
/// Obejmuje trzy sekcje API:
/// - Spisy,
/// - Arkusze,
/// - Slowniki.
@RestApi()
abstract class InventoryApi {
  /// Tworzy klienta `InventoryApi` oparty o `Dio`.
  factory InventoryApi(Dio dio, {String? baseUrl}) = _InventoryApi;

  /// Pobiera liste inwentaryzacji z filtrami i sortowaniem.
  @GET('/api/v1/inwentaryzacja')
  Future<DataResponse<GetInwentaryzacjeResponseData>> getInwentaryzacje({
    @Query('firma') int? firma,
    @Query('status') int? status,
    @Query('numer') String? numer,
    @Query('data_od_from') String? dataOdFrom,
    @Query('data_od_to') String? dataOdTo,
    @Query('sort_by') String? sortBy,
    @Query('sort_dir') String? sortDir,
  });

  /// Tworzy nowa inwentaryzacje wraz z komisja.
  @POST('/api/v1/inwentaryzacja')
  Future<DataResponse<PostInwentaryzacjaResponseData>> createInwentaryzacja(
    /// Request body zgodny ze Swagger `CreateInwentaryzacjaRequest`.
    @Body() PostInwentaryzacjaQuery body,
  );

  /// Pobiera szczegoly inwentaryzacji wraz z arkuszami i komisja.
  @GET('/api/v1/inwentaryzacja/{inwentaryzacja_id}')
  Future<DataResponse<GetInwentaryzacjaDetailsResponseData>>
  getInwentaryzacjaDetails(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId,
  );

  /// Wyszukuje elementy we wszystkich arkuszach wskazanej inwentaryzacji.
  ///
  /// Zweryfikowano względem lokalnego kontraktu backendu:
  /// - `veloryn-databus/src/databus/api/v1/inwentaryzacja.py`
  /// - `veloryn-databus/src/databus/api/schemas/inwentaryzacja.py`
  @GET('/api/v1/inwentaryzacja/{inwentaryzacja_id}/search/arkusze')
  Future<DataResponse<GetInwentaryzacjaSearchArkuszeResponseData>>
  searchInwentaryzacjaArkusze(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId, {
    @Query('q') String? q,
    @Query('sort_by') String? sortBy,
    @Query('sort_dir') String? sortDir,
  });

  /// Pobiera drzewo wykonania arkuszy dla miejsc objetych inwentaryzacja.
  ///
  /// Swagger Laravel: http://192.168.170.20:8101/api/documentation#/Inwentaryzacja
  /// Kontrakt: `InwentaryzacjaController::arkuszeTreeProgress`.
  @GET('/api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze/tree-progress')
  Future<DataResponse<GetInwentaryzacjaTreeProgressResponseData>>
  getInwentaryzacjaTreeProgress(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId,
  );

  /// Pobiera informacyjna liste konfliktow obecnosci dla inwentaryzacji.
  ///
  /// Zweryfikowano względem lokalnego kontraktu backendu:
  /// - `veloryn-inwentaryzacja/routes/api.php`
  /// - `veloryn-inwentaryzacja/app/Http/Controllers/Api/V1/InwentaryzacjaController.php`
  /// - `veloryn-databus/src/databus/api/schemas/inwentaryzacja.py`
  @GET('/api/v1/inwentaryzacja/{inwentaryzacja_id}/presence-conflicts')
  Future<DataResponse<GetInwentaryzacjaPresenceConflictsResponseData>>
  getInwentaryzacjaPresenceConflicts(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId,
  );

  /// Pobiera informacyjna liste konfliktow nadwyzek dla inwentaryzacji.
  ///
  /// Zweryfikowano względem lokalnego kontraktu backendu:
  /// - `veloryn-inwentaryzacja/routes/api.php`
  /// - `veloryn-inwentaryzacja/app/Http/Controllers/Api/V1/InwentaryzacjaController.php`
  @GET('/api/v1/inwentaryzacja/{inwentaryzacja_id}/surplus-conflicts')
  Future<DataResponse<GetInwentaryzacjaSurplusConflictsResponseData>>
  getInwentaryzacjaSurplusConflicts(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId,
  );

  /// Pobiera raport przekrojowy dla wskazanej inwentaryzacji.
  ///
  /// Swagger: http://192.168.170.20:8101/api/documentation#/Inwentaryzacja/reportForInwentaryzacja
  @GET('/api/v1/inwentaryzacja/{inwentaryzacja_id}/raporty/{report_type}')
  Future<DataResponse<GetInwentaryzacjaReportResponseData>>
  getInwentaryzacjaReport(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId,

    /// Typ raportu backendowego.
    @Path('report_type') String reportType, {

    /// Backend na `8101` nie akceptuje `true/false` jako query boolean.
    ///
    /// Dla domyslnego `true` parametr pomijamy, a dla `false` wysylamy `0`.
    @Query('include_summary') String? includeSummary,
    @Query('sort_by') String? sortBy,
    @Query('sort_dir') String? sortDir,
  });

  /// Usuwa inwentaryzacje (kaskadowo).
  @DELETE('/api/v1/inwentaryzacja/{inwentaryzacja_id}')
  Future<DataResponse<DeleteInwentaryzacjaResponseData>> deleteInwentaryzacja(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId,
  );

  /// Podmienia komisje inwentaryzacji.
  @PUT('/api/v1/inwentaryzacja/{inwentaryzacja_id}/komisja')
  Future<DataResponse<KomisjaUpdateData>> updateInwentaryzacjaKomisja(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId,

    /// Request body `UpdateKomisjaRequest` ze Swagger/OpenAPI.
    @Body() UpdateKomisjaRequest body,
  );

  /// Konczy aktywna inwentaryzacje bez edycji dat.
  ///
  /// Swagger Laravel: http://192.168.170.20:8101/api/documentation#/Inwentaryzacja
  /// Kontrakt: `InwentaryzacjaController::close`.
  @POST('/api/v1/inwentaryzacja/{id}/close')
  Future<DataResponse<PatchInwentaryzacjaStatusResponseData>>
  closeInwentaryzacja(
    /// Identyfikator inwentaryzacji.
    @Path('id') int inwentaryzacjaId,
  );

  /// Aktualizuje naglowek aktywnej inwentaryzacji.
  ///
  /// Swagger Laravel: http://192.168.170.20:8101/api/documentation#/Inwentaryzacja
  /// Kontrakt: `InwentaryzacjaController::update`.
  @PATCH('/api/v1/inwentaryzacja/{id}')
  Future<DataResponse<PatchInwentaryzacjaResponseData>> updateInwentaryzacja(
    /// Identyfikator inwentaryzacji.
    @Path('id') int inwentaryzacjaId,

    /// Request body zgodny z backendem `UpdateInwentaryzacjaRequest`.
    @Body() PatchInwentaryzacjaRequest body,
  );

  /// Tworzy nowy arkusz spisu dla wskazanej inwentaryzacji.
  @POST('/api/v1/inwentaryzacja/{inwentaryzacja_id}/arkusze')
  Future<DataResponse<PostArkuszResponseData>> createArkusz(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId,

    /// Request body zgodny ze Swagger `CreateArkuszRequest`.
    @Body() PostArkuszQuery body,
  );

  /// Pobiera szczegoly arkusza spisu.
  @GET('/api/v1/inwentaryzacja/arkusze/{arkusz_id}')
  Future<DataResponse<GetArkuszDetailsResponseData>> getArkuszDetails(
    /// Identyfikator arkusza.
    @Path('arkusz_id') int arkuszId,
  );

  /// Aktualizuje daty wskazanego arkusza spisu.
  @PATCH('/api/v1/inwentaryzacja/arkusze/{arkusz_id}')
  Future<DataResponse<UpdateArkuszResponseData>> updateArkusz(
    /// Identyfikator arkusza.
    @Path('arkusz_id') int arkuszId,

    /// Request body zgodny ze Swagger `UpdateArkuszRequest`.
    @Body() UpdateArkuszRequest body,
  );

  /// Aktualizuje numer wskazanego arkusza spisu.
  ///
  /// Swagger: http://192.168.170.20:8101/api/documentation#/Arkusze/5e03ec2bfd2126cfcb0dc0eb259426e4
  @PATCH('/api/v1/inwentaryzacja/arkusze/{arkusz_id}/numer')
  Future<DataResponse<UpdateArkuszNumerResponseData>> updateArkuszNumer(
    /// Identyfikator arkusza.
    @Path('arkusz_id') int arkuszId,

    /// Request body zgodny ze Swagger `UpdateArkuszNumerRequest`.
    @Body() UpdateArkuszNumerRequest body,
  );

  /// Usuwa arkusz spisu.
  ///
  /// Swagger: http://192.168.170.20:8101/api/documentation#/Inwentaryzacja%20%E2%80%94%20Arkusze/delete_arkusz_api_v1_inwentaryzacja_arkusze__arkusz_id__delete
  @DELETE('/api/v1/inwentaryzacja/arkusze/{arkusz_id}')
  Future<DataResponse<DeleteArkuszResponseData>> deleteArkusz(
    /// Identyfikator arkusza.
    @Path('arkusz_id') int arkuszId,
  );

  /// Podmienia komisje arkusza spisu.
  ///
  /// Swagger: http://192.168.170.20:8101/api/documentation#/Inwentaryzacja%20%E2%80%94%20Arkusze/update_arkusz_komisja_api_v1_inwentaryzacja_arkusze__arkusz_id__komisja_put
  @PUT('/api/v1/inwentaryzacja/arkusze/{arkusz_id}/komisja')
  Future<DataResponse<KomisjaUpdateData>> updateArkuszKomisja(
    /// Identyfikator arkusza.
    @Path('arkusz_id') int arkuszId,

    /// Request body `UpdateKomisjaRequest` ze Swagger/OpenAPI.
    @Body() UpdateKomisjaRequest body,
  );

  /// Aktualizuje pojedynczy element arkusza spisu.
  ///
  /// Swagger: http://192.168.170.20:8101/api/documentation#/Inwentaryzacja%20%E2%80%94%20Arkusze/update_arkusz_element_api_v1_inwentaryzacja_arkusze__arkusz_id__elementy__element_id__patch
  @PATCH('/api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}')
  Future<DataResponse<PatchArkuszElementResponseData>> updateArkuszElement(
    /// Identyfikator arkusza.
    @Path('arkusz_id') int arkuszId,

    /// Identyfikator elementu arkusza.
    @Path('element_id') int elementId,

    /// Request body zgodny ze Swagger `UpdateArkuszElementRequest`.
    @Body() PatchArkuszElementQuery body,
  );

  /// Usuwa pojedynczy element ze wskazanego arkusza.
  @DELETE('/api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/{element_id}')
  Future<DataResponse<DeleteArkuszElementResponseData>> deleteArkuszElement(
    /// Identyfikator arkusza.
    @Path('arkusz_id') int arkuszId,

    /// Identyfikator elementu arkusza.
    @Path('element_id') int elementId,
  );

  /// Dodaje nowy element (nadwyzke) do wskazanego arkusza.
  ///
  /// Swagger: http://192.168.170.20:8101/api/documentation#/Inwentaryzacja%20%E2%80%94%20Arkusze/add_nadwyzka_api_v1_inwentaryzacja_arkusze__arkusz_id__elementy_post
  @POST('/api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy')
  Future<DataResponse<PostArkuszElementyResponseData>> addArkuszNadwyzka(
    /// Identyfikator arkusza.
    @Path('arkusz_id') int arkuszId,

    /// Request body zgodny ze Swagger `AddNadwyzkaRequest`.
    @Body() PostArkuszElementyQuery body,
  );

  /// Dodaje element do arkusza po numerze ewidencyjnym.
  @POST('/api/v1/inwentaryzacja/arkusze/{arkusz_id}/elementy/nrewid')
  Future<DataResponse<CreateArkuszElementByNrewidResponseData>>
  createArkuszElementByNrewid(
    /// Identyfikator arkusza.
    @Path('arkusz_id') int arkuszId,

    /// Request body zgodny ze Swagger `CreateElementByNrewidRequest`.
    @Body() CreateArkuszElementByNrewidRequest body,
  );

  /// Pobiera liste firm ze slownika inwentaryzacji.
  @GET('/api/v1/inwentaryzacja/firmy')
  Future<DataResponse<GetFirmyResponseData>> getFirmy();

  /// Usuwa firme ze slownika inwentaryzacji.
  @DELETE('/api/v1/inwentaryzacja/firmy/{firma_id}')
  Future<DataResponse<DeleteFirmaResponseData>> deleteFirma(
    /// Identyfikator firmy.
    @Path('firma_id') int firmaId,
  );

  /// Usuwa pojedynczy rekord ze snapshotu `stan_st`.
  ///
  /// Zweryfikowano wzgledem lokalnego backendu:
  /// - `veloryn-inwentaryzacja/routes/api.php`
  /// - `veloryn-inwentaryzacja/app/Http/Controllers/Api/V1/SlownikController.php`
  /// Swagger UI: `http://192.168.170.20:8101/api/documentation`
  @DELETE('/api/v1/inwentaryzacja/stan_st/{stan_st_id}')
  Future<DataResponse<DeleteStanStResponseData>> deleteStanSt(
    /// Identyfikator rekordu `stan_st`.
    @Path('stan_st_id') int stanStId, {

    /// Potwierdzony przez uzytkownika numer ewidencyjny.
    @Query('confirm_nrewid') required String confirmNrewid,

    /// Potwierdzona przez uzytkownika pelna nazwa.
    @Query('confirm_nazwa') required String confirmNazwa,
  });

  /// Pobiera liste miejsc (drzewo lokalizacji).
  @GET('/api/v1/inwentaryzacja/miejsca')
  Future<DataResponse<GetMiejscaResponseData>> getMiejsca({
    @Query('firma') int? firma,
  });

  /// Pobiera liste srodkow trwalych (`stan_st`) z paginacja.
  ///
  /// Swagger Laravel: http://192.168.170.20:8101/api/documentation#/Slowniki
  /// Kontrakt: `SlownikController::stanSt`.
  @GET('/api/v1/inwentaryzacja/stan_st')
  Future<DataResponse<GetStanStResponseData>> getStanSt({
    @Query('firma') int? firma,
    @Query('baza') String? baza,
    @Query('idmiejsce') int? idmiejsce,
    @Query('stan') String? stan,
    @Query('q') String? q,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('nazwa') String? nazwa,
    @Query('nrewid') String? nrewid,
    @Query('kod_kreskowy') String? kodKreskowy,
  });

  /// Pobiera duplikaty numerow ewidencyjnych w `stan_st`.
  @GET('/api/v1/inwentaryzacja/stan_st/duplicates')
  Future<DataResponse<GetStanStDuplicatesResponseData>> getStanStDuplicates();

  /// Uruchamia pelne odswiezenie snapshotu ST przez Data Bus.
  ///
  /// Swagger Data Bus: `POST /api/v1/inwentaryzacja/snapshot/refresh`.
  /// Tymczasowo kierowane bezposrednio na host FastAPI (Data Bus).
  @POST(
    'https://b2b8100.excellent.com.pl/api/v1/inwentaryzacja/snapshot/refresh',
  )
  Future<PostSnapshotRefreshResponseData> refreshSnapshot(
    @DioOptions() Options options,
  );

  /// Skanuje kod kreskowy dla wskazanej inwentaryzacji i arkusza.
  @POST('/api/v1/inwentaryzacja/{inwentaryzacja_id}/skanuj')
  Future<DataResponse<SkanujInwentaryzacjaResponseData>> skanujInwentaryzacja(
    /// Identyfikator inwentaryzacji.
    @Path('inwentaryzacja_id') int inwentaryzacjaId,

    /// Request body zgodny ze Swagger `SkanujRequest`.
    @Body() SkanujInwentaryzacjaRequest body,
  );

  /// Wyszukuje uzytkownikow po frazie `q` (min. 2 znaki).
  @GET('/api/v1/ready/users/search')
  Future<DataResponseList<GetReadyUsersSearchItem>> searchReadyUsers({
    @Query('q') required String q,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('include_inactive') bool? includeInactive,
  });
}
