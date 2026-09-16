import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/delete_firma_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/shared/data/models/data_response.dart';

class _MockInventoryApi extends Mock implements InventoryApi {}

void main() {
  late InventoryApi api;
  late StockRepository repository;

  setUp(() {
    api = _MockInventoryApi();
    repository = StockRepositoryImpl(api: api);
  });

  group('StockRepositoryImpl', () {
    test(
      'fetchCompanies: cache zwraca te same dane bez ponownego GET (wykrywa niepotrzebne obciazenie backendu)',
      () async {
        when(() => api.getFirmy()).thenAnswer(
          (_) async => const DataResponse(
            data: GetFirmyResponseData(
              items: [
                GetFirmyItem(id: 1, idFirmy: 1, nazwa: 'A'),
                GetFirmyItem(id: 2, idFirmy: 2, nazwa: 'B'),
              ],
              meta: GetFirmyMeta(total: 2),
            ),
          ),
        );

        final first = await repository.fetchCompanies();
        final second = await repository.fetchCompanies();

        expect(first.isRight(), isTrue);
        expect(second.isRight(), isTrue);

        final firstItems = first.getOrElse(() => const []);
        final secondItems = second.getOrElse(() => const []);

        expect(firstItems.length, 2);
        expect(identical(firstItems, secondItems), isTrue);
        expect(
          () => firstItems.add(
            const GetFirmyItem(id: 9, idFirmy: 9, nazwa: 'X'),
          ),
          throwsUnsupportedError,
        );

        verify(() => api.getFirmy()).called(1);
      },
    );

    test(
      'fetchCompanies(forceRefresh): pomija cache i odpytuje backend ponownie (wykrywa zastałe dane po odswiezeniu)',
      () async {
        when(() => api.getFirmy()).thenAnswer(
          (_) async => const DataResponse(
            data: GetFirmyResponseData(
              items: [GetFirmyItem(id: 10, idFirmy: 10, nazwa: 'AA')],
              meta: GetFirmyMeta(total: 1),
            ),
          ),
        );

        await repository.fetchCompanies();
        await repository.fetchCompanies(forceRefresh: true);

        verify(() => api.getFirmy()).called(2);
      },
    );

    test(
      'deleteCompany: po sukcesie czysci cache firm (wykrywa bug, gdzie UI pokazuje usunieta firme)',
      () async {
        when(() => api.getFirmy()).thenAnswer(
          (_) async => const DataResponse(
            data: GetFirmyResponseData(
              items: [GetFirmyItem(id: 5, idFirmy: 5, nazwa: 'Przed')],
              meta: GetFirmyMeta(total: 1),
            ),
          ),
        );

        await repository.fetchCompanies();

        when(() => api.deleteFirma(5)).thenAnswer(
          (_) async => const DataResponse(
            data: DeleteFirmaResponseData(id: 5),
          ),
        );

        await repository.deleteCompany(5);

        when(() => api.getFirmy()).thenAnswer(
          (_) async => const DataResponse(
            data: GetFirmyResponseData(
              items: [GetFirmyItem(id: 7, idFirmy: 7, nazwa: 'Po')],
              meta: GetFirmyMeta(total: 1),
            ),
          ),
        );

        final afterDelete = await repository.fetchCompanies();
        final items = afterDelete.getOrElse(() => const []);

        expect(items.single.idFirmy, 7);
        verify(() => api.deleteFirma(5)).called(1);
        verify(() => api.getFirmy()).called(2);
      },
    );

    test(
      'fetchStock: mapuje DioException na ApiError.connection (wykrywa brak obslugi awarii sieci)',
      () async {
        when(
          () => api.getStanSt(
            firma: any(named: 'firma'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            nazwa: any(named: 'nazwa'),
            nrewid: any(named: 'nrewid'),
            kodKreskowy: any(named: 'kodKreskowy'),
          ),
        ).thenThrow(
          DioException.connectionError(
            requestOptions: RequestOptions(
              path: '/api/v1/inwentaryzacja/stan_st',
            ),
            reason: 'offline',
          ),
        );

        final result = await repository.fetchStock(
          const GetStanStQuery(nazwa: 'Laptop'),
        );

        expect(result.isLeft(), isTrue);
        final error = result.fold((left) => left, (_) => null);
        expect(error?.type, ApiErrorType.connection);
      },
    );

    test(
      'fetchStock: mapuje wyjatek parsowania na ApiError.parsing (wykrywa ciche przyjmowanie uszkodzonej odpowiedzi)',
      () async {
        when(
          () => api.getStanSt(
            firma: any(named: 'firma'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            nazwa: any(named: 'nazwa'),
            nrewid: any(named: 'nrewid'),
            kodKreskowy: any(named: 'kodKreskowy'),
          ),
        ).thenThrow(const FormatException('bad payload'));

        final result = await repository.fetchStock(const GetStanStQuery());

        final error = result.fold((left) => left, (_) => null);
        expect(error?.type, ApiErrorType.parsing);
        expect(error?.message, 'Backend zwrócił nieprawidłowe dane stanów ŚT.');
      },
    );

    test(
      'fetchStock: zwraca dane z backendu i przekazuje query 1:1 (wykrywa zle mapowanie filtrow)',
      () async {
        when(
          () => api.getStanSt(
            firma: 2,
            baza: 'CENTRALA',
            idmiejsce: 50102,
            q: 'krzesło',
            limit: 30,
            offset: 60,
            nrewid: 'ST-12',
          ),
        ).thenAnswer(
          (_) async => const DataResponse(
            data: GetStanStResponseData(
              items: [GetStanStItem(id: 1, nrewid: 'ST-12')],
              meta: GetStanStMeta(total: 1, limit: 30, offset: 60),
            ),
          ),
        );

        final result = await repository.fetchStock(
          const GetStanStQuery(
            firma: 2,
            baza: 'CENTRALA',
            idmiejsce: 50102,
            q: 'krzesło',
            limit: 30,
            offset: 60,
            nrewid: 'ST-12',
          ),
        );

        expect(result.isRight(), isTrue);
        final data = result.getOrElse(
          () => const GetStanStResponseData(
            items: [],
            meta: GetStanStMeta(total: 0, limit: 0, offset: 0),
          ),
        );
        expect(data.items.single.nrewid, 'ST-12');
      },
    );
  });
}
