import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Etykieta sekcji kreatora projektu.
class ProjectSetupSectionLabel extends StatelessWidget {
  /// Tworzy etykietę sekcji.
  const ProjectSetupSectionLabel(this.label, {this.hint, super.key});

  /// Tekst etykiety.
  final String label;

  /// Opcjonalne wyjaśnienie pod etykietą.
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurfaceVariant,
          ),
        ),
        if (hint case final value?) ...[
          Gaps.h2,
          Text(
            value,
            style: context.text.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Błąd walidacji pokazywany przy konkretnym polu.
class ProjectSetupFieldError extends StatelessWidget {
  /// Tworzy komunikat błędu pola.
  const ProjectSetupFieldError({required this.error, super.key});

  /// Stabilny powód odrzucenia wartości.
  final ProjectSetupValidationError? error;

  @override
  Widget build(BuildContext context) {
    if (error case final value?) {
      return Padding(
        padding: const EdgeInsets.only(top: Sizes.p4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Symbols.error, size: 14, color: context.colors.error),
            Gaps.w4,
            Expanded(
              child: Text(
                ProjectSetupWizardL10n.validationError(context.l10n, value),
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

/// Karta wyboru jednej opcji kroku kreatora.
class ProjectSetupChoiceCard extends StatelessWidget {
  /// Tworzy kartę wyboru.
  const ProjectSetupChoiceCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.onSelected,
    this.icon,
    this.trailing,
    this.enabled = true,
    super.key,
  });

  /// Nazwa opcji.
  final String title;

  /// Opis skutków wyboru.
  final String description;

  /// Czy opcja jest wybrana.
  final bool selected;

  /// Wybór opcji.
  final VoidCallback onSelected;

  /// Ikona opcji.
  final IconData? icon;

  /// Dodatkowa treść pod opisem.
  final Widget? trailing;

  /// Czy opcję można wybrać.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: enabled ? onSelected : null,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(Sizes.p12),
          decoration: BoxDecoration(
            color: selected
                ? colors.primaryContainer.withValues(alpha: 0.4)
                : colors.surfaceContainerLowest,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: selected ? colors.primary : colors.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Opacity(
            opacity: enabled ? 1 : 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (icon case final value?) ...[
                      Icon(
                        value,
                        size: 18,
                        color: selected
                            ? colors.primary
                            : colors.onSurfaceVariant,
                      ),
                      Gaps.w8,
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: context.text.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      selected
                          ? Symbols.radio_button_checked
                          : Symbols.radio_button_unchecked,
                      size: 18,
                      color: selected ? colors.primary : colors.outline,
                    ),
                  ],
                ),
                Gaps.h4,
                Text(
                  description,
                  style: context.text.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                if (trailing case final value?) ...[
                  Gaps.h8,
                  value,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Karta wielokrotnego wyboru, np. przepisu automatyzacji.
class ProjectSetupCheckCard extends StatelessWidget {
  /// Tworzy kartę wyboru.
  const ProjectSetupCheckCard({
    required this.title,
    required this.description,
    required this.checked,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  /// Nazwa opcji.
  final String title;

  /// Opis opcji.
  final String description;

  /// Czy opcja jest zaznaczona.
  final bool checked;

  /// Zmiana zaznaczenia.
  final ValueChanged<bool> onChanged;

  /// Czy opcję można zaznaczyć.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: CheckboxListTile(
        value: checked,
        onChanged: enabled ? (value) => onChanged(value ?? false) : null,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
        title: Text(
          title,
          style: context.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          description,
          style: context.text.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Nazwa katalogowego szablonu workflow przypisana do klucza Backendu.
String projectSetupWorkflowTemplateName(AppLocalizations l10n, String key) =>
    ProjectSetupWizardL10n.workflowTemplateName(l10n, key);

/// Etykieta kategorii jawnego statusu workflow.
String projectSetupStatusCategoryLabel(
  AppLocalizations l10n,
  TaskStatusCategory category,
) => ProjectSetupWizardL10n.statusCategory(l10n, category);
