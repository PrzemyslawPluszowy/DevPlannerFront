# Veloryn Core — propozycja centralnej autoryzacji

## Cel

Utworzenie osobnego projektu **`veloryn-core`** w C# / ASP.NET Core Minimal API.
Core ma być centralnym punktem uwierzytelniania i zarządzania dostępem dla:

- Ready Next (Flutter),
- Inwentaryzacji,
- BHP,
- przyszłych modułów Veloryn.

System eDokumenty / Ready pozostaje źródłem istniejących kont użytkowników i ich haseł. Core staje się źródłem ról, uprawnień i sesji dla nowych modułów.

## Zasada tożsamości

Użytkownik loguje się dotychczasowym loginem i hasłem Ready. Core weryfikuje te dane przez adapter eDokumenty/Ready, a po sukcesie tworzy albo aktualizuje lokalny profil użytkownika.

Trwałym powiązaniem jest `public.users.usr_id` z eDokumenty (`ready_user_id`). W pierwszym etapie nie wprowadzamy zakresów per firma/spółka (`ent_id`).

Core nie przechowuje:

- haseł Ready,
- hashy haseł Ready,
- danych w `public.auth_token` Ready.

Hasła Ready występują w eDokumenty tylko jako hashe i nie można odzyskać ich wartości tekstowej.

## Docelowy przepływ

1. Ready Next wysyła dane logowania wyłącznie do Veloryn Core.
2. Core weryfikuje dane w eDokumenty / Ready.
3. Core wykonuje `upsert` własnego użytkownika po `ready_user_id`.
4. Core odczytuje prawa użytkownika z istniejącego systemu grup i uprawnień Ready, przez połączenie tylko do odczytu.
5. Core wydaje jedną własną parę tokenów dla całego ekosystemu Veloryn: token dostępu i token odświeżania.
6. Ready Next przekazuje ten sam token dostępu Core do BHP i Inwentaryzacji.
7. Każdy moduł lokalnie waliduje podpis tokenu Core i sprawdza wyłącznie uprawnienia należące do swojego modułu.

Weryfikacja tokenu przy każdym żądaniu nie wymaga wywołania Core ani eDokumenty. Backend pobiera klucz publiczny Core okresowo i trzyma go w cache, a podpis tokenu sprawdza lokalnie.

## Lokalne hasło Veloryn — opcja

Po pierwszym poprawnym zalogowaniu hasłem Ready użytkownik może ustawić dodatkowe hasło **Veloryn**. To hasło należy do Core, a nie do samego Ready Next, więc może obsługiwać również BHP i przyszłe moduły.

Core przechowuje tylko bezpieczny hash lokalnego hasła (np. Argon2id), nigdy jego tekst. Należy dodać ograniczenie prób logowania, reset hasła, audyt oraz docelowo MFA/passkey.

Jeżeli użytkownik zostanie zablokowany w Ready, Core musi blokować także logowanie lokalnym hasłem — przez synchronizację statusu lub sprawdzenie statusu w eDokumenty.

## Uprawnienia i administrator

W pierwszym etapie administracja dostępem odbywa się w istniejącym panelu Ready. Nie trzeba od razu budować panelu ról w Core. Administrator Ready nadaje użytkownikom grupy lub bezpośrednie prawa.

Core odczytuje przypisania z:

- `public.users_link_group` — użytkownik → grupa,
- `public.groups_link_right_def` — grupa → prawo,
- `public.users_access` — bezpośrednie prawo użytkownika,
- `public.right_def` — definicja prawa.

W Ready istnieją już prawa Inwentaryzacji, między innymi `bswfms.custom_modules.inwentaryzacja` oraz `bswfms.custom_modules.inwentaryzacja.usuwanie`.

Core mapuje wybrane prawa Ready na prawa Veloryn. Przykładowe uprawnienia w tokenie Core:

- `inventory.read` — odczyt inwentaryzacji,
- `inventory.write` — edycja danych inwentaryzacji,
- `inventory.full` — pełna administracja inwentaryzacją,
- `bhp.read` — odczyt BHP,
- `bhp.manage` — zarządzanie BHP.

Przykładowe role:

- `Inwentaryzacja — podgląd`,
- `Inwentaryzacja — operator`,
- `Inwentaryzacja — administrator`,
- `BHP — administrator`,
- `Administrator systemu`.

W pierwszym etapie nie ma ograniczeń per spółka. Ukrywanie pozycji menu w Flutterze jest tylko wygodą interfejsu; każde uprawnienie musi być sprawdzone przez backend modułu.

| Prawo Ready | Prawo w tokenie Core |
|---|---|
| `bswfms.custom_modules.inwentaryzacja` | `inventory.read` |
| `bswfms.custom_modules.inwentaryzacja.usuwanie` | `inventory.full` |
| `bswfms.custom_modules.bhp.view` | `bhp.read` |
| `bswfms.custom_modules.bhp.manage` | `bhp.manage` |

Nie znaleziono jeszcze zdefiniowanych praw BHP w Ready. Jeżeli panel pozwala tworzyć definicje praw, należy je dodać i przypisać do grup, np. `Veloryn — BHP — podgląd` oraz `Veloryn — BHP — administrator`. Core nie zapisuje do tabel Ready; odczytuje ich stan przy logowaniu i odświeżeniu sesji.

## Minimalny model bazy Core

- `users` — lokalny identyfikator UUID, podstawowy profil, aktywność,
- `external_identities` — dostawca `edokumenty`, `ready_user_id`,
- `modules`,
- `permissions`, `roles`, `role_permissions` i `user_role_assignments` — opcjonalne na późniejszy etap, gdy Core przejmie administrację prawami,
- `refresh_sessions` — hashe tokenów odświeżania i ich rotacja,
- `audit_log` — zmiany dostępów i zdarzenia bezpieczeństwa.

Core powinien mieć własną bazę PostgreSQL, np. `veloryn_core`. Nie należy dodawać jego tabel do schematu `edokumenty`, aby nie sprzęgać wdrożeń i aktualizacji Ready z nowymi aplikacjami.

## Jeden token dla wszystkich modułów

Core powinien działać jako standardowy dostawca OAuth2/OpenID Connect, a nie wystawiać ręcznie wymyślone tokeny.

- jeden krótki token dostępu (np. 10 minut), podpisany asymetrycznie, używany zarówno przez BHP, jak i Inwentaryzację,
- token odświeżania przechowywany i rotowany przez Core,
- walidacja podpisu, `iss`, `aud` i terminu ważności w każdym module,
- opcjonalna introspekcja lub wersja uprawnień dla operacji wymagających natychmiastowego odebrania dostępu.

Przykładowe stałe wartości techniczne tokenu:

```json
{
  "sub": "uuid-uzytkownika-core",
  "ready_user_id": 123,
  "permissions": ["inventory.read", "inventory.full", "bhp.read"],
  "iss": "veloryn-core",
  "aud": "veloryn-api",
  "exp": "..."
}
```

`iss` oznacza wystawcę tokenu, a `aud` odbiorcę. Są stałe dla całego ekosystemu i nie oznaczają osobnych tokenów dla modułów. BHP sprawdza wyłącznie prawa `bhp.*`, a Inwentaryzacja tylko `inventory.*`.

## Walidacja w backendach PHP

Każdy backend Laravel otrzymuje middleware `core.auth`.

1. Middleware odczytuje `Authorization: Bearer <token Core>`.
2. Lokalnie weryfikuje podpis tokenu kluczem publicznym Core z cache.
3. Sprawdza `iss`, `aud` oraz termin ważności.
4. Zapisuje dane użytkownika i listę uprawnień w kontekście żądania.
5. Middleware typu `permission:inventory.full` albo `permission:bhp.manage` chroni konkretny endpoint.

Nie ma wywołania do Core ani eDokumenty dla zwykłego żądania biznesowego. W okresie przejściowym BHP i Inwentaryzacja mogą akceptować równolegle stary token Ready oraz nowy token Core.

## Odświeżanie i przywracanie sesji

Token dostępu ma krótki termin ważności. Gdy wygaśnie, Ready Next wywołuje wyłącznie endpoint Core `/auth/refresh` z tokenem odświeżania.

1. Core sprawdza sesję w swojej bazie.
2. Core odczytuje bieżące prawa Ready użytkownika i mapuje je na uprawnienia Veloryn.
3. Unieważnia poprzedni token odświeżania.
4. Zwraca nowy token dostępu i nowy token odświeżania.
5. Ready Next ponawia poprzednie żądanie do BHP albo Inwentaryzacji z nowym tokenem dostępu.

Token odświeżania nigdy nie trafia do BHP ani Inwentaryzacji. Na web powinien znajdować się w ciasteczku `HttpOnly` i `Secure`; na desktop/mobile w bezpiecznym magazynie systemowym. Przy uruchomieniu aplikacji Ready Next cicho odświeża sesję, dzięki czemu użytkownik nie musi ponownie wpisywać hasła.

Administrator lub użytkownik może wylogować pojedyncze urządzenie albo wszystkie sesje. Zwykłe odebranie dostępu zacznie obowiązywać najpóźniej po wygaśnięciu krótkiego tokenu; dla szczególnie wrażliwych operacji można później dodać szybkie sprawdzanie wersji uprawnień.

## Usunięcie użytkownika i zmiana praw w Ready

Ready pozostaje źródłem prawdy o aktywności użytkownika oraz jego grupach i prawach. Core zachowuje własny rekord użytkownika wyłącznie dla sesji, lokalnego hasła i audytu.

Jeżeli konto zostanie usunięte albo zablokowane w Ready:

- użytkownik nie zaloguje się ponownie hasłem Ready,
- Core przy następnym refreshu nie znajdzie aktywnego konta i unieważni sesje,
- lokalne hasło Veloryn również nie może już zostać użyte,
- rekord w Core zostaje oznaczony jako zablokowany/odłączony, a nie jest automatycznie usuwany — zachowujemy audyt.

Jeżeli administrator w Ready zmieni prawa albo grupę użytkownika, Core wystawia kolejne tokeny z nową listą `permissions`. Przykładowo odebranie prawa Inwentaryzacji powoduje, że kolejny token nie będzie zawierał `inventory.read`, a backend Inwentaryzacji zwróci `403`.

Ponieważ prawa są częścią krótkiego tokenu dostępu, wydany token zachowuje dotychczasowe prawa do swojego wygaśnięcia. Dla tokenu ważnego 5–10 minut oznacza to maksymalnie taki czas propagacji zmiany w najprostszym wariancie.

Możliwe poziomy propagacji:

1. **Start:** odczyt praw przy logowaniu i refreshu; zmiana obowiązuje po odświeżeniu albo wygaśnięciu tokenu.
2. **Rekomendowany kolejny krok:** lokalny synchronizator Core odczytuje Ready co 1–5 minut i unieważnia sesje użytkowników, których konto albo prawa się zmieniły.
3. **Natychmiastowy:** Core publikuje zmianę wersji uprawnień do lokalnego cache/Redis, a backendy sprawdzają tę wersję przy żądaniach. Daje to prawie natychmiastowe cofnięcie dostępu, ale wymaga dodatkowej infrastruktury.

Na pierwszy etap wystarczają tokeny 5–10 minut oraz odczyt praw przy refreshu. Synchronizator można dołączyć bez zmiany formatu tokenów ani endpointów biznesowych.

## Stan obecny i ryzyka migracji

Obecnie występują różne mechanizmy:

- Inwentaryzacja bezpośrednio czyta `public.users` oraz `public.auth_token` i tworzy tokeny kompatybilne z Ready.
- BHP weryfikuje token Ready przez wywołanie HTTP do Ready.
- DataBus ma zarówno integracje techniczne z Ready REST, jak i endpointy autoryzacji kompatybilne z Ready.
- IQC używa tokenu Ready również do proxy bezpośrednio do `api.php/REST/custom/iqc/...`.

Token Core **nie będzie akceptowany** przez bezpośrednie endpointy `eDokumenty /api.php/REST/...`.

## Zakres pierwszego etapu

Do pierwszego etapu wchodzą tylko:

- Ready Next,
- Inwentaryzacja,
- BHP.

IQC nie jest używane przez Ready Next i zostaje bez zmian. DataBusowe integracje techniczne z Ready również zostają bez zmian.

## Bezpieczna kolejność migracji

1. Utworzyć Veloryn Core i jego własną bazę bez zmiany obecnych modułów.
2. W panelu Ready utworzyć/testowo przypisać grupę oraz prawo Inwentaryzacji do jednego konta testowego.
3. Zaimplementować w Core odczyt grup i praw Ready oraz mapowanie na `inventory.*` i `bhp.*`.
4. Dodać w BHP i Inwentaryzacji obsługę tokenu Core obok starego tokenu Ready.
5. Przełączyć Ready Next na logowanie Core oraz pobieranie listy dostępnych modułów.
6. Przenieść egzekwowanie ról BHP i Inwentaryzacji do ich backendów.
7. Po okresie równoległym usunąć z BHP i Inwentaryzacji zależność od tokenów Ready.

Nie wykonujemy globalnej podmiany Bearera: każdy moduł przełączamy osobno i odwracalnie.

## IQC — poza zakresem pierwszego etapu

IQC pozostaje na tokenach Ready, ponieważ część jego endpointów przekazuje Bearer użytkownika bezpośrednio do endpointów REST eDokumenty. Core nie modyfikuje `public.auth_token`, więc wdrożenie pierwszego etapu nie powinno wpływać na IQC.

Docelowo dla IQC będą możliwe trzy warianty:

1. Własne endpointy PHP eDokumenty dla IQC akceptują token Core.
2. IQC korzysta z konta technicznego eDokumenty, a faktyczny użytkownik jest audytowany po stronie IQC.
3. Przejściowo Core przechowuje po stronie serwera token Ready uzyskany przy logowaniu i używa go wyłącznie do proxy.

Wariant pierwszy jest najczystszy, ale nie jest wymagany do uruchomienia Core dla Ready Next, BHP i Inwentaryzacji.
