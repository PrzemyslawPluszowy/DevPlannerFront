import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_atoms.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_models.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Podsumowanie zawartości szablonu: etykiety, pola własne i liczby.
///
/// Wycinek nigdy nie udaje całości: pokazuje pierwsze pozycje i liczbę
/// pozostałych, żeby użytkownik wiedział, co jeszcze powstanie z szablonu.
class TemplateContentsSummary extends StatelessWidget {
  /// Tworzy podsumowanie zawartości.
  const TemplateContentsSummary({
    required this.snapshot,
    this.version,
    super.key,
  });

  /// Liczba pozycji pokazywanych w jednym rzędzie.
  static const int visibleNames = 3;

  /// Dane podglądu.
  final ProjectPreviewSnapshot snapshot;

  /// Wersja szablonu, jeśli podgląd pochodzi z szablonu.
  final int? version;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasLabels = snapshot.labels.isNotEmpty;
    final hasFields = snapshot.fields.isNotEmpty;
    if (!hasLabels && !hasFields) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasLabels) ...[
          ProjectSetupPreviewListLegend(
            icon: Symbols.label,
            label: l10n.projectSetupTemplateLabelsCount(
              snapshot.labels.length,
            ),
          ),
          Gaps.h6,
          _Names(names: snapshot.labels),
        ],
        if (hasLabels && hasFields) Gaps.h12,
        if (hasFields) ...[
          ProjectSetupPreviewListLegend(
            icon: Symbols.category,
            label: l10n.projectSetupTemplateFieldsCount(
              snapshot.fields.length,
            ),
          ),
          Gaps.h6,
          _Names(names: snapshot.fields),
        ],
        if (version case final value?) ...[
          Gaps.h12,
          ProjectPreviewBadge(
            label: l10n.projectSetupTemplateVersionLabel(value),
            icon: Symbols.layers,
          ),
        ],
      ],
    );
  }
}

class _Names extends StatelessWidget {
  const _Names({required this.names});

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visible = names.length <= TemplateContentsSummary.visibleNames
        ? names
        : names.sublist(0, TemplateContentsSummary.visibleNames);
    final hidden = names.length - visible.length;
    return Wrap(
      spacing: Sizes.p6,
      runSpacing: Sizes.p6,
      children: [
        for (final name in visible)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p8,
              vertical: Sizes.p4,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: const BorderRadius.all(Radius.circular(Sizes.p6)),
            ),
            child: Text(
              name,
              style: context.text.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        if (hidden > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
            child: Text(
              context.l10n.projectSetupPreviewMoreItems(hidden),
              style: context.text.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

/// Etykieta sekcji listy podglądu.
class ProjectSetupPreviewListLegend extends StatelessWidget {
  /// Tworzy etykietę sekcji.
  const ProjectSetupPreviewListLegend({
    required this.label,
    this.icon,
    super.key,
  });

  /// Tekst etykiety.
  final String label;

  /// Ikona etykiety.
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (icon case final value?) ...[
        Icon(value, size: 14, color: context.colors.onSurfaceVariant),
        Gaps.w6,
      ],
      Text(
        label,
        style: context.text.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: context.colors.onSurfaceVariant,
        ),
      ),
    ],
  );
}
