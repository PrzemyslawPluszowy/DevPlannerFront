import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_help_button.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Etykieta sekcji kreatora projektu.
///
/// Jednozdaniowy skutek ustawienia ([hint]) zostaje pod etykietą, a znak
/// zapytania otwiera dłuższe objaśnienie pojęcia. Dzięki temu decyzję można
/// podjąć bez czytania pomocy, a pomoc wyjaśnia to, czego etykieta nie mieści.
class ProjectSetupSectionLabel extends StatelessWidget {
  /// Tworzy etykietę sekcji.
  const ProjectSetupSectionLabel(
    this.label, {
    this.hint,
    this.helpTitle,
    this.helpBody,
    super.key,
  });

  /// Tekst etykiety.
  final String label;

  /// Opcjonalne wyjaśnienie pod etykietą.
  final String? hint;

  /// Nagłówek objaśnienia po znaku zapytania.
  final String? helpTitle;

  /// Treść objaśnienia po znaku zapytania.
  final String? helpBody;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final helpTitle = this.helpTitle;
    final helpBody = this.helpBody;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: context.text.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
            if (helpTitle != null && helpBody != null)
              ProjectSetupHelpButton(title: helpTitle, body: helpBody),
          ],
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
///
/// Karta ma trzy czytelne stany: zwykły, hover/focus i wybrany. Wybrany stan
/// dostaje akcentowy pasek i wyraźniejszą obwódkę, żeby nie polegał wyłącznie na
/// subtelnej zmianie tła.
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
    final accent = colors.primary;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
        child: InkWell(
          onTap: enabled ? onSelected : null,
          borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
          hoverColor: colors.primary.withValues(alpha: 0.06),
          focusColor: colors.primary.withValues(alpha: 0.12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: BoxDecoration(
              color: selected
                  ? colors.primaryContainer.withValues(alpha: 0.4)
                  : colors.surfaceContainerLowest,
              borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
              border: Border.all(
                color: selected ? accent : colors.outlineVariant,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: selected ? accent : Colors.transparent,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(Sizes.p12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p12),
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
                                        ? accent
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
                                  color: selected ? accent : colors.outline,
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
                ],
              ),
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
    this.rule,
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

  /// Konkretna reguła opcji, np. „Gdy… → wtedy…” automatyzacji.
  final Widget? rule;

  /// Czy opcję można zaznaczyć.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      decoration: BoxDecoration(
        color: checked
            ? colors.primaryContainer.withValues(alpha: 0.28)
            : colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
        border: Border.all(
          color: checked ? colors.primary : colors.outlineVariant,
          width: checked ? 1.4 : 1,
        ),
      ),
      child: InkWell(
        onTap: enabled ? () => onChanged(!checked) : null,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p12)),
        hoverColor: colors.primary.withValues(alpha: 0.06),
        focusColor: colors.primary.withValues(alpha: 0.12),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: checked,
                onChanged: enabled
                    ? (value) => onChanged(value ?? false)
                    : null,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Gaps.w8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.h2,
                    Text(
                      description,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    if (rule case final value?) ...[
                      Gaps.h6,
                      value,
                    ],
                  ],
                ),
              ),
            ],
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
