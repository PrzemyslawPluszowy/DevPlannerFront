import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Pusty stan pól własnych z jedną akcją utworzenia.
class ProjectCustomFieldsEmptyState extends StatelessWidget {
  const ProjectCustomFieldsEmptyState({
    required this.canCreate,
    required this.isSaving,
    required this.onCreate,
    super.key,
  });

  final bool canCreate;
  final bool isSaving;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p32),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(Sizes.p16),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const .all(Sizes.p16),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.data_object_rounded,
              size: Sizes.p36,
              color: colors.primary,
            ),
          ),
          Gaps.h16,
          Text(
            l10n.projectSettingsCustomFieldsEmpty,
            style: context.text.titleSmall?.copyWith(
              fontWeight: .w700,
              color: colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          Gaps.h6,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              'Dodaj własne pola tekstowe, liczbowe, daty lub listy wyboru do '
              'zadań w tym projekcie.',
              style: context.text.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (canCreate) ...[
            Gaps.h20,
            FilledButton.icon(
              onPressed: isSaving ? null : onCreate,
              icon: const Icon(Icons.add_rounded, size: Sizes.p18),
              label: Text(l10n.projectSettingsAddCustomField),
            ),
          ],
        ],
      ),
    );
  }
}
