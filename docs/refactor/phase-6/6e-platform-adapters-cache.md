# 6E — standalone platform adapters and cache

**Status:** COMPLETE for the typed frontend transport boundary — macOS native
end-to-end is blocked by URL launcher delivery; manual native verification
remains downstream work.

## Zakres wykonany

- Dodano `WebBffAuthAdapter` oraz `WebBffSessionTransport`. Adapter zna
  wyłącznie typed session operations; nie przechowuje ani nie zwraca tokenów.
  `UnavailableWebBffSessionTransport` jest fail-closed i nie zgaduje ścieżek
  HTTP przed opublikowaniem kontraktu backendu.
- Dodano `DesktopPkceAuthAdapter` oraz `DesktopPkceSessionTransport`. Adapter
  deleguje Authorization Code + PKCE do hosta transportowego, zapisuje jedyny
  refresh credential wyłącznie przez `SecureRefreshTokenVault`, odtwarza sesję
  przez transport i zawsze usuwa lokalny credential przy wylogowaniu. Nie
  implementuje własnego OAuth ani nie udostępnia access tokenu UI.
- Typed transport używa publicznego klienta `devplanner-desktop`, systemowego
  browsera, wymaganego PKCE `S256`, losowego loopback portu `49152..65535` oraz
  posiada `state`, `nonce` i `code_verifier`. Access token pozostaje w pamięci,
  refresh token w OS vault, a rotacja zastępuje wpis w vault. Odczyt użytkownika
  korzysta z `GET /api/v1/me/`, revoke z `POST /connect/revocation`; vault jest
  czyszczony także po błędzie zdalnego revoke. Launcher paths obejmują
  Windows/macOS/Linux.
- Dodano `PlatformSecureRefreshTokenVault` z natywną implementacją
  `flutter_secure_storage` dla `dart.library.io`. Gałąź Web/non-IO korzysta z
  jawnego stubu rzucającego `UnsupportedError`; nie instancjuje pluginu i nie
  ma fallbacku do Hive, localStorage, IndexedDB ani pliku.
- Dodano wersjonowany `HiveDevPlannerCacheStore` z wyłącznym boxem
  `devplanner_cache_v1`. Klucze są namespacowane przez lokalny `userId`, zakres
  i wpis; cache nie czyta ani nie migruje żadnego cache Ready/Core/DataBus.
  Payload jest JSON-safe, a pola wyglądające jak token, sekret lub hasło są
  odrzucane. Uszkodzony/stary wpis jest usuwany i traktowany jako cache miss.
- Eksporty adapterów i cache są dostępne przez odpowiednio `auth_data.dart` i
  `foundation.dart`; warstwa presentation nie importuje secure storage ani
  platformowych API.

## Pliki

- `lib/auth/data/adapters/web_bff_auth_adapter.dart`
- `lib/auth/data/adapters/desktop_pkce_auth_adapter.dart`
- `lib/auth/data/adapters/secure_refresh_token_vault.dart`
- `lib/auth/data/adapters/platform_secure_secret_store_io.dart`
- `lib/auth/data/adapters/platform_secure_secret_store_stub.dart`
- `lib/foundation/cache/devplanner_cache.dart`
- `test/auth/auth_platform_adapters_test.dart`
- `test/foundation/cache/devplanner_cache_test.dart`

## Walidacja

- `flutter test test/auth/auth_platform_adapters_test.dart test/foundation/cache/devplanner_cache_test.dart` — PASS, 11 tests.
- Final targeted Desktop PKCE suite — PASS, 13/13.
- `flutter analyze` — PASS, `No issues found!`.
- `git diff --check` — PASS.

## Ograniczenia i następny krok

- Nie podłączono wymyślonych endpointów; transport korzysta z rzeczywistych
  kontraktów `GET /api/v1/me/` i `POST /connect/revocation`.
- Testy używają wstrzykiwanych fake portów i nie są dowodem ręcznego działania
  Credential Manager/Keychain/libsecret na konkretnym hoście. Native
  login/callback/refresh/logout na Windows/macOS/Linux pozostaje do ręcznej
  weryfikacji; real browser E2E jest celowo odroczone.
- macOS smoke potwierdził trusted development certificate, backend discovery,
  native CTA i loopback listener, ale `/connect/authorize` nie został
  dostarczony do browsera ani przez `Process.open`, ani przez `url_launcher`,
  mimo raportowanego sukcesu launchera. Nie zweryfikowano callbacku, sesji,
  `me`, refresh ani revocation; disposable runtime i baza zostały wyczyszczone.
  Desktop end-to-end pozostaje zablokowane tą konkretną usterką i nie jest
  ukończone. Browser E2E pozostaje odroczone zgodnie z decyzją użytkownika.
- `AuthComposition` nadal pozostaje niedostępna do czasu spięcia kompletnego
  `AuthGateway` z backendem. Ten pakiet nie zmieniał routera ani wspólnych
  planów/handoffów.
