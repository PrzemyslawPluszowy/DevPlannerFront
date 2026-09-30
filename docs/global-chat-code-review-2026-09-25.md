# Pełny przegląd kodu Chat — Front i Backend

Data: 25.09.2026
Zakres: bieżący kod oraz niezapisane zmiany w `Front` i `Backend`; historia, read receipts, wyszukiwanie, odpowiedzi, realtime, formatowanie Quill, załączniki i powiązane akcje Storage, członkostwo, modele i kontrakty.

## Znalezione problemy

### P1 — równoległe wysłanie z tym samym `clientMessageId` mogło zakończyć się błędem — NAPRAWIONE

`ChatService.SendAsync` deklaruje obsługę wyścigu unikalności/serializacji, ale filtr obsługuje tylko bezpośrednie `DbUpdateException`/`PostgresException` (`Backend/Application/Chat/ChatService.cs:497`). Test PostgreSQL `ConcurrentSendWithSameClientMessageIdReturnsStoredMessage` zakończył się błędem `InvalidOperationException: An exception has been raised that is likely due to a transient failure`, z wewnętrznym PostgreSQL `40001 could not serialize access due to read/write dependencies among transactions`. Wyjątek nie wszedł do filtra, więc ponowienie idempotentnej wysyłki nie zwróciło zapisanej wiadomości.

**Naprawa:** `IsMessageDispatchConflict` przegląda teraz łańcuch `InnerException` i akceptuje wyłącznie PostgreSQL `40001` lub naruszenie unikalności. Zachowuje rollback oraz porównanie `PayloadHash`; nie przechwytuje ogólnie `InvalidOperationException`. Test PostgreSQL współbieżnego wysłania i cały wybrany filtr kontraktowo-wyszukiwawczy: **17/17 PASS**.

### P2 — snippet wyszukiwarki przekraczał deklarowany limit po escapowaniu — NAPRAWIONE

`ChatSearchText.Highlight` wycina najwyżej 238 znaków źródłowych, a następnie dodaje delimitery i escape'uje `\\`, `⟦` oraz `⟧` (`Backend/Application/Chat/ChatSearchText.cs:18-36`). Każdy escape zwiększa długość tekstu, więc zwracana wartość może być znacznie dłuższa niż 240 znaków. Test sprawdza limit wyłącznie dla treści bez znaków wymagających escape (`Backend/Tests/Veloryn.Workspaces.Tests/ChatFoundationTests.cs:1079-1097`).

**Naprawa:** `ChatSearchText.Highlight` buduje wynik z budżetem długości po escape, nie rozcina par surogatów i w razie dopasowania, którego nie da się zmieścić ze znacznikami, zwraca ograniczony fragment literalny. Testy ukośników, delimiterów, długiego dopasowania i granicy emoji przechodzą w ramach **17/17 PASS**.

### P2 — `ChatInvitationStatus` nie miał testu wire — ZNALEZISKO ODRZUCONE PO WERYFIKACJI TRAS

Pierwotna klasyfikacja była błędna: `ChatInviteResponse`/`ChatInvitationStatus` nie jest zwracany przez żaden endpoint HTTP; używa go wyłącznie wewnętrzna warstwa aplikacji. Nie powinien być testowany jako enum wire ani dodawany do OpenAPI. Usunąłem nieużywany model/status Fluttera, a pełny audyt enumów pozostających w kontrakcie Front/Backend pozostaje objęty istniejącymi testami.

**Naprawa:** dodać pełny zestaw wartości do testu OpenAPI Backend oraz round-trip decode/encode DTO zaproszenia we Flutterze. W raporcie klasyfikacja: `ChatConversationType`, `ChatScopeKind`, `ChatNotificationPreference`, `ChatMessageDeliveryStatus`, `ChatInvitationStatus` — transportowe; `ChatInboxFilter` — lokalny UI; `ChatMemberRole` — lokalny typ mapujący tekstową właściwość `role`.

### P2 — klient Retrofit Chat przekraczał limit wielkości klasy — NAPRAWIONE

`ChatApi` ma 506 linii (`Front/lib/workspaces/data/chat/api/chat_api.dart`), mimo limitu 400 linii dla pojedynczej klasy produkcyjnej w Front `AGENTS.md`. Model transportowy Chat ma 1026 linii (`Front/lib/workspaces/data/chat/models/chat_models.dart`) i utrudnia lokalną kontrolę zmian kontraktu.

**Naprawa:** endpointy skrzynki/read ACK, wyszukiwania, katalogu, obecności, ustawień powiadomień oraz treści/linków przeniesiono do wyspecjalizowanych klientów Retrofit. Runtime tworzy je na tym samym uwierzytelnionym transporcie; repozytoria zależą od właściwego klienta. `ChatApi` ma teraz **386 linii**. Implementacje `.g.dart` utworzył build_runner. Duży plik DTO (`chat_models.dart`, 1008 linii) pozostał do osobnego, bezpiecznego podziału według podfeature'ów.

### P2 — `ChatService` łączy zbyt wiele przypadków użycia — OTWARTE

Backendowy `ChatService` przekracza 1800 linii i obsługuje m.in. rozmowy, członkostwo, wiadomości, historię, statusy odczytu, wzmianki i załączniki. To god service sprzeczny z zasadą jednej odpowiedzialności z Backend `AGENTS.md`, utrudniający testy i zmianę kontraktów bez efektów ubocznych.

**Dalsza praca:** wydzielić wysyłkę/historię, lifecycle członków, read/delivery cursors i wzmianki do małych serwisów aplikacyjnych. Nie robiłem mechanicznego podziału tej klasy w tym pakiecie: wymaga przeniesienia odpowiedzialności, rejestracji DI i testów integracyjnych, a pozostałe poprawki nie wymagają zmiany zachowania tych ścieżek. To nadal realny dług architektoniczny do osobnego pakietu.

## Zweryfikowane obszary bez znalezionej usterki statycznej

- Odczyt w Front jest wysyłany po potwierdzeniu widoczności najnowszej wiadomości; `ChatConversationMessageMerger` porządkuje historię tym samym kluczem czasu i UUID, a backend aktualizuje kursor monotonicznie.
- Backend dodaje `ReplyPreview` do historii, sprawdza jego przynależność do tej samej rozmowy i nie ujawnia tekstu usuniętej wiadomości. Front mapuje cytat i czyści go po zdarzeniu usunięcia.
- Testowane wartości `ChatConversationType`, `ChatScopeKind`, `ChatNotificationPreference` i `ChatMessageDeliveryStatus` zgadzają się między OpenAPI Backend i mapami Fluttera. `ChatInvitationStatus` jest wewnętrzny, a nie transportowy.
- Przepływ długiego wklejenia zachowuje oryginalny tekst przy błędzie/pustym/skróconym wyniku przygotowania; wybrany upload przechodzi przez kolejkę załączników.
- Bieżący kod bloków kodu, załączników prywatnych, podglądu miniatur i statusów ma testy jednostkowe; przegląd statyczny nie wykazał kolejnej jednoznacznej usterki w tych ścieżkach.

## Weryfikacja

- `flutter analyze`: PASS, 0 problemów po podziale klientów. `git diff --check` nadal wskazuje spacje na pustych wierszach w wygenerowanych plikach Freezed; pozostawiłem je zgodne z wynikiem generatora.
- Wybrany pakiet testów Front po podziale API, w tym enum wire: **37/37 PASS**.
- Wybrany pakiet testów Backend obejmujący wyścig PostgreSQL, snippet i OpenAPI: **17/17 PASS**.
- Testów widgetowych/goldenów nie uruchamiano zgodnie z ustaleniem, że będą uruchamiane po akceptacji UI.
- Nie uruchamiano aplikacji do wizualnego odbioru. Raport nie potwierdza wyglądu ani działania na żywym stagingu.

## Kolejność napraw

1. W osobnym pakiecie rozbić DTO `chat_models.dart` oraz wydzielić przypadki użycia z `ChatService`.
2. Po akceptacji UI uruchomić jeden zebrany pakiet testów widgetowych i wykonać odbiór widoków Chat; testy runtime pozostają osobną bramką.
