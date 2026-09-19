# I0 — Projects data (bez Tasks/Milestones/Portfolio)

## Zakres

Ten batch obejmuje wyłącznie `lib/workspaces/data/projects/**` poza:

- `tasks/**` oraz zależnościami Kanbanu,
- `milestones/**`,
- `portfolios/**`,
- `project_resources_repository_impl.dart`, ponieważ agreguje kontrakty
  Whiteboard/Wiki/Storage/Automation spoza tego batcha.

Nie zmieniano routingu, shella, listy zadań, Board/Kanban, Files, Chat,
Notifications ani backendu.

## Wykonane zmiany

- Zweryfikowano, że dozwolony kod źródłowy Projects nie ma już importów
  `package:ready_next`.
- Zregenerowano wyłącznie kontrakty Retrofit dla:
  - `project_templates_api.g.dart`,
  - `custom_workflow_api.g.dart`.
  Źródłowe deklaracje miały już konkretne typy odpowiedzi/payloadów, ale
  wygenerowane implementacje pozostawały przy `InvalidType`.
- Zaktualizowano bezpośredni test profili członków projektu do kanonicznego
  `userId` zamiast usuniętego aliasu `coreUserId`.
- Nie dodawano aliasów, suppressions ani wymyślonych modeli.

## Walidacja

Przed zmianami szeroki audyt obejmujący ten obszar i bezpośrednie testy
prezentacji wykazał **243 problemy analizatora**; wynik zawierał również
problemy z agregatorem zasobów i testami spoza ścisłego zakresu.

Po zmianach, na dokładnie ograniczonym zakresie źródeł (30 plików Projects
poza wykluczeniami, bez plików generowanych, oraz dwa bezpośrednie testy
danych):

- `flutter analyze ...` — **No issues found**, exit code 0;
- testy:
  `flutter test test/workspaces/data/projects/project_member_profiles_repository_test.dart test/workspaces/data/projects/projects_gateway_test.dart --reporter compact`
  — **7 testów zaliczonych**;
- skan dozwolonego źródła i wygenerowanych plików: **0**
  `package:ready_next`, **0** `InvalidType`;
- skan bezpośrednich testów danych Projects: **0** `package:ready_next` i
  `InvalidType`;
- `git diff --check` — bez problemów.

Pełny ścisły zakres obejmujący także wygenerowane pliki zwraca exit code 0,
ale raportuje 40 informacji stylistycznych z generatorów Retrofit/Freezed;
nie edytowano ręcznie kodu generowanego.

Poza zakresem nadal istnieją znane `InvalidType` w `tasks/**` i
`portfolios/**`; nie zostały ruszone zgodnie z granicami batcha.

## Komenda generatora

Użyto filtrowanej regeneracji:

```text
dart run build_runner build --delete-conflicting-outputs \
  --build-filter=lib/workspaces/data/projects/templates/api/project_templates_api.g.dart \
  --build-filter=lib/workspaces/data/projects/custom_workflow/api/custom_workflow_api.g.dart
```

W tej wersji `build_runner` ostrzega, że `--delete-conflicting-outputs` jest
usunięte i ignorowane; nie wykonano żadnej operacji Git ani czyszczenia
worktree.
