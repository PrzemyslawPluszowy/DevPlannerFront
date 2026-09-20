import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_shimmer.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Krok 1 kreatora: pusty projekt albo szablon całego projektu.
class ProjectSetupStartStep extends StatelessWidget {
  /// Tworzy krok wyboru sposobu startu.
  const ProjectSetupStartStep({required this.state, super.key});

  /// Bieżący stan kreatora.
  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final isBlank = !state.draft.usesTemplate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupChoiceCard(
          title: l10n.projectSetupStartBlankTitle,
          description: l10n.projectSetupStartBlankDescription,
          icon: Symbols.dashboard_customize,
          selected: isBlank,
          onSelected: cubit.selectBlankStart,
        ),
        Gaps.h8,
        switch (state.catalog.status) {
          ProjectSetupCatalogStatus.unavailable =>
            const _UnavailableCatalogNote(),
          ProjectSetupCatalogStatus.loading => const _CatalogSkeleton(),
          ProjectSetupCatalogStatus.failed => _CatalogFailure(
            message: state.catalog.error?.message,
          ),
          ProjectSetupCatalogStatus.ready => _TemplateList(state: state),
        },
        ProjectSetupFieldError(
          error: state.fieldErrors[ProjectSetupField.template],
        ),
      ],
    );
  }
}

class _UnavailableCatalogNote extends StatelessWidget {
  const _UnavailableCatalogNote();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.projectSetupTemplatesUnavailable,
            style: context.text.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Gaps.h2,
          Text(
            l10n.projectSetupTemplatesUnavailableReason,
            style: context.text.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogSkeleton extends StatelessWidget {
  const _CatalogSkeleton();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Gaps.h8,
      Text(
        context.l10n.projectSetupTemplatesLoading,
        style: context.text.bodySmall,
      ),
      Gaps.h8,
      for (var index = 0; index < 3; index++) ...[
        const AppShimmerBox(height: 58),
        Gaps.h8,
      ],
    ],
  );
}

class _CatalogFailure extends StatelessWidget {
  const _CatalogFailure({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message ?? l10n.projectSetupTemplatePreviewFailed,
            style: context.text.bodySmall?.copyWith(
              color: colors.onErrorContainer,
            ),
          ),
          Gaps.h8,
          FilledButton.tonal(
            onPressed: () =>
                context.read<ProjectSetupWizardCubit>().retryCatalog(),
            child: Text(l10n.projectSetupTemplatesRetry),
          ),
        ],
      ),
    );
  }
}

class _TemplateList extends StatelessWidget {
  const _TemplateList({required this.state});

  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final templates = state.catalog.templates;
    if (templates.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: Sizes.p8),
        child: Text(
          l10n.projectSetupTemplatesEmpty,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.h8,
        for (final template in templates) ...[
          _TemplateCard(
            template: template,
            state: state,
          ),
          Gaps.h8,
        ],
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.state});

  final ProjectTemplateResponse template;
  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final preview = state.templatePreviews[template.id];
    final isSelected =
        state.draft.usesTemplate && state.draft.templateId == template.id;
    return ProjectSetupChoiceCard(
      title: template.name,
      description: preview?.description?.trim().isNotEmpty ?? false
          ? preview!.description!.trim()
          : l10n.projectSetupStartTemplateDescription,
      icon: Symbols.auto_awesome_motion,
      selected: isSelected,
      onSelected: () {
        cubit.selectTemplateStart(
          template.id,
          templateName: template.name,
          version: template.version,
        );
        unawaited(cubit.ensureTemplatePreview(template.id));
      },
      trailing: _TemplateFacts(
        template: template,
        preview: preview,
        isLoading: state.templateLoadingId == template.id,
        // Błąd pokazuje wyłącznie karta, której podgląd naprawdę się nie powiódł.
        // Karta nigdy nie otwierana nie zobaczyła jeszcze podglądu, więc nie
        // może twierdzić, że pobranie się nie udało.
        errorMessage: state.templateErrorId == template.id
            ? state.templateError?.message ??
                  l10n.projectSetupTemplatePreviewFailed
            : null,
      ),
    );
  }
}

class _TemplateFacts extends StatelessWidget {
  const _TemplateFacts({
    required this.template,
    required this.preview,
    required this.isLoading,
    required this.errorMessage,
  });

  final ProjectTemplateResponse template;
  final ProjectTemplateDetailsResponse? preview;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final style = context.text.labelSmall?.copyWith(
      color: colors.onSurfaceVariant,
    );
    if (isLoading && preview == null) {
      return Text(l10n.projectSetupTemplatePreviewLoading, style: style);
    }
    if (preview == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage case final message?) ...[
            Text(
              message,
              style: context.text.labelSmall?.copyWith(color: colors.error),
            ),
            Gaps.h2,
          ],
          Text(
            l10n.projectSetupTemplateVersionLabel(template.version),
            style: style,
          ),
        ],
      );
    }
    final details = preview!;
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        Text(
          l10n.projectSetupTemplateTasksCount(details.tasks.length),
          style: style,
        ),
        Text(
          l10n.projectSetupTemplateLabelsCount(details.labels.length),
          style: style,
        ),
        Text(
          l10n.projectSetupTemplateFieldsCount(details.customFields.length),
          style: style,
        ),
        Text(
          l10n.projectSetupTemplateStatusesCount(
            details.customStatuses?.length ?? 0,
          ),
          style: style,
        ),
        Text(
          l10n.projectSetupTemplateVersionLabel(details.version),
          style: style,
        ),
      ],
    );
  }
}
