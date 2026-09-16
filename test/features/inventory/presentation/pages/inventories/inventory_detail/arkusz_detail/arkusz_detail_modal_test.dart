import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/users_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_detail_modal.dart';
import 'package:ready_next/l10n/app_localizations.dart';

/// Mock repozytorium arkuszy i inwentaryzacji.
class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

/// Mock repozytorium miejsc.
class _MockLocationsRepository extends Mock implements LocationsRepository {}

/// Mock repozytorium stanow magazynowych i firm.
class _MockStockRepository extends Mock implements StockRepository {}

/// Mock repozytorium uzytkownikow.
class _MockUsersRepository extends Mock implements UsersRepository {}

void main() {
  const inventoryCompanies = [
    GetInwentaryzacjaDetailsFirmaItem(id: 15, nazwaFirmy: 'Firma testowa'),
  ];

  late InventoriesRepository inventoriesRepository;
  late LocationsRepository locationsRepository;
  late StockRepository stockRepository;
  late UsersRepository usersRepository;

  setUp(() {
    inventoriesRepository = _MockInventoriesRepository();
    locationsRepository = _MockLocationsRepository();
    stockRepository = _MockStockRepository();
    usersRepository = _MockUsersRepository();
  });

  Future<void> pumpLauncher({
    required WidgetTester tester,
    required int arkuszId,
    required String arkuszNumber,
    required bool canDeleteArkusz,
    required bool canEditArkusz,
    required GetArkuszDetailsResponseData details,
  }) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    when(
      () => inventoriesRepository.fetchArkuszDetails(arkuszId),
    ).thenAnswer((_) async => Right(details));

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
        home: MediaQuery(
          data: const MediaQueryData(
            textScaler: TextScaler.linear(0.9),
          ),
          child: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () {
                    unawaited(
                      showArkuszDetailModal(
                        context,
                        arkuszId: arkuszId,
                        arkuszNumber: arkuszNumber,
                        inventoryCompanies: inventoryCompanies,
                        canDeleteArkusz: canDeleteArkusz,
                        canEditArkusz: canEditArkusz,
                        inventoriesRepository: inventoriesRepository,
                        locationsRepository: locationsRepository,
                        stockRepository: stockRepository,
                        usersRepository: usersRepository,
                      ),
                    );
                  },
                  child: const Text('Otworz arkusz'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Otworz arkusz'));
    await tester.pumpAndSettle();
  }

  group('showArkuszDetailModal', () {
    testWidgets(
      'pokazuje metadane, format daty i etykiete tabeli bez dopisku ST',
      (tester) async {
        const details = GetArkuszDetailsResponseData(
          arkusz: GetArkuszDetailsHeader(
            id: 12,
            idInwentaryzacja: 70,
            numer: 'ARK/12',
            idMiejsca: 101,
            nazwaMiejsca: 'Magazyn glowny',
            lvlMiejsca: '2',
            firma: 15,
            wczytanest: 1,
            rozpoczecie: '2026-04-16T07:05:00',
            zakonczenie: '2026-04-16T08:40:00',
          ),
          komisja: [
            GetArkuszDetailsKomisjaItem(
              userId: 3759,
              displayName: 'Anna Kowalska',
            ),
            GetArkuszDetailsKomisjaItem(userId: 3812, displayName: ''),
          ],
          elementy: [
            GetArkuszDetailsElementItem(
              id: 9001,
              nazwa: 'Laptop',
              nrewid: 'ST/1',
              osoba: 'Jan Nowak',
              aktualnyStan: SrodekTrwalyStatus.zlikwidowany,
              idmiejsce: 101,
              miejsce: 'Magazyn glowny',
              lvl: '2',
              kodKreskowy: 123456,
              wartoscP: '1000,50',
              wartoscA: '900,50',
              stanInwent: ArkuszElementInwentStatus.zgodny,
              nowyKodKreskowy: '123456',
              nowaOsoba: 'Jan Nowak',
              nowaNazwa: 'Laptop',
              uwagiLoc: 'Przeniesiony',
              kkWczytany: false,
              nadwIdmiejsce: 101,
              nadwMiejsce: 'Magazyn glowny',
              nadwLvl: '2',
            ),
          ],
        );

        await pumpLauncher(
          tester: tester,
          arkuszId: 12,
          arkuszNumber: 'ARK/12',
          canDeleteArkusz: true,
          canEditArkusz: true,
          details: details,
        );

        expect(find.text('Szczegóły arkusza'), findsOneWidget);
        expect(find.text('Arkusz spisu'), findsNothing);
        expect(find.text('Magazyn glowny'), findsOneWidget);
        expect(find.text('Elementy:'), findsOneWidget);
        expect(find.text('Komisja:'), findsOneWidget);
        expect(find.text('Lvl miejsca:'), findsOneWidget);
        expect(find.text('Start:'), findsOneWidget);
        expect(find.text('Koniec:'), findsOneWidget);
        expect(find.text('16.04.2026 07:05'), findsOneWidget);
        expect(find.text('16.04.2026 08:40'), findsOneWidget);
        expect(find.text('Anna Kowalska'), findsOneWidget);
        expect(find.text('Użytkownik'), findsOneWidget);
        expect(find.text('Status ST'), findsNothing);
        expect(find.text('Status spisu (opcje)'), findsOneWidget);
        expect(find.text('Dostępny'), findsOneWidget);
        expect(find.text('Skan'), findsOneWidget);
      },
    );

    testWidgets(
      'uzywa fallbackow dla pustego naglowka i pustej komisji',
      (tester) async {
        const details = GetArkuszDetailsResponseData(
          arkusz: GetArkuszDetailsHeader(
            id: 13,
            idInwentaryzacja: 70,
            numer: 'ARK/13',
            firma: 15,
            wczytanest: 0,
            rozpoczecie: '   ',
          ),
          komisja: [],
          elementy: [],
        );

        await pumpLauncher(
          tester: tester,
          arkuszId: 13,
          arkuszNumber: 'ARK/13',
          canDeleteArkusz: true,
          canEditArkusz: true,
          details: details,
        );

        expect(find.text('Arkusz spisu'), findsOneWidget);
        expect(find.text('Brak przypisanej komisji'), findsOneWidget);
        expect(find.text('Lvl miejsca:'), findsNothing);
        expect(find.text('Start:'), findsNothing);
        expect(find.text('Koniec:'), findsNothing);
        expect(find.text('Elementy:'), findsOneWidget);
        expect(find.text('Komisja:'), findsOneWidget);
      },
    );

    testWidgets(
      'otwiera legende statusow po kliknieciu ikony informacji',
      (tester) async {
        const details = GetArkuszDetailsResponseData(
          arkusz: GetArkuszDetailsHeader(
            id: 14,
            idInwentaryzacja: 70,
            numer: 'ARK/14',
            firma: 15,
            nazwaMiejsca: 'Magazyn glowny',
          ),
          komisja: [
            GetArkuszDetailsKomisjaItem(
              userId: 3759,
              displayName: 'Anna Kowalska',
            ),
          ],
          elementy: [],
        );

        await pumpLauncher(
          tester: tester,
          arkuszId: 14,
          arkuszNumber: 'ARK/14',
          canDeleteArkusz: true,
          canEditArkusz: true,
          details: details,
        );

        await tester.tap(find.byIcon(Icons.info_outline_rounded));
        await tester.pumpAndSettle();

        expect(find.text('Status spisu (opcje)'), findsOneWidget);
        expect(find.text('Dostępny'), findsNothing);
        expect(find.text('Skan'), findsOneWidget);
        expect(find.text('Nadwyżka'), findsOneWidget);
        expect(find.text('Nowy'), findsOneWidget);
        expect(find.text('Znaleziony w innej firmie'), findsOneWidget);
        expect(find.text('Niejednoznaczny kod'), findsOneWidget);
        expect(find.text('Sprzedany w trakcie'), findsOneWidget);
        expect(find.text('Zakupiony w trakcie'), findsOneWidget);
        expect(find.text('0 - Niewczytane skanerem'), findsOneWidget);
        expect(find.text('1 - Wczytane skanerem'), findsOneWidget);
      },
    );

    testWidgets(
      'pokazuje akcje dodawania elementu i modal reczny z opcjonalnym kodem kreskowym',
      (tester) async {
        const details = GetArkuszDetailsResponseData(
          arkusz: GetArkuszDetailsHeader(
            id: 15,
            idInwentaryzacja: 70,
            numer: 'ARK/15',
            firma: 15,
            nazwaMiejsca: 'Magazyn glowny',
          ),
          komisja: [],
          elementy: [],
        );

        await pumpLauncher(
          tester: tester,
          arkuszId: 15,
          arkuszNumber: 'ARK/15',
          canDeleteArkusz: true,
          canEditArkusz: true,
          details: details,
        );

        expect(find.text('Dodaj'), findsOneWidget);
        expect(find.text('Dodaj po nr ewid.'), findsOneWidget);

        await tester.tap(find.text('Dodaj'));
        await tester.pumpAndSettle();

        expect(find.text('Dodaj element arkusza'), findsOneWidget);
        expect(
          find.text(
            'Pole opcjonalne. Jeśli zostawisz puste, backend zapisze 0.',
          ),
          findsOneWidget,
        );
        expect(find.text('Data zakupu'), findsOneWidget);
      },
    );
  });
}
