import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';

void main() {
  test(
    'GetInwentaryzacjaReportResponseData.fromJson: mapuje meta, totals i compensation 1:1 z backendu',
    () {
      final response = GetInwentaryzacjaReportResponseData.fromJson({
        'meta': {
          'scope': 'inventory',
          'scope_id': 71,
          'report_type': 'kompensaty',
          'generated_at': '2026-04-22T10:15:00+02:00',
          'inwentaryzacja': {
            'id': 71,
            'numer': 'INV/71',
            'status': 1,
          },
          'filters': {
            'include_summary': true,
            'sort_by': 'nrewid',
            'sort_dir': 'asc',
          },
          'totals': {
            'count': 2,
            'wartosc_p_sum': '120.00',
            'wartosc_a_sum': '80.00',
          },
        },
        'elements': [
          {
            'element_id': 15,
            'arkusz_id': 201,
            'arkusz_numer': 'ARK/15',
            'inwentaryzacja_id': 71,
            'nrewid': 'ST-15',
            'nazwa': 'Krzeslo',
            'osoba': 'Jan Kowalski',
            'miejsce': 'Biuro',
            'data_zakupu': '2026-04-10',
            'stan_inwent': 'discrepancy',
            'status_spisu': 'nadwyzka',
            'compensation': {
              'pair_element_id': 16,
              'pair_arkusz_id': 202,
              'match_key': '15:ST-15',
              'brak_element_id': 15,
              'brak_arkusz_id': 201,
              'brak_miejsce': 'Biuro A',
              'brak_osoba': 'Jan Kowalski',
              'nadwyzka_element_id': 16,
              'nadwyzka_arkusz_id': 202,
              'nadwyzka_miejsce': 'Biuro B',
              'nadwyzka_osoba': 'Anna Nowak',
            },
          },
        ],
      });

      expect(response.meta.reportType, InwentaryzacjaReportType.kompensaty);
      expect(response.meta.inwentaryzacja?.numer, 'INV/71');
      expect(response.meta.filters?.sortBy, 'nrewid');
      expect(response.meta.totals?.count, 2);
      expect(response.elements.single.dataZakupu, '2026-04-10');
      expect(response.elements.single.compensation?.pairElementId, 16);
      expect(response.elements.single.compensation?.matchKey, '15:ST-15');
      expect(response.elements.single.compensation?.brakMiejsce, 'Biuro A');
      expect(response.elements.single.compensation?.brakOsoba, 'Jan Kowalski');
      expect(
        response.elements.single.compensation?.nadwyzkaMiejsce,
        'Biuro B',
      );
      expect(
        response.elements.single.compensation?.nadwyzkaOsoba,
        'Anna Nowak',
      );
    },
  );

  test(
    'displayElementsForInventoryReport: kompensaty pokazuje jako unikalne pary',
    () {
      const brak = GetInwentaryzacjaReportElementItem(
        elementId: 15,
        arkuszId: 201,
        inwentaryzacjaId: 71,
        nrewid: 'ST-15',
        compensation: GetInwentaryzacjaReportCompensation(
          pairElementId: 16,
          pairArkuszId: 202,
          brakElementId: 15,
          brakArkuszId: 201,
          nadwyzkaElementId: 16,
          nadwyzkaArkuszId: 202,
        ),
      );
      const nadwyzka = GetInwentaryzacjaReportElementItem(
        elementId: 16,
        arkuszId: 202,
        inwentaryzacjaId: 71,
        nrewid: 'ST-15',
        compensation: GetInwentaryzacjaReportCompensation(
          pairElementId: 15,
          pairArkuszId: 201,
          brakElementId: 15,
          brakArkuszId: 201,
          nadwyzkaElementId: 16,
          nadwyzkaArkuszId: 202,
        ),
      );

      final visible = displayElementsForInventoryReport(
        reportType: InwentaryzacjaReportType.kompensaty,
        elements: const [nadwyzka, brak],
      );

      expect(visible, hasLength(1));
      expect(visible.single.elementId, 15);
    },
  );
}
