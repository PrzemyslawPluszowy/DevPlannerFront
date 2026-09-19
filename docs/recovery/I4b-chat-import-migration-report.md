# I4b — migracja importów Chat z `ready_next`

Data: 2026-09-18  
Repozytorium: `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`  
Status: **częściowo wykonane — migracja prefiksów zakończona, graf Chat nie jest jeszcze kompilowalny**

## Zakres

Wykonano wyłącznie mechaniczną zamianę importów w istniejącym pionie Chat:

- `lib/workspaces/domain/chat/**`;
- `lib/workspaces/data/chat/**`;
- `lib/workspaces/presentation/chat/**`.

Łącznie zmieniono 232 importy w 65 plikach. Każde wystąpienie
`package:ready_next/...` w tym zakresie zostało zamienione na
`package:devplanner/...`. Nie zmieniano widgetów, Cubitów, routingu,
bootstrapu, kontraktów transportowych ani zachowania Chat. Nie dodawano
`setState`, funkcji globalnych ani nowych abstrakcji.

## Wynik skanu ścieżek

Po zamianie nie ma już `package:ready_next/` w trzech wskazanych gałęziach.
Większość importów wskazuje na istniejące pliki standalone. Trzy ścieżki nie
mają jeszcze odpowiednika w aktualnym repozytorium i wymagają osobnych prac
architektonicznych:

- `package:devplanner/app/router/app_router.dart` — aktywny router nazywa się
  `devplanner_router.dart` i ma inny kontrakt;
- `package:devplanner/app/shell/overlay/app_modal_host.dart` — nowy root modal
  host nie został jeszcze podłączony do legacy Chat;
- `package:devplanner/core/auth/auth_repository.dart` — Chat nadal oczekuje
  starego repozytorium auth; nie wolno odtwarzać go jako aliasu Ready/Core.

## Walidacja

Wykonano:

```text
flutter analyze lib/workspaces/domain/chat \
  lib/workspaces/data/chat \
  lib/workspaces/presentation/chat
```

Wynik: **68 issues found**. `git diff --check` dla zmienionych gałęzi:
**PASS**. Testów Chat nie oznaczono jako PASS, ponieważ analiza wykazała
blokujące błędy kompilacji.

Najważniejsze nierozwiązane klasy błędów:

1. Brak trzech standalone powierzchni wymienionych wyżej (router, modal host,
   auth repository).
2. Legacy identyfikatory `coreUserId` w adapterze ustawień powiadomień Chat.
   Docelowy kontrakt używa lokalnego `userId`; należy poprawić mapper i payload
   w osobnym pakiecie, nie dodawać aliasu.
3. Niezgodność starego `WorkspaceChatRealtimeService` z portem
   `ChatConversationRealtimeClient`.
4. Stare pole `authorCoreUserId` w kolejce dostarczania wiadomości; wymaga
   migracji do kanonicznego `authorUserId` wraz z kontraktem modelu.
5. Niezgodności typów `Either` w Cubitach ustawień powiadomień po przejściu na
   standalone `ApiError` i modele lokalne.
6. Informacyjne ostrzeżenia sortowania importów (`directives_ordering`), które
   można poprawić dopiero po ustaleniu docelowych powierzchni importowanych
   przez Chat.

## Następny pakiet

Kolejny agent powinien zamknąć graf kompilacji Chat w małych pakietach:

1. przepiąć Chat na `devplanner_navigation`/docelowy router;
2. zdefiniować i podłączyć standalone modal host z rootowym lifecycle;
3. podłączyć typed auth user/session port bez przywracania `core/auth`;
4. ujednolicić `userId`/`authorUserId` i typy błędów w adapterach Chat;
5. dopiero potem naprawić realtime port i uruchomić testy Chat.

Nie należy traktować tej mechanicznej zamiany jako ukończenia Chat ani jako
dowodu działania globalnego overlayu. Funkcjonalność nie została usunięta.
