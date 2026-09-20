import 'dart:async';

import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/domain/repositories/project_setups_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_draft_validator.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_idempotency_key.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_draft_commands.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_submit_commands.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Kontroler kreatora projektu.
///
/// Cubit zna wyłącznie porty domenowe: nie importuje Dio, `BuildContext` ani
/// nawigacji, a jego stan jest w pełni typowany i testowalny. Kolejność kroków
/// i walidacja są lokalne — żadne żądanie nie powstaje przed finalnym
/// potwierdzeniem w podsumowaniu.
final class ProjectSetupWizardCubit extends Cubit<ProjectSetupWizardState>
    with ProjectSetupWizardDraftCommands, ProjectSetupWizardSubmitCommands {
  /// Tworzy kontroler kreatora dla jednego draftu.
  ///
  /// [idempotencyKeyFactory] istnieje po to, żeby test mógł przewidzieć klucz;
  /// produkcyjnie klucz powstaje raz na draft.
  ProjectSetupWizardCubit({
    required this.workspaceId,
    required this.setups,
    this.templates,
    this.members,
    this.currentUserId,
    String Function()? idempotencyKeyFactory,
    ProjectSetupDraft? initialDraft,
  }) : _idempotencyKeyFactory =
           idempotencyKeyFactory ?? ProjectSetupIdempotencyKey.generate,
       super(
         ProjectSetupWizardState(
           idempotencyKey:
               (idempotencyKeyFactory ?? ProjectSetupIdempotencyKey.generate)(),
           draft: initialDraft ?? const ProjectSetupDraft(),
           catalog: templates == null
               ? const ProjectSetupCatalogState()
               : const ProjectSetupCatalogState(
                   status: ProjectSetupCatalogStatus.loading,
                 ),
           members: members == null
               ? const ProjectSetupMembersState()
               : const ProjectSetupMembersState(
                   status: ProjectSetupMembersStatus.loading,
                 ),
         ),
       );

  /// Workspace, w którym powstanie projekt.
  @override
  final String workspaceId;

  /// Port atomowego kreatora projektu.
  @override
  final ProjectSetupsRepository setups;

  /// Port katalogu i podglądów szablonów; `null` oznacza brak wpięcia w app.
  @override
  final ProjectTemplatesRepository? templates;

  /// Port członków workspace; `null` oznacza brak wpięcia w app.
  final WorkspacesRepository? members;

  /// UUID bieżącego użytkownika, jeśli znany.
  @override
  final String? currentUserId;

  final String Function() _idempotencyKeyFactory;

  @override
  void applyDraft(
    ProjectSetupDraft draft, {
    Set<ProjectSetupField> touched = const <ProjectSetupField>{},
  }) {
    if (isClosed) return;
    final all = ProjectSetupDraftValidator.validate(draft);
    final errors = <ProjectSetupField, ProjectSetupValidationError>{
      for (final entry in state.fieldErrors.entries)
        if (!touched.contains(entry.key)) entry.key: entry.value,
      for (final field in touched)
        if (all[field] case final ProjectSetupValidationError error)
          field: error,
    };
    emit(
      state.copyWith(
        draft: draft,
        fieldErrors: errors,
        // Plan zbudowany dla poprzedniego draftu nie opisuje już tego, co
        // powstanie, więc podsumowanie musi go odświeżyć przed `Utwórz`.
        planIsStale: state.plan != null,
      ),
    );
  }

  /// Pobiera katalog szablonów i listę członków workspace.
  ///
  /// Skeleton pokazuje się wyłącznie tutaj — przy pierwszym pobraniu katalogu.
  Future<void> load() async {
    await loadCatalog();
    await _loadMembers();
  }

  @override
  Future<void> reloadCatalog() => loadCatalog();

  @override
  String rotateIdempotencyKey() => _idempotencyKeyFactory();

  Future<void> loadCatalog() async {
    final repository = templates;
    if (repository == null || isClosed) return;
    emit(
      state.copyWith(
        catalog: state.catalog.copyWith(
          status: ProjectSetupCatalogStatus.loading,
          clearError: true,
        ),
      ),
    );
    final result = await repository.listTemplates(workspaceId);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          catalog: ProjectSetupCatalogState(
            status: ProjectSetupCatalogStatus.failed,
            error: error,
          ),
        ),
      ),
      (templates) => emit(
        state.copyWith(
          catalog: ProjectSetupCatalogState(
            status: ProjectSetupCatalogStatus.ready,
            templates: List.unmodifiable(templates),
          ),
        ),
      ),
    );
  }

  Future<void> _loadMembers() async {
    final repository = members;
    if (repository == null || isClosed) return;
    emit(
      state.copyWith(
        members: state.members.copyWith(
          status: ProjectSetupMembersStatus.loading,
          clearError: true,
        ),
      ),
    );
    final result = await repository.listMembers(workspaceId);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          members: ProjectSetupMembersState(
            status: ProjectSetupMembersStatus.failed,
            error: error,
          ),
        ),
      ),
      (members) {
        final list = List<WorkspaceMemberResponse>.unmodifiable(members);
        emit(
          state.copyWith(
            members: ProjectSetupMembersState(
              status: ProjectSetupMembersStatus.ready,
              members: list,
            ),
            myWorkspaceRole: _roleOfCurrentUser(list),
          ),
        );
      },
    );
  }

  WorkspaceRole? _roleOfCurrentUser(List<WorkspaceMemberResponse> members) {
    final userId = currentUserId;
    if (userId == null) return null;
    for (final member in members) {
      if (member.userId == userId) return member.role;
    }
    return null;
  }

  /// Ponawia pobranie katalogu szablonów.
  Future<void> retryCatalog() => loadCatalog();

  /// Ponawia pobranie listy członków workspace.
  Future<void> retryMembers() => _loadMembers();

  /// Przechodzi do wskazanego kroku bez wysyłania żądań.
  void goToStep(ProjectSetupStep step) {
    if (isClosed || state.step == step) return;
    emit(state.copyWith(step: step));
    if (step == ProjectSetupStep.summary) refreshPlanIfNeeded();
  }

  /// Przechodzi do kolejnego kroku, walidując pola kroku bieżącego.
  void next() {
    if (isClosed) return;
    final index = state.step.index;
    if (index >= ProjectSetupStep.values.length - 1) return;
    _moveTo(ProjectSetupStep.values[index + 1]);
  }

  /// Wraca do poprzedniego kroku; draft pozostaje nietknięty.
  void back() {
    if (isClosed) return;
    final index = state.step.index;
    if (index == 0) return;
    _moveTo(ProjectSetupStep.values[index - 1]);
  }

  /// Przechodzi do podsumowania bez zatrzymywania się na krokach opcjonalnych.
  ///
  /// Draft pozostaje lokalny, a wybrane wartości domyślne kroków 3-6 i tak
  /// trafiają do planu, więc podsumowanie pokazuje pełny obraz.
  void skipToSummary() => _moveTo(ProjectSetupStep.summary);

  void _moveTo(ProjectSetupStep step) {
    if (step.index > state.step.index) {
      // Wyjście dalej odsłania błędy pól i zatrzymuje krok w miejscu, w którym
      // użytkownik może je poprawić.
      final errors = ProjectSetupDraftValidator.validate(state.draft);
      if (errors.isNotEmpty) {
        emit(state.copyWith(fieldErrors: errors));
        return;
      }
      emit(state.copyWith(step: step, fieldErrors: const {}));
    } else {
      // Cofanie nigdy nie zmienia draftu ani nie ukrywa wcześniej pokazanych
      // błędów pól.
      emit(state.copyWith(step: step));
    }
    if (step == ProjectSetupStep.summary) refreshPlanIfNeeded();
  }

  /// Pobiera podgląd szablonu z pamięcią podręczną per `templateId`.
  ///
  /// Ponowne wejście w ten sam szablon nie miga, bo podgląd jest już w stanie.
  @override
  Future<void> ensureTemplatePreview(String templateId) async {
    final repository = templates;
    if (repository == null ||
        isClosed ||
        state.templatePreviews.containsKey(templateId)) {
      return;
    }
    emit(
      state.copyWith(
        templateLoadingId: templateId,
        clearTemplateError: true,
      ),
    );
    final result = await repository.getTemplateDetails(
      workspaceId: workspaceId,
      templateId: templateId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          clearTemplateLoading: true,
          templateError: error,
          // Błąd jest przypisany do szablonu, którego dotyczy: pozostałe karty
          // nie mogą pokazywać cudzej porażki.
          templateErrorId: templateId,
        ),
      ),
      (details) => emit(
        state.copyWith(
          clearTemplateLoading: true,
          clearTemplateError: true,
          templatePreviews: {
            ...state.templatePreviews,
            templateId: details,
          },
        ),
      ),
    );
  }
}
