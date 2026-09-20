import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';

/// Stabilne kody Backendu rozróżniane przez kreator projektu.
final class ProjectSetupWizardErrorCodes {
  const ProjectSetupWizardErrorCodes._();

  /// Ten sam klucz idempotencji z innym ciałem żądania.
  static const String idempotencyKeyConflict =
      'project_setup.idempotency_key_conflict';

  /// Operacja o tym samym kluczu jest jeszcze przetwarzana.
  static const String idempotencyInProgress =
      'project_setup.idempotency_in_progress';

  /// Szablon projektu zmienił się od czasu ostatniego odczytu.
  static const String templateVersionConflict =
      'project_setup.template_version_conflict';
}

/// Przypisanie pól draftu do kroków kreatora.
///
/// Jedno źródło prawdy dla „który krok zawiera które pole” — używa go walidacja
/// i przejście do kroku z błędem. Bez tego mapowania kreator musiałby zgadywać,
/// gdzie pokazać użytkownikowi poprawkę.
final class ProjectSetupStepNavigator {
  const ProjectSetupStepNavigator._();

  /// Pola draftu edytowane w danym kroku.
  static Set<ProjectSetupField> fieldsOf(ProjectSetupStep step) =>
      switch (step) {
        ProjectSetupStep.start => {ProjectSetupField.template},
        ProjectSetupStep.basics => {ProjectSetupField.name},
        ProjectSetupStep.access => {ProjectSetupField.members},
        ProjectSetupStep.workflow => {ProjectSetupField.customStatuses},
        ProjectSetupStep.workingStyle => {
          ProjectSetupField.boardFields,
          ProjectSetupField.capacity,
        },
        ProjectSetupStep.starterFeatures => const <ProjectSetupField>{},
        ProjectSetupStep.summary => const <ProjectSetupField>{},
      };

  /// Pierwszy krok zawierający pole z błędem.
  ///
  /// Dzięki temu finalne `Utwórz` przenosi użytkownika dokładnie tam, gdzie
  /// jest co poprawić, zamiast blokować go bez wyjaśnienia.
  static ProjectSetupStep? firstStepWithError(
    Map<ProjectSetupField, ProjectSetupValidationError> errors,
  ) {
    final fields = errors.keys.toSet();
    for (final step in ProjectSetupStep.values) {
      if (fieldsOf(step).any(fields.contains)) return step;
    }
    return null;
  }
}
