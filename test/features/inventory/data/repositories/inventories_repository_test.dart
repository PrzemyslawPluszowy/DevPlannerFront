import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/delete_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_element_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_elementy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/put_komisja_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/shared/data/models/data_response.dart';

class _MockInventoryApi extends Mock implements InventoryApi {}

void main() {
  late InventoryApi api;
  late InventoriesRepository repository;

  const listQuery = GetInwentaryzacjeQuery(
    firma: 15,
    status: 1,
    numer: 'INV/2026/1',
    dataOdFrom: '2026-01-01',
    dataOdTo: '2026-12-31',
    sortBy: GetInwentaryzacjeSortBy.dataOd,
    sortDir: GetInwentaryzacjeSortDirection.desc,
  );

  setUp(() {
    api = _MockInventoryApi();
    repository = InventoriesRepositoryImpl(api: api);
  });

  group('InventoriesRepositoryImpl', () {
    test(
      'fetchInventories: mapuje query 1:1 do API i zwraca dane (wykrywa regresje parametrow sortowania)',
      () async {
        when(
          () => api.getInwentaryzacje(
            firma: 15,
            status: 1,
            numer: 'INV/2026/1',
            dataOdFrom: '2026-01-01',
            dataOdTo: '2026-12-31',
            sortBy: 'data_od',
            sortDir: 'DESC',
          ),
        ).thenAnswer(
          (_) async => const DataResponse(
            data: GetInwentaryzacjeResponseData(
              items: [
                GetInwentaryzacjeItem(
                  id: 7,
                  firma: 15,
                  numer: 'INV/2026/1',
                  status: InwentaryzacjaStatus.wToku,
                ),
              ],
              meta: GetInwentaryzacjeMeta(
                total: 1,
                sortBy: 'data_od',
                sortDir: 'DESC',
              ),
            ),
          ),
        );

        final result = await repository.fetchInventories(listQuery);

        expect(result.isRight(), isTrue);
        final data = result.getOrElse(
          () => const GetInwentaryzacjeResponseData(
            items: [],
            meta: GetInwentaryzacjeMeta(total: 0, sortBy: 'id', sortDir: 'ASC'),
          ),
        );
        expect(data.items.single.id, 7);
      },
    );

    test(
      'searchInventorySheets: mapuje query 1:1 do API i zwraca dane wyszukiwarki arkuszy',
      () async {
        const query = GetInwentaryzacjaSearchArkuszeQuery(
          q: 'krzeslo',
          sortBy: GetInwentaryzacjaSearchArkuszeSortBy.matchesCount,
          sortDir: GetInwentaryzacjaSearchArkuszeSortDirection.desc,
        );

        when(
          () => api.searchInwentaryzacjaArkusze(
            71,
            q: 'krzeslo',
            sortBy: 'matches_count',
            sortDir: 'desc',
          ),
        ).thenAnswer(
          (_) async => const DataResponse(
            data: GetInwentaryzacjaSearchArkuszeResponseData(
              meta: GetInwentaryzacjaSearchArkuszeMeta(
                scope: 'inventory',
                scopeId: 71,
                generatedAt: '2026-06-15T10:00:00',
                inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta(
                  id: 71,
                  numer: 'INV/71',
                  status: 1,
                ),
                filters: GetInwentaryzacjaSearchArkuszeFilters(
                  q: 'krzeslo',
                  sortBy: 'matches_count',
                  sortDir: 'desc',
                ),
                totals: GetInwentaryzacjaSearchArkuszeTotals(
                  groupsCount: 1,
                  matchesCount: 2,
                ),
              ),
              items: [
                GetInwentaryzacjaSearchArkuszeGroup(
                  identityKey: 'group-1',
                  matchesCount: 2,
                  hasMultipleMatches: true,
                  hasMixedStatuses: false,
                  uiStatuses: [SearchArkuszeUiStatus.potwierdzony],
                  matches: [
                    GetInwentaryzacjaSearchArkuszeMatch(
                      elementId: 15,
                      arkuszId: 201,
                      arkuszNumer: 'A/201',
                      uiStatus: SearchArkuszeUiStatus.potwierdzony,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

        final result = await repository.searchInventorySheets(
          inventoryId: 71,
          query: query,
        );

        final data = result.getOrElse(
          () => const GetInwentaryzacjaSearchArkuszeResponseData(
            meta: GetInwentaryzacjaSearchArkuszeMeta(
              scope: 'inventory',
              scopeId: 0,
              generatedAt: '',
              inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta(
                id: 0,
              ),
              filters: GetInwentaryzacjaSearchArkuszeFilters(
                q: '',
                sortBy: 'nrewid',
                sortDir: 'asc',
              ),
              totals: GetInwentaryzacjaSearchArkuszeTotals(
                groupsCount: 0,
                matchesCount: 0,
              ),
            ),
            items: [],
          ),
        );
        expect(data.meta.filters.sortBy, 'matches_count');
        expect(data.items.single.matches.single.elementId, 15);
      },
    );

    test(
      'fetchInventoryReport: mapuje path i query 1:1 do API oraz zwraca dane raportu',
      () async {
        const query = GetInwentaryzacjaReportQuery(
          reportType: InwentaryzacjaReportType.kompensaty,
          sortBy: GetInwentaryzacjaReportSortBy.nrewid,
          sortDir: GetInwentaryzacjaReportSortDirection.desc,
        );

        when(
          () => api.getInwentaryzacjaReport(
            71,
            'kompensaty',
            sortBy: 'nrewid',
            sortDir: 'desc',
          ),
        ).thenAnswer(
          (_) async => const DataResponse(
            data: GetInwentaryzacjaReportResponseData(
              meta: GetInwentaryzacjaReportMeta(
                scope: 'inventory',
                scopeId: 71,
                reportType: InwentaryzacjaReportType.kompensaty,
              ),
              elements: [
                GetInwentaryzacjaReportElementItem(
                  elementId: 15,
                  arkuszId: 201,
                  inwentaryzacjaId: 71,
                  nrewid: 'ST-15',
                ),
              ],
            ),
          ),
        );

        final result = await repository.fetchInventoryReport(
          inventoryId: 71,
          query: query,
        );

        final data = result.getOrElse(
          () => const GetInwentaryzacjaReportResponseData(
            meta: GetInwentaryzacjaReportMeta(
              scope: 'inventory',
              scopeId: 0,
              reportType: InwentaryzacjaReportType.ogolnyStanSpisu,
            ),
            elements: [],
          ),
        );
        expect(data.meta.reportType, InwentaryzacjaReportType.kompensaty);
        expect(data.elements.single.elementId, 15);
      },
    );

    test(
      'fetchInventoryDetails: mapuje blad Dio na ApiError.notFound (wykrywa zla obsluge nieistniejacej inwentaryzacji)',
      () async {
        when(() => api.getInwentaryzacjaDetails(404)).thenThrow(
          DioException.badResponse(
            requestOptions: RequestOptions(path: '/api/v1/inwentaryzacja/404'),
            statusCode: 404,
            response: Response(
              requestOptions: RequestOptions(
                path: '/api/v1/inwentaryzacja/404',
              ),
              statusCode: 404,
              data: <String, dynamic>{},
            ),
          ),
        );

        final result = await repository.fetchInventoryDetails(404);
        final error = result.fold((left) => left, (_) => null);

        expect(error?.type, ApiErrorType.notFound);
      },
    );

    test(
      'deleteInventory: zwraca id usunietej inwentaryzacji (wykrywa zly model odpowiedzi delete)',
      () async {
        when(() => api.deleteInwentaryzacja(99)).thenAnswer(
          (_) async => const DataResponse(
            data: DeleteInwentaryzacjaResponseData(id: 99),
          ),
        );

        final result = await repository.deleteInventory(99);

        expect(result.isRight(), isTrue);
        expect(
          result
              .getOrElse(() => const DeleteInwentaryzacjaResponseData(id: -1))
              .id,
          99,
        );
      },
    );

    test(
      'fetchArkuszDetails: mapuje FormatException na ApiError.parsing (wykrywa uszkodzenie kontraktu arkusza)',
      () async {
        when(
          () => api.getArkuszDetails(55),
        ).thenThrow(const FormatException('bad payload'));

        final result = await repository.fetchArkuszDetails(55);
        final error = result.fold((left) => left, (_) => null);

        expect(error?.type, ApiErrorType.parsing);
        expect(
          error?.message,
          'Backend zwrócił nieprawidłowe dane szczegółów arkusza.',
        );
      },
    );

    test(
      'createInwentaryzacja: przekazuje body bez modyfikacji (wykrywa utrate danych komisji i dat)',
      () async {
        const query = PostInwentaryzacjaQuery(
          firmy: [15],
          numer: 'INV/NEW/1',
          komisja: [3759, 3812],
          dataOd: '2026-04-10',
          uwagi: 'test',
        );

        when(() => api.createInwentaryzacja(query)).thenAnswer(
          (_) async => const DataResponse(
            data: PostInwentaryzacjaResponseData(id: 901),
          ),
        );

        final result = await repository.createInwentaryzacja(query);

        expect(result.isRight(), isTrue);
        expect(
          result
              .getOrElse(() => const PostInwentaryzacjaResponseData(id: -1))
              .id,
          901,
        );
      },
    );

    test(
      'createArkusz: zwraca policzone pola scope/elementyCount (wykrywa regresje mapowania odpowiedzi tworzenia arkusza)',
      () async {
        const query = PostArkuszQuery(
          idMiejsca: 100,
          idFirmy: 2,
          baza: 'PROFILE',
          scope: 'subtree',
          komisja: [3759, 3812],
        );

        when(() => api.createArkusz(501, query)).thenAnswer(
          (_) async => const DataResponse(
            data: PostArkuszResponseData(
              id: 333,
              scope: 'subtree',
              elementyCount: 47,
              komisjaCount: 2,
            ),
          ),
        );

        final result = await repository.createArkusz(
          inventoryId: 501,
          query: query,
        );

        final data = result.getOrElse(
          () => const PostArkuszResponseData(
            id: -1,
            scope: 'node',
            elementyCount: 0,
            komisjaCount: 0,
          ),
        );
        expect(data.scope, 'subtree');
        expect(data.elementyCount, 47);
      },
    );

    test(
      'updateInventoryCommittee: mapuje 422 na validation i przenosi message backendu (wykrywa znikajace komunikaty walidacji)',
      () async {
        const query = UpdateKomisjaRequest(komisja: [3759]);

        when(() => api.updateInwentaryzacjaKomisja(10, query)).thenThrow(
          DioException.badResponse(
            requestOptions: RequestOptions(
              path: '/api/v1/inwentaryzacja/10/komisja',
            ),
            statusCode: 422,
            response: Response(
              requestOptions: RequestOptions(
                path: '/api/v1/inwentaryzacja/10/komisja',
              ),
              statusCode: 422,
              data: {'message': 'Komisja musi miec min. 2 osoby'},
            ),
          ),
        );

        final result = await repository.updateInventoryCommittee(
          inventoryId: 10,
          query: query,
        );

        final error = result.fold((left) => left, (_) => null);
        expect(error?.type, ApiErrorType.validation);
        expect(error?.message, 'Komisja musi miec min. 2 osoby');
      },
    );

    test(
      'updateArkuszCommittee: zwraca zaktualizowany komisjaCount (wykrywa zly mapping odpowiedzi PUT komisji arkusza)',
      () async {
        const query = UpdateKomisjaRequest(komisja: [3759, 3812]);

        when(() => api.updateArkuszKomisja(99, query)).thenAnswer(
          (_) async => const DataResponse(
            data: KomisjaUpdateData(id: 99, komisjaCount: 2),
          ),
        );

        final result = await repository.updateArkuszCommittee(
          arkuszId: 99,
          query: query,
        );
        expect(result.isRight(), isTrue);
        expect(
          result
              .getOrElse(() => const KomisjaUpdateData(id: -1, komisjaCount: 0))
              .komisjaCount,
          2,
        );
      },
    );

    test(
      'updateArkuszElement: przekazuje arkuszId/elementId/query do API 1:1 (wykrywa pomylone identyfikatory elementu)',
      () async {
        const query = PatchArkuszElementQuery(
          stanInwent: ArkuszElementInwentStatus.przeniesiony,
          uwagiLoc: 'Przeniesiony',
        );

        when(() => api.updateArkuszElement(7, 777, query)).thenAnswer(
          (_) async => const DataResponse(
            data: PatchArkuszElementResponseData(elementId: 777),
          ),
        );

        final result = await repository.updateArkuszElement(
          arkuszId: 7,
          elementId: 777,
          query: query,
        );

        expect(result.isRight(), isTrue);
        expect(
          result
              .getOrElse(
                () => const PatchArkuszElementResponseData(elementId: -1),
              )
              .elementId,
          777,
        );
      },
    );

    test(
      'addArkuszNadwyzka: mapuje odpowiedz z id nowego elementu (wykrywa utrate informacji o dodanej nadwyzce)',
      () async {
        const query = PostArkuszElementyQuery(
          kodKreskowy: 123456,
          nazwa: 'Monitor',
        );

        when(() => api.addArkuszNadwyzka(300, query)).thenAnswer(
          (_) async => const DataResponse(
            data: PostArkuszElementyResponseData(
              id: 808,
              success: true,
              nadwyzka: true,
            ),
          ),
        );

        final result = await repository.addArkuszNadwyzka(
          arkuszId: 300,
          query: query,
        );

        expect(result.isRight(), isTrue);
        final data = result.getOrElse(
          () => const PostArkuszElementyResponseData(id: -1),
        );
        expect(data.id, 808);
        expect(data.nadwyzka, isTrue);
      },
    );

    test(
      'fetchArkuszDetails: poprawnie zwraca model z headerem i elementami (wykrywa regress po zmianach w DTO)',
      () async {
        when(() => api.getArkuszDetails(12)).thenAnswer(
          (_) async => const DataResponse(
            data: GetArkuszDetailsResponseData(
              arkusz: GetArkuszDetailsHeader(id: 12, idInwentaryzacja: 77),
              komisja: [
                GetArkuszDetailsKomisjaItem(
                  userId: 3759,
                  displayName: 'Jan Nowak',
                ),
              ],
              elementy: [GetArkuszDetailsElementItem(id: 1, nazwa: 'Laptop')],
            ),
          ),
        );

        final result = await repository.fetchArkuszDetails(12);
        final data = result.getOrElse(
          () => const GetArkuszDetailsResponseData(
            arkusz: GetArkuszDetailsHeader(id: -1, idInwentaryzacja: -1),
            komisja: [],
            elementy: [],
          ),
        );

        expect(data.arkusz.idInwentaryzacja, 77);
        expect(data.elementy.single.nazwa, 'Laptop');
      },
    );

    test(
      'fetchInventoryDetails: poprawnie zwraca naglowek i arkusze (wykrywa regresje mapowania szczegolow inwentaryzacji)',
      () async {
        when(() => api.getInwentaryzacjaDetails(70)).thenAnswer(
          (_) async => const DataResponse(
            data: GetInwentaryzacjaDetailsResponseData(
              inwentaryzacja: GetInwentaryzacjaDetailsHeader(
                id: 70,
                firma: 15,
                numer: 'INV/70',
                status: 1,
              ),
              komisja: [
                GetInwentaryzacjaDetailsKomisjaItem(
                  id: 1,
                  userId: 3759,
                  displayName: 'Jan Nowak',
                ),
              ],
              arkusze: [
                GetInwentaryzacjaDetailsArkuszItem(id: 700, idMiejsca: 101),
              ],
            ),
          ),
        );

        final result = await repository.fetchInventoryDetails(70);

        final data = result.getOrElse(
          () => const GetInwentaryzacjaDetailsResponseData(
            inwentaryzacja: GetInwentaryzacjaDetailsHeader(
              id: -1,
              firma: -1,
              numer: '',
              status: 0,
            ),
            komisja: [],
            arkusze: [],
          ),
        );

        expect(data.inwentaryzacja.id, 70);
        expect(data.arkusze.single.id, 700);
      },
    );
  });
}
