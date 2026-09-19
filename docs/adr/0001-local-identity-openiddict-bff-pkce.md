# ADR-0001: lokalna tożsamość, OpenIddict, BFF i PKCE

- **Status:** ACCEPTED / COMPLETED
- **Data:** 2026-09-16
- **Zakres:** DevPlanner Backend i kontrakt bezpieczeństwa z aplikacją Flutter
- **Pakiet planu:** Faza 0C (dokument, bez zmiany runtime)
- **Właściciel decyzji:** zespół DevPlanner

## 1. Kontekst i problem

DevPlanner jest samodzielnym produktem. Tożsamość nie może zależeć od Ready,
Core ani od ich sieci, katalogu, sesji, JWKS lub identyfikatorów. Potrzebujemy
jednego modelu konta i protokołu, który obsłuży równocześnie przeglądarkę webową
oraz aplikacje desktopowe Windows/macOS/Linux, a także administrację,
aktywację, recovery, MFA, sesje urządzeń i unieważnianie dostępu.

Dokument jest decyzją architektoniczną i threat modelem dla kolejnych pakietów.
Nie implementuje endpointów ani migracji. Wiążące szczegóły transportu muszą być
odzwierciedlone w OpenAPI i testach protokołu.

### Cele

- lokalny, stabilny `UserId` typu UUID jako jedyny identyfikator osoby;
- konta tworzone wyłącznie przez administratora, bez publicznej rejestracji;
- bezpieczny lifecycle: activation, email verification, login, password change,
  forgot/reset password, MFA i device sessions;
- standardowy OIDC/OAuth 2.0 dla desktopu oraz BFF dla webu;
- krótko żyjący access token, rotowany refresh token i wykrywanie reuse;
- egzekwowanie ról, permissions i ACL po stronie backendu oraz pełny audit;
- możliwość odtworzenia dowodów bezpieczeństwa z testów i artefaktów operacyjnych.

### Poza zakresem tej decyzji

Publiczna rejestracja, social login, konta gościnne, federacja Ready/Core,
migracja starych hashy haseł, passkeys/WebAuthn, SAML/Entra/Google, mobile oraz
multi-tenant IAM są odłożone. Nie wolno ich wprowadzać jako ukrytych wyjątków
w implementacji tej fazy.

## 2. Decyzja

### 2.1 Źródło tożsamości i identyfikator

ASP.NET Core Identity jest lokalnym magazynem użytkowników i lifecycle kont,
a OpenIddict jest jedynym lokalnym serwerem OIDC/OAuth 2.0 dla klientów
DevPlanner. Kanoniczny `UserId` jest UUID (`Guid` w C#); wartość claimu OIDC
`sub` jest tekstową reprezentacją tego samego UUID. Domena, API, eventy,
audyt i klient używają nazw `UserId`, `ActorUserId`, `OwnerUserId` itd.

Następujące rozwiązania są **zakazane**:

- `ReadyId`, `ReadyUserId`, `CoreUserId` i ich odpowiedniki jako runtime
  identyfikatory, claims, kontrakty lub klucze ACL;
- zależność od katalogu, sesji, tokenów, JWKS albo provisioning-u Ready/Core;
- własny issuer JWT, własny generator/walidator JWT lub własny protokół tokenowy.

JWT może być formatem access tokenu wystawionego i zweryfikowanego przez
OpenIddict; format nie jest osobnym systemem logowania. Nie implementujemy
własnej kryptografii. OpenIddict i ASP.NET Core Identity pozostają źródłem
implementacji standardów oraz ich bezpiecznych domyślnych mechanizmów
([OpenIddict documentation](https://documentation.openiddict.com/),
[ASP.NET Core Identity authentication](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/identity-api-authorization)).

### 2.2 Konto, activation i email

- Nie istnieje endpoint `register`. Administrator z odpowiednim permission
  tworzy konto, a użytkownik nie może utworzyć konta ani nadać sobie roli.
- Konto wymaga unikalnego loginu, unikalnego adresu e-mail oraz hasła. Login i
  e-mail są normalizowane i porównywane bez uwzględniania wielkości liter.
- Nowe konto ma status `PendingActivation`. System wysyła jednorazowy,
  krótko ważny link HTTPS do ustawienia pierwszego hasła i potwierdzenia adresu.
  API nigdy nie zwraca ani nie loguje tymczasowego hasła.
- Konto staje się `Active` dopiero po spełnieniu wymaganych kroków. Konta
  `PendingActivation`, `Locked` i `Deactivated` nie mogą uzyskać sesji.
- Zmiana adresu e-mail wymaga ponownej weryfikacji, zachowania unikalności i
  wpisu w audycie. Linki używają wyłącznie allowlistowanego originu HTTPS.

### 2.3 Hasło, login i recovery

Polityka startowa: minimum 15 znaków, maksimum co najmniej 128 znaków,
pełne passphrase dozwolone, bez sztucznego wymogu klas znaków i bez okresowej
zmiany poza incydentem lub decyzją administratora. Hasło jest sprawdzane wobec
listy popularnych/ujawnionych haseł. Ta polityka i dobór kosztu hashera muszą
być potwierdzone testem i benchmarkiem przed produkcją; uzasadnienie opiera się
na [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
oraz [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html).

Preferowany jest Argon2id z wersjonowanym formatem hasha i rehashem po udanym
logowaniu. Użyta biblioteka musi być utrzymywana i zweryfikowana; nie wolno
implementować Argon2 samodzielnie. Jeżeli wdrożenie pozostanie przy hasherze
PBKDF2 dostarczonym przez Identity, iteracje, benchmark, wersja formatu i plan
podnoszenia kosztu muszą zostać jawnie zapisane przed implementacją Fazy 1A.

`forgot-password` nie ujawnia istnienia konta: zawsze zwraca ten sam status,
neutralny komunikat i porównywalny czas odpowiedzi. Token resetu jest losowy,
jednorazowy, związany z użytkownikiem i `SecurityVersion`, krótko ważny (domyślnie
30 minut do potwierdzenia w implementacji), a w bazie przechowywany wyłącznie
jako hash. Udany reset zużywa wszystkie tokeny resetu, zwiększa
`SecurityVersion`, unieważnia wszystkie sesje i wysyła neutralne powiadomienie.
Zasady wynikają z [OWASP Forgot Password Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html).

### 2.4 Web: BFF i cookie

Web korzysta z BFF. Przeglądarka rozpoczyna flow OIDC, a BFF wymienia code i
przechowuje tokeny po stronie serwera. Do przeglądarki trafia tylko sesyjny
cookie `Secure`, `HttpOnly`, `SameSite=Lax` (lub `Strict`, jeżeli callback OIDC
na to pozwala). Access/refresh tokeny nie trafiają do JavaScript, localStorage,
IndexedDB, Hive ani innego browser storage.

Każde żądanie zmieniające stan wymaga synchronizer token albo double-submit
cookie związany z sesją oraz walidacji `Origin`/`Sec-Fetch-Site`. GET nie mutuje
stanu. BFF ma własne polityki cookie, CSRF, CORS, rate limit i logowanie; jego
granica zaufania i deploy są takie same jak chronionego frontendu.

### 2.5 Desktop: system browser i PKCE

Windows/macOS/Linux używają systemowej przeglądarki oraz Authorization Code +
PKCE (`S256`). Embedded WebView do wpisywania hasła jest zabroniony. Callback
korzysta z loopback redirect z losowym portem albo zarejestrowanego custom URI
scheme; każdy flow sprawdza losowe `state`, `nonce`, ścisły redirect URI i
jednorazowy code verifier. Zasady PKCE są zgodne z [RFC 7636](https://www.rfc-editor.org/rfc/rfc7636)
i aktualnymi zaleceniami OAuth dla natywnych aplikacji [RFC 8252](https://www.rfc-editor.org/rfc/rfc8252).

Access token jest krótko ważny (docelowo 5–10 minut, po potwierdzeniu profilu
ryzyka) i istnieje wyłącznie w pamięci procesu. Refresh token jest przechowywany
wyłącznie w systemowym secure storage: Windows Credential Manager/DPAPI,
macOS Keychain albo Linux Secret Service/libsecret. Brak dostępnego secure
storage oznacza brak trwałej sesji i ponowne logowanie.

### 2.6 Tokeny, refresh families i device sessions

- Access token zawiera minimalne claims: `iss`, `aud`, `sub`, `exp`, `iat`,
  `jti` oraz niezbędne scopes/security version; nie zawiera e-maila, PII ani
  rozbudowanej listy ACL.
- Refresh token jest opaque. W bazie zapisujemy tylko hash/HMAC, nigdy wartość
  okaziciela. Każde użycie wydaje nowy token.
- Rodzina ma `FamilyId`, poprzednika i następcę. Ponowne użycie zużytego tokenu
  jest reuse detection i unieważnia całą rodzinę oraz sesję urządzenia.
- Każde logowanie tworzy `DeviceSession`. Wylogowanie unieważnia sesję bieżącą,
  a logout-all, blokada/dezaktywacja, reset hasła lub krytyczna zmiana roli
  unieważniają wszystkie sesje.
- Refresh sprawdza status konta, `SecurityVersion`, expiry i revocation w
  źródle serwerowym. Operacje wysokiego ryzyka wymagają świeżego uwierzytelnienia
  (`auth_time`) i MFA.
- Klucze podpisujące są asymetryczne, mają `kid`, nakładające się okresy
  rotacji i trwały szyfrowany magazyn poza repozytorium. OpenIddict publikuje
  standardowy JWKS. SignalR używa tego samego access tokenu, odrzuca sesje
  wygasłe/revoked przy reconnect, a token w query podczas handshake nigdy nie
  jest logowany.

### 2.7 MFA, role i permissions

TOTP jest obowiązkowe dla każdego administratora (`SystemAdmin`). Administrator
bez potwierdzonego MFA jest blokowany przed operacjami administracyjnymi.
Recovery codes są jednorazowe, przechowywane jako hashe i regenerowane dopiero
po świeżym uwierzytelnieniu. MFA użytkowników nie jest wymagane w tej fazie,
ale interfejs i model sesji nie mogą utrudniać późniejszego dodania.

Autoryzacja jest serwerowa: policies sprawdzają role i stabilne permissions
(np. `users.read`, `users.manage`, `audit.read`), a ACL sprawdzają członkostwo
w workspace/projekcie/zasobie. Ukrywanie przycisku w UI nie jest kontrolą.
Każde żądanie po `userId` lub `sessionId` sprawdza ownership/permission, aby
wykluczyć IDOR. `SystemAdmin` nie otrzymuje automatycznie prywatnych danych
workspace ani powiadomień.

### 2.8 Bootstrap i audit

Pierwszy administrator powstaje wyłącznie przez jednorazowe polecenie/tryb
wdrożeniowy, z sekretem spoza repozytorium. Tryb działa tylko, gdy nie ma
administratora, zapisuje audit i nie pozostawia aktywnego endpointu HTTP.

Zmiany kont, ról, statusu, sesji, resetów, MFA, logowań, lockoutów,
refresh-reuse i operacji administracyjnych są append-only audytowane. Event
zawiera aktora, sesję, cel, wynik, powód i correlation/trace ID, ale nigdy
hasło, OTP, cookie, code verifier, token, reset link ani pełny PII. Historia
biznesowa jest zachowana: deaktywacja blokuje nowe działania i sesje, lecz nie
usuwa autora ani audytu.

## 3. Kontrole przekrojowe

### Rate limiting i anti-enumeration

Login, token endpoint, refresh, MFA, activation i recovery mają limity per IP
oraz per znormalizowane konto/klient, z bezpiecznym limitem łącznym i `429` plus
`Retry-After`. Limiter nie może umożliwiać prostego DoS pojedynczego konta.
Nieudane próby zwiększają lockout zgodnie z polityką Identity; odpowiedzi dla
istniejącego i nieistniejącego loginu/e-maila są neutralne. Mail resetu jest
objęty limitem i outboxem z retry oraz ochroną przed floodem.

### Data Protection, signing keys i sekrety

Klucze ASP.NET Data Protection i klucze podpisujące OpenIddict są trwałe,
szyfrowane, rozdzielone per środowisko, poza repozytorium i obrazem, z ACL,
backupem, ownerem oraz runbookiem rotacji/kompromitacji. Sekrety providera
e-mail, bazy, Redis i klientów są dostarczane przez secret manager/env poza
repo. Rotacja zachowuje nakładanie kluczy potrzebne do bezpiecznej walidacji.

### CORS, CSP i transport

CORS dopuszcza tylko jawnie skonfigurowane originy; nie używamy wildcardu z
credentials. Mutacje BFF przechodzą CSRF i walidację originu. Produkcyjny ruch
OIDC/API/BFF wymaga HTTPS. Web dostarcza CSP z nonce/hash dla skryptów,
blokadą mixed content i minimalnymi `connect-src`; polityka jest testowana po
wdrożeniu na każdej domenie.

### Logging, PII i operacje

Logi są strukturalne, korelowane przez `traceId`, z redakcją sekretów i PII.
Dozwolone dane diagnostyczne (np. wynik, typ klienta, zanonimizowany hash IP)
mają określoną retencję i dostęp. Metryki nie zawierają loginów/e-maili.
Monitoring obejmuje success/failure loginu, lockout, recovery, MFA failure,
refresh reuse, revoke latency, 401/403/429, zero-reference scan i reconnect
SignalR. Audyt ma osobną retencję, permission i eksport do odpornego na
modyfikację storage/SIEM.

## 4. Kontrakt odpowiedzialności BE/FE

| Obszar | Backend (BE) | Flutter (FE) |
|---|---|---|
| Identity | Identity, lokalny UUID `UserId`, status, normalizacja, password policy, activation/email verification | Pokazuje stan i formularze zgodnie z OpenAPI; nie tworzy konta i nie ufa UI jako kontroli |
| OIDC | OpenIddict discovery/authorize/token/revoke, clients, scopes, signing keys, validation | Web uruchamia BFF; desktop uruchamia system-browser Code+PKCE i waliduje callback przez adapter |
| Web session | BFF przechowuje tokeny i wystawia Secure/HttpOnly cookie oraz CSRF | Nie czyta tokenów; nie używa localStorage/IndexedDB/Hive do sesji |
| Desktop session | Krótkie access tokeny, refresh rotation, reuse detection, device session i revoke | Access token tylko RAM; refresh wyłącznie OS secure vault; brak vaultu = login ponownie |
| Auth lifecycle | Login/logout/refresh/recovery/MFA, neutralne błędy i rate limits | Jeden transport na sesję, serializowany refresh po 401, brak pętli retry; logout czyści cache i realtime |
| Authorization | Policies, permissions, ACL, ownership i ochrona IDOR na każdym endpoint/hub | Renderuje akcje według permissions, ale każdą odpowiedź BE traktuje jako źródło prawdy |
| Audit/telemetry | Append-only audit, redakcja, trace ID, alerty i retencja | Nie loguje sekretów; przekazuje correlation ID i bezpiecznie mapuje `code/message/fields/traceId` |
| Platform | Kontrakt callbacków, redirect URI i CORS/CSP; brak haseł w aplikacji | System browser i adaptery Windows/macOS/Linux; embedded WebView do hasła zakazany |

Wspólnym źródłem kontraktu jest OpenAPI. Błędy mają `code`, `message`,
opcjonalne `fields` i `traceId`; brak konta, nieważny reset i brak uprawnień
nie ujawniają dodatkowych danych. FE nie zgaduje ścieżek, claims, enumów ani
statusów.

## 5. Threat model i dowody

| Wektor zagrożenia | Kontrola | Test / evidence wymagane |
|---|---|---|
| Credential stuffing i brute force | Mocne hasła, lista haseł ujawnionych, lockout i limity per IP+konto+klient | Test integracyjny poprawnych/błędnych loginów, 429/`Retry-After`, metryka lockout bez ujawniania konta |
| Enumeracja loginu/e-maila | Neutralne body/status i porównywalny czas dla loginu, activation i recovery | Test porównawczy konta istniejącego/nieistniejącego; przegląd odpowiedzi i logów |
| CSRF sesji web | Secure/HttpOnly/SameSite cookie, synchronizer/double-submit token, Origin/Sec-Fetch-Site, brak mutacji GET | Test każdej mutacji z brakującym/złym CSRF i Origin; test cookie attributes |
| XSS i kradzież tokenu web | Tokeny tylko w BFF, CSP, brak tokenów w JS/browser storage | E2E próbuje odczytu cookie/storage; nagłówki CSP i skan artefaktu |
| Przechwycenie code desktop | System browser, Authorization Code + PKCE S256, state, nonce, exact redirect URI | Test złego/missing verifier, state, nonce, redirect i replay code |
| Kradzież/replay refresh tokenu | Opaque token, hash w DB, rotacja per użycie, FamilyId i unieważnienie rodziny po reuse | Test równoległego refresh, zużytego tokenu i revoke całej rodziny; audit `refresh_reuse` |
| Session fixation/hijack | Nowa DeviceSession po logowaniu, security version, logout current/all, reauth dla ryzyka | Test rotacji sesji, unieważnienia po resecie/zmianie roli i reconnect SignalR |
| Reset hasła przez napastnika | Losowy jednorazowy token, hash, TTL, wersja bezpieczeństwa, neutralny e-mail, revoke sesji | Test użycia drugi raz, expiry, resetu innego usera i neutralności timing/status |
| Ominięcie lub replay MFA | TOTP wymagane dla admina, confirm enrollment, recovery codes single-use, reauth | Test admina bez MFA, złego/replayed TOTP, zużytego recovery code i krytycznej operacji |
| Privilege escalation / IDOR | Policies+permissions+ACL po stronie BE, ownership dla każdego `userId/sessionId`, audit admina | Macierz anonymous/User/SystemAdmin/członek/obcy; test odczytu i mutacji cudzego zasobu |
| Dezaktywowane konto używa starej sesji | Status i security version sprawdzane przy refresh, revoke wszystkich sesji, odmowa SignalR reconnect | Test deactivation/lockout/reset i access/refresh/hub po zdarzeniu |
| Fałszowanie tokenów po kompromitacji klucza | Asymetryczne klucze poza repo, `kid`, JWKS, rotacja z overlapem, incident runbook | Test key rotation/JWKS; artefakt backup/restore i ćwiczenie global revoke |
| Wyciek sekretów i PII | Secret manager, redakcja, minimalne claims, brak tokenów/reset links/OTP w logach | Secret scan, test loggera z markerami, review retention i przykładowych eventów |
| Nadużycie CORS/CSP / originu | Allowlista originów, brak wildcard credentials, HTTPS, CSP nonce/hash | Test niedozwolonego originu/preflight i walidacja nagłówków po deployu |
| DoS auth, e-maila lub SignalR | Rate limits, limity payloadu/connection, outbox retry cap, backpressure, 429 | Load/abuse test mail flood, duże payloady, connection flood i stabilność limitera |
| Open redirect/phishing linkiem | HTTPS allowlist originów, exact redirect URI, brak dowolnego `returnUrl` | Test niezatwierdzonego redirect/return URL i przegląd konfiguracji deploymentu |

Dowód jest ważny dopiero po faktycznym uruchomieniu testu lub kontroli
operacyjnej. Samo istnienie konfiguracji nie oznacza spełnienia kontroli.

## 6. Kryteria wejścia/wyjścia kolejnych pakietów

### Faza 1A — model i migracje Identity

Przed startem: zaakceptowany ten ADR, zatwierdzone środowisko PostgreSQL,
zewnętrzny secret store, plan świeżego schematu oraz manifest usunięcia
baseline referencji z blokadą DNS/egress, endpointów i sekretów Ready/Core/DataBus.
Baseline może zawierać opisane dormant referencje, ale nie może wykonać połączenia.
Wyjście musi obejmować:

- model `User` z UUID, unikalnością loginu/e-maila, statusami, security version,
  audit i FK bez cascade usuwającego historię;
- role/permissions (`SystemAdmin`, `User`) oraz testy policies i braku
  self-registration/privilege escalation;
- hasher i password policy z wersją, benchmarkiem oraz testem rehashu;
- jednorazowy bootstrap admina poza HTTP, z audit i bez sekretu w repo;
- świeży schemat po kontrolowanym reset/reprovision oraz rollback/restore drill,
  bez edycji migracji historycznych; `git diff --check`, build i testy migracji
  są dowodem.
- startup, DI i konfiguracja nie rejestrują zewnętrznego auth/directory/JWKS/
  DataBus; świeży reset/migracja/seed/restore oraz negative network test są
  wykonane i potwierdzają izolację uruchomionego runtime (fake loopback otrzymał
  0 bajtów). Aktywne rejestracje runtime/config oraz uruchamiane przez startup
  fixtures/artefakty muszą być zero. Dormant klasy, statyczne referencje i
  fixtures nieładowane przez startup przechodzą do 1C/5/7; nie blokują EXIT 1A,
  ale nie mogą być rejestrowane ani wykonywać połączeń. Finalne 7A/7D nadal
  wymagają zero-reference w pełnym zakresie. Dokumenty planistyczne/ADR/
  manifesty/handoffy oznaczone jako historyczne oraz niezmieniana historia
  migracji EF są wyjątkami i nie są ładowane do runtime.

Zakres 1A nie może wystawiać tokenów produkcyjnych ani usuwać legacy pól.

### Faza 2 — issuer, klienci i lifecycle sesji

Wejście: aktywne lokalne konto/admin z Fazy 1, dostępny secret store oraz
provider e-mail dla testów activation/recovery. Wyjście:

- discovery/JWKS, registered clients i Authorization Code + PKCE S256;
- BFF cookie+CSRF oraz desktop system-browser callback na każdej wspieranej
  platformie; brak tokenów web w JS/storage;
- access RAM, refresh vault, rotacja/reuse detection, DeviceSession, logout,
  revoke i security-version checks;
- obowiązkowe TOTP dla administratora i reauth dla operacji wysokiego ryzyka;
- protocol/security suite obejmujący zły state/nonce/verifier/redirect,
  replay, concurrent refresh, key rotation, cookies, CSRF, MFA i log redaction.

Do Fazy 3 nie przechodzimy, jeśli choć jeden z tych przypadków nie ma zielonego
testu lub jawnie zarejestrowanego wyjątku właściciela bezpieczeństwa.

## 7. Rollback, operacje i decyzje odroczone

ADR nie zmienia runtime, więc rollbackem dokumentu jest jego wycofanie przed
implementacją. W kolejnych fazach lokalny issuer i BFF wdraża się wyłącznie
standalone; nie ma fallbacku do Ready/Core/DataBus, importu, mapowania ani
backfillu. Rollback dotyczy świeżego schematu i backup restore drill, nie danych
produkcyjnych.

Odroczone decyzje i kryteria powrotu do ADR:

- dokładny koszt Argon2id/PBKDF2 — po benchmarku na produkcyjnym profilu;
- 5 czy 10 minut access tokenu oraz TTL resetu — po risk review, telemetry i
  threat validation, bez osłabienia jednorazowości/neutralności;
- osobny host BFF versus ten sam proces — po deploy boundary, CORS/CSRF i
  failure-mode review;
- MFA wszystkich użytkowników, passkeys/WebAuthn i zewnętrzne SSO — osobny ADR
  z modelem recovery, UX, threatami i testami;
- multi-tenant IAM i zakres introspection — dopiero po zaakceptowaniu granic
  tenant/ACL; introspection nie jest domyślnie publiczna.

## 8. Źródła normatywne

- [OpenIddict — official documentation](https://documentation.openiddict.com/)
- [Microsoft Learn — ASP.NET Core Identity API authorization](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/identity-api-authorization)
- [Microsoft Learn — MFA in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/mfa)
- [RFC 7636 — Proof Key for Code Exchange](https://www.rfc-editor.org/rfc/rfc7636)
- [RFC 8252 — OAuth 2.0 for Native Apps](https://www.rfc-editor.org/rfc/rfc8252)
- [RFC 9700 — OAuth 2.0 Security Best Current Practice](https://www.rfc-editor.org/rfc/rfc9700)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
- [OWASP Forgot Password Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Forgot_Password_Cheat_Sheet.html)
- [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
- [OWASP Cross-Site Request Forgery Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
- [OWASP Content Security Policy Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
- [OWASP Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)
