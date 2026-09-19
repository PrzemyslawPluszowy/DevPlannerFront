import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_settings_tab.dart';
import 'package:flutter/foundation.dart';

/// Centralny model uprawnień i możliwości użytkownika w kontekście projektu.
///
/// Określa, jakie operacje i zakładki konfiguracji są dozwolone dla danej roli
/// oraz uwzględnia globalne uprawnienia SuperAdmina i opcjonalną symulację
/// widoku („Zobacz jako rola”).
@immutable
final class ProjectCapabilities {
  /// Tworzy instancję [ProjectCapabilities].
  const ProjectCapabilities({
    required this.role,
    this.isSuperAdmin = false,
    this.simulatedRole,
  });

  /// Rzeczywista rola użytkownika w projekcie.
  final ProjectRole? role;

  /// Czy użytkownik posiada globalne uprawnienia SuperAdmina.
  final bool isSuperAdmin;

  /// Opcjonalna rola do celów podglądu interfejsu („Zobacz jako rola”).
  final ProjectRole? simulatedRole;

  /// Efektywna rola uwzględniająca symulację oraz uprawnienia administratora.
  ProjectRole? get effectiveRole =>
      simulatedRole ?? (isSuperAdmin ? ProjectRole.admin : role);

  /// Czy użytkownik ma jakiekolwiek uprawnienia zarządcze w projekcie.
  bool get canManage =>
      (isSuperAdmin && simulatedRole == null) ||
      effectiveRole == ProjectRole.owner ||
      effectiveRole == ProjectRole.admin;

  /// Czy użytkownik może edytować ogólne ustawienia projektu.
  bool get canManageSettings => canManage;

  /// Czy użytkownik może zarządzać członkami projektu i ich rolami.
  bool get canManageMembers => canManage;

  /// Czy użytkownik może konfigurować workflow i statusy zadań.
  bool get canManageWorkflow => canManage;

  /// Czy użytkownik może definiować i modyfikować pola własne (Custom Fields).
  bool get canManageCustomFields => canManage;

  /// Czy użytkownik może tworzyć i edytować etykiety zadań.
  bool get canManageLabels => canManage;

  /// Czy użytkownik może tworzyć i edytować kamienie milowe.
  bool get canManageMilestones => canManage;

  /// Czy użytkownik może zarządzać regułami automatyzacji.
  bool get canManageAutomations => canManage;

  /// Czy użytkownik może tworzyć, nadpisywać i usuwać szablony projektów.
  bool get canManageTemplates => canManage;

  /// Czy użytkownik może trwale usunąć projekt (tylko Właściciel lub SuperAdmin).
  bool get canDeleteProject =>
      (isSuperAdmin && simulatedRole == null) ||
      effectiveRole == ProjectRole.owner;

  /// Czy użytkownik może przekazać własność projektu.
  bool get canTransferOwnership =>
      (isSuperAdmin && simulatedRole == null) ||
      effectiveRole == ProjectRole.owner;

  /// Określa, czy dana zakładka panelu ustawień powinna być widoczna.
  bool canViewTab(ProjectSettingsTab tab) => switch (tab) {
    ProjectSettingsTab.general => true,
    ProjectSettingsTab.members => true,
    ProjectSettingsTab.workflow => canManageWorkflow,
    ProjectSettingsTab.customFields => canManageCustomFields,
    ProjectSettingsTab.labels => canManageLabels,
    ProjectSettingsTab.milestones => canManageMilestones,
    ProjectSettingsTab.automations => canManageAutomations,
    ProjectSettingsTab.templates => true,
  };

  /// Zwraca nową kopię możliwości z ustawioną rolą podglądu.
  ProjectCapabilities withPreviewRole(ProjectRole? previewRole) =>
      ProjectCapabilities(
        role: role,
        isSuperAdmin: isSuperAdmin,
        simulatedRole: previewRole,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectCapabilities &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          isSuperAdmin == other.isSuperAdmin &&
          simulatedRole == other.simulatedRole;

  @override
  int get hashCode => Object.hash(role, isSuperAdmin, simulatedRole);
}
