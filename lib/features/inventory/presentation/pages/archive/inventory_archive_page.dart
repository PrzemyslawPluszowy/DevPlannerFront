import 'package:flutter/material.dart';

import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/features/inventory/presentation/widgets/inventory_section_placeholder_card.dart';

/// Ekran sekcji "Firmy".
class InventoryArchivePage extends StatelessWidget {
  /// Tworzy ekran sekcji "Firmy".
  const InventoryArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    return InventorySectionPlaceholderCard(
      title: intl.inventoryArchiveTitle,
      subtitle: intl.inventoryArchiveSubtitle,
    );
  }
}
