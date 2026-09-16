import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_tree_progress_models.dart';

void main() {
  test(
    'fromJson: przyjmuje totals bez ambiguous_places_count',
    () {
      final response = GetInwentaryzacjaTreeProgressResponseData.fromJson({
        'meta': {
          'scope': 'inwentaryzacja',
          'scope_id': 71,
          'generated_at': '2026-07-02T10:00:00+02:00',
          'inwentaryzacja': {
            'id': 71,
            'numer': 'INV/71',
            'status': 1,
          },
          'firmy_scope': <int>[],
          'totals': {
            'items_count': 0,
          },
        },
        'items': <Object?>[],
      });

      expect(response.meta.totals.itemsCount, 0);
      expect(response.meta.totals.ambiguousPlacesCount, 0);
      expect(response.items, isEmpty);
    },
  );
}
