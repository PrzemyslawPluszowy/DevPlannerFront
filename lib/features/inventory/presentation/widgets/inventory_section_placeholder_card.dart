import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';

import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_section.dart';

/// Kontener sekcji inwentaryzacji z nagłówkiem i opcjonalnym placeholderem.
class InventorySectionPlaceholderCard extends StatelessWidget {
  /// Tworzy widok sekcji inwentaryzacji.
  const InventorySectionPlaceholderCard({
    required this.title,
    required this.subtitle,
    super.key,
    this.chips = const [],
    this.actions = const [],
    this.child,
    this.headerPadding = const EdgeInsets.symmetric(
      horizontal: Sizes.p16,
      vertical: Sizes.p12,
    ),
  });

  /// Tytuł sekcji.
  final String title;

  /// Krótki opis sekcji.
  final String subtitle;

  /// Chipy szybkich akcji lub filtrów sekcji.
  final List<AppActionChip> chips;

  /// Akcje sekcji renderowane po prawej stronie pod nagłówkiem.
  final List<Widget> actions;

  /// Główna zawartość sekcji.
  final Widget? child;

  /// Padding nagłówka sekcji.
  final EdgeInsets headerPadding;

  @override
  Widget build(BuildContext context) {
    return AppModuleSection(
      title: title,
      subtitle: subtitle,
      chips: chips,
      actions: actions,
      headerPadding: headerPadding,
      child: child,
    );
  }
}
