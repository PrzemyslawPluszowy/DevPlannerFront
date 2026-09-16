import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/cubit/inventory_report_bundle_pdf_export_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_report_definition.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/reports/inventory_reports_flow.dart';
import 'package:ready_next/l10n/app_localizations.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

void main() {
  late InventoriesRepository repository;
  const fallbackQuery = GetInwentaryzacjaReportQuery(
    reportType: InwentaryzacjaReportType.ogolnyStanSpisu,
  );
  const inventoryDetails = GetInwentaryzacjaDetailsResponseData(
    inwentaryzacja: GetInwentaryzacjaDetailsHeader(
      id: 71,
      numer: 'INV/71',
      status: 1,
      dataOd: '2026-04-01',
      dataDo: '2026-04-30',
      firmaNazwa: 'Excellent',
    ),
    komisja: [
      GetInwentaryzacjaDetailsKomisjaItem(
        id: 1,
        userId: 10,
        displayName: 'Jan Kowalski',
      ),
    ],
    arkusze: [],
  );
  const reportResponse = GetInwentaryzacjaReportResponseData(
    meta: GetInwentaryzacjaReportMeta(
      scope: 'inventory',
      scopeId: 71,
      reportType: InwentaryzacjaReportType.ogolnyStanSpisu,
    ),
    elements: [
      GetInwentaryzacjaReportElementItem(
        elementId: 15,
        arkuszId: 201,
        inwentaryzacjaId: 71,
        nrewid: 'ST-15',
        nazwa: 'Krzeslo',
        dataZakupu: '2026-04-10',
      ),
    ],
  );

  setUp(() {
    repository = _MockInventoriesRepository();
    registerFallbackValue(fallbackQuery);
    when(
      () => repository.fetchInventoryReport(
        inventoryId: any(named: 'inventoryId'),
        query: any(named: 'query'),
      ),
    ).thenAnswer((_) async => const Right(reportResponse));
  });

  test(
    'InventoryReportBundlePdfExportCubit: pobiera raport koncowy rosnaco po numerze ewidencyjnym',
    () async {
      final cubit = InventoryReportBundlePdfExportCubit(repository: repository);
      addTearDown(cubit.close);

      await cubit.fetchBundleSections(71);

      final queries = verify(
        () => repository.fetchInventoryReport(
          inventoryId: 71,
          query: captureAny(named: 'query'),
        ),
      ).captured.cast<GetInwentaryzacjaReportQuery>();

      expect(queries, hasLength(InventoryReportDefinitions.fullBundle.length));
      for (final query in queries) {
        expect(query.sortBy, GetInwentaryzacjaReportSortBy.nrewid);
        expect(query.sortDir, GetInwentaryzacjaReportSortDirection.asc);
      }
    },
  );

  testWidgets(
    'showInventoryReportsFlow: pokazuje 8 raportow v1 w bocznym wyborze',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().light(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () => showInventoryReportsFlow(
                    context,
                    inventoryId: 71,
                    inventoryNumber: 'INV/71',
                    inventoryDetails: inventoryDetails,
                    repository: repository,
                  ),
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Raporty'), findsOneWidget);
      expect(find.text('Pobierz'), findsOneWidget);
      expect(find.text('Drukuj'), findsOneWidget);
      expect(find.text('Ogólny stan spisu'), findsOneWidget);
      expect(find.text('Braki inwentaryzacyjne'), findsOneWidget);
      expect(find.text('Nadwyżki inwentaryzacyjne'), findsOneWidget);
      expect(find.text('Kompensaty'), findsOneWidget);
      expect(find.text('Kasacje'), findsOneWidget);
      expect(
        find.text('Braki inwentaryzacyjne nieskompensowane'),
        findsOneWidget,
      );
      expect(
        find.text('Nadwyżki inwentaryzacyjne nieskompensowane'),
        findsOneWidget,
      );
      expect(find.text('Elementy znalezione w innych firmach'), findsOneWidget);
    },
  );

  testWidgets(
    'showInventoryReportsFlow: kasacje pokazuja osobne akcje protokolu',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().light(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () => showInventoryReportsFlow(
                    context,
                    inventoryId: 71,
                    inventoryNumber: 'INV/71',
                    inventoryDetails: inventoryDetails,
                    repository: repository,
                  ),
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kasacje'));
      await tester.pumpAndSettle();

      expect(find.text('Pobierz raport PDF'), findsOneWidget);
      expect(find.text('Drukuj raport PDF'), findsOneWidget);
      expect(find.text('Pobierz protokół'), findsOneWidget);
      expect(find.text('Drukuj protokół'), findsOneWidget);
    },
  );

  testWidgets(
    'showInventoryReportsFlow: tabela raportu sortuje po kliknieciu naglowka kolumny',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const sortableResponse = GetInwentaryzacjaReportResponseData(
        meta: GetInwentaryzacjaReportMeta(
          scope: 'inventory',
          scopeId: 71,
          reportType: InwentaryzacjaReportType.ogolnyStanSpisu,
        ),
        elements: [
          GetInwentaryzacjaReportElementItem(
            elementId: 15,
            arkuszId: 201,
            inwentaryzacjaId: 71,
            nrewid: 'ST-15',
            nazwa: 'Zulu',
          ),
          GetInwentaryzacjaReportElementItem(
            elementId: 16,
            arkuszId: 201,
            inwentaryzacjaId: 71,
            nrewid: 'ST-16',
            nazwa: 'Alfa',
          ),
        ],
      );

      when(
        () => repository.fetchInventoryReport(
          inventoryId: any(named: 'inventoryId'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => const Right(sortableResponse));

      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().light(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () => showInventoryReportsFlow(
                    context,
                    inventoryId: 71,
                    inventoryNumber: 'INV/71',
                    inventoryDetails: inventoryDetails,
                    repository: repository,
                  ),
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.text('Zulu')).dy,
        lessThan(tester.getTopLeft(find.text('Alfa')).dy),
      );

      await tester.tap(find.text('Nazwa').last);
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.text('Alfa')).dy,
        lessThan(tester.getTopLeft(find.text('Zulu')).dy),
      );
    },
  );

  testWidgets(
    'showInventoryReportsFlow: kompensaty wyszukuje po danych z compensation',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1800, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const compensationResponse = GetInwentaryzacjaReportResponseData(
        meta: GetInwentaryzacjaReportMeta(
          scope: 'inventory',
          scopeId: 71,
          reportType: InwentaryzacjaReportType.kompensaty,
        ),
        elements: [
          GetInwentaryzacjaReportElementItem(
            elementId: 16,
            arkuszId: 202,
            inwentaryzacjaId: 71,
            nrewid: 'ST-15',
            nazwa: 'Krzeslo',
            compensation: GetInwentaryzacjaReportCompensation(
              brakElementId: 15,
              brakArkuszId: 201,
              brakMiejsce: 'Magazyn A',
              brakOsoba: 'Jan Kowalski',
              nadwyzkaElementId: 16,
              nadwyzkaArkuszId: 202,
              nadwyzkaMiejsce: 'Magazyn B',
              nadwyzkaOsoba: 'Anna Nowak',
            ),
          ),
          GetInwentaryzacjaReportElementItem(
            elementId: 15,
            arkuszId: 201,
            inwentaryzacjaId: 71,
            nrewid: 'ST-15',
            nazwa: 'Krzeslo',
            compensation: GetInwentaryzacjaReportCompensation(
              brakElementId: 15,
              brakArkuszId: 201,
              brakMiejsce: 'Magazyn A',
              brakOsoba: 'Jan Kowalski',
              nadwyzkaElementId: 16,
              nadwyzkaArkuszId: 202,
              nadwyzkaMiejsce: 'Magazyn B',
              nadwyzkaOsoba: 'Anna Nowak',
            ),
          ),
        ],
      );

      when(
        () => repository.fetchInventoryReport(
          inventoryId: any(named: 'inventoryId'),
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async => const Right(compensationResponse));

      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().light(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () => showInventoryReportsFlow(
                    context,
                    inventoryId: 71,
                    inventoryNumber: 'INV/71',
                    inventoryDetails: inventoryDetails,
                    repository: repository,
                  ),
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kompensaty'));
      await tester.pumpAndSettle();

      expect(find.text('ST-15'), findsOneWidget);

      await tester.enterText(find.byType(TextField).last, 'Anna Nowak');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('ST-15'), findsOneWidget);
    },
  );
}
