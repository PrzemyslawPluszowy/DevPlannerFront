import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'projects_tree_lifecycle.dart';
part 'projects_tree_model.dart';
part 'projects_tree_order.dart';
part 'projects_tree_preferences.dart';
part 'projects_tree_state.dart';

/// Kontrakt łączący cubit drzewa z jego kontrolerami.
///
/// Kontrolery nie znają `Cubit` ani `BuildContext`: dostają model, porty i
/// powiadomienia o stanie, dzięki czemu każdą operację można testować osobno.
abstract interface class _TreeCommandHost {
  /// Identyfikator workspace’u, którego dotyczy drzewo.
  String get workspaceId;

  /// Czy cubit został zamknięty.
  bool get isClosed;

  /// Port mutacji projektów albo `null` w kompozycji bez zapisu.
  ProjectsRepository? get mutations;

  /// Model drzewa z projektami, kolejnością i nakładkami preferencji.
  _ProjectsTreeModel get model;

  /// Publikuje aktualny stan drzewa.
  void emitTreeState();

  /// Zapisuje trwały komunikat błędu.
  void raiseFailure({
    required ProjectsTreeOperation operation,
    required ProjectsTreeFailureKind kind,
    required bool rolledBack,
    ApiError? error,
    ProjectsRetryIntent? retry,
  });

  /// Zapisuje nietrwałe potwierdzenie operacji.
  void raiseNotice(
    ProjectsTreeNoticeKind kind, {
    required String projectId,
    required String projectName,
    bool canUndo,
  });

  /// Zgłasza brak portu mutacji zamiast udawać wykonaną operację.
  bool requireMutations(ProjectsTreeOperation operation);

  /// Klasyfikuje błąd transportu do stabilnej przyczyny w UI.
  ProjectsTreeFailureKind kindFor(ApiError error);

  /// Usuwa projekt z kanałów po trwałym usunięciu.
  void forgetProject(String projectId);
}

/// Stan drzewa projektów jednego workspace’u: osobiste preferencje i lifecycle.
///
/// Cubit jest fasadą: przechowuje model, publikuje stan i deleguje operacje do
/// trzech kontrolerów (preferencje, kolejność, lifecycle). Nie zna
/// `BuildContext`, nawigacji ani widgetów, więc scalanie intencji i rollback są
/// testowalne bez UI.
///
/// Reguły z planu §7:
/// - najpierw stan lokalny, potem żądanie;
/// - maksymalnie jedno żądanie na projekt i pole, kolejne intencje są scalane do
///   ostatniej wartości docelowej;
/// - porażka cofa wyłącznie pola tej operacji i nie kasuje późniejszych zmian
///   użytkownika;
/// - sukces zastępuje stan odpowiedzią serwera dla pól tej operacji;
/// - błąd jest trwały (stan), a nie tylko SnackBarem;
/// - żadne żądanie nie jest automatycznie ponawiane po błędzie sieci.
final class ProjectsTreeCubit extends Cubit<ProjectsTreeState>
    implements _TreeCommandHost {
  /// Tworzy cubit drzewa projektów dla jednego workspace’u.
  ///
  /// Porty `mutations` i `templates` są opcjonalne: kompozycja bez mutacji
  /// projektów (np. Web BFF bez samodzielnego klienta API) nadal renderuje
  /// drzewo, ale akcje mutujące są jawnie niedostępne zamiast udawać działanie.
  ProjectsTreeCubit({
    required this.workspaceId,
    this._mutations,
    this._templates,
  }) : super(const ProjectsTreeState()) {
    _preferences = _PreferencesController(this);
    _lifecycle = _LifecycleController(this);
    _order = _OrderController(this);
  }

  @override
  final String workspaceId;

  final ProjectsRepository? _mutations;
  final ProjectTemplatesRepository? _templates;

  @override
  final _ProjectsTreeModel model = _ProjectsTreeModel();

  late final _PreferencesController _preferences;
  late final _LifecycleController _lifecycle;
  late final _OrderController _order;

  int _noticeSequence = 0;

  /// Rewizja odczytu sekcji; nowsze żądanie unieważnia wolniejszą odpowiedź.
  int _sectionsRevision = 0;

  ProjectsTreeFailure? _failure;
  ProjectsTreeNotice? _notice;

  @override
  ProjectsRepository? get mutations => _mutations;

  /// Czy drzewo może mutować projekty (dostępny port repozytorium).
  bool get canMutateProjects => _mutations != null;

  /// Czy drzewo może tworzyć szablony projektów.
  bool get canCreateTemplate => _templates != null;

  /// Wczytuje listę projektów z serwera i scala ją z lokalnymi nakładkami.
  ///
  /// [state] i [visibility] opisują filtr, którym pobrano listę: tylko one
  /// pozwalają stwierdzić, czy brak projektu na liście jest dowodem na zmianę
  /// jego miejsca w drzewie. Domyślny zakres (aktywne, nieukryte) zdejmuje
  /// lokalne znaczniki ukrycia i archiwum z każdego projektu, który się na niej
  /// pojawił.
  ///
  /// Identyfikatory z mutacją w locie są pomijane, żeby wolniejsza odpowiedź
  /// listy nie skasowała świeżej intencji użytkownika.
  void syncFromServer(
    List<ProjectListItem> projects, {
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility visibility = ProjectListVisibility.visible,
  }) {
    for (final project in projects) {
      if (_preferences.hasPendingPreference(project.id)) continue;
      if (_lifecycle.hasPendingLifecycle(project.id)) continue;
      _preferences.syncConfirmed(project, isHidden: project.isHidden);
      model.applyServerStage(project, state: state, visibility: visibility);
    }
    model.mergeServerItems(projects);
    // Kolejność potwierdzona nie może nadpisać bazy rollbacku, gdy DnD jest
    // w trakcie zapisu.
    if (!model.orderLocked) {
      model.confirmedOrder = List<String>.unmodifiable(model.order);
    }
    _emit();
  }

  /// Pobiera sekcje `Ukryte` i `Archiwum` z serwera.
  ///
  /// Drzewo nie opiera tych sekcji wyłącznie na operacjach wykonanych w bieżącej
  /// sesji: ukryte projekty pochodzą z `visibility=hidden`, a archiwalne
  /// z `state=archived`, więc po restarcie klienta nadal są widoczne i można je
  /// przywrócić. Sekcja archiwum pyta o `visibility=all`, żeby nie zgubić
  /// projektu, który jest jednocześnie ukryty i zarchiwizowany.
  ///
  /// Częściowa porażka nie kasuje tego, co udało się pobrać: wynik każdego
  /// zapytania jest stosowany osobno, a błąd trafia do trwałego komunikatu.
  Future<void> refreshServerSections() async {
    final repository = _mutations;
    if (repository == null) return;
    final revision = ++_sectionsRevision;
    try {
      final results = await Future.wait(<
        Future<Either<ApiError, List<ProjectListItem>>>
      >[
        // Sekcja `Ukryte`: aktywne projekty ukryte przez bieżącego użytkownika
        // (`state` pozostaje domyślnym filtrem `active`).
        repository.listProjects(
          workspaceId,
          visibility: ProjectListVisibility.hidden,
        ),
        repository.listProjects(
          workspaceId,
          state: ProjectListState.archived,
          visibility: ProjectListVisibility.all,
        ),
      ]);
      if (isClosed || revision != _sectionsRevision) return;
      ApiError? failure;
      _applySection(
        results[0],
        state: ProjectListState.active,
        visibility: ProjectListVisibility.hidden,
        onFailure: (error) => failure ??= error,
      );
      _applySection(
        results[1],
        state: ProjectListState.archived,
        visibility: ProjectListVisibility.all,
        onFailure: (error) => failure ??= error,
      );
      if (failure case final error?) {
        raiseFailure(
          operation: ProjectsTreeOperation.loadSections,
          kind: kindFor(error),
          rolledBack: false,
          error: error,
          retry: const ProjectsRetryIntent(
            operation: ProjectsTreeOperation.loadSections,
          ),
        );
      }
      _emit();
    } on Object catch (error) {
      if (isClosed || revision != _sectionsRevision) return;
      // Port bez implementacji odczytu nie może zniknąć po cichu: brak sekcji
      // byłby nieodróżnialny od próżni w danych.
      raiseFailure(
        operation: ProjectsTreeOperation.loadSections,
        kind: ProjectsTreeFailureKind.unknown,
        rolledBack: false,
        error: ApiError(
          type: ApiErrorType.unknown,
          message: error.toString(),
        ),
        retry: const ProjectsRetryIntent(
          operation: ProjectsTreeOperation.loadSections,
        ),
      );
      _emit();
    }
  }

  /// Stosuje wynik jednego zapytania o sekcję i oddaje błąd do raportu.
  void _applySection(
    Either<ApiError, List<ProjectListItem>> result, {
    required ProjectListState state,
    required ProjectListVisibility visibility,
    required void Function(ApiError error) onFailure,
  }) => result.fold(onFailure, (items) {
    for (final item in items) {
      if (_preferences.hasPendingPreference(item.id)) continue;
      if (_lifecycle.hasPendingLifecycle(item.id)) continue;
      _preferences.syncConfirmed(item, isHidden: item.isHidden);
    }
    // Projekty z intencją w locie zachowują swój znacznik, ale są liczone jako
    // obecne na liście serwera.
    model.applyServerSection(
      items,
      state: state,
      visibility: visibility,
      skipIds: _pendingProjectIds(),
    );
    if (!model.orderLocked) {
      model.confirmedOrder = List<String>.unmodifiable(model.order);
    }
  });

  /// Przypina albo odpina projekt.
  void setPinned(ProjectListItem project, {required bool isPinned}) =>
      _preferences.setPinned(project, isPinned: isPinned);

  /// Ukrywa projekt w drzewie albo przywraca go do drzewa.
  void setHidden(ProjectListItem project, {required bool isHidden}) =>
      _preferences.setHidden(project, isHidden: isHidden);

  /// Zapisuje nową kolejność widocznych projektów.
  void reorderVisible(List<String> orderedIds) => _order.reorder(orderedIds);

  /// Archiwizuje projekt i przenosi go do sekcji `Archiwum`.
  void archive(ProjectListItem project) => _lifecycle.archive(project);

  /// Przywraca zarchiwizowany projekt do aktywnego drzewa.
  void restore(ProjectListItem project) => _lifecycle.restore(project);

  /// Trwale usuwa zarchiwizowany projekt.
  ///
  /// Dostępne wyłącznie z sekcji `Archiwum` i po potwierdzeniu nazwy w warstwie
  /// prezentacji.
  void deletePermanently(ProjectListItem project) =>
      _lifecycle.deletePermanently(project);

  /// Opuszcza jawne członkostwo projektu.
  ///
  /// Zwraca `true` po potwierdzeniu przez backend, żeby warstwa prezentacji
  /// odświeżyła listę projektów (widoczność projektu Shared może się nie
  /// zmienić, bo dostęp dziedziczy się z workspace).
  Future<bool> leaveProject(ProjectListItem project) =>
      _lifecycle.leave(project);

  /// Tworzy szablon z aktualnego stanu projektu.
  ///
  /// Zwraca `true`, gdy backend potwierdził utworzenie szablonu — dzięki temu
  /// dialog może się zamknąć wyłącznie po sukcesie.
  Future<bool> createTemplateFromProject({
    required ProjectListItem project,
    required String name,
  }) async {
    final templates = _templates;
    if (templates == null) {
      raiseFailure(
        operation: ProjectsTreeOperation.createTemplate,
        kind: ProjectsTreeFailureKind.unavailable,
        rolledBack: false,
      );
      return false;
    }
    final result = await templates.createTemplateFromProject(
      workspaceId: workspaceId,
      projectId: project.id,
      name: name,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        raiseFailure(
          operation: ProjectsTreeOperation.createTemplate,
          kind: kindFor(error),
          rolledBack: false,
          error: error,
        );
        return false;
      },
      (_) {
        raiseNotice(
          ProjectsTreeNoticeKind.templateCreated,
          projectId: project.id,
          projectName: project.name,
        );
        return true;
      },
    );
  }

  /// Cofa ostatnią operację, która to potwierdzała (np. ukrycie).
  void undoLastNotice() {
    final notice = _notice;
    if (notice == null || !notice.canUndo) return;
    final project = model.known[notice.projectId];
    if (project == null) return;
    switch (notice.kind) {
      case ProjectsTreeNoticeKind.hidden:
        setHidden(project, isHidden: false);
      case ProjectsTreeNoticeKind.archived:
        restore(project);
      case ProjectsTreeNoticeKind.pinned:
      case ProjectsTreeNoticeKind.unpinned:
      case ProjectsTreeNoticeKind.unhidden:
      case ProjectsTreeNoticeKind.restored:
      case ProjectsTreeNoticeKind.deleted:
      // Opuszczenia projektu nie da się cofnąć z drzewa: wymaga ponownego
      // dodania członkostwa przez osobę zarządzającą projektem.
      case ProjectsTreeNoticeKind.left:
      case ProjectsTreeNoticeKind.templateCreated:
        return;
    }
  }

  /// Ponawia ostatnią nieudaną operację, jeśli da się ją bezpiecznie odtworzyć.
  void retryFailure() {
    final intent = _failure?.retry;
    if (intent == null) return;
    _clearFailure();
    switch (intent.operation) {
      case ProjectsTreeOperation.pin:
      case ProjectsTreeOperation.hide:
      case ProjectsTreeOperation.preference:
        _preferences.retry(intent);
      case ProjectsTreeOperation.reorder:
        _order.retry(intent);
      case ProjectsTreeOperation.archive:
        _retryLifecycle(intent, archive);
      case ProjectsTreeOperation.restore:
        _retryLifecycle(intent, restore);
      case ProjectsTreeOperation.deletePermanently:
        _retryLifecycle(intent, deletePermanently);
      case ProjectsTreeOperation.leaveMembership:
        final project = _projectFor(intent);
        if (project != null) unawaited(leaveProject(project));
      case ProjectsTreeOperation.createTemplate:
        // Szablon wymaga nazwy od użytkownika; ponowienie otwiera dialog.
        return;
      case ProjectsTreeOperation.loadSections:
        unawaited(refreshServerSections());
    }
  }

  /// Ponawia operację lifecycle dla projektu z intencji.
  void _retryLifecycle(
    ProjectsRetryIntent intent,
    void Function(ProjectListItem project) command,
  ) {
    final projectId = intent.projectId;
    final project = projectId == null ? null : model.known[projectId];
    if (project == null) return;
    command(project);
  }

  /// Projekt z intencji ponowienia albo `null`, gdy zniknął z drzewa.
  ProjectListItem? _projectFor(ProjectsRetryIntent intent) {
    final projectId = intent.projectId;
    return projectId == null ? null : model.known[projectId];
  }

  /// Ukrywa trwały komunikat błędu bez zmiany stanu projektów.
  void dismissFailure() => _clearFailure();

  /// Czyści nietrwałe potwierdzenie po pokazaniu go użytkownikowi.
  void clearNotice() {
    if (_notice == null) return;
    _notice = null;
    _emit();
  }

  @override
  bool requireMutations(ProjectsTreeOperation operation) {
    if (_mutations != null) return true;
    raiseFailure(
      operation: operation,
      kind: ProjectsTreeFailureKind.unavailable,
      rolledBack: false,
    );
    return false;
  }

  @override
  ProjectsTreeFailureKind kindFor(ApiError error) => switch (error.statusCode) {
    400 => ProjectsTreeFailureKind.validation,
    401 => ProjectsTreeFailureKind.unauthorized,
    403 => ProjectsTreeFailureKind.forbidden,
    404 => ProjectsTreeFailureKind.notFound,
    409 => ProjectsTreeFailureKind.conflict,
    422 => ProjectsTreeFailureKind.validation,
    429 => ProjectsTreeFailureKind.rateLimited,
    final int status when status >= 500 => ProjectsTreeFailureKind.server,
    _ => switch (error.type) {
      ApiErrorType.connection ||
      ApiErrorType.connectionTimeout ||
      ApiErrorType.sendTimeout ||
      ApiErrorType.receiveTimeout => ProjectsTreeFailureKind.transport,
      ApiErrorType.forbidden => ProjectsTreeFailureKind.forbidden,
      ApiErrorType.unauthorized => ProjectsTreeFailureKind.unauthorized,
      ApiErrorType.notFound => ProjectsTreeFailureKind.notFound,
      ApiErrorType.conflict => ProjectsTreeFailureKind.conflict,
      ApiErrorType.validation => ProjectsTreeFailureKind.validation,
      ApiErrorType.server => ProjectsTreeFailureKind.server,
      _ => ProjectsTreeFailureKind.unknown,
    },
  };

  @override
  void forgetProject(String projectId) {
    _preferences.forget(projectId);
    _lifecycle.forget(projectId);
  }

  @override
  void raiseFailure({
    required ProjectsTreeOperation operation,
    required ProjectsTreeFailureKind kind,
    required bool rolledBack,
    ApiError? error,
    ProjectsRetryIntent? retry,
  }) {
    _failure = ProjectsTreeFailure(
      operation: operation,
      kind: kind,
      rolledBack: rolledBack,
      statusCode: error?.statusCode,
      code: error?.apiCode ?? error?.backendCode?.toString(),
      traceId: error?.traceId,
      backendMessage: error?.message,
      retry: retry,
    );
    _emit();
  }

  @override
  void raiseNotice(
    ProjectsTreeNoticeKind kind, {
    required String projectId,
    required String projectName,
    bool canUndo = false,
  }) {
    _notice = ProjectsTreeNotice(
      id: ++_noticeSequence,
      kind: kind,
      canUndo: canUndo,
      projectId: projectId,
      projectName: projectName,
    );
    _emit();
  }

  @override
  void emitTreeState() => _emit();

  void _clearFailure() {
    if (_failure == null) return;
    _failure = null;
    _emit();
  }

  Set<String> _pendingProjectIds() => <String>{
    ..._preferences.pendingProjectIds,
    ..._lifecycle.pendingProjectIds,
  };

  void _emit() {
    if (isClosed) return;
    emit(
      ProjectsTreeState(
        visible: List<ProjectListItem>.unmodifiable(model.visible),
        hidden: List<ProjectListItem>.unmodifiable(model.hidden),
        archived: List<ProjectListItem>.unmodifiable(model.archived),
        pendingProjectIds: Set<String>.unmodifiable(_pendingProjectIds()),
        isReordering: _order.isReordering,
        failure: _failure,
        notice: _notice,
      ),
    );
  }
}
