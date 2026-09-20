part of 'projects_tree_cubit.dart';

/// Operacja drzewa projektów, do której należy żądanie albo potwierdzenie.
///
/// Enum jest typowany, a nie tekstowy, żeby warstwa prezentacji mogła dobrać
/// komunikat z ARB, a cubit nie musiał znać lokalizacji.
enum ProjectsTreeOperation {
  /// Przypięcie albo odpięcie projektu.
  pin,

  /// Ukrycie albo przywrócenie projektu w drzewie.
  hide,

  /// Jedno żądanie niosące scalone przypięcie i ukrycie.
  preference,

  /// Zapis kolejności widocznych projektów.
  reorder,

  /// Archiwizacja projektu.
  archive,

  /// Przywrócenie zarchiwizowanego projektu.
  restore,

  /// Trwałe usunięcie zarchiwizowanego projektu.
  deletePermanently,

  /// Opuszczenie jawnego członkostwa projektu.
  ///
  /// Operacja nie zmienia drzewa optymistycznie: projekt Shared pozostaje
  /// widoczny przez dziedziczenie dostępu workspace, więc o miejscu projektu
  /// rozstrzyga dopiero świeża lista serwera.
  leaveMembership,

  /// Utworzenie szablonu z projektu.
  createTemplate,

  /// Odczyt sekcji `Ukryte` i `Archiwum` z serwera.
  ///
  /// Operacja jest tylko odczytem, więc nie ma czego cofać — mimo to jej błąd
  /// jest trwały i widoczny, bo bez niego drzewo pokazywałoby niepełną listę
  /// projektów bez wyjaśnienia.
  loadSections,
}

/// Stabilna klasyfikacja porażki operacji, niezależna od transportu.
enum ProjectsTreeFailureKind {
  /// Operacji nie da się wykonać, bo brakuje portu mutacji w kompozycji.
  unavailable,

  /// Sesja wygasła i odświeżenie nie powiodło się.
  unauthorized,

  /// Brak uprawnień do zasobu albo operacji.
  forbidden,

  /// Projekt nie istnieje albo nie jest już dostępny.
  notFound,

  /// Konflikt ze stanem serwera (np. równoległa zmiana w drugiej sesji).
  conflict,

  /// Backend odrzucił dane wejściowe.
  validation,

  /// Limit żądań po stronie backendu.
  rateLimited,

  /// Błąd serwera.
  server,

  /// Brak połączenia z transportem.
  transport,

  /// Intencja była niepełna (np. kolejność nie obejmowała wszystkich
  /// widocznych projektów) i nie została wysłana do backendu.
  invalidIntent,

  /// Błąd niezaklasyfikowany.
  unknown,
}

/// Opis intencji do bezpiecznego ponowienia po nieudanej operacji.
///
/// Cubit nie przechowuje domknięć: ponowienie odtwarza operację z wartości
/// docelowych, więc test może je zweryfikować bez UI.
final class ProjectsRetryIntent {
  const ProjectsRetryIntent({
    required this.operation,
    this.projectId,
    this.targetPinned,
    this.targetHidden,
    this.targetOrder,
  });

  /// Operacja, która ma zostać powtórzona.
  final ProjectsTreeOperation operation;

  /// Projekt, którego dotyczyła operacja; `null` dla operacji na całej liście.
  final String? projectId;

  /// Docelowa wartość przypięcia dla operacji `pin`/`preference`.
  final bool? targetPinned;

  /// Docelowa wartość ukrycia dla operacji `hide`/`preference`.
  final bool? targetHidden;

  /// Docelowa kolejność dla operacji `reorder`.
  final List<String>? targetOrder;
}

/// Trwały opis nieudanej operacji pokazywany bezpośrednio w drzewie.
///
/// Błąd nie jest wyłącznie SnackBarem: niesie status, kod backendu i `traceId`,
/// a informacja `rolledBack` mówi wprost, czy stan lokalny został cofnięty.
final class ProjectsTreeFailure {
  const ProjectsTreeFailure({
    required this.operation,
    required this.kind,
    required this.rolledBack,
    this.statusCode,
    this.code,
    this.traceId,
    this.backendMessage,
    this.retry,
  });

  /// Operacja, która się nie powiodła.
  final ProjectsTreeOperation operation;

  /// Znormalizowana przyczyna porażki.
  final ProjectsTreeFailureKind kind;

  /// Czy cofnięto zmiany lokalne tej operacji.
  final bool rolledBack;

  /// Kod HTTP zwrócony przez backend, jeżeli był dostępny.
  final int? statusCode;

  /// Tekstowy kod błędu z kontraktu (np. `project_version_conflict`).
  final String? code;

  /// Identyfikator korelacyjny backendu, jeżeli został zwrócony.
  final String? traceId;

  /// Komunikat zwrócony przez backend; prezentacja decyduje, gdzie go pokazać.
  final String? backendMessage;

  /// Intencja do ponowienia; `null`, gdy ponowienie nie jest bezpieczne.
  final ProjectsRetryIntent? retry;
}

/// Rodzaj nietrwałego potwierdzenia operacji.
enum ProjectsTreeNoticeKind {
  pinned,
  unpinned,
  hidden,
  unhidden,
  archived,
  restored,
  deleted,
  left,
  templateCreated,
}

/// Nietrwałe potwierdzenie akcji z opcjonalnym cofnięciem.
///
/// Identyfikator rośnie z każdym potwierdzeniem, więc warstwa prezentacji wie,
/// czy pokazać komunikat ponownie po przebudowie.
final class ProjectsTreeNotice {
  const ProjectsTreeNotice({
    required this.id,
    required this.kind,
    required this.canUndo,
    required this.projectId,
    required this.projectName,
  });

  /// Lokalny identyfikator potwierdzenia.
  final int id;

  /// Rodzaj potwierdzenia; prezentacja mapuje go na tekst ARB.
  final ProjectsTreeNoticeKind kind;

  /// Czy dostępne jest cofnięcie ostatniej operacji.
  final bool canUndo;

  /// Identyfikator projektu, którego dotyczyło potwierdzenie.
  final String projectId;

  /// Nazwa projektu, którego dotyczyło potwierdzenie.
  final String projectName;
}

/// Stan jednego drzewa projektów wraz z lokalnymi nakładkami preferencji.
final class ProjectsTreeState {
  const ProjectsTreeState({
    this.visible = const [],
    this.hidden = const [],
    this.archived = const [],
    this.pendingProjectIds = const {},
    this.isReordering = false,
    this.failure,
    this.notice,
  });

  /// Projekty widoczne w drzewie w kolejności prezentacji (przypięte na górze).
  final List<ProjectListItem> visible;

  /// Projekty ukryte przez bieżącego użytkownika — sekcja `Ukryte`.
  final List<ProjectListItem> hidden;

  /// Projekty zarchiwizowane — sekcja `Archiwum`.
  ///
  /// Sekcja pochodzi z serwera (`state: archived`), więc po restarcie klienta
  /// nadal pokazuje projekty zarchiwizowane wcześniej, a nie tylko te
  /// zarchiwizowane w bieżącej sesji.
  final List<ProjectListItem> archived;

  /// Identyfikatory projektów z mutacją w locie.
  final Set<String> pendingProjectIds;

  /// Czy trwa zapis kolejności projektów.
  final bool isReordering;

  /// Ostatni trwały błąd operacji albo `null`.
  final ProjectsTreeFailure? failure;

  /// Ostatnie nietrwałe potwierdzenie operacji albo `null`.
  final ProjectsTreeNotice? notice;

  /// Czy jakakolwiek mutacja jest w locie.
  bool get hasPendingMutation => isReordering || pendingProjectIds.isNotEmpty;

  ProjectsTreeState copyWith({
    List<ProjectListItem>? visible,
    List<ProjectListItem>? hidden,
    List<ProjectListItem>? archived,
    Set<String>? pendingProjectIds,
    bool? isReordering,
    ProjectsTreeFailure? failure,
    bool clearFailure = false,
    ProjectsTreeNotice? notice,
    bool clearNotice = false,
  }) => ProjectsTreeState(
    visible: visible ?? this.visible,
    hidden: hidden ?? this.hidden,
    archived: archived ?? this.archived,
    pendingProjectIds: pendingProjectIds ?? this.pendingProjectIds,
    isReordering: isReordering ?? this.isReordering,
    failure: clearFailure ? null : (failure ?? this.failure),
    notice: clearNotice ? null : (notice ?? this.notice),
  );
}
