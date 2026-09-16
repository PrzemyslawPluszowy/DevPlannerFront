import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/cubit/inventory_report_cubit.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

void main() {
  late InventoriesRepository repository;
  const fallbackQuery = GetInwentaryzacjaReportQuery(
    reportType: InwentaryzacjaReportType.kompensaty,
  );

  const response = GetInwentaryzacjaReportResponseData(
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
  );

  setUp(() {
    repository = _MockInventoriesRepository();
    registerFallbackValue(fallbackQuery);
  });

  group('InventoryReportCubit', () {
    blocTest<InventoryReportCubit, InventoryReportState>(
      'load: emituje loading i success z raportem backendu',
      setUp: () {
        when(
          () => repository.fetchInventoryReport(
            inventoryId: 71,
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async => const Right(response));
      },
      build: () => InventoryReportCubit(
        repository: repository,
        reportType: InwentaryzacjaReportType.kompensaty,
      ),
      act: (cubit) => cubit.load(71),
      expect: () => const <InventoryReportState>[
        InventoryReportState(
          reportType: InwentaryzacjaReportType.kompensaty,
          sortBy: GetInwentaryzacjaReportSortBy.id,
          sortDir: GetInwentaryzacjaReportSortDirection.asc,
          result: LoadableLoading(),
        ),
        InventoryReportState(
          reportType: InwentaryzacjaReportType.kompensaty,
          sortBy: GetInwentaryzacjaReportSortBy.id,
          sortDir: GetInwentaryzacjaReportSortDirection.asc,
          result: LoadableSuccess(data: response),
        ),
      ],
      verify: (_) {
        final captured =
            verify(
                  () => repository.fetchInventoryReport(
                    inventoryId: 71,
                    query: captureAny(named: 'query'),
                  ),
                ).captured.single
                as GetInwentaryzacjaReportQuery;
        expect(captured.reportType, InwentaryzacjaReportType.kompensaty);
        expect(captured.includeSummary, isFalse);
        expect(captured.sortBy, GetInwentaryzacjaReportSortBy.id);
        expect(captured.sortDir, GetInwentaryzacjaReportSortDirection.asc);
      },
    );

    blocTest<InventoryReportCubit, InventoryReportState>(
      'updateSortBy: zmienia sortowanie i przeładowuje raport z nowym query',
      setUp: () {
        when(
          () => repository.fetchInventoryReport(
            inventoryId: 71,
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async => const Right(response));
      },
      build: () => InventoryReportCubit(
        repository: repository,
        reportType: InwentaryzacjaReportType.kompensaty,
      ),
      act: (cubit) => cubit.updateSortBy(
        71,
        GetInwentaryzacjaReportSortBy.nrewid,
      ),
      expect: () => const <InventoryReportState>[
        InventoryReportState(
          reportType: InwentaryzacjaReportType.kompensaty,
          sortBy: GetInwentaryzacjaReportSortBy.nrewid,
          sortDir: GetInwentaryzacjaReportSortDirection.asc,
        ),
        InventoryReportState(
          reportType: InwentaryzacjaReportType.kompensaty,
          sortBy: GetInwentaryzacjaReportSortBy.nrewid,
          sortDir: GetInwentaryzacjaReportSortDirection.asc,
          result: LoadableLoading(),
        ),
        InventoryReportState(
          reportType: InwentaryzacjaReportType.kompensaty,
          sortBy: GetInwentaryzacjaReportSortBy.nrewid,
          sortDir: GetInwentaryzacjaReportSortDirection.asc,
          result: LoadableSuccess(data: response),
        ),
      ],
      verify: (_) {
        final captured =
            verify(
                  () => repository.fetchInventoryReport(
                    inventoryId: 71,
                    query: captureAny(named: 'query'),
                  ),
                ).captured.single
                as GetInwentaryzacjaReportQuery;
        expect(captured.sortBy, GetInwentaryzacjaReportSortBy.nrewid);
      },
    );

    blocTest<InventoryReportCubit, InventoryReportState>(
      'load: emituje error gdy backend zwraca blad',
      setUp: () {
        when(
          () => repository.fetchInventoryReport(
            inventoryId: 71,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Raport jest chwilowo niedostępny.',
            ),
          ),
        );
      },
      build: () => InventoryReportCubit(
        repository: repository,
        reportType: InwentaryzacjaReportType.kompensaty,
      ),
      act: (cubit) => cubit.load(71),
      expect: () => const <InventoryReportState>[
        InventoryReportState(
          reportType: InwentaryzacjaReportType.kompensaty,
          sortBy: GetInwentaryzacjaReportSortBy.id,
          sortDir: GetInwentaryzacjaReportSortDirection.asc,
          result: LoadableLoading(),
        ),
        InventoryReportState(
          reportType: InwentaryzacjaReportType.kompensaty,
          sortBy: GetInwentaryzacjaReportSortBy.id,
          sortDir: GetInwentaryzacjaReportSortDirection.asc,
          result: LoadableError(message: 'Raport jest chwilowo niedostępny.'),
        ),
      ],
    );
  });
}
