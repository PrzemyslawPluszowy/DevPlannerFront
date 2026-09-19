import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Responsywny nagłówek listy statusów workflow i jej akcji.
class ProjectWorkflowHeader extends StatelessWidget {
  const ProjectWorkflowHeader({
    required this.statusesCount,
    required this.canManage,
    required this.isSaving,
    required this.onOpenTemplates,
    required this.onCreateStatus,
    super.key,
  });

  final int statusesCount;
  final bool canManage;
  final bool isSaving;
  final VoidCallback onOpenTemplates;
  final VoidCallback onCreateStatus;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.projectSettingsWorkflowColumnsHeader,
              style: context.text.titleMedium?.copyWith(
                fontWeight: .w700,
                color: colors.onSurface,
              ),
            ),
            Gaps.h4,
            Text(
              'Liczba kolumn: $statusesCount',
              style: context.text.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        );
        final actions = Wrap(
          spacing: Sizes.p8,
          runSpacing: Sizes.p8,
          children: [
            Tooltip(
              message: !canManage
                  ? 'Brak uprawnień do edycji workflow (wymagana rola Właściciel lub Administrator)'
                  : isSaving
                  ? 'Trwa zapisywanie zmian...'
                  : 'Wybierz gotowy szablon etapów workflow',
              child: OutlinedButton.icon(
                onPressed: !canManage || isSaving ? null : onOpenTemplates,
                icon: const Icon(Icons.auto_awesome_rounded, size: Sizes.p16),
                label: Text(l10n.projectSettingsWorkflowTemplatesButton),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(Sizes.p8),
                  ),
                ),
              ),
            ),
            Tooltip(
              message: !canManage
                  ? 'Brak uprawnień do dodawania statusów (wymagana rola Właściciel lub Administrator)'
                  : isSaving
                  ? 'Trwa zapisywanie zmian...'
                  : 'Utwórz nowy status/kolumnę w projekcie',
              child: FilledButton.icon(
                onPressed: !canManage || isSaving ? null : onCreateStatus,
                icon: const Icon(Icons.add_rounded, size: Sizes.p18),
                label: Text(l10n.projectSettingsWorkflowAddStatus),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(Sizes.p8),
                  ),
                ),
              ),
            ),
          ],
        );
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              if (canManage) ...[Gaps.h12, actions],
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: title),
            Gaps.w16,
            actions,
          ],
        );
      },
    );
  }
}
