import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';

/// Modal wyboru gotowych szablonów workflow (Standardowy, IT/Software, Marketing, HR, Produkcja).
class ProjectWorkflowTemplatesDialog extends StatelessWidget {
  const ProjectWorkflowTemplatesDialog({
    required this.templates,
    super.key,
  });

  /// Lista dostępnych szablonów z backendu.
  final List<WorkflowTemplateSummary> templates;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return WorkspaceCreationModalWrapper(
      title: l10n.projectSettingsWorkflowTemplatesButton,
      subtitle: 'Wybierz zestaw gotowych kolumn i etapów dla Twojego projektu.',
      icon: Icons.auto_awesome_rounded,
      submitLabel: '', // Niepotrzebny, kliknięcie w szablon wybiera go od razu
      cancelLabel: l10n.tasksListCancelButton,
      maxWidth: 500,
      onSubmit: () {},
      body: ListView.separated(
        shrinkWrap: true,
        itemCount: templates.length,
        separatorBuilder: (_, _) => Gaps.h8,
        itemBuilder: (ctx, index) {
          final template = templates[index];

          return InkWell(
            onTap: () => Navigator.of(ctx).pop(template),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
                color: colors.surfaceContainerLowest,
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer.withValues(alpha: .5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.view_kanban_rounded,
                          size: 16,
                          color: colors.primary,
                        ),
                      ),
                      Gaps.w8,
                      Expanded(
                        child: Text(
                          template.name,
                          style: context.text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                  Gaps.h8,
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (final statusName in template.statusNames)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest.withValues(
                              alpha: .6,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusName,
                            style: context.text.labelSmall?.copyWith(
                              fontSize: 11,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
