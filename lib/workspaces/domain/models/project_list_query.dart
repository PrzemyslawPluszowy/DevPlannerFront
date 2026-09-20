/// Filtr stanu archiwum listy projektów.
///
/// Wartości odpowiadają parametrowi `state` w
/// `GET /api/v1/workspaces/{workspaceId}/projects` i są mapowane jawnie, a nie
/// przez `Enum.name`, żeby zmiana nazwy w Dartcie nie zmieniła kontraktu.
enum ProjectListState {
  /// Wyłącznie aktywne projekty; zachowanie domyślne backendu.
  active('active'),

  /// Wyłącznie projekty z niepustym znacznikiem archiwizacji.
  archived('archived'),

  /// Aktywne i zarchiwizowane projekty razem.
  all('all');

  const ProjectListState(this.queryValue);

  /// Token akceptowany przez backend w query.
  final String queryValue;
}

/// Filtr osobistego ukrycia listy projektów.
enum ProjectListVisibility {
  /// Pomija projekty ukryte przez bieżącego użytkownika; zachowanie domyślne.
  visible('visible'),

  /// Zwraca wyłącznie projekty ukryte przez bieżącego użytkownika.
  hidden('hidden'),

  /// Zwraca projekty widoczne i ukryte razem.
  all('all');

  const ProjectListVisibility(this.queryValue);

  /// Token akceptowany przez backend w query.
  final String queryValue;

  /// Rozwiązuje filtr widoczności wraz z przestarzałym aliasem `includeHidden`.
  ///
  /// Jawna [visibility] ma pierwszeństwo, a `includeHidden == true` odpowiada
  /// `visibility=all` — dokładnie tak, jak robi to backend. Dzięki temu alias
  /// nie wymaga drugiej implementacji w każdym adapterze.
  static ProjectListVisibility fromLegacy({
    ProjectListVisibility? visibility,
    bool? includeHidden,
  }) =>
      visibility ??
      (includeHidden == true
          ? ProjectListVisibility.all
          : ProjectListVisibility.visible);
}
