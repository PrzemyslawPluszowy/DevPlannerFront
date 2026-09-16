part of 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/inventory_detail_modal.dart';

/// Chip pojedynczego czlonka komisji.
class _InventoryDetailCommissionChip extends StatelessWidget {
  /// Tworzy chip czlonka komisji.
  const _InventoryDetailCommissionChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: .5),
        borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          const AppIcon(
            Icons.person_outline_rounded,
            tone: .muted,
          ),
          const SizedBox(width: Sizes.p4),
          AppText(
            name,
            style: context.text.labelMedium?.copyWith(fontWeight: .w600),
          ),
        ],
      ),
    );
  }
}

/// Chip metadanych szczegolow inwentaryzacji.
class _InventoryDetailMetaChip extends StatelessWidget {
  /// Tworzy chip metadanych szczegolow inwentaryzacji.
  const _InventoryDetailMetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: Sizes.p8, vertical: 2),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest.withValues(alpha: .5),
        borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          AppText(
            '$label: ',
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant.withValues(alpha: .7),
            ),
          ),
          AppText(
            value,
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}
