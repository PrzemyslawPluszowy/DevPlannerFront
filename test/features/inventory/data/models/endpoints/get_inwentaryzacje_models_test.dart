import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';

void main() {
  group('GetInwentaryzacje models', () {
    test(
      'GetInwentaryzacjeItem.fromJson: nieznany status mapuje na InwentaryzacjaStatus.nieznany (wykrywa regresje kontraktu enumow)',
      () {
        final item = GetInwentaryzacjeItem.fromJson({
          'id': 10,
          'firma': 15,
          'numer': 'INV/10',
          'status': 12345,
          'komisja_count': 1,
          'arkusze_count': 2,
        });

        expect(item.status, InwentaryzacjaStatus.nieznany);
      },
    );

    test(
      'InwentaryzacjaStatus.fromApi oraz apiValue mapuja wartosci 1:1 (wykrywa przesuniecia statusow miedzy UI i backendem)',
      () {
        expect(InwentaryzacjaStatus.fromApi(0), InwentaryzacjaStatus.nowa);
        expect(InwentaryzacjaStatus.fromApi(1), InwentaryzacjaStatus.wToku);
        expect(
          InwentaryzacjaStatus.fromApi(2),
          InwentaryzacjaStatus.zakonczona,
        );
        expect(
          InwentaryzacjaStatus.fromApi(-1),
          InwentaryzacjaStatus.nieznany,
        );
        expect(InwentaryzacjaStatus.fromApi(999), isNull);

        expect(InwentaryzacjaStatus.nowa.apiValue, 0);
        expect(InwentaryzacjaStatus.wToku.apiValue, 1);
        expect(InwentaryzacjaStatus.zakonczona.apiValue, 2);
      },
    );

    test(
      'SortBy/SortDirection apiValue zwracaja wartosci zgodne z query backendu (wykrywa bledne sortowanie po stronie API)',
      () {
        expect(GetInwentaryzacjeSortBy.dataOd.apiValue, 'data_od');
        expect(GetInwentaryzacjeSortBy.dataDo.apiValue, 'data_do');
        expect(GetInwentaryzacjeSortDirection.asc.apiValue, 'ASC');
        expect(GetInwentaryzacjeSortDirection.desc.apiValue, 'DESC');
      },
    );
  });
}
