import 'package:flutter/material.dart';

import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_info_container.dart';

/// Główna zawartość prawej kolumny modułu Inventory.
///
/// Ten widget renderuje:
/// - nagłówek sekcji (ikona + tytuł + opis),
/// - blok "Status modułu" z danymi sesji i kontekstu uruchomienia.
class InventoryModuleContent extends StatelessWidget {
  const InventoryModuleContent({
    required this.sectionLabel,
    required this.sectionIcon,
    required this.sectionDescription,
    required this.currentRoute,
    super.key,
  });

  final String sectionLabel;
  final IconData sectionIcon;
  final String sectionDescription;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.l10n;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Container(
          padding: const .symmetric(vertical: Sizes.p8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colors.outlineVariant.withValues(alpha: .9),
              ),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.primary,
                child: Icon(sectionIcon, size: 20),
              ),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      sectionLabel,
                      style: context.text.headlineSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h4,
                    Text(
                      sectionDescription,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gaps.h20,
        AppInfoContainer(
          title: intl.inventoryModuleStatusTitle,
          subtitle: intl.inventoryModuleStatusSubtitle,
          flat: true,
          showBorder: false,
          padding: .zero,
          child: Column(
            children: [
              _InfoLine(
                label: intl.inventoryModuleInitialRoute,
                value: currentRoute,
              ),
              _InfoLine(
                label: intl.inventoryModuleSession,
                value: intl.inventoryModuleSessionNoAuthContext,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const .symmetric(vertical: Sizes.p12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: .7),
                ),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.text.labelLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Gaps.w12,
          Flexible(
            child: Text(
              value,
              textAlign: .right,
              style: context.text.titleSmall?.copyWith(fontWeight: .w700),
            ),
          ),
        ],
      ),
    );
  }
}
