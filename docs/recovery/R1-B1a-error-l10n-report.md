# R1/B1a — foundation surface `error` i `l10n`

Data: 2026-09-17. Repozytorium: `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`.
Status: **PASS dla aktywnego standalone podzbioru; pozostały graf legacy
Workspaces jest jawnie odroczony**.

## Zakres i granice

Pakiet obejmował wyłącznie `lib/core/error`, `lib/core/l10n`, ich bezpośrednie
importery w aktywnym standalone kodzie oraz odpowiadające testy. Nie wykonywano
fizycznych przenosin plików. Nie dotykano auth, theme, transportu,
root/router/runtime, Chat, Notifications ani realtime.

`lib/core/error/api_error.dart` i `lib/core/l10n/l10n_extensions.dart` już
korzystały z realnych ścieżek `package:devplanner` i nie zawierały importu
`ready_next`. Istniejące pliki:

- `lib/foundation/error/error.dart` — typowany re-export `ApiError`;
- `lib/foundation/l10n/l10n.dart` — typowany re-export rozszerzeń l10n.

Były więc rzeczywistymi, zgodnymi powierzchniami foundation. Nie tworzono
aliasów, funkcji globalnych ani nowych typów.

## Zmiany

Skierowano importy na foundation w 12 deklaracjach:

### Error — 7 deklaracji

- `lib/admin/data/adapters/admin_user_gateway_api_adapter.dart`
- `lib/admin/domain/ports/admin_user_gateway.dart`
- `test/admin/admin_user_gateway_api_adapter_test.dart`
- `test/admin/admin_users_test.dart`
- `test/app/devplanner_app_test.dart`
- `test/app/router/devplanner_notifications_router_test.dart`
- `test/core/error/api_error_test.dart`

Docelowa ścieżka: `package:devplanner/foundation/error/error.dart`.

### Lokalizacja — 5 deklaracji

- `lib/admin/presentation/admin_user_form_dialog.dart`
- `lib/admin/presentation/admin_user_roles_dialog.dart`
- `lib/admin/presentation/admin_users_list_view.dart`
- `lib/admin/presentation/admin_users_page.dart`
- `lib/me/presentation/user_profile_page.dart`

Docelowa ścieżka: `package:devplanner/foundation/l10n/l10n.dart`.

Każdy zmieniony plik pozostaje w odpowiedzialnej gałęzi, nie importuje Dio,
transportu ani storage z presentation i zachowuje dokumentację istniejącego
kodu. `dart format` nie wykazał problemów; uporządkowano również dyrektywy
importów zgłoszone przez analyzer.

## Liczniki przed/po

W punkcie wejściowym tego pakietu aktywny standalone podzbiór miał 10
bezpośrednich deklaracji `package:devplanner/core/error/api_error.dart` oraz 7
bezpośrednich deklaracji `package:devplanner/core/l10n/l10n_extensions.dart`.
Po zmianie:

- aktywne importery error skierowane do foundation: **7**; bezpośrednie
  importery `devplanner/core/error` w tym podzbiorze: **0**;
- aktywne importery l10n skierowane do foundation: **5**; pozostał tylko
  nienaruszony importer auth oraz celowy re-export foundation.

Aktualny pełny skan worktree po pakiecie wykazał **199** deklaracji
`package:ready_next/core/error/api_error.dart` i **123** deklaracje
`package:ready_next/core/l10n/l10n_extensions.dart`, skoncentrowane w starym
drzewie Workspaces. Te liczby są stanem po pomiarze, nie dowodem regresji B1a;
manifest R01 nie miał osobnej tabeli dla tych dwóch ścieżek.

## Niezgodności odroczone

Nie zmieniono `lib/core/data/api_repository.dart` ani
`lib/features/settings/application/current_user_avatar_cubit.dart`. Ich
bezpośrednie repozytoria Storage i potomne implementacje nadal publikują typy
z `package:ready_next`, więc podmiana samego importu `ApiError` powoduje błędy
typów `Either`, m.in. `Object?` zamiast `ApiError` i niedostępne pola modeli.
To jest niezgodność kontraktu, a nie problem do obejścia aliasem. Te pliki
czekają na osobny batch migracji Storage/data.

Nie zmieniono 199 importerów error i 123 importerów l10n w Workspaces, w tym
Chat, Notifications i realtime. Ich migracja musi iść razem z konkretnym
pionem modeli, portów i mapperów, nie jako globalna zamiana tekstu.

## Walidacja

Wykonano faktycznie:

```text
flutter analyze [7 aktywnych plików admin/me]
=> PASS — No issues found!

flutter test test/core/error/api_error_test.dart \
  test/admin/admin_user_gateway_api_adapter_test.dart \
  test/admin/admin_users_test.dart
=> PASS — 15/15

dart format --output=none [10 zmienionych źródeł/testów]
=> exit 0

git diff --check
=> exit 0
```

Pełny `flutter analyze` repozytorium nie był bramką tego pakietu; pozostałe
importy Workspaces i brakujące root entry points są osobnymi, wcześniej
udokumentowanymi blokadami.

## Następny krok

Kolejny agent powinien wybrać jeden pion danych, najpierw jego modele i porty,
następnie implementacje/repozytoria, a dopiero potem mapowanie `ApiError` i
generator. Nie zmieniać jeszcze Chat/Notifications/realtime równolegle z innym
pionem. Po usunięciu kontraktowej zależności Storage od `ready_next` można
powtórzyć odroczone dwa pliki i dopiero wtedy usunąć ich legacy importy.
