import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/shared/data/models/data_response.dart';

class _MockInventoryApi extends Mock implements InventoryApi {}

void main() {
  late InventoryApi api;
  late LocationsRepository repository;

  setUp(() {
    api = _MockInventoryApi();
    repository = LocationsRepositoryImpl(api: api);
  });

  group('LocationsRepositoryImpl', () {
    test(
      'fetchLocations: cache dziala per firma (wykrywa mieszanie drzew miedzy firmami)',
      () async {
        when(() => api.getMiejsca(firma: 1)).thenAnswer(
          (_) async => const DataResponse(
            data: GetMiejscaResponseData(
              items: [
                GetMiejscaItem(
                  id: 10,
                  idMiejsca: 100,
                  idFirmy: 1,
                  nazwa: 'Magazyn A',
                ),
              ],
              meta: GetMiejscaMeta(total: 1),
            ),
          ),
        );

        when(() => api.getMiejsca(firma: 2)).thenAnswer(
          (_) async => const DataResponse(
            data: GetMiejscaResponseData(
              items: [
                GetMiejscaItem(
                  id: 20,
                  idMiejsca: 200,
                  idFirmy: 2,
                  nazwa: 'Magazyn B',
                ),
              ],
              meta: GetMiejscaMeta(total: 1),
            ),
          ),
        );

        final firstA = await repository.fetchLocations(firma: 1);
        final secondA = await repository.fetchLocations(firma: 1);
        final firstB = await repository.fetchLocations(firma: 2);

        expect(firstA.isRight(), isTrue);
        expect(secondA.isRight(), isTrue);
        expect(firstB.isRight(), isTrue);

        verify(() => api.getMiejsca(firma: 1)).called(1);
        verify(() => api.getMiejsca(firma: 2)).called(1);

        final dataA = firstA.getOrElse(
          () => const GetMiejscaResponseData(
            items: [],
            meta: GetMiejscaMeta(total: 0),
          ),
        );
        expect(
          () => dataA.items.add(
            const GetMiejscaItem(id: 99, idMiejsca: 99, idFirmy: 1),
          ),
          throwsUnsupportedError,
        );
      },
    );

    test(
      'invalidateLocationsCache(firma): czysci tylko wybrany klucz cache (wykrywa przypadkowe czyszczenie wszystkiego)',
      () async {
        when(() => api.getMiejsca(firma: 1)).thenAnswer(
          (_) async => const DataResponse(
            data: GetMiejscaResponseData(
              items: [GetMiejscaItem(id: 1, idMiejsca: 11, idFirmy: 1)],
              meta: GetMiejscaMeta(total: 1),
            ),
          ),
        );
        when(() => api.getMiejsca(firma: 2)).thenAnswer(
          (_) async => const DataResponse(
            data: GetMiejscaResponseData(
              items: [GetMiejscaItem(id: 2, idMiejsca: 22, idFirmy: 2)],
              meta: GetMiejscaMeta(total: 1),
            ),
          ),
        );

        await repository.fetchLocations(firma: 1);
        await repository.fetchLocations(firma: 2);

        repository.invalidateLocationsCache(firma: 1);

        await repository.fetchLocations(firma: 1);
        await repository.fetchLocations(firma: 2);

        verify(() => api.getMiejsca(firma: 1)).called(2);
        verify(() => api.getMiejsca(firma: 2)).called(1);
      },
    );

    test(
      'invalidateLocationsCache(): bez firmy czyści caly cache (wykrywa pozostawienie starych danych)',
      () async {
        when(() => api.getMiejsca(firma: any(named: 'firma'))).thenAnswer(
          (_) async => const DataResponse(
            data: GetMiejscaResponseData(
              items: [GetMiejscaItem(id: 1, idMiejsca: 11, idFirmy: 1)],
              meta: GetMiejscaMeta(total: 1),
            ),
          ),
        );

        await repository.fetchLocations(firma: 1);
        repository.invalidateLocationsCache();
        await repository.fetchLocations(firma: 1);

        verify(() => api.getMiejsca(firma: 1)).called(2);
      },
    );

    test(
      'fetchLocations: mapuje DioException na ApiError (wykrywa brak sygnalu bledu dla UI)',
      () async {
        when(() => api.getMiejsca(firma: any(named: 'firma'))).thenThrow(
          DioException.connectionError(
            requestOptions: RequestOptions(
              path: '/api/v1/inwentaryzacja/miejsca',
            ),
            reason: 'offline',
          ),
        );

        final result = await repository.fetchLocations(firma: 1);
        final error = result.fold((left) => left, (_) => null);

        expect(error?.type, ApiErrorType.connection);
      },
    );

    test(
      'fetchLocations: mapuje wyjatek modelu na ApiError.parsing (wykrywa uszkodzony kontrakt backendu)',
      () async {
        when(() => api.getMiejsca(firma: any(named: 'firma'))).thenThrow(
          const FormatException('bad payload'),
        );

        final result = await repository.fetchLocations(firma: 3);
        final error = result.fold((left) => left, (_) => null);

        expect(error?.type, ApiErrorType.parsing);
        expect(error?.message, 'Backend zwrócił nieprawidłowe dane miejsc.');
      },
    );
  });
}
