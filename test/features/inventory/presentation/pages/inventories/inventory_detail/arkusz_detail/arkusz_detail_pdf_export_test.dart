import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/arkusz_detail/arkusz_detail_pdf_export.dart';

void main() {
  group('collectResponsiblePeopleForSignatures', () {
    test(
      'dla przekazania uwzglednia osobe przyjmujaca i pomija poprzednia osobe',
      () {
        const items = [
          GetArkuszDetailsElementItem(
            id: 12,
            osoba: 'Arkadiusz Liszewski',
            nowaOsoba: 'Andrzej Szczepocki',
          ),
        ];

        final signatures = collectResponsiblePeopleForSignatures(items);

        expect(signatures, ['Andrzej Szczepocki']);
      },
    );

    test(
      'gdy ta sama osoba ma inny element bez przekazania to pozostaje na liscie podpisow',
      () {
        const items = [
          GetArkuszDetailsElementItem(
            id: 12,
            osoba: 'Arkadiusz Liszewski',
            nowaOsoba: 'Andrzej Szczepocki',
          ),
          GetArkuszDetailsElementItem(
            id: 13,
            osoba: 'Arkadiusz Liszewski',
          ),
        ];

        final signatures = collectResponsiblePeopleForSignatures(items);

        expect(signatures, ['Andrzej Szczepocki', 'Arkadiusz Liszewski']);
      },
    );
  });
}
