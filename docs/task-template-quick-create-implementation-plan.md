# Plan wdrożenia: domyślne formatki tasków i szybkie tworzenie

Status: plan implementacyjny dla backendu `veloryn-workspaces` i klienta Flutter `ready_next`.

## 1. Cel funkcjonalny

Użytkownik może posiadać i wykorzystywać kilka formatek tasków, na przykład:

- „Mały task — ja przypisany”,
- „Bug — XL — zespół IT”,
- „Analiza”,
- „Pilne”,
- „Subtask techniczny”,
- „Zadanie bez przypisania”.

Jedną formatkę ustawia jako domyślną dla danego workspace. Po ustawieniu domyślnej formatki:

- na Kanbanie wpisuje tylko tytuł i naciska Enter,
- na liście tasków wpisuje tylko tytuł,
- przy dodawaniu subtaska wpisuje tylko tytuł,
- backend tworzy zadanie z wpisanym tytułem i pozostałymi wartościami z domyślnej formatki.

Użytkownik nadal może:

- wybrać inną formatkę dla pojedynczego taska,
- utworzyć task bez formatki,
- otworzyć pełny formularz i zmienić wartości,
- wyczyścić domyślną formatkę.

## 2. Najważniejsza decyzja techniczna

Domyślna formatka jest stosowana przez backend, a nie wyłącznie przez Fluttera. Dzięki temu zachowanie jest identyczne dla Kanbana, listy tasków, subtasków, przyszłych klientów, automatyzacji i bezpośrednich wywołań API.

Obecny backend przechowuje już:

- bibliotekę szablonów workspace,
- osobisty domyślny szablon użytkownika,
- pełny snapshot ustawień,
- endpoint tworzenia taska z szablonu.

Brakuje możliwości utworzenia taska z szablonu z zastąpieniem zapisanego tytułu tekstem wpisanym przez użytkownika. Obecny `ApplyTaskTemplateRequest` przekazuje tylko projekt, rodzica i status docelowy, a backend używa tytułu zapisanego w szablonie.

## 3. Ustalenia produktowe

### 3.1. Zakres formatki

Formatka przechowuje:

- nazwę formatki,
- opcjonalny proponowany tytuł,
- opis,
- status,
- priorytet,
- typ taska,
- rozmiar,
- złożoność,
- ryzyko,
- wartość biznesową,
- estymowany czas,
- wykonawców, z kolejnością i głównym wykonawcą,
- checklistę,
- kryteria akceptacji,
- etykiety,
- custom fields,
- opcjonalną własną kolumnę Kanbana.

Zakres ten zasadniczo pokrywa istniejący `TaskTemplateContracts.cs`.

### 3.2. Widoczność formatek

W pierwszej wersji zachować obecny model:

- formatki należą do workspace,
- wszyscy aktywni członkowie workspace mogą je odczytać,
- użytkownik ma własny wybór domyślnej formatki,
- autor albo administracja może edytować formatkę zgodnie z obecnymi uprawnieniami.

Nie wprowadzać sztucznego limitu dokładnie 5–6 formatek. UI ma być wygodne dla tej liczby, ale backend powinien obsłużyć więcej. Jeżeli potrzebny będzie limit biznesowy, należy dodać go później jako jawną politykę workspace lub planu.

### 3.3. Priorytet wartości

Przy szybkim tworzeniu kolejność źródeł jest następująca:

1. Kontekst miejsca tworzenia: wpisany tytuł, `ParentTaskId` i wybrana kolumna Kanbana.
2. Jawnie wybrana formatka.
3. Domyślna formatka użytkownika.
4. Systemowe wartości domyślne, jeśli nie ma formatki.

Reguły:

- wpisany tytuł zawsze zastępuje tytuł zapisany w formatce,
- `ParentTaskId` zawsze pochodzi z miejsca, w którym tworzony jest subtask,
- kolumna, w której użytkownik wpisał task, ma pierwszeństwo przed statusem formatki,
- pozostałe pola pochodzą z formatki,
- brak domyślnej formatki nie jest błędem — działa prosty create.

### 3.4. Własna kolumna Kanbana

Jeżeli użytkownik wpisuje task bezpośrednio w kolumnie:

- kolumna Kanbana wygrywa ze statusem zapisanym w formatce,
- dla systemowej kolumny klient przekazuje `TargetStatus`,
- dla własnej kolumny klient przekazuje `CustomStatusId`.

Dla subtaska:

- klient nie przekazuje `CustomStatusId`, ponieważ backend zabrania umieszczania subtaska bezpośrednio we własnej kolumnie,
- status subtaska wynika z formatki albo początkowego systemowego workflow.

## 4. Backend C# — zmiany kontraktu

### 4.1. Rozszerzenie `ApplyTaskTemplateRequest`

W `Contracts/Tasks/TaskTemplateContracts.cs` dodać opcjonalne pola:

```csharp
public sealed record ApplyTaskTemplateRequest(
    Guid ProjectId,
    Guid? ParentTaskId = null,
    Guid? CustomStatusId = null,
    string? TitleOverride = null,
    ProjectTaskStatus? TargetStatus = null);
```

Każde pole musi dostać polski opis Swaggera:

- `TitleOverride` — tytuł podany w szybkim tworzeniu; zastępuje tytuł snapshotu,
- `TargetStatus` — systemowa kolumna wskazana przez miejsce tworzenia,
- `CustomStatusId` — własna kolumna wskazana przez miejsce tworzenia.

Walidacja:

- `TitleOverride`, jeśli przekazany, po `Trim()` musi mieć 1–240 znaków,
- `TargetStatus` i `CustomStatusId` są wzajemnie wykluczające,
- `CustomStatusId` jest niedozwolony dla subtasków,
- status lub kolumna musi należeć do projektu i być aktywna.

Zmiana pozostaje kompatybilna wstecznie, ponieważ nowe pola są opcjonalne.

### 4.2. Stosowanie nadpisanego tytułu

W `Application/Tasks/TaskTemplateHandler.cs` wyliczyć:

```csharp
var effectiveTitle = request.TitleOverride is null
    ? snapshot.Title
    : request.TitleOverride.Trim();
```

`effectiveTitle` musi zostać użyty w:

- konstruktorze `ProjectTask`,
- `task.Update(...)`,
- historii zadania, jeśli snapshot historii zawiera tytuł,
- powiadomieniu,
- zdarzeniu realtime.

### 4.3. Rozwiązywanie statusu

Rozdzielić odpowiedzialność do prywatnej, testowalnej metody lub osobnego serwisu, np. `ResolveEffectiveTaskPlacementAsync`.

Kolejność:

1. Jeżeli podano `CustomStatusId`, użyć wskazanego aktywnego custom statusu.
2. W przeciwnym razie, jeżeli podano `TargetStatus`, użyć go.
3. W przeciwnym razie spróbować odtworzyć custom status zapisany w formatce.
4. Jeśli się nie uda lub formatka go nie ma, użyć systemowego statusu formatki.
5. Dla subtaska pominąć własny custom status.

Nie wykonywać cichego fallbacku, gdy klient jawnie podał nieistniejący `CustomStatusId`. W takim przypadku zwrócić `400`.

### 4.4. Nowy endpoint szybkiego tworzenia

Dodać osobny przypadek użycia:

```http
POST /api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/quick-create
```

Request:

```csharp
public sealed record QuickCreateProjectTaskRequest(
    string Title,
    Guid? ParentTaskId = null,
    Guid? TaskTemplateId = null,
    bool UseDefaultTemplate = true,
    ProjectTaskStatus? TargetStatus = null,
    Guid? CustomStatusId = null,
    Guid? PreviousTaskId = null,
    Guid? NextTaskId = null);
```

Znaczenie:

- `TaskTemplateId` — jawnie wybrana formatka,
- `UseDefaultTemplate=true` — gdy nie podano ID, backend pobiera formatkę domyślną użytkownika,
- `UseDefaultTemplate=false` — tworzy prosty task bez formatki,
- `Title` — zawsze tytuł nowego zadania,
- pola placementu pochodzą z UI.

Ten endpoint powinien być głównym kontraktem wszystkich szybkich formularzy Fluttera.

### 4.5. Handler `QuickCreateProjectTaskHandler`

Dodać handler w `Application/Tasks/Handlers/`.

Algorytm:

1. Sprawdzić `RequireCreateAsync`.
2. Zwalidować tytuł i placement.
3. Rozwiązać ID formatki: `request.TaskTemplateId`, preferencja użytkownika przy `UseDefaultTemplate=true` albo brak formatki.
4. Jeżeli jest formatka, użyć wspólnego serwisu tworzenia ze snapshotu i nadpisać tytuł oraz placement.
5. Jeżeli nie ma formatki, utworzyć prosty task: priorytet `Normal`, wskazana kolumna albo początkowy status, brak przypisań i pól dodatkowych.
6. Zapisać wszystko atomowo jednym `SaveChangesAsync`.
7. Zwrócić `TaskMutationResponse<ProjectTaskResponse>`, tak jak standardowe tworzenie.
8. Wysłać jedno powiadomienie i jedno zdarzenie realtime.
9. Zapisać w historii źródło, ID formatki i informację, czy użyto defaultu.

Przykładowe metadane historii:

```json
{
  "source": "quick_create",
  "templateId": "...",
  "usedDefaultTemplate": true
}
```

Nie wywoływać jednego handlera HTTP z drugiego. Wydzielić wspólną logikę tworzenia ze snapshotu do serwisu aplikacyjnego używanego przez `TaskTemplateHandler.ApplyAsync` i `QuickCreateProjectTaskHandler`.

### 4.6. Nieaktualna lub niezgodna formatka

Jeżeli domyślna formatka została usunięta, preferencja powinna zostać usunięta razem z nią — backend już to obsługuje.

Jeżeli formatka wskazuje nieaktywnego członka, brakującą etykietę, brakujące custom field albo brakujący custom status, quick create nie może utworzyć niepełnego taska.

Backend zwraca kontrolowany błąd, np.:

```json
{
  "code": "task_template.invalid_for_project",
  "message": "Domyślna formatka nie może zostać użyta w tym projekcie.",
  "fields": {
    "customFieldValues": ["W projekcie nie istnieje pole „Klient”."]
  },
  "traceId": "..."
}
```

UI pokazuje błąd oraz akcję „Zmień formatkę”.

### 4.7. Endpoint listowania

Żeby szybkie UI nie musiało osobno wykonywać `list` i `getDefault`, rekomendowane jest rozszerzenie elementu listy:

```csharp
public sealed record TaskTemplateListItemResponse(
    Guid Id,
    Guid WorkspaceId,
    string Name,
    bool IsDefaultForCurrentUser,
    DateTime UpdatedAtUtc,
    long Version);
```

Alternatywnie można pozostawić dwa istniejące requesty. Jedno zapytanie jest docelowo lepsze, ale nie jest warunkiem uruchomienia funkcji. Lista nie powinna zwracać pełnego snapshotu.

### 4.8. Tworzenie formatki bez taska źródłowego

Obecnie formatkę tworzy się przez snapshot istniejącego taska. Dodać:

```http
POST /api/v1/workspaces/{workspaceId}/task-templates
```

Request powinien zawierać ten sam zakres co `UpdateTaskTemplateRequest`, ale bez `ExpectedVersion`. Nie wymaga to nowej tabeli. Powstaje standardowy `TaskTemplate` ze snapshotem aktualnej wersji.

### 4.9. Limit i unikalność nazw

Rekomendacja:

- bez twardego limitu liczby formatek,
- nazwa 1–160 znaków,
- unikalność nazwy w workspace bez uwzględniania wielkości liter,
- konflikt zwraca `409 task_template.name_conflict`.

Jeżeli biznes wymaga maksymalnie sześciu formatek:

- limit egzekwować na backendzie,
- liczyć aktywne szablony workspace,
- zwracać `409 task_template.limit_reached`,
- limit przechowywać w typowanej konfiguracji lub polityce, nie jako magiczną liczbę w endpointach.

### 4.10. Naprawa istniejącego kontraktu usuwania

Backend `DELETE` wymaga `expectedVersion`, natomiast obecny klient Retrofit go nie przekazuje. Ujednolicić kontrakt:

```http
DELETE .../task-templates/{templateId}?expectedVersion=3
```

Flutter musi przekazywać wersję elementu.

## 5. Backend — baza danych i migracje

Dla podstawowego wariantu nie jest potrzebna nowa migracja:

- `task_templates` już istnieje,
- `task_template_user_preferences` już istnieje,
- relacja domyślnej formatki per użytkownik i workspace już istnieje.

Migracja jest potrzebna tylko w przypadku wprowadzenia dodatkowej polityki, np. formatek prywatnych, archiwizacji, przypisania formatki do projektu albo unikalnego indeksu nazwy.

Jeśli dodajemy unikalność nazwy, indeks powinien uwzględniać `workspace_id` i znormalizowaną nazwę. Nie wprowadzać ręcznego SQL bez technicznego uzasadnienia.

## 6. Backend — Swagger i zgodność projektu

Każdy dodany lub zmieniony endpoint musi mieć:

- tag `Tasks`,
- szczegółowy polski opis,
- polskie opisy wszystkich parametrów,
- opis wymaganych uprawnień,
- jawne response types,
- błędy `400`, `401`, `403`, `404`, `409`,
- przykładowy request i response dla quick create,
- JWT Bearer w OpenAPI.

Zmiana musi objąć:

- `Contracts/Tasks`,
- `Endpoints/Tasks/ProjectTaskEndpoints.cs`,
- handler Application,
- testy kontraktowe i OpenAPI,
- dokumentację API,
- klienta Flutter.

## 7. Flutter — warstwa danych

### 7.1. Model quick create

Dodać do modeli transportowych:

```dart
@freezed
abstract class QuickCreateProjectTaskPayload
    with _$QuickCreateProjectTaskPayload {
  const factory QuickCreateProjectTaskPayload({
    required String title,
    String? parentTaskId,
    String? taskTemplateId,
    @Default(true) bool useDefaultTemplate,
    ProjectTaskStatus? targetStatus,
    String? customStatusId,
    String? previousTaskId,
    String? nextTaskId,
  }) = _QuickCreateProjectTaskPayload;
}
```

Po zmianie uruchomić generator Freezed/JSON zgodnie z projektem.

### 7.2. Retrofit

W `lib/workspaces/data/projects/tasks/api/tasks_api.dart` dodać endpoint `quickCreateTask` wskazujący na `/tasks/quick-create`.

W `task_templates_api.dart` dodać lub poprawić:

- tworzenie formatki od zera,
- `expectedVersion` przy usuwaniu,
- ewentualnie kontrakt listy z `isDefaultForCurrentUser`.

### 7.3. Repository

Do `TasksRepository` dodać:

```dart
Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
quickCreateTask({
  required String workspaceId,
  required String projectId,
  required QuickCreateProjectTaskPayload payload,
});
```

Implementacja:

- wywołuje wyłącznie API,
- mapuje `ApiError` z zachowaniem `code`, `message`, `fields` i `traceId`,
- nie stosuje formatki lokalnie,
- nie zna UI ani `BuildContext`.

## 8. Flutter — wspólny stan formatek

Obecny `TaskTemplatePickerCubit` ładuje katalog i domyślną formatkę, ale żyje tylko wewnątrz side sheetu. Quick create nie ma dostępu do tej preferencji.

Dodać lokalny dla modułu tasków cubit/cache, np.:

```text
lib/workspaces/presentation/tasks/templates/
├── cubit/
│   ├── task_templates_cubit.dart
│   └── task_templates_state.dart
├── task_template_picker.dart
├── task_template_badge.dart
└── task_template_editor/
```

Stan powinien rozróżniać:

- loading,
- ready z listą, `defaultTemplateId`, stanem zapisu i błędem,
- failure z typowanym `ApiError`.

Cubit odpowiada za:

- listę formatek,
- pobranie domyślnej,
- ustawienie domyślnej,
- tworzenie,
- edycję,
- usuwanie,
- odświeżanie,
- wyznaczenie nazwy domyślnej formatki.

Scope Cubita:

- najniższy wspólny poziom ekranu Tasks,
- współdzielony przez listę i Kanban w ramach bieżącego workspace,
- tworzony i zamykany razem z ekranem,
- nie może być globalnym singletonem.

Backend pozostaje źródłem prawdy. Cache trzeba unieważnić po zmianie workspace.

## 9. Flutter — zachowanie szybkiego tworzenia

### 9.1. Kanban

Obecny quick create w `tasks_board_quick_create.dart` wysyła prosty create z priorytetem `Normal`.

Zmienić `TasksBoardCubit.createQuickTask`, aby wywoływał `quickCreateTask`:

```dart
QuickCreateProjectTaskPayload(
  title: normalizedTitle,
  useDefaultTemplate: true,
  targetStatus: column.customStatusId == null ? column.status : null,
  customStatusId: column.customStatusId,
)
```

Nie przesyłać wartości pól formatki z Fluttera.

Po sukcesie:

- zamknąć edycję,
- wyczyścić pole,
- odświeżyć właściwą kolumnę albo wstawić wynik optymistycznie,
- obsłużyć zdarzenie realtime bez duplikowania karty.

Po błędzie:

- nie zamykać pola,
- zachować wpisany tekst,
- wyświetlić komunikat backendu,
- dać akcję „Zmień formatkę” lub „Utwórz bez formatki”.

Obecnie pole jest czyszczone również wtedy, gdy create zwróci `false`. Trzeba je zamykać i czyścić tylko po sukcesie.

### 9.2. Lista tasków

Oba miejsca szybkiego tworzenia w liście tasków mają korzystać z tego samego endpointu:

- quick create w nagłówku,
- inline create w grupie.

Kontekst grupowania wpływa na request:

- grupa statusu → `TargetStatus`,
- grupa custom statusu → `CustomStatusId`,
- inne grupy, np. priorytet lub assignee, nie powinny niejawnie nadpisywać wartości formatki bez jawnego kontraktu.

Jeśli produkt ma wymagać tworzenia w grupie przypisanego użytkownika, osobno rozszerzyć quick-create request o typowane overrides. Nie budować tego z niejawnego słownika.

### 9.3. Subtask

Miejsca w `KanbanSubtasksCubit` i `TaskDetailsCubit` powinny wysyłać:

```dart
QuickCreateProjectTaskPayload(
  title: title,
  parentTaskId: parentTaskId,
  useDefaultTemplate: true,
)
```

Domyślna formatka jest stosowana także do subtaska. Jeśli formatka zawiera custom status, backend pomija go dla subtaska zgodnie z regułą domenową.

### 9.4. Pełny formularz

Pełny formularz nie powinien automatycznie zapisywać taska po wyborze formatki.

Przepływ:

1. Otwarcie formularza.
2. Załadowanie domyślnej formatki.
3. Wypełnienie pól formatki.
4. Użytkownik może je zmienić.
5. Zapis wysyła zwykły `CreateProjectTaskPayload`.

Nad selektorem formatki umieścić przełącznik „Używaj domyślnej formatki przy szybkim dodawaniu”.

## 10. Projekt UI

### 10.1. Quick create w kolumnie

Po wejściu w tryb wpisywania pokazać chip nad polem lub pod nim:

```text
[ Domyślna: Bug XL ▾ ]                 [Enter]
Tytuł zadania…
```

Po kliknięciu chipa otworzyć lekkie menu:

```text
Formatka dla tego zadania

★ Bug XL                 Domyślna
  Mały task
  Analiza
  Pilne
  Bez formatki
────────────────────────────
Zarządzaj formatkami
```

Wybór w tym menu dotyczy tylko bieżącego tworzenia i nie zmienia domyślnej formatki. Osobna akcja przy formatce brzmi „Ustaw jako domyślną”.

### 10.2. Panel zarządzania formatkami

Obecny side sheet można zachować, ale rozdzielić na:

- lewą listę formatek,
- prawy panel edycji,
- na mniejszym ekranie: lista → osobny widok edycji.

Każdy kafel pokazuje:

- nazwę,
- gwiazdkę domyślnej,
- skrócone podsumowanie, np. `Bug · XL · 2 osoby`,
- liczbę checklist i custom fields,
- menu: użyj, ustaw jako domyślną, edytuj, duplikuj, usuń.

Nagłówek:

```text
Formatki tasków                         [+ Nowa formatka]
Wybierz ustawienia automatycznie stosowane do nowych tasków.
```

### 10.3. Edytor formatki

Sekcje:

1. Podstawowe: nazwa formatki, przykładowy tytuł, opis i typ taska.
2. Planowanie: priorytet, rozmiar, złożoność, ryzyko, wartość biznesowa i estymacja.
3. Odpowiedzialność: wykonawcy, główny wykonawca i akcja „Przypisz mnie”.
4. Organizacja: status, etykiety i custom fields.
5. Definicja ukończenia: checklista i kryteria akceptacji.

Daty bezwzględne w formatce są ryzykowne, ponieważ szybko się dezaktualizują. Docelowo warto zastąpić je regułami typu „start: dzisiaj” i „termin: za N dni roboczych”. Nie jest to wymagane do pierwszego wdrożenia.

### 10.4. Stany UI

Obsłużyć:

- ładowanie,
- pustą bibliotekę,
- zapis domyślnej formatki,
- błąd formatu niezgodnego z projektem,
- usunięcie formatki,
- konflikt wersji `409`,
- utratę dostępu do wykonawcy,
- brak definicji custom field,
- brak sieci,
- ponowienie operacji bez utraty wpisanego tytułu.

Wszystkie teksty dodać do ARB PL/EN i wygenerować lokalizacje. Widoczny tekst skrótów klawiaturowych również powinien pochodzić z lokalizacji lub komponentu skrótów.

## 11. Testy backendu

### 11.1. Testy jednostkowe

Dodać przypadki:

- szybkie utworzenie bez domyślnej formatki,
- szybkie utworzenie z domyślną formatką,
- jawna formatka ma pierwszeństwo przed domyślną,
- `UseDefaultTemplate=false` pomija preferencję,
- wpisany tytuł zastępuje tytuł snapshotu,
- formatka przypisuje jedną lub wiele osób,
- pierwszy wykonawca pozostaje główny,
- formatka przenosi `Size`, custom fields, etykiety i checklistę,
- kolumna Kanbana ma pierwszeństwo przed statusem formatki,
- subtask otrzymuje pola formatki,
- subtask nie otrzymuje custom statusu,
- nieaktywny wykonawca powoduje kontrolowany błąd,
- brakujące custom field powoduje kontrolowany błąd,
- użytkownik nie może użyć szablonu z innego workspace,
- użytkownik bez prawa create otrzymuje `403`,
- brak domyślnej formatki nie powoduje `404`.

### 11.2. Testy integracyjne PostgreSQL

Zweryfikować:

- FK preferencji do szablonu,
- usunięcie szablonu czyści preferencję,
- ustawienie nowego defaultu zastępuje poprzedni,
- użytkownicy tego samego workspace mają niezależne defaulty,
- transakcja nie pozostawia częściowo utworzonych assignees lub custom fields,
- historia zawiera źródło i ID formatki.

### 11.3. Testy endpointów i OpenAPI

Sprawdzić:

- request i response quick create,
- opisy Swaggera po polsku,
- tag `Tasks`,
- enumy jako tekst,
- kody `400`, `401`, `403`, `404`, `409`,
- kompatybilność rozszerzonego `ApplyTaskTemplateRequest`.

## 12. Testy Fluttera

### 12.1. Repository i API

- poprawna serializacja quick-create,
- brak `taskTemplateId` nie usuwa `useDefaultTemplate`,
- poprawne mapowanie `TargetStatus` i `CustomStatusId`,
- `expectedVersion` przy delete,
- pełne mapowanie błędu backendu.

### 12.2. Cubity

- ładowanie listy i defaultu,
- zmiana i wyczyszczenie defaultu,
- przełączenie workspace czyści poprzedni stan,
- quick create wywołuje nowy endpoint,
- jawna formatka jest przekazywana tylko dla pojedynczego create,
- błąd nie usuwa wpisanego tekstu,
- sukces odświeża Kanban lub listę,
- brak emisji po zamknięciu Cubita.

### 12.3. Widgety

- chip pokazuje nazwę domyślnej formatki,
- menu pozwala wybrać inną formatkę,
- „Bez formatki” ustawia `UseDefaultTemplate=false`,
- Enter tworzy dokładnie raz,
- wielokrotne kliknięcie jest blokowane podczas requestu,
- Escape zamyka edycję bez requestu,
- błąd zachowuje tytuł,
- układ działa przy małej szerokości,
- obsługa klawiatury działa na Web i desktopie,
- wszystkie teksty pochodzą z `context.l10n`.

## 13. Kolejność implementacji dla agenta

- [x] 1. Zweryfikować branch `workspace` w obu repozytoriach.
- [x] 2. Przeczytać `workspace-implementation.md`, `workspace-implementation-plan.md`, `AGENTS.md` Fluttera i instrukcje backendu C#.
- [x] 3. Dodać backendowy kontrakt `QuickCreateProjectTaskRequest`.
- [x] 4. Rozszerzyć `ApplyTaskTemplateRequest` o `TitleOverride` i placement.
- [x] 5. Wydzielić wspólny serwis tworzenia taska ze snapshotu (`TaskTemplateExecutionService`).
- [x] 6. Dodać `QuickCreateProjectTaskHandler`.
- [x] 7. Dodać endpoint `/tasks/quick-create`.
- [x] 8. Dodać polskie metadane OpenAPI i kontrakty błędów.
- [x] 9. Dodać backendowe testy jednostkowe oraz integracyjne (`TaskTemplateQuickCreateTests`).
- [x] 10. Zaktualizować albo wygenerować kontrakt OpenAPI.
- [x] 11. Dodać modele Fluttera zgodne z OpenAPI.
- [x] 12. Rozszerzyć Retrofit i repository.
- [x] 13. Wygenerować pliki Retrofit, Freezed i JSON (`build_runner`).
- [x] 14. Wyodrębnić wspólny `TaskTemplatesCubit` / `TaskTemplatePickerCubit` dostarczany w `TasksBoardPage`.
- [x] 15. Przepiąć szybkie tworzenie Kanbana na nowy endpoint.
- [x] 16. Przepiąć szybkie tworzenie listy (`ProjectTasksListCubit`).
- [x] 17. Przepiąć dodawanie subtasków (`KanbanSubtasksCubit`, `TaskDetailsCubit`).
- [x] 18. Dodać selektor aktywnej formatki do quick create (`tasks_board_quick_create.dart`).
- [x] 19. Dodać lub udoskonalić panel zarządzania formatkami.
- [x] 20. Dodać tworzenie formatki od zera (`createFromDefinition`).
- [x] 21. Dodać lokalizacje PL/EN i wygenerować `l10n`.
- [x] 22. Dodać testy repository, Cubitów i widgetów.
- [x] 23. Uruchomić backendowe `dotnet test` (855 passed).
- [x] 24. Uruchomić `dart format`, `flutter analyze` i `flutter test`.
- [x] 25. Zbudować Flutter Web / zweryfikować kompilację.
- [x] 26. Zweryfikować zachowanie Web oraz Desktop.
- [x] 27. Zaktualizować `workspace-implementation.md` i checklistę `workspace-implementation-plan.md` po zakończeniu implementacji.

## 14. Kryteria akceptacji

Funkcja jest ukończona, gdy:

- użytkownik może mieć wiele formatek,
- może ustawić dokładnie jedną domyślną w workspace,
- dwóch użytkowników może mieć różne defaulty,
- wpisanie samego tytułu na Kanbanie stosuje default,
- wpisanie samego tytułu na liście stosuje default,
- wpisanie samego tytułu subtaska stosuje default,
- tytuł wpisany przez użytkownika zastępuje tytuł formatki,
- kolumna Kanbana pozostaje zgodna z miejscem tworzenia,
- można jednorazowo wybrać inną formatkę,
- można utworzyć task bez formatki,
- błąd nie usuwa wpisanego tekstu,
- backend atomowo zapisuje task, przypisania, checklistę, etykiety i custom fields,
- uprawnienia są sprawdzane po stronie backendu,
- Swagger, Flutter i testy używają jednego kontraktu,
- funkcja działa na Flutter Web/Wasm oraz desktopie.

## 15. Pliki startowe do analizy

Backend:

- `veloryn-workspaces/Application/Tasks/Handlers/CreateProjectTaskHandler.cs`,
- `veloryn-workspaces/Application/Tasks/TaskTemplateHandler.cs`,
- `veloryn-workspaces/Contracts/Tasks/CreateProjectTaskRequest.cs`,
- `veloryn-workspaces/Contracts/Tasks/TaskTemplateContracts.cs`,
- `veloryn-workspaces/Endpoints/Tasks/ProjectTaskEndpoints.cs`,
- `veloryn-workspaces/Domain/Entities/TaskTemplateUserPreference.cs`.

Flutter:

- `lib/workspaces/data/projects/tasks/api/tasks_api.dart`,
- `lib/workspaces/data/projects/tasks/api/task_templates_api.dart`,
- `lib/workspaces/data/projects/tasks/models/task_models.dart`,
- `lib/workspaces/data/projects/tasks/models/task_templates_models.dart`,
- `lib/workspaces/domain/repositories/tasks_repository.dart`,
- `lib/workspaces/domain/repositories/task_template_repository.dart`,
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart`,
- `lib/workspaces/presentation/tasks/board/tasks_board_quick_create.dart`,
- `lib/workspaces/presentation/tasks/board/tasks_board_template_picker.dart`,
- `lib/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart`,
- `lib/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit.dart`,
- `lib/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart`.
