import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';

/// Reguły walidacji lokalnej kreatora projektu.
///
/// Walidacja odwzorowuje wyłącznie limity i zależności kontraktu Backendu.
/// Nie kopiuje ACL ani reguł biznesowych domeny — te nadal egzekwuje serwer,
/// a każdy błąd serwera jest pokazywany razem z kodem i `traceId`.
final class ProjectSetupDraftValidator {
  const ProjectSetupDraftValidator._();

  /// Sprawdza cały draft i zwraca błędy przypisane do konkretnych pól.
  ///
  /// Walidacja jest bezstanowa i obejmuje wszystkie kroki, dzięki czemu
  /// cofnięcie do wcześniejszego kroku nie gubi błędu pola z kroku późniejszego.
  static Map<ProjectSetupField, ProjectSetupValidationError> validate(
    ProjectSetupDraft draft,
  ) {
    final errors = <ProjectSetupField, ProjectSetupValidationError>{};
    _validateName(draft, errors);
    _validateTemplate(draft, errors);
    _validateMembers(draft, errors);
    _validateWorkflow(draft, errors);
    _validateBoardFields(draft, errors);
    _validateCapacity(draft, errors);
    return errors;
  }

  static void _validateName(
    ProjectSetupDraft draft,
    Map<ProjectSetupField, ProjectSetupValidationError> errors,
  ) {
    final name = draft.name.trim();
    if (name.isEmpty) {
      errors[ProjectSetupField.name] = ProjectSetupValidationError.nameRequired;
    } else if (name.length > ProjectSetupCatalog.maxProjectNameLength) {
      errors[ProjectSetupField.name] = ProjectSetupValidationError.nameTooLong;
    }
    if (draft.description.length >
        ProjectSetupCatalog.maxProjectDescriptionLength) {
      errors[ProjectSetupField.name] =
          ProjectSetupValidationError.descriptionTooLong;
    }
  }

  static void _validateTemplate(
    ProjectSetupDraft draft,
    Map<ProjectSetupField, ProjectSetupValidationError> errors,
  ) {
    if (draft.usesTemplate && (draft.templateId?.trim().isEmpty ?? true)) {
      errors[ProjectSetupField.template] =
          ProjectSetupValidationError.templateRequired;
    }
  }

  static void _validateMembers(
    ProjectSetupDraft draft,
    Map<ProjectSetupField, ProjectSetupValidationError> errors,
  ) {
    final memberIds = [for (final member in draft.members) member.userId];
    if (memberIds.toSet().length != memberIds.length) {
      errors[ProjectSetupField.members] =
          ProjectSetupValidationError.memberDuplicated;
    }
  }

  static void _validateWorkflow(
    ProjectSetupDraft draft,
    Map<ProjectSetupField, ProjectSetupValidationError> errors,
  ) {
    if (draft.workflowChoice != ProjectSetupWorkflowChoice.explicitStatuses) {
      return;
    }
    final statuses = draft.customStatuses;
    if (statuses.isEmpty ||
        statuses.length > ProjectSetupCatalog.maxExplicitStatuses) {
      errors[ProjectSetupField.customStatuses] =
          ProjectSetupValidationError.statusesLimitExceeded;
      return;
    }
    final names = <String>{};
    for (final status in statuses) {
      final name = status.name.trim();
      if (name.isEmpty) {
        errors[ProjectSetupField.customStatuses] =
            ProjectSetupValidationError.statusNameRequired;
        return;
      }
      if (name.length > ProjectSetupCatalog.maxStatusNameLength ||
          !names.add(name.toLowerCase())) {
        errors[ProjectSetupField.customStatuses] =
            ProjectSetupValidationError.statusNameInvalid;
        return;
      }
      final wip = status.wipLimit;
      if (wip != null && (wip < 1 || wip > 999)) {
        errors[ProjectSetupField.customStatuses] =
            ProjectSetupValidationError.statusWipInvalid;
        return;
      }
    }
  }

  static void _validateBoardFields(
    ProjectSetupDraft draft,
    Map<ProjectSetupField, ProjectSetupValidationError> errors,
  ) {
    if (draft.boardVisibleFields.isEmpty) {
      errors[ProjectSetupField.boardFields] =
          ProjectSetupValidationError.boardFieldsRequired;
    }
  }

  static void _validateCapacity(
    ProjectSetupDraft draft,
    Map<ProjectSetupField, ProjectSetupValidationError> errors,
  ) {
    final capacity = draft.capacityMinutes;
    if (capacity == null) {
      return;
    }
    if (capacity < 0 ||
        capacity > ProjectSetupCatalog.maxDailyCapacityMinutes) {
      errors[ProjectSetupField.capacity] =
          ProjectSetupValidationError.capacityOutOfRange;
    }
  }
}
