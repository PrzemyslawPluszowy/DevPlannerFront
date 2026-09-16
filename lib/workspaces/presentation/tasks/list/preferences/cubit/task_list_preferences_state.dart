import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';

/// Niemutowalne stany zarządzania preferencjami i układem kolumn listy zadań.
@immutable
sealed class TaskListPreferencesState extends Equatable {
  const TaskListPreferencesState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy ładowania konfiguracji kolumn.
final class TaskListPreferencesLoading extends TaskListPreferencesState {
  const TaskListPreferencesLoading();
}

/// Stan błędu odczytu lub zapisu konfiguracji.
final class TaskListPreferencesError extends TaskListPreferencesState {
  const TaskListPreferencesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Gotowy, aktywny stan układu kolumn, szerokości i sortowania.
final class TaskListPreferencesReady extends TaskListPreferencesState {
  const TaskListPreferencesReady({
    required this.workspaceId,
    required this.projectId,
    required this.effectiveVisibleColumns,
    required this.availableColumns,
    required this.requiredColumns,
    required this.columnWidths,
    required this.sortField,
    required this.sortDirection,
    required this.groupBy,
    this.activeSavedViewId,
    required this.userPreferenceVersion,
    required this.policyVersion,
    this.isSaving = false,
    this.saveError,
    this.projectDefaultColumnsDraft,
    this.isLoadingProjectPolicy = false,
    this.projectPolicyError,
  });

  /// UUID aktywnego workspace.
  final String workspaceId;

  /// UUID aktywnego projektu.
  final String projectId;

  /// Uporządkowane widoczne kolumny (zarówno systemowe, jak i pola własne).
  final List<TaskColumnReference> effectiveVisibleColumns;

  /// Kolumny dozwolone przez administratora (jeśli puste, brak ograniczeń).
  final Set<String> availableColumns;

  /// Kolumny wymagane, których nie można ukryć (np. sys:title).
  final Set<String> requiredColumns;

  /// Szerokości kolumn w pikselach (klucz to ID kolumny, np. sys:title lub cf:guid).
  final Map<String, double> columnWidths;

  /// Aktywne pole sortowania.
  final TaskSavedViewSortField sortField;

  /// Aktywny kierunek sortowania.
  final TaskSavedViewSortDirection sortDirection;

  /// Aktywne grupowanie.
  final TaskSavedViewGroupBy groupBy;

  /// ID aktywnego zapisanego widoku (jeśli wybrany).
  final String? activeSavedViewId;

  /// Wersja rekordu preferencji użytkownika z backendu.
  final int userPreferenceVersion;

  /// Wersja rekordu polityki projektu z backendu.
  final int policyVersion;

  /// Czy trwa asynchroniczny zapis preferencji do backendu.
  final bool isSaving;

  /// Ostatni komunikat błędu zapisu (np. 409 conflict).
  final String? saveError;

  /// Roboczy draft domyślnych kolumn projektu edytowany w zakładce administracyjnej.
  final List<TaskColumnReference>? projectDefaultColumnsDraft;

  /// Czy trwa ładowanie domyślnej polityki projektu z backendu.
  final bool isLoadingProjectPolicy;

  /// Ostatni komunikat błędu ładowania polityki projektu.
  final String? projectPolicyError;

  /// Zwraca aktywne kolumny domyślne projektu (z draftu lub awaryjnie z widoku efektywnego).
  List<TaskColumnReference> get effectiveProjectDefaultColumns =>
      projectDefaultColumnsDraft ?? effectiveVisibleColumns;

  /// Czy kolumna o podanym kluczu jest widoczna.
  bool isColumnVisible(String id) => effectiveVisibleColumns.any(
    (col) => col.id.toLowerCase() == id.toLowerCase(),
  );

  /// Czy kolumna o podanym kluczu jest widoczna w drafcie polityki projektu.
  bool isProjectColumnVisible(String id) => effectiveProjectDefaultColumns.any(
    (col) => col.id.toLowerCase() == id.toLowerCase(),
  );

  /// Czy kolumna o podanym kluczu jest wymagana przez administratora projektu.
  bool isColumnRequired(String id) =>
      requiredColumns.any((req) => req.toLowerCase() == id.toLowerCase());

  /// Czy kolumna o podanym kluczu jest dozwolona do włączenia przez administratora projektu.
  bool isColumnAvailable(String id) {
    if (availableColumns.isEmpty) return true;
    return availableColumns.any(
      (avail) => avail.toLowerCase() == id.toLowerCase(),
    );
  }

  /// Zwraca bieżącą szerokość kolumny lub domyślną wartość rezerwową.
  double widthFor(String columnId, {double defaultWidth = 140}) =>
      columnWidths[columnId] ?? defaultWidth;

  TaskListPreferencesReady copyWith({
    List<TaskColumnReference>? effectiveVisibleColumns,
    Set<String>? availableColumns,
    Set<String>? requiredColumns,
    Map<String, double>? columnWidths,
    TaskSavedViewSortField? sortField,
    TaskSavedViewSortDirection? sortDirection,
    TaskSavedViewGroupBy? groupBy,
    String? activeSavedViewId,
    bool clearActiveSavedViewId = false,
    int? userPreferenceVersion,
    int? policyVersion,
    bool? isSaving,
    String? saveError,
    bool clearSaveError = false,
    List<TaskColumnReference>? projectDefaultColumnsDraft,
    bool clearProjectDefaultColumnsDraft = false,
    bool? isLoadingProjectPolicy,
    String? projectPolicyError,
    bool clearProjectPolicyError = false,
  }) => TaskListPreferencesReady(
    workspaceId: workspaceId,
    projectId: projectId,
    effectiveVisibleColumns:
        effectiveVisibleColumns ?? this.effectiveVisibleColumns,
    availableColumns: availableColumns ?? this.availableColumns,
    requiredColumns: requiredColumns ?? this.requiredColumns,
    columnWidths: columnWidths ?? this.columnWidths,
    sortField: sortField ?? this.sortField,
    sortDirection: sortDirection ?? this.sortDirection,
    groupBy: groupBy ?? this.groupBy,
    activeSavedViewId: clearActiveSavedViewId
        ? null
        : (activeSavedViewId ?? this.activeSavedViewId),
    userPreferenceVersion: userPreferenceVersion ?? this.userPreferenceVersion,
    policyVersion: policyVersion ?? this.policyVersion,
    isSaving: isSaving ?? this.isSaving,
    saveError: clearSaveError ? null : (saveError ?? this.saveError),
    projectDefaultColumnsDraft: clearProjectDefaultColumnsDraft
        ? null
        : (projectDefaultColumnsDraft ?? this.projectDefaultColumnsDraft),
    isLoadingProjectPolicy:
        isLoadingProjectPolicy ?? this.isLoadingProjectPolicy,
    projectPolicyError: clearProjectPolicyError
        ? null
        : (projectPolicyError ?? this.projectPolicyError),
  );

  @override
  List<Object?> get props => [
    workspaceId,
    projectId,
    effectiveVisibleColumns,
    availableColumns,
    requiredColumns,
    columnWidths,
    sortField,
    sortDirection,
    groupBy,
    activeSavedViewId,
    userPreferenceVersion,
    policyVersion,
    isSaving,
    saveError,
    projectDefaultColumnsDraft,
    isLoadingProjectPolicy,
    projectPolicyError,
  ];
}
