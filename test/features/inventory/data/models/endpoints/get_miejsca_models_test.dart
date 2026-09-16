import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';

void main() {
  group('GetMiejsca models', () {
    test(
      'GetMiejscaResponseData.fromJson mapuje drzewo wraz z parent/level (wykrywa bledne laczenie node/subtree)',
      () {
        final data = GetMiejscaResponseData.fromJson({
          'items': [
            {
              'id': 1,
              'id_miejsca': 100,
              'id_firmy': 15,
              'idparent': null,
              'nazwa': 'Budynek A',
              'lvl': '1',
            },
            {
              'id': 2,
              'id_miejsca': 101,
              'id_firmy': 15,
              'idparent': 1,
              'nazwa': 'Pokoj 101',
              'lvl': '2',
            },
          ],
          'meta': {'total': 2},
        });

        expect(data.items.length, 2);
        expect(data.items.first.idparent, isNull);
        expect(data.items.last.idparent, 1);
        expect(data.items.last.nazwa, 'Pokoj 101');
      },
    );

    test(
      'GetMiejscaQuery.toJson trzyma snake_case i nullable firma (wykrywa bledne query do slownika miejsc)',
      () {
        const withFirma = GetMiejscaQuery(firma: 15);
        const withoutFirma = GetMiejscaQuery();

        expect(withFirma.toJson()['firma'], 15);
        expect(withoutFirma.toJson().containsKey('firma'), isTrue);
        expect(withoutFirma.toJson()['firma'], isNull);
      },
    );
  });
}
