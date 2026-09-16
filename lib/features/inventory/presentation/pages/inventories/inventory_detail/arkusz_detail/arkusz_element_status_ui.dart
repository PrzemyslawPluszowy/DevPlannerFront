import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';

String statusSpisuFieldLabel(BuildContext context) =>
    context.l10n.inventoryStatusSpisuFieldLabel;

String statusSpisuNoSelectionLabel(BuildContext context) =>
    context.l10n.inventoryStatusSpisuNoOptions;

const kVisibleStatusSpisuOptions = <ArkuszElementStatusSpisu>[
  ArkuszElementStatusSpisu.nadwyzka,
  ArkuszElementStatusSpisu.nowy,
  ArkuszElementStatusSpisu.znalezionyWInnejFirmie,
  ArkuszElementStatusSpisu.niejednoznacznyKod,
  ArkuszElementStatusSpisu.sprzedanyWTrakcie,
  ArkuszElementStatusSpisu.zakupionyWTrakcie,
];

String inventoryAvailabilityLabel(
  BuildContext context,
  ArkuszElementInwentStatus? status,
) {
  return switch (status) {
    null ||
    ArkuszElementInwentStatus.brak => context.l10n.inventoryCountStatusMissing,
    ArkuszElementInwentStatus.zgodny =>
      context.l10n.inventoryCountStatusPresent,
    ArkuszElementInwentStatus.przeniesiony =>
      context.l10n.inventoryCountStatusTransferred,
  };
}

String inventoryStatusSpisuOptionsHelperText(BuildContext context) {
  return context.l10n.inventoryChangeItemStatusTitle;
}

String assetStatusDescription(
  BuildContext context,
  SrodekTrwalyStatus status,
) {
  return switch (status) {
    SrodekTrwalyStatus.brak =>
      context.l10n.inventoryAssetStateMissingDescription,
    SrodekTrwalyStatus.niezatwierdzone =>
      context.l10n.inventoryAssetStateUnapprovedDescription,
    SrodekTrwalyStatus.wUzytkowaniu =>
      context.l10n.inventoryAssetStateInUseDescription,
    SrodekTrwalyStatus.zlikwidowany =>
      context.l10n.inventoryAssetStateDisposedDescription,
    SrodekTrwalyStatus.sprzedane =>
      context.l10n.inventoryAssetStateSoldDescription,
    SrodekTrwalyStatus.przeniesiony =>
      context.l10n.inventoryAssetStateTransferredDescription,
    SrodekTrwalyStatus.nieWystepujeWSt =>
      context.l10n.inventoryAssetStateNotInAssetsDescription,
  };
}

extension ArkuszElementInwentStatusUi on ArkuszElementInwentStatus {
  String localizedLabel(BuildContext context) {
    return inventoryAvailabilityLabel(context, this);
  }

  AppStatusBadgeTone get tone {
    return switch (this) {
      ArkuszElementInwentStatus.brak => AppStatusBadgeTone.neutral,
      ArkuszElementInwentStatus.zgodny => AppStatusBadgeTone.success,
      ArkuszElementInwentStatus.przeniesiony => AppStatusBadgeTone.danger,
    };
  }

  IconData get icon {
    return switch (this) {
      ArkuszElementInwentStatus.brak => Icons.remove_rounded,
      ArkuszElementInwentStatus.zgodny => Icons.check_circle_rounded,
      ArkuszElementInwentStatus.przeniesiony => Icons.warning_amber_rounded,
    };
  }

  Color dropdownForegroundColor(BuildContext context) {
    return statusToneForegroundColor(context, tone);
  }

  AppDropdownOption<ArkuszElementInwentStatus> toDropdownOption(
    BuildContext context,
  ) {
    return AppDropdownOption<ArkuszElementInwentStatus>(
      value: this,
      label: localizedLabel(context),
      icon: icon,
      foregroundColor: dropdownForegroundColor(context),
    );
  }

  AppStatusBadge toBadge(BuildContext context) {
    return AppStatusBadge(
      label: localizedLabel(context),
      tone: tone,
      icon: icon,
      showBorder: false,
    );
  }
}

extension ArkuszElementStatusSpisuUi on ArkuszElementStatusSpisu {
  String localizedLabel(BuildContext context) {
    return switch (this) {
      ArkuszElementStatusSpisu.nadwyzka =>
        context.l10n.inventoryCountStatusExcess,
      ArkuszElementStatusSpisu.nowy => context.l10n.inventoryCountStatusNew,
      ArkuszElementStatusSpisu.znalezionyWInnejFirmie =>
        context.l10n.inventoryCountStatusFoundInOtherCompany,
      ArkuszElementStatusSpisu.niejednoznacznyKod =>
        context.l10n.inventoryCountStatusAmbiguousCode,
      ArkuszElementStatusSpisu.sprzedanyWTrakcie =>
        context.l10n.inventoryCountStatusSoldDuringInventory,
      ArkuszElementStatusSpisu.zakupionyWTrakcie =>
        context.l10n.inventoryCountStatusPurchasedDuringInventory,
    };
  }

  AppStatusBadgeTone get tone {
    return switch (this) {
      ArkuszElementStatusSpisu.nadwyzka => AppStatusBadgeTone.warning,
      ArkuszElementStatusSpisu.nowy => AppStatusBadgeTone.info,
      ArkuszElementStatusSpisu.znalezionyWInnejFirmie =>
        AppStatusBadgeTone.neutral,
      ArkuszElementStatusSpisu.niejednoznacznyKod => AppStatusBadgeTone.danger,
      ArkuszElementStatusSpisu.sprzedanyWTrakcie => AppStatusBadgeTone.neutral,
      ArkuszElementStatusSpisu.zakupionyWTrakcie => AppStatusBadgeTone.success,
    };
  }

  IconData get icon {
    return switch (this) {
      ArkuszElementStatusSpisu.nadwyzka => Icons.add_circle_outline_rounded,
      ArkuszElementStatusSpisu.nowy => Icons.fiber_new_rounded,
      ArkuszElementStatusSpisu.znalezionyWInnejFirmie => Icons.business_rounded,
      ArkuszElementStatusSpisu.niejednoznacznyKod => Icons.help_outline_rounded,
      ArkuszElementStatusSpisu.sprzedanyWTrakcie => Icons.sell_rounded,
      ArkuszElementStatusSpisu.zakupionyWTrakcie => Icons.shopping_cart_rounded,
    };
  }

  String description(BuildContext context) {
    return switch (this) {
      ArkuszElementStatusSpisu.nadwyzka =>
        context.l10n.inventoryCountStatusExcessDescription,
      ArkuszElementStatusSpisu.nowy =>
        context.l10n.inventoryCountStatusNewDescription,
      ArkuszElementStatusSpisu.znalezionyWInnejFirmie =>
        context.l10n.inventoryCountStatusFoundInOtherCompanyDescription,
      ArkuszElementStatusSpisu.niejednoznacznyKod =>
        context.l10n.inventoryCountStatusAmbiguousCodeDescription,
      ArkuszElementStatusSpisu.sprzedanyWTrakcie =>
        context.l10n.inventoryCountStatusSoldDuringInventoryDescription,
      ArkuszElementStatusSpisu.zakupionyWTrakcie =>
        context.l10n.inventoryCountStatusPurchasedDuringInventoryDescription,
    };
  }

  Color dropdownForegroundColor(BuildContext context) {
    return statusToneForegroundColor(context, tone);
  }

  AppDropdownOption<ArkuszElementStatusSpisu?> toDropdownOption(
    BuildContext context,
  ) {
    return AppDropdownOption<ArkuszElementStatusSpisu?>(
      value: this,
      label: localizedLabel(context),
      icon: icon,
      foregroundColor: dropdownForegroundColor(context),
    );
  }

  AppStatusBadge toBadge(BuildContext context) {
    return AppStatusBadge(
      label: localizedLabel(context),
      tone: tone,
      icon: icon,
      showBorder: false,
    );
  }
}

Color statusToneForegroundColor(BuildContext context, AppStatusBadgeTone tone) {
  final feedback = context.feedback;
  return switch (tone) {
    AppStatusBadgeTone.neutral => context.colors.onSurface.withValues(
      alpha: .92,
    ),
    AppStatusBadgeTone.info => feedback.infoForeground,
    AppStatusBadgeTone.success => feedback.successForeground,
    AppStatusBadgeTone.warning => feedback.warningForeground,
    AppStatusBadgeTone.danger => feedback.errorForeground,
  };
}
