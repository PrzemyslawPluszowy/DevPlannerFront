import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_atoms.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_models.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Podgląd tablicy Kanban zbudowany z kolumn i zadań szablonu.
///
/// Widget nie zna portów: dostaje gotowy [ProjectPreviewSnapshot]. Gęstość
/// kafelka zmienia liczbę linii tytułu i liczbę znaczników, więc użytkownik
/// widzi skutek ustawienia, a nie samą nazwę opcji.
class TemplateKanbanPreview extends StatelessWidget {
  /// Tworzy podgląd tablicy.
  const TemplateKanbanPreview({
    required this.snapshot,
    this.density = KanbanCardDensity.comfortable,
    super.key,
  });

  /// Klucz podglądu tablicy używany w testach.
  static const Key previewKey = ValueKey('project-preview-kanban');

  /// Szerokość pojedynczej kolumny podglądu.
  static const double columnWidth = 168;

  /// Dane podglądu.
  final ProjectPreviewSnapshot snapshot;

  /// Gęstość kafelka zapisana w drafcie.
  final KanbanCardDensity density;

  @override
  Widget build(BuildContext context) {
    final columns = snapshot.columns;
    if (columns.isEmpty) return const SizedBox.shrink();
    return SingleChildScrollView(
      key: previewKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final column in columns) ...[
            SizedBox(
              width: columnWidth,
              child: _KanbanColumn(column: column, density: density),
            ),
            Gaps.w8,
          ],
        ],
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  const _KanbanColumn({required this.column, required this.density});

  final ProjectPreviewColumn column;
  final KanbanCardDensity density;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final accent = projectPreviewColor(column.colorHex, colors.primary);
    final wipLimit = column.wipLimit;
    final isOverLimit = wipLimit != null && column.taskCount > wipLimit;
    return Container(
      padding: const EdgeInsets.all(Sizes.p8),
      decoration: BoxDecoration(
        color: context.surfaceRoles.raisedBackground,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p10)),
        border: Border.all(
          color: isOverLimit ? colors.error : context.surfaceRoles.raisedBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                ),
              ),
              Gaps.w6,
              Expanded(
                child: Text(
                  column.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (column.isDefault)
                AppPreviewPin(
                  color: colors.onSurfaceVariant,
                  semanticLabel: l10n.projectSetupStatusDefaultLabel,
                ),
            ],
          ),
          Gaps.h6,
          Wrap(
            spacing: Sizes.p4,
            runSpacing: Sizes.p4,
            children: [
              ProjectPreviewBadge(
                label: '${column.taskCount}',
                icon: Symbols.task_alt,
              ),
              if (column.wipLimit case final limit?)
                ProjectPreviewBadge(
                  label: l10n.projectSetupPreviewWipBadge(limit),
                  icon: Symbols.speed,
                  tone: isOverLimit
                      ? ProjectPreviewTone.error
                      : ProjectPreviewTone.neutral,
                ),
            ],
          ),
          if (column.taskTitles.isNotEmpty) ...[
            Gaps.h8,
            for (final title in column.taskTitles) ...[
              _KanbanCard(title: title, density: density, accent: accent),
              Gaps.h4,
            ],
          ],
          if (column.hiddenTaskCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: Sizes.p2),
              child: Text(
                l10n.projectSetupPreviewMoreTasks(column.hiddenTaskCount),
                style: context.text.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _KanbanCard extends StatelessWidget {
  const _KanbanCard({
    required this.title,
    required this.density,
    required this.accent,
  });

  final String title;
  final KanbanCardDensity density;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final maxLines = switch (density) {
      KanbanCardDensity.compact => 1,
      KanbanCardDensity.comfortable => 2,
      KanbanCardDensity.detailed => 3,
    };
    final padding = switch (density) {
      KanbanCardDensity.compact => const EdgeInsets.all(Sizes.p4),
      KanbanCardDensity.comfortable => const EdgeInsets.all(Sizes.p6),
      KanbanCardDensity.detailed => const EdgeInsets.all(Sizes.p8),
    };
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p6)),
        border: Border(
          left: BorderSide(color: accent, width: 3),
        ),
      ),
      child: Text(
        title,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: context.text.labelSmall,
      ),
    );
  }
}

/// Ikona przypięcia kolumny domyślnej z opisem dla czytnika ekranu.
class AppPreviewPin extends StatelessWidget {
  /// Tworzy ikonę przypięcia.
  const AppPreviewPin({
    required this.color,
    required this.semanticLabel,
    super.key,
  });

  /// Kolor ikony.
  final Color color;

  /// Opis dla czytnika ekranu.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    child: Icon(Symbols.push_pin, size: 13, color: color),
  );
}
