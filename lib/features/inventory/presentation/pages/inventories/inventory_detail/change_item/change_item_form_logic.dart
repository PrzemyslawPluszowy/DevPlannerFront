import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';

/// Zwraca status spisu, ktory finalnie powinien trafic do backendu.
ArkuszElementStatusSpisu? resolveSubmittedStatusSpisu({
  required ArkuszElementStatusSpisu? statusSpisu,
  required bool nadwyzka,
}) {
  return switch ((statusSpisu, nadwyzka)) {
    (final ArkuszElementStatusSpisu status, _) => status,
    (null, true) => ArkuszElementStatusSpisu.nadwyzka,
    (null, false) => null,
  };
}

/// Zwraca flage nadwyzki zgodna z backendowym kontraktem.
bool resolveSubmittedSurplus({
  required ArkuszElementStatusSpisu? statusSpisu,
  required bool nadwyzka,
}) {
  return switch (statusSpisu) {
    ArkuszElementStatusSpisu.nadwyzka => true,
    ArkuszElementStatusSpisu.nowy ||
    ArkuszElementStatusSpisu.znalezionyWInnejFirmie ||
    ArkuszElementStatusSpisu.niejednoznacznyKod ||
    ArkuszElementStatusSpisu.sprzedanyWTrakcie ||
    ArkuszElementStatusSpisu.zakupionyWTrakcie => false,
    null => nadwyzka,
  };
}

/// Informuje, czy backend wymusza wynik `discrepancy` dla danego statusu.
bool shouldForceDiscrepancyStatus(ArkuszElementStatusSpisu? statusSpisu) {
  return switch (statusSpisu) {
    ArkuszElementStatusSpisu.znalezionyWInnejFirmie ||
    ArkuszElementStatusSpisu.niejednoznacznyKod => true,
    _ => false,
  };
}

/// Informuje, czy formularz powinien ograniczyc edycje tylko do miejsca/firmy.
bool shouldRestrictToLocationOnly(ArkuszElementStatusSpisu? statusSpisu) {
  return switch (statusSpisu) {
    ArkuszElementStatusSpisu.znalezionyWInnejFirmie => true,
    _ => false,
  };
}

/// Zwraca stan inwentaryzacyjny, ktory finalnie powinien trafic do backendu.
ArkuszElementInwentStatus resolveSubmittedInventoryStatus({
  required ArkuszElementInwentStatus inventoryStatus,
  required ArkuszElementStatusSpisu? statusSpisu,
}) {
  if (shouldForceDiscrepancyStatus(statusSpisu)) {
    return ArkuszElementInwentStatus.przeniesiony;
  }

  return inventoryStatus;
}

/// Zwraca flage likwidacji zgodna z backendowymi ograniczeniami biznesowymi.
bool resolveSubmittedLiquidation({
  required bool likwidacja,
  required ArkuszElementStatusSpisu? statusSpisu,
}) {
  if (shouldForceDiscrepancyStatus(statusSpisu)) {
    return false;
  }

  return likwidacja;
}
