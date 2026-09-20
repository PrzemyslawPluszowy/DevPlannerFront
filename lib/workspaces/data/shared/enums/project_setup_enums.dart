import 'package:json_annotation/json_annotation.dart';

/// Sposób rozpoczęcia projektu w atomowym kreatorze projektu.
///
/// Wartości odwzorowują `ProjectSetupSource` z kontraktu C#
/// `Contracts/Projects/ProjectSetupContracts.cs`. Mapper jest jawny, żeby
/// zmiana nazwy w Dartcie nie zmieniła treści żądania HTTP.
@JsonEnum()
enum ProjectSetupSourceKind {
  /// Pusty projekt bez zawartości startowej.
  @JsonValue('Blank')
  blank,

  /// Projekt odtwarzany z wersjonowanego szablonu całego projektu.
  @JsonValue('ProjectTemplate')
  projectTemplate,
}

/// Źródło workflow zadań wybieranego w kreatorze projektu.
@JsonEnum()
enum ProjectSetupWorkflowKind {
  /// Systemowe statusy zadań projektu, bez własnych kolumn.
  @JsonValue('Default')
  systemDefault,

  /// Katalogowy szablon własnych kolumn wskazany kluczem.
  @JsonValue('CatalogTemplate')
  catalogTemplate,

  /// Jawne statusy przekazane w żądaniu.
  @JsonValue('ExplicitStatuses')
  explicitStatuses,
}

/// Domyślny widok modułu Zadania tworzony razem z projektem.
@JsonEnum()
enum ProjectSetupTaskViewKind {
  /// Tabela Lista.
  @JsonValue('List')
  list,

  /// Tablica Kanban.
  @JsonValue('Board')
  board,
}
