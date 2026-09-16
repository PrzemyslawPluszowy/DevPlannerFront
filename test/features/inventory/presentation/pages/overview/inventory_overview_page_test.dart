import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/overview/inventory_overview_page.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/services/stock_filter_service.dart';
import 'package:ready_next/l10n/app_localizations.dart';

import '../../../../../test_support/test_hive.dart';

class _MockStockRepository extends Mock implements StockRepository {}

class _FakeGetStanStQuery extends Fake implements GetStanStQuery {}

void main() {
  late StockRepository repository;
  late StockFilterService filterService;

  const stockData = GetStanStResponseData(
    items: [GetStanStItem(id: 1, nazwa: 'Laptop', nrewid: 'ST-1')],
    meta: GetStanStMeta(total: 1, limit: 50, offset: 0),
  );

  setUpAll(() async {
    registerFallbackValue(_FakeGetStanStQuery());
    await initTestHive(prefix: 'ready_next_inventory_overview_test_');
  });

  setUp(() async {
    await StockFilterStorage().clear();
    await StockFilterStorage().init(forceReload: true);
    repository = _MockStockRepository();
    filterService = StockFilterService();

    when(
      () => repository.fetchStock(any()),
    ).thenAnswer((_) async => const Right(stockData));
    when(
      () => repository.fetchCompanies(forceRefresh: any(named: 'forceRefresh')),
    ).thenAnswer(
      (_) async =>
          const Right([GetFirmyItem(id: 15, idFirmy: 15, nazwa: 'Firma A')]),
    );
  });

  tearDown(() async {
    await filterService.close();
  });

  Future<void> pumpOverviewPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<StockRepository>.value(value: repository),
          RepositoryProvider<StockFilterService>.value(value: filterService),
        ],
        child: MaterialApp(
          theme: MaterialTheme.crm().light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('pl'),
          home: const Scaffold(body: InventoryOverviewPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets(
    'ekran spina wyszukiwanie globalne i filtr statusu z query backendowym',
    (tester) async {
      await pumpOverviewPage(tester);
      clearInteractions(repository);

      filterService.setOffset(50);
      await tester.pumpAndSettle();
      clearInteractions(repository);

      await tester.enterText(find.byType(TextField), 'laptop');
      await tester.pump(const Duration(milliseconds: 400));

      final searchVerification = verify(
        () => repository.fetchStock(captureAny()),
      );
      searchVerification.called(1);
      final searchQuery = searchVerification.captured.single as GetStanStQuery;
      expect(searchQuery.q, 'laptop');
      expect(searchQuery.stan, isNull);
      expect(searchQuery.offset, 0);

      clearInteractions(repository);

      await tester.tap(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Stan: ',
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Zlikwidowany').last);
      await tester.pumpAndSettle();

      final statusVerification = verify(
        () => repository.fetchStock(captureAny()),
      );
      statusVerification.called(1);
      final statusQuery = statusVerification.captured.single as GetStanStQuery;
      expect(statusQuery.q, 'laptop');
      expect(statusQuery.stan, '2');
      expect(statusQuery.offset, 0);
      expect(filterService.currentStatus, SrodekTrwalyStatus.zlikwidowany);
    },
  );
}
