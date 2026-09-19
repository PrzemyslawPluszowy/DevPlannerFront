import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/admin/tabs/templates/cubit/project_templates_cubit.dart';
import 'package:flutter/material.dart';

/// Dialog podglądu składowych szablonu projektu.
class ProjectTemplateDetailsDialog extends StatefulWidget {
  const ProjectTemplateDetailsDialog({
    required this.templateId,
    required this.templateName,
    required this.cubit,
    super.key,
  });

  final String templateId;
  final String templateName;
  final ProjectTemplatesCubit cubit;

  @override
  State<ProjectTemplateDetailsDialog> createState() =>
      _ProjectTemplateDetailsDialogState();
}

class _ProjectTemplateDetailsDialogState
    extends State<ProjectTemplateDetailsDialog> {
  final ValueNotifier<_ProjectTemplateDetailsLoadState> _loadState =
      ValueNotifier(const _ProjectTemplateDetailsLoadState.loading());

  @override
  void initState() {
    super.initState();
    unawaited(_fetchDetails());
  }

  Future<void> _fetchDetails() async {
    final details = await widget.cubit.getTemplateDetails(widget.templateId);
    if (mounted) {
      _loadState.value = _ProjectTemplateDetailsLoadState.loaded(details);
    }
  }

  @override
  void dispose() {
    _loadState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final contentWidth = (size.width * .85).clamp(280.0, 640.0);
    final contentHeight = (size.height * .65).clamp(300.0, 480.0);

    return ValueListenableBuilder<_ProjectTemplateDetailsLoadState>(
      valueListenable: _loadState,
      builder: (context, loadState, _) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.dashboard_customize_rounded,
              color: colors.primary,
              size: Sizes.p20,
            ),
            Gaps.w8,
            Expanded(
              child: Text(
                '${l10n.projectSettingsTemplateDetailsTitle}: ${widget.templateName}',
                style: context.text.titleMedium?.copyWith(fontWeight: .w700),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: contentWidth,
          height: contentHeight,
          child: switch (loadState) {
            _ProjectTemplateDetailsLoadState(isLoading: true) => const Center(
              child: CircularProgressIndicator(),
            ),
            _ProjectTemplateDetailsLoadState(details: null) => Center(
              child: Text(
                l10n.workspacesErrorTitle,
                style: context.text.bodyMedium?.copyWith(color: colors.error),
              ),
            ),
            _ProjectTemplateDetailsLoadState(:final details?) =>
              _ProjectTemplateDetailsContent(details: details),
          },
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.workspacesCancelButton),
          ),
        ],
      ),
    );
  }
}

class _ProjectTemplateDetailsContent extends StatelessWidget {
  const _ProjectTemplateDetailsContent({required this.details});

  final ProjectTemplateDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _TemplateDetailSection(
            title: l10n.projectSettingsTemplateDetailsWorkflow,
            content: Wrap(
              spacing: Sizes.p8,
              runSpacing: Sizes.p6,
              children: details.workflow
                  .map(
                    (workflow) => Chip(
                      label: Text(workflow.name),
                      backgroundColor: colors.surfaceContainerHighest,
                    ),
                  )
                  .toList(),
            ),
          ),
          if (details.customStatuses?.isNotEmpty ?? false)
            _TemplateDetailSection(
              title: l10n.projectSettingsWorkflowColumnsHeader,
              content: Wrap(
                spacing: Sizes.p8,
                runSpacing: Sizes.p6,
                children: details.customStatuses!
                    .map(
                      (status) => Chip(
                        avatar: CircleAvatar(
                          radius: Sizes.p8,
                          backgroundColor: _TemplateStatusColor.parse(
                            status.color,
                            colors.primary,
                          ),
                        ),
                        label: Text(status.name),
                      ),
                    )
                    .toList(),
              ),
            ),
          _TemplateDetailSection(
            title: l10n.projectSettingsTemplateDetailsCustomFields,
            content: details.customFields.isEmpty
                ? _EmptyDetailText(
                    text: l10n.projectSettingsTemplateDetailsNoFields,
                  )
                : Wrap(
                    spacing: Sizes.p8,
                    runSpacing: Sizes.p6,
                    children: details.customFields
                        .map(
                          (field) => Chip(
                            avatar: const Icon(
                              Icons.tune_rounded,
                              size: Sizes.p16,
                            ),
                            label: Text('${field.name} (${field.type})'),
                          ),
                        )
                        .toList(),
                  ),
          ),
          _TemplateDetailSection(
            title: l10n.projectSettingsTemplateDetailsLabels,
            content: details.labels.isEmpty
                ? _EmptyDetailText(
                    text: l10n.projectSettingsTemplateDetailsNoLabels,
                  )
                : Wrap(
                    spacing: Sizes.p8,
                    runSpacing: Sizes.p6,
                    children: details.labels
                        .map(
                          (label) => Chip(
                            avatar: const Icon(
                              Icons.label_outline_rounded,
                              size: Sizes.p16,
                            ),
                            label: Text(label.name),
                          ),
                        )
                        .toList(),
                  ),
          ),
          _TemplateDetailSection(
            title: l10n.projectSettingsTemplateDetailsTasks(
              details.tasks.length,
            ),
            content: details.tasks.isEmpty
                ? _EmptyDetailText(
                    text: l10n.projectSettingsTemplateDetailsNoTasks,
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: details.tasks.length,
                    separatorBuilder: (_, _) => Gaps.h6,
                    itemBuilder: (context, index) => _TemplateTaskRow(
                      task: details.tasks[index],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TemplateDetailSection extends StatelessWidget {
  const _TemplateDetailSection({required this.title, required this.content});

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .only(bottom: Sizes.p16),
    child: Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          title,
          style: context.text.titleSmall?.copyWith(fontWeight: .w700),
        ),
        Gaps.h8,
        content,
      ],
    ),
  );
}

class _EmptyDetailText extends StatelessWidget {
  const _EmptyDetailText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.text.bodySmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    ),
  );
}

class _TemplateTaskRow extends StatelessWidget {
  const _TemplateTaskRow({required this.task});

  final ProjectTemplateTaskResponse task;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(Sizes.p8),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .4)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_box_outline_blank_rounded,
            size: Sizes.p16,
            color: colors.primary,
          ),
          Gaps.w8,
          Expanded(
            child: Text(
              task.title,
              style: context.text.bodySmall?.copyWith(fontWeight: .w600),
            ),
          ),
          if (task.checklist.isNotEmpty) ...[
            Gaps.w8,
            Text(
              '✓ ${task.checklist.length}',
              style: context.text.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TemplateStatusColor {
  static Color parse(String value, Color fallback) {
    final hex = value.replaceFirst('#', '');
    if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hex)) return fallback;
    return Color(int.parse('FF$hex', radix: 16));
  }
}

class _ProjectTemplateDetailsLoadState {
  const _ProjectTemplateDetailsLoadState.loading()
    : isLoading = true,
      details = null;

  const _ProjectTemplateDetailsLoadState.loaded(this.details)
    : isLoading = false;

  final bool isLoading;
  final ProjectTemplateDetailsResponse? details;
}
