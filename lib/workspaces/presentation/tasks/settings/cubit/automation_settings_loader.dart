import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/workspaces/models/automation_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/automation_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';

/// Wynik startowego odczytu, zanim Cubit opublikuje stan ekranu.
sealed class AutomationSettingsLoadResult {
  const AutomationSettingsLoadResult();
}

final class AutomationSettingsLoadFailure extends AutomationSettingsLoadResult {
  const AutomationSettingsLoadFailure(this.message);

  final String message;
}

final class AutomationSettingsLoadSuccess extends AutomationSettingsLoadResult {
  const AutomationSettingsLoadSuccess({
    required this.rules,
    required this.catalog,
    required this.recipes,
  });

  final List<AutomationRuleResponse> rules;
  final AutomationCatalogResponse catalog;
  final List<AutomationRecipe> recipes;
}

/// Opcjonalne dane kreatora; ich błąd nie blokuje listy reguł.
final class AutomationSettingsBuilderOptions {
  const AutomationSettingsBuilderOptions({
    required this.memberProfiles,
    required this.labels,
  });

  /// `null` oznacza brak portu albo błąd pobocznego odczytu; pusta lista jest
  /// prawidłową odpowiedzią i musi wyczyścić wcześniejszy wybór.
  final List<ProjectMemberProfile>? memberProfiles;
  final List<TaskLabelResponse>? labels;
}

/// Odczyty repository dla ustawień automatyzacji, bez stanu Fluttera.
final class AutomationSettingsLoader {
  const AutomationSettingsLoader({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    this.memberProfilesRepository,
    this.taskMetadataRepository,
  });

  final AutomationRepository repository;
  final String workspaceId;
  final String projectId;
  final ProjectMemberProfilesRepository? memberProfilesRepository;
  final TaskMetadataRepository? taskMetadataRepository;

  Future<AutomationSettingsLoadResult> load() async {
    final rulesResult = await repository.listRules(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    return rulesResult.fold(
      (error) => AutomationSettingsLoadFailure(error.message),
      (rules) async {
        final catalogResult = await repository.getCatalog(
          workspaceId: workspaceId,
          projectId: projectId,
        );
        return catalogResult.fold(
          (error) => AutomationSettingsLoadFailure(error.message),
          (catalog) async {
            final recipesResult = await repository.listRecipes(
              workspaceId: workspaceId,
              projectId: projectId,
            );
            return recipesResult.fold(
              (error) => AutomationSettingsLoadFailure(error.message),
              (recipes) => AutomationSettingsLoadSuccess(
                rules: _sortedRules(rules),
                catalog: catalog,
                recipes: recipes,
              ),
            );
          },
        );
      },
    );
  }

  Future<AutomationSettingsBuilderOptions> loadBuilderOptions() async {
    final profilesFuture = memberProfilesRepository?.listProfiles(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    final labelsFuture = taskMetadataRepository?.listLabels(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    final profiles = profilesFuture == null ? null : await profilesFuture;
    final labels = labelsFuture == null ? null : await labelsFuture;
    return AutomationSettingsBuilderOptions(
      memberProfiles: profiles?.fold((_) => null, (items) => items),
      labels: labels?.fold((_) => null, (items) => items),
    );
  }

  static List<AutomationRuleResponse> _sortedRules(
    List<AutomationRuleResponse> rules,
  ) => [...rules]..sort((left, right) => left.name.compareTo(right.name));
}
