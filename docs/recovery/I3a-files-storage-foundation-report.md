# I3a — fundament Files/Storage

Data: 2026-09-17  
Repozytorium: `Front`  
Zakres: warstwa data/domain Storage oraz testy tej warstwy.  
Status: zakończone, bez zmian backendu i bez zmian UI.

## Cel pakietu

Usunięto bezpośrednią zależność warstwy Storage od starego pakietu `ready_next`.
Kontrakty zostały przepięte na lokalny namespace `devplanner`, bez zmiany
ścieżek HTTP, nazw DTO, portów ani zachowania repozytorium. Pakiet przygotowuje
Files do późniejszego podłączenia do samodzielnego UI workspace, ale nie dodaje
jeszcze ekranu, routingu, menu ani overlayu.

Poza zakresem pozostały: Backend, router/shell, Chat, Notifications, Tasks,
Kanban, przenoszenie katalogów oraz migracja danych.

## Dowód zgodności z backendem

Rzeczywisty kontrakt został sprawdzony w:

- `../Backend/Endpoints/Storage/StorageEndpoints.cs:144-167` — upload-ticket,
  bulk upload i complete-upload;
- `../Backend/Endpoints/Storage/StorageEndpoints.cs:176-194` — download,
  stream i listowanie plików;
- `../Backend/Endpoints/Storage/StorageEndpoints.cs:231-259` — wersje,
  restore, kosz, restore z kosza i bulk ZIP;
- `../Backend/Endpoints/Storage/StorageEndpoints.cs:276-305` — udostępnienia,
  foldery, children, placementy i attach do projektu;
- `../Backend/Contracts/Storage/StorageContracts.cs:221-271` — pełny snapshot
  pliku, capability ACL, stan AI i flagi OnlyOffice;
- `../Backend/Contracts/Storage/StorageContracts.cs:325-425` — foldery,
  placementy, zawartość folderu i filtry listy.

Nie zmieniono żadnego endpointu ani kontraktu backendowego. Front nadal używa
lokalnego `userId` oraz pól kontraktu `ownerUserId`, `createdByUserId` i
`sharedWithUserId`; nie ma mapowania na stare identyfikatory Ready/Core.

## Zmiany

1. Przepięto importy w 36 plikach źródłowych Storage z
   `package:ready_next/...` na `package:devplanner/...`:
   `data/storage/**`, `domain/storage/**` oraz
   `domain/repositories/storage_repository.dart`.
2. Przepięto 8 testów warstwy data/storage na ten sam lokalny namespace.
3. Zachowano istniejące porty i implementacje:
   `StorageRepository`, upload/download transport, picker plików, preview,
   public-share link builder oraz adaptery OnlyOffice.
4. Wykonano kontrolowaną regenerację kodu Retrofit/Freezed/JSON przez
   `build_runner`; wygenerowano 21 wyjść. Plików generowanych nie edytowano
   ręcznie.
5. Uporządkowano importy zgodnie z `directives_ordering`. Warstwa Storage nie
   zawiera już bezpośrednich importów `ready_next` ani nazw
   `CoreUserId`/`ReadyUserId`.

## Zachowana funkcjonalność

W istniejącym repozytorium nadal są obsługiwane:

- listowanie plików z filtrami, widokami, kursorem i wyszukiwaniem;
- foldery, children, placementy oraz przenoszenie/usuwanie referencji;
- upload-ticket, presigned PUT, complete-upload i anulowanie transferu;
- download-ticket, streaming, pobieranie wersji oraz bulk ZIP;
- historia wersji i restore z optimistic concurrency;
- soft-delete, restore i ulubione;
- shares plików/folderów i budowanie publicznych linków;
- OnlyOffice session/export/konwersja oraz bezpieczny preview tekstowy;
- capability ACL (`canRead`, `canComment`, `canEdit`, `canShare`,
  `canDelete`, `canDownload`, `canRestore`, `canManageVersions`);
- modele oraz zapytania AI Storage, bez degradacji do atrap.

Nie usunięto żadnej metody repozytorium, portu ani transportu. Zmiana ma
charakter namespace/build-integracyjny.

## Liczniki przed/po

| Kontrola | Przed | Po |
|---|---:|---:|
| Pliki źródłowe Storage z `package:ready_next` | 36 | 0 |
| Testy `test/workspaces/data/storage` z `package:ready_next` | 8 | 0 |
| Pliki źródłowe Storage w zakresie audytu | 51 | 51 |
| Testy Storage w zakresie audytu | 8 | 8 |
| Wykryte `CoreUserId`/`ReadyUserId`/`readyUserId` w zakresie | 0 | 0 |
| Metody/operacje Storage usunięte | — | 0 |

Liczba „przed” pochodzi z `git grep` względem bazowego `HEAD`; liczba „po” z
tego samego skanu po zmianie.

## Walidacja

Wykonano w katalogu `Front`:

```text
dart format --output=none --set-exit-if-changed \
  lib/workspaces/data/storage \
  lib/workspaces/domain/storage \
  lib/workspaces/domain/repositories/storage_repository.dart \
  test/workspaces/data/storage
=> Formatted 60 files (0 changed).

dart run build_runner build --delete-conflicting-outputs \
  --build-filter='lib/workspaces/data/storage/**'
=> Built with build_runner/aot; wrote 21 outputs.

flutter analyze \
  lib/workspaces/data/storage \
  lib/workspaces/domain/storage \
  lib/workspaces/domain/repositories/storage_repository.dart
=> No issues found!

flutter test test/workspaces/data/storage
=> 00:01 +24: All tests passed!

git diff --check
=> OK (brak błędów whitespace).
```

Generator zgłosił wyłącznie znane ostrzeżenia narzędziowe o wersji SDK/analyzera
i constraint `json_annotation`; nie wystąpił błąd kompilacji ani testu.

## Bramka dla następnego etapu

Warstwa Files/Storage jest gotowa do osobnego pakietu UI. Następny agent może
złożyć lokalny composition root dla Files, a potem ekran/overlay z typowanym
stanem pustym, błędem i retry. Nie wolno przywracać importów `ready_next`,
przenosić logiki HTTP do widgetów ani dodawać placeholderów zamiast realnych
operacji Storage.

## Addendum po review — porządek importów testów

Review wykrył, że pierwsza wersja raportu obejmowała analizę źródeł Storage,
ale nie raportowała osobnej analizy ośmiu testów. W ośmiu plikach testowych
uporządkowano wyłącznie dyrektywy importu (`directives_ordering`); nie zmieniono
ciał testów ani zachowania produkcyjnego.

Kontrola po poprawce:

```text
dart format --output=none --set-exit-if-changed test/workspaces/data/storage
=> Formatted 8 files (0 changed).

flutter analyze \
  lib/workspaces/data/storage \
  lib/workspaces/domain/storage \
  lib/workspaces/domain/repositories/storage_repository.dart \
  test/workspaces/data/storage
=> No issues found! (ran in 5.5s)

flutter test test/workspaces/data/storage
=> 00:01 +24: All tests passed!

git diff --check
=> OK.
```

Nie wykonywano ręcznych zmian w plikach wygenerowanych.
