# R4a — Chat error boundary

Data: 2026-09-17  
Repozytorium: `Front`  
Zakres: wyłącznie bazowy Chat repository/error boundary.

## Problem

Pierwsza wersja R4a przekazywała z warstwy data do `ApiError` polskie teksty
fallback/parsing. Było to niezgodne z zasadą, że data/domain nie zawierają
komunikatów dla użytkownika, a lokalizacja należy do presentation/ARB.

## Zmiana

Dodano `ChatApiErrorMapper` z typowanym `ChatApiErrorCode`. Repozytorium używa
wyłącznie kodów maszynowych:

- `chat.conversations.load_failed`,
- `chat.messages.load_failed`,
- `chat.messages.send_failed`,
- `chat.response.invalid`.

`ApiError.apiCode` i `ApiError.type/status/backendCode` są zachowane. Pole
`message` zawiera teraz ten sam kod techniczny, nie tekst do wyświetlenia.
Przyszła warstwa presentation może mapować `apiCode` przez ARB; w tym pakiecie
nie dodawano UI ani routingu.

## Zmienione pliki

- `lib/workspaces/data/chat/errors/chat_api_error_mapper.dart` — enum kodów i
  mapper Dio/parsing.
- `lib/workspaces/data/chat/repositories/chat_repository_impl.dart` — brak
  hardcoded user-facing fallbacków; repozytorium przekazuje kody do mappera.
- `test/workspaces/data/chat/chat_api_error_mapper_test.dart` — test mapowania
  transport/parsing i granicy l10n.

## Walidacja

- `flutter test test/workspaces/data/chat/chat_api_error_mapper_test.dart test/workspaces/data/chat/global_chat_contract_test.dart` — PASS, 4/4.
- scoped `flutter analyze` mappera, repozytorium i testu — PASS, 0 issues.
- `dart format --output=none` — PASS.
- `git diff --check` — PASS.

## Następny krok

Po stabilizacji roota dodać prezentacyjny mapper `ApiError.apiCode` → klucze
ARB. Nie przywracać tekstów użytkownika do data/domain ani nie mapować błędów
na podstawie zgadywanego statusu poza istniejącym `ApiErrorType`.
