import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';

void main() {
  group('GetStanSt models', () {
    test(
      'SrodekTrwalyStatus.fromApi mapuje wszystkie znane wartosci i odrzuca obce (wykrywa zly status ST na UI)',
      () {
        expect(SrodekTrwalyStatus.fromApi(null), SrodekTrwalyStatus.brak);
        expect(
          SrodekTrwalyStatus.fromApi(0),
          SrodekTrwalyStatus.niezatwierdzone,
        );
        expect(
          SrodekTrwalyStatus.fromApi(1),
          SrodekTrwalyStatus.wUzytkowaniu,
        );
        expect(
          SrodekTrwalyStatus.fromApi(2),
          SrodekTrwalyStatus.zlikwidowany,
        );
        expect(SrodekTrwalyStatus.fromApi(4), SrodekTrwalyStatus.sprzedane);
        expect(
          SrodekTrwalyStatus.fromApi(5),
          SrodekTrwalyStatus.przeniesiony,
        );
        expect(
          SrodekTrwalyStatus.fromApi(99),
          SrodekTrwalyStatus.nieWystepujeWSt,
        );
        expect(SrodekTrwalyStatus.fromApi(999), isNull);
      },
    );

    test(
      'GetStanStItem.status korzysta z mapowania `stan` (wykrywa rozjazd miedzy DTO i helperem)',
      () {
        const item = GetStanStItem(id: 1, stan: 1);
        expect(item.status, SrodekTrwalyStatus.wUzytkowaniu);
      },
    );

    test(
      'GetStanStQuery.toJson trzyma snake_case zgodnie z kontraktem backendu (wykrywa bledne klucze query)',
      () {
        const query = GetStanStQuery(
          firma: 15,
          limit: 50,
          offset: 100,
          nazwa: 'Laptop',
          nrewid: 'ST-1',
          kodKreskowy: '123',
        );

        final json = query.toJson();

        expect(json['firma'], 15);
        expect(json['limit'], 50);
        expect(json['offset'], 100);
        expect(json['nazwa'], 'Laptop');
        expect(json['nrewid'], 'ST-1');
        expect(json['kod_kreskowy'], '123');
      },
    );
  });
}
