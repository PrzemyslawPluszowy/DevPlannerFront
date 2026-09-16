import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';

void main() {
  group('GetArkuszDetails models', () {
    test(
      'ArkuszElementInwentStatus.fromApi i apiValue sa spójne (wykrywa bledne mapowanie stan_inwent)',
      () {
        expect(
          ArkuszElementInwentStatus.fromApi(null),
          ArkuszElementInwentStatus.brak,
        );
        expect(
          ArkuszElementInwentStatus.fromApi(0),
          ArkuszElementInwentStatus.brak,
        );
        expect(
          ArkuszElementInwentStatus.fromApi('confirmed'),
          ArkuszElementInwentStatus.zgodny,
        );
        expect(
          ArkuszElementInwentStatus.fromApi('discrepancy'),
          ArkuszElementInwentStatus.przeniesiony,
        );
        expect(ArkuszElementInwentStatus.fromApi(999), isNull);

        expect(ArkuszElementInwentStatus.brak.apiValue, isNull);
        expect(ArkuszElementInwentStatus.zgodny.apiValue, 'confirmed');
        expect(
          ArkuszElementInwentStatus.przeniesiony.apiValue,
          'discrepancy',
        );
      },
    );

    test(
      'GetArkuszDetailsElementItem.inventoryStatus mapuje pole stanInwent (wykrywa niezgodnosc helpera i transportu)',
      () {
        const element = GetArkuszDetailsElementItem(
          id: 1,
          stanInwent: ArkuszElementInwentStatus.przeniesiony,
        );
        expect(element.inventoryStatus, ArkuszElementInwentStatus.przeniesiony);
      },
    );

    test(
      'GetArkuszDetailsElementItem.assetStatus mapuje pole aktualnyStan z backendu',
      () {
        const element = GetArkuszDetailsElementItem(
          id: 1,
          aktualnyStan: SrodekTrwalyStatus.wUzytkowaniu,
        );
        expect(element.assetStatus, SrodekTrwalyStatus.wUzytkowaniu);
      },
    );

    test('SrodekTrwalyStatus.fromApi obsluguje string enum aktualny_stan', () {
      expect(
        SrodekTrwalyStatus.fromApi('w_uzytkowaniu'),
        SrodekTrwalyStatus.wUzytkowaniu,
      );
      expect(
        SrodekTrwalyStatus.fromApi('sprzedany'),
        SrodekTrwalyStatus.sprzedane,
      );
      expect(
        SrodekTrwalyStatus.fromApi('poza_ewidencja'),
        SrodekTrwalyStatus.nieWystepujeWSt,
      );
    });

    test(
      'ArkuszElementStatusSpisu.fromApi i apiValue sa zgodne z lokalnym kontraktem backendu',
      () {
        expect(
          ArkuszElementStatusSpisu.fromApi('nadwyzka'),
          ArkuszElementStatusSpisu.nadwyzka,
        );
        expect(
          ArkuszElementStatusSpisu.fromApi('znaleziony_w_innej_firmie'),
          ArkuszElementStatusSpisu.znalezionyWInnejFirmie,
        );
        expect(
          ArkuszElementStatusSpisu.fromApi('niejednoznaczny_kod'),
          ArkuszElementStatusSpisu.niejednoznacznyKod,
        );
        expect(
          ArkuszElementStatusSpisu.fromApi('sprzedany_w_trakcie'),
          ArkuszElementStatusSpisu.sprzedanyWTrakcie,
        );
        expect(
          ArkuszElementStatusSpisu.fromApi('skasowany_w_trakcie'),
          isNull,
        );
        expect(
          ArkuszElementStatusSpisu.fromApi(
            'zakupiony_w_trakcie_inwentaryzacji',
          ),
          isNull,
        );

        expect(
          ArkuszElementStatusSpisu.znalezionyWInnejFirmie.apiValue,
          'znaleziony_w_innej_firmie',
        );
        expect(
          ArkuszElementStatusSpisu.niejednoznacznyKod.apiValue,
          'niejednoznaczny_kod',
        );
        expect(
          ArkuszElementStatusSpisu.sprzedanyWTrakcie.apiValue,
          'sprzedany_w_trakcie',
        );
      },
    );

    test(
      'GetArkuszDetailsResponseData.fromJson poprawnie mapuje zagniezdzone dane (wykrywa regresje DTO arkusza)',
      () {
        final data = GetArkuszDetailsResponseData.fromJson({
          'arkusz': {
            'id': 12,
            'id_inwentaryzacja': 70,
            'id_miejsca': 101,
            'nazwa_miejsca': 'Magazyn A',
          },
          'komisja': [
            {'user_id': 3759, 'display_name': 'Jan Nowak'},
          ],
          'elementy': [
            {
              'id': 1,
              'idarkusz_spisu': 777,
              'firma': 15,
              'nazwa': 'Laptop',
              'aktualny_stan': 'w_uzytkowaniu',
              'stan_inwent': 'confirmed',
              'status_spisu': 'zakupiony_w_trakcie',
              'kod_kreskowy': 123,
              'data_zakupu': '2026-04-10',
            },
          ],
        });

        expect(data.arkusz.idInwentaryzacja, 70);
        expect(data.komisja.single.userId, 3759);
        expect(data.elementy.single.idarkuszSpisu, 777);
        expect(data.elementy.single.firma, 15);
        expect(
          data.elementy.single.inventoryStatus,
          ArkuszElementInwentStatus.zgodny,
        );
        expect(
          data.elementy.single.assetStatus,
          SrodekTrwalyStatus.wUzytkowaniu,
        );
        expect(
          data.elementy.single.statusSpisu,
          ArkuszElementStatusSpisu.zakupionyWTrakcie,
        );
        expect(data.elementy.single.dataZakupu, '2026-04-10');
      },
    );
  });
}
