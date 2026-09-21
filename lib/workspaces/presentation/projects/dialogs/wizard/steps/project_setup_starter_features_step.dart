import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_recipe_rule.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Krok 6 kreatora: przepisy automatyzacji instalowane razem z projektem.
///
/// Katalog przepisów pochodzi z Backendu i jest dostępny dopiero po utworzeniu
/// projektu, dlatego kreator wystawia wyłącznie klucze potwierdzone kontraktem.
/// Nic nie jest zaznaczone domyślnie — funkcja nie może być reklamowana jako
/// gotowa, zanim użytkownik sam jej nie wybierze i nie zobaczy jej w planie.
class ProjectSetupStarterFeaturesStep extends StatelessWidget {
  /// Tworzy krok funkcji startowych.
  const ProjectSetupStarterFeaturesStep({required this.state, super.key});

  /// Bieżący stan kreatora.
  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final selected = state.draft.recipeKeys;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupSectionLabel(
          l10n.projectSetupStepStarterFeaturesTitle,
          hint: l10n.projectSetupStartersDescription,
          helpTitle: l10n.projectSetupHelpAutomationsTitle,
          helpBody: l10n.projectSetupHelpAutomationsBody,
        ),
        Gaps.h12,
        for (final key in ProjectSetupCatalog.automationRecipeKeys)
          ProjectSetupCheckCard(
            title: ProjectSetupWizardL10n.recipeName(l10n, key),
            description: ProjectSetupWizardL10n.recipeDescription(l10n, key),
            checked: selected.contains(key),
            // Reguła jest na karcie, a nie tylko w podglądzie: decyzję o
            // automatyzacji podejmuje się tutaj, więc skutek musi być widoczny
            // bez zaznaczania opcji.
            rule: ProjectSetupRecipeRule(
              trigger: ProjectSetupWizardL10n.recipeTrigger(l10n, key),
              action: ProjectSetupWizardL10n.recipeAction(l10n, key),
            ),
            onChanged: (_) => cubit.toggleRecipe(key),
          ),
      ],
    );
  }
}
