import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_request_models.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/domain/repositories/project_setups_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_draft_validator.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_request_builder.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_steps.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Plan i finalne utworzenie projektu.
///
/// Mixin oddziela operacje sieciowe kreatora od edycji draftu: podsumowanie
/// buduje plan tym samym żądaniem, które trafi do `create`, a submit nigdy nie
/// powstaje przed finalnym potwierdzeniem użytkownika.
mixin ProjectSetupWizardSubmitCommands on Cubit<ProjectSetupWizardState> {
  /// Port atomowego kreatora projektu.
  ProjectSetupsRepository get setups;

  /// Workspace, w którym powstanie projekt.
  String get workspaceId;

  /// Port szablonów projektu, jeśli został wpięty.
  ProjectTemplatesRepository? get templates;

  /// UUID bieżącego użytkownika, jeśli znany.
  String? get currentUserId;

  /// Zapisuje draft i przelicza błędy walidacji dla zmienionych pól.
  void applyDraft(
    ProjectSetupDraft draft, {
    Set<ProjectSetupField> touched = const <ProjectSetupField>{},
  });

  /// Pobiera podgląd szablonu po konflikcie wersji.
  Future<void> ensureTemplatePreview(String templateId);

  /// Ponawia pobranie katalogu szablonów.
  Future<void> reloadCatalog();

  /// Tworzy nowy klucz idempotencji po dowiedzionym konflikcie klucza.
  String rotateIdempotencyKey();

  /// Buduje albo odświeża plan utworzenia projektu.
  Future<void> refreshPlan() async {
    if (isClosed || state.isSubmitting) return;
    final errors = ProjectSetupDraftValidator.validate(state.draft);
    if (errors.isNotEmpty) {
      emit(
        state.copyWith(
          fieldErrors: errors,
          status: ProjectSetupWizardStatus.failed,
          step:
              ProjectSetupStepNavigator.firstStepWithError(errors) ??
              state.step,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: ProjectSetupWizardStatus.previewing,
        clearGlobalError: true,
      ),
    );
    final request = _buildRequest();
    final result = await setups.previewProjectSetup(
      workspaceId: workspaceId,
      request: request,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        state.copyWith(
          status: ProjectSetupWizardStatus.failed,
          globalError: error,
        ),
      ),
      (plan) => emit(
        state.copyWith(
          status: ProjectSetupWizardStatus.editing,
          plan: plan,
          planIsStale: false,
          clearGlobalError: true,
        ),
      ),
    );
  }

  void refreshPlanIfNeeded() {
    if (state.plan == null || state.planIsStale) {
      // Podsumowanie potrzebuje planu, ale brak planu nie blokuje draftu.
      unawaited(refreshPlan());
    }
  }

  /// Tworzy projekt atomowo pod kluczem idempotencji draftu.
  ///
  /// Podwójne kliknięcie nie tworzy drugiego projektu: stan `submitting`
  /// blokuje kolejne wejścia, a klucz idempotencji pozostaje ten sam, więc nawet
  /// równoległe żądanie z innej instancji odtworzy zapisany wynik.
  Future<void> submit() async {
    if (isClosed || state.isSubmitting || state.isSucceeded) return;
    final errors = ProjectSetupDraftValidator.validate(state.draft);
    if (errors.isNotEmpty) {
      emit(
        state.copyWith(
          fieldErrors: errors,
          status: ProjectSetupWizardStatus.failed,
          step:
              ProjectSetupStepNavigator.firstStepWithError(errors) ??
              state.step,
          clearGlobalError: true,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: ProjectSetupWizardStatus.submitting,
        clearGlobalError: true,
      ),
    );
    final result = await setups.createProjectSetup(
      workspaceId: workspaceId,
      request: _buildRequest(),
      idempotencyKey: state.idempotencyKey,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(_stateAfterFailure(error)),
      (creation) => emit(
        state.copyWith(
          status: ProjectSetupWizardStatus.succeeded,
          creation: creation,
          clearGlobalError: true,
        ),
      ),
    );
  }

  CreateProjectSetupRequest _buildRequest() => ProjectSetupRequestBuilder.build(
    draft: state.draft,
    currentUserId: currentUserId,
    canManageWorkspaceCapacity: state.canManageWorkspaceCapacity,
  );

  /// Zachowuje draft i krok po błędzie, zachowując diagnostykę Backendu.
  ProjectSetupWizardState _stateAfterFailure(ApiError error) {
    final code = error.apiCode;
    if (code == ProjectSetupWizardErrorCodes.idempotencyKeyConflict) {
      // Backend dowiódł, że ten klucz należy do innego żądania. Dalsze
      // ponowienia ze starym kluczem byłyby skazane na ten sam konflikt, więc
      // kolejna próba dostaje nowy klucz — nigdy jednak nie robimy tego
      // automatycznie po timeoucie, gdzie wynik operacji jest nieznany.
      return state.copyWith(
        status: ProjectSetupWizardStatus.failed,
        globalError: error,
        idempotencyKey: rotateIdempotencyKey(),
        idempotencyKeyRotated: true,
      );
    }
    if (code == ProjectSetupWizardErrorCodes.templateVersionConflict) {
      unawaited(_refreshSelectedTemplate());
    }
    return state.copyWith(
      status: ProjectSetupWizardStatus.failed,
      globalError: error,
    );
  }

  /// Po konflikcie wersji szablonu pobiera świeży snapshot razem z jego wersją.
  Future<void> _refreshSelectedTemplate() async {
    final templateId = state.draft.templateId;
    final repository = templates;
    if (templateId == null || repository == null || isClosed) return;
    final previews = Map<String, ProjectTemplateDetailsResponse>.of(
      state.templatePreviews,
    )..remove(templateId);
    emit(
      state.copyWith(
        templatePreviews: Map.unmodifiable(previews),
        planIsStale: true,
      ),
    );
    await ensureTemplatePreview(templateId);
    if (isClosed) return;
    final refreshed = state.templatePreviews[templateId];
    if (refreshed != null) {
      applyDraft(
        state.draft.copyWith(
          templateExpectedVersion: refreshed.version,
          templateName: refreshed.name,
        ),
      );
      return;
    }
    await reloadCatalog();
  }
}
