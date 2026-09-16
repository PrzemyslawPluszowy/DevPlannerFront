import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/workspaces/presentation/workspaces_section.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_feature_wrapper.dart';

/// Informacyjna treść sekcji oczekującej na właściwy kontrakt domenowy.
class WorkspacesSectionPlaceholder extends StatelessWidget {
  /// Tworzy placeholder dla wskazanej sekcji menu.
  const WorkspacesSectionPlaceholder({required this.section, super.key});

  /// Aktywnie wybrana sekcja menu.
  final WorkspacesSection section;

  @override
  Widget build(BuildContext context) => WorkspaceFeatureWrapper(
    title: section.label(context.l10n),
    icon: section.icon,
    subtitle: 'Widok i narzędzia dedykowane dla tej sekcji',
    isEmpty: true,
    emptyTitle: section.label(context.l10n),
    emptyMessage: context.l10n.workspacesSectionPending,
  );
}
