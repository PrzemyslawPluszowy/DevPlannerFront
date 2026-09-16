import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/change_item/change_item_form_logic.dart';

void main() {
  group('change_item_form_logic', () {
    test(
      'znaleziony_w_innej_firmie wymusza discrepancy i wyłącza likwidację oraz nadwyżkę',
      () {
        const status = ArkuszElementStatusSpisu.znalezionyWInnejFirmie;

        expect(shouldForceDiscrepancyStatus(status), isTrue);
        expect(shouldRestrictToLocationOnly(status), isTrue);
        expect(
          resolveSubmittedInventoryStatus(
            inventoryStatus: ArkuszElementInwentStatus.zgodny,
            statusSpisu: status,
          ),
          ArkuszElementInwentStatus.przeniesiony,
        );
        expect(
          resolveSubmittedLiquidation(
            likwidacja: true,
            statusSpisu: status,
          ),
          isFalse,
        );
        expect(
          resolveSubmittedSurplus(
            statusSpisu: status,
            nadwyzka: true,
          ),
          isFalse,
        );
      },
    );

    test('nadwyżka bez statusu ustawia status nadwyżki', () {
      expect(
        resolveSubmittedStatusSpisu(
          statusSpisu: null,
          nadwyzka: true,
        ),
        ArkuszElementStatusSpisu.nadwyzka,
      );
      expect(
        resolveSubmittedSurplus(
          statusSpisu: ArkuszElementStatusSpisu.nadwyzka,
          nadwyzka: false,
        ),
        isTrue,
      );
    });

    test('zwykła niezgodność nie blokuje likwidacji ani ręcznego wyniku', () {
      expect(shouldRestrictToLocationOnly(null), isFalse);
      expect(shouldForceDiscrepancyStatus(null), isFalse);
      expect(
        resolveSubmittedInventoryStatus(
          inventoryStatus: ArkuszElementInwentStatus.przeniesiony,
          statusSpisu: null,
        ),
        ArkuszElementInwentStatus.przeniesiony,
      );
      expect(
        resolveSubmittedLiquidation(
          likwidacja: true,
          statusSpisu: null,
        ),
        isTrue,
      );
    });
  });
}
