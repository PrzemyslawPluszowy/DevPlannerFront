## 2026-10-02 — zbiorczy pakiet forward plików i nawigacji Chat

- Backend: ChatMessageForwardService tworzy rzeczywistą, niezależną kopię obiektu i StorageFile Comment w ACL docelowej wiadomości. Trwała rezerwacja przed copy, stabilne SourceIdempotencyKey mieszczące się w varchar(128), transakcja READ COMMITTED, uporządkowane blokady advisory źródła i celu oraz FOR UPDATE rezerwacji. Po oczekiwaniu odczytywana jest świeża wersja wiadomości, członkostwa/polityki i powiązania/stan pliku. Pending lub Infected nie mogą być przekazane. Retry błędu S3 używa rezerwacji; usunięta/claimed/inna rezerwacja zwraca konflikt; nowy clientMessageId pozwala utworzyć nową kopię. Odpowiedź i outbox zawierają załącznik od razu. Bez nowego API/DTO/migracji.
- Front: picker forward ma własne serwerowe query, cursor/paginację, wyklucza źródło, odrzuca stare odpowiedzi i zachowuje pełny ApiError przy pierwszej/dalszej stronie. Fallback filtruje poza build; fragmenty są klasami widgetów. Sekundarne akcje forward/pin/bookmark/reaction zachowują pełne ApiError per wiadomość i pokazują przewijany ChatSurfaceDialog. Przy niepewnym wyniku forward (brak HTTP, 2xx parsing, 408, 5xx) Cubit zachowuje client key do retry; sukces i definitywne 4xx zwalniają go. Cache ma zakres sesji Cubita, nie jest trwałą kolejką restartu aplikacji.
- Zakładka z innej rozmowy nad task modal otwiera pełny Chat przez ChatSessionDependencyScope i ChatSavedConversationSheet bez zamknięcia zadania. Zwykły globalny Chat dalej używa własnego selection Cubita. Zachowywana jest rola z dostępnej strony inbox. Globalny panel ma nieprzezroczysty panelSurface; wspólne tokeny, menu, hover/focus i root modal host. UI UX Pro Max + Impeccable Operate: czytelność powierzchni, bounded scroll błędów, desktop picker i spójne kontrolki; faktyczny runtime po publikacji nadal wymagany.
- Backend root: restore z jawnym veloryn-workspaces.csproj PASS; build no-restore PASS, 0 warning/0 error; scoped autoryzacja, forward, pliki, foundation, creation, admission, OpenAPI i wire enums 153 PASS/0 SKIP. Osobne testy forward PostgreSQL obejmują rollback/retry, zmianę źródła podczas rzeczywistego lock wait i soft-delete pending reservation. Cały projekt format PASS; testowe pliki scoped format PASS; oba idempotentne skrypty EF wygenerowane offline przy technicznym ConnectionStrings__Workspaces (bez wykonywania SQL). Skrótowe restore/format bez workspace odrzucone przez CLI przez równoczesny csproj/sln; użyto jawnej ścieżki. Brak nowej pełnej suite backendu.
- Front pełna suite snapshot: 2278 PASS/0 FAIL. Po końcowych rozszerzeniach secondary actions wszystkie testy Chat 384 PASS/0 FAIL, analyzer clean; końcowy mechaniczny review przenosi nowy helper do istniejącej klasy Dialogs i chroni dismiss po zamknięciu Cubita — końcowy analyzer clean i scoped message-actions 35 PASS/0 FAIL, exit 0. Testy błędów saved navigation przeszły na 320/1280, picker full ApiError na 340x350, saved conversation na 320/1280 oraz bez optional message-actions portu. Początkowe 2 FAIL timingowe usunięto przez oczekiwanie na rzeczywisty wynik stanu/zapisu, nie sztywne sleep ani obniżenie asercji.
- Audyt transportu: Forward request nie zawiera enumów, nowe stany picker/secondary actions są lokalnym UI. Reużywane StorageScanStatus, StorageProcessingStatus, ChatScopeKind/ConversationType/NotificationPreference/MessageDeliveryStatus i realtime wire bez zmian; pełne zestawy serializer/OpenAPI potwierdzone w root scoped backend, klient wire tests w pełnej suite. Odbiór rzeczywistego forward DTO/pliku na stagingu jest następną bramką.
- Commit/push oraz wspólna publikacja skryptami SSH przygotowywane; wyłącznie Wasm dla Frontu. Do potwierdzenia po publikacji: kopia TXT w celu od razu i jej bytes/odrębne ID/ACL, query/paginacja pickera, obca zakładka + zachowany szkic zadania, brak prześwitywania tabeli pod Chatem. Dalszy Office, izolowane konta, keyboard/theme i pełne P0–P7 pozostają otwarte; pakiet nie oznacza zakończenia całego celu.

## 2026-10-02 — potwierdzenie obecności i stan następnego pakietu

- Ręczny odbiór bieżącego stagingu: Lista pokazuje na jednym ekranie Online przy aktywnym wykonawcy i Offline przy pozostałych. Bez tooltipu lub otwierania awatara. Dowód: /tmp/devplanner-staging-online-offline-list-2026-10-02.png. Brak nowych zmian funkcji presence w tym sprawdzeniu; wdrożony Front nadal 81df885, Backend a62b81c. Timer profili 15 s, forceRefresh, przy błędzie status unknown zamiast fałszywego Offline — sprawdzone w aktualnym kodzie.
- Następny zbiorczy pakiet pozostaje WIP, nieopublikowany: nieprzezroczysty globalny Chat, otwieranie zakładki z innej rozmowy nad modalem zadania (ChatSavedConversationSheet + wspólny ChatSessionDependencyScope), serwerowe query/paginacja forward pickera i forwarding niezależnej kopii pliku po ACL. Agenci forward_picker i forward_files pracują we własnych plikach; nie wdrażać w trakcie ich edycji.
- Front pełna suite tego WIP zakończyła się exit 1: 2272 PASS, 2 FAIL. Failing: chat_inbox_cubit_test realtime invalidations oraz chat_composer_draft_persistence_test debounce/flush. Nie ustalono jeszcze, czy są to flaki timingowe; powtórzyć i zdiagnozować. Analyzer miał 11 info w rootowym chat_saved_conversation_sheet_test; 10 poprawiono dart fix i 1 ręcznie (ChatInboxPage.empty), ponowna walidacja wymagana. Wcześniejszy test saved conversation: 2 PASS przy 320/1280 px; nie mylić z świeżą pełną suite.
- Próba ponowienia presence widget tests trafiła na chwilowy compile error nullable _cubit w pickerze podczas refaktoru agenta; agent powiadomiony i poprawia. Po ustabilizowaniu zmian ponowić scoped testy i analyzer.
- Backend forwarding: agent wydzielił ChatMessageForwardService, dopina testy ACL/retry/idempotency i niezależnych kopii. Root wskazał: client key musi wiązać kompletny zestaw plików źródłowych, po locku rewalidacja wersji/tekstu/delta i świeżych memberships; jawny Guid.Empty odrzucić. Konieczny końcowy review i rzeczywiste wyniki testów przed publikacją.
- Kolejność: zakończyć agentów, review, wyjaśnić 2 FAIL, final analyzer/testy; aktualizacja planu i handoffów; commit/push z [skip ci] zgodnie autoryzacją użytkownika; jeden batch publikacji skryptami Backend + Front Wasm; ręcznie odebrać nowe forward pliki, query/paginację, inną zakładkę i nieprzezroczysty panel. Office/3 sesje i pełne P0–P7 nadal niezamknięte. IAB tab 6 markHandoff, Lista ustawiona na wiersz aktywnego wykonawcy.

## 2026-10-02 — opublikowany i ręcznie odebrany pakiet akcji Chat

- Backend a62b81c7c2b2ffa3cf685816b96942acd300be02: devplanner-deploy-local exit 0, obraz API zgodny, healthy/readiness ready. Brak migracji do zastosowania. Front Wasm 81df8850827d3b049bc55857db51ff873e475ac9: deploy_staging_wasm.sh exit 0, publiczny version.json potwierdza SHA. Publikacja przez skrypty, bez GitHub Actions.
- Ręczny staging po reload: wyszukiwanie w modalu zadania aktywne, fraza znalazła wiadomość wątku, wybór zamknął panel i wyróżnił właściwą wiadomość. Zakładki i przypięte pokazują prawdziwą treść w nieprzezroczystym panelu 480 px; wybór lokalnej zakładki/pinu wraca do wiadomości. Picker przekazywania pokazuje rozmowy; wybór grupy QA wysłał treść i w docelowym globalnym panelu potwierdzono Wysłano.
- Dowody: /tmp/devplanner-staging-task-chat-search-2026-10-02.png, /tmp/devplanner-staging-chat-bookmark-previews-2026-10-02.png, /tmp/devplanner-staging-chat-pin-previews-2026-10-02.png, /tmp/devplanner-staging-task-chat-forward-targets-2026-10-02.png, /tmp/devplanner-staging-chat-forward-received-2026-10-02.png.
- Kolejny pakiet do wykonania: otwieranie zakładek z innej rozmowy w task modal; serwerowe wyszukiwanie i paginacja pickera forward; forwarding załączników (aktualny Backend ForwardAsync przekazuje wyłącznie Text/DeltaJson, manualnie odebrano tylko tekst); nieprzezroczysta powierzchnia globalnego panelu Chat (obecna przepuszcza tabelę zadań). Dalszy Office/3 izolowane sesje i P0–P7 pozostają otwarte. Żaden z tych punktów nie jest oznaczony jako zaliczony.
- Testy i ich zakres zapisane w sekcji przygotowania poniżej. Nie wykonano nowej pełnej suite backendu ani pełnego Front po końcowym inbox; scoped testy i runtime pokrywają ten pakiet. IAB tab 6 markHandoff: docelowa grupa QA w globalnym panelu, pusty composer.

## 2026-10-02 — zbiorczy pakiet akcji Chat przygotowany do publikacji

- Backend: ChatBookmarkResponse/ChatPinnedMessageResponse otrzymują opcjonalne messageText. Listy i odpowiedzi mutacji korzystają z aktualnego SearchText dopiero po ACL; zmiana treści i usunięcie wiadomości nie pozostawiają starego podglądu. Brak DDL/migracji. DTO/generowane modele Flutter i adaptery aktualizowane razem; legacy bez pola pozostaje dekodowalne.
- Front: ograniczone do 480 px, nieprzezroczyste ChatActionSideSheet w tokenach ChatTheme dla zapisanych/przypiętych; podgląd treści i zachowana prywatna notatka. Wyszukiwanie lokalne w rozmowie zadania filtruje także facety. Target request ID umożliwia kolejny skok do tej samej wiadomości. TaskDetailChatDependencyScope tworzy własny ChatInboxCubit do przekazywania, z poprawnym zamknięciem; lista śledzi zmianę stanu inbox.
- UI UX Pro Max i Impeccable Operate: wykorzystano istniejące tokeny, responsywne ograniczenia panelu, widoczne zamknięcie i rzeczywiste akcje. Testy geometrii light/dark, 320/1280 px, podglądów i wyboru celu.
- Backend scoped ChatFoundation + ChatOpenApiContract + ChatCreationPostgres + ACL: 105 PASS / 0 SKIP (29 s); format zmienionych plików exit 0. Dotknięty przepływ akcji nie wprowadza enumów: DTO zakładek/pinów nie mają enumów; dotychczasowe pełne wartości transportowe Chat sprawdzone testami wire/OpenAPI, lokalne stany UI nie są transportem.
- Front pełna suite 2266 PASS przed końcowym podłączeniem inbox; po nim 58 testów widgetowych PASS, następnie 19 testów podglądów PASS. Końcowy flutter analyze No issues found (11.3 s). Nie przedstawiać tego jako pełnej suite po ostatnim kodzie. build_runner exit 0, git diff-check clean. Logi /tmp/devplanner-chat-action-backend-final.log, /tmp/devplanner-chat-action-front-full.log, /tmp/devplanner-chat-action-final-widget-tests.log, /tmp/devplanner-chat-action-preview-final.log.
- Manualny staging upload+send w wątku TXT 86 B już PASS na dotychczasowym wdrożeniu: kafelek od razu bez reload. Nowe akcje wymagają retestu po zbiorczej publikacji Backend i Front Wasm. Nadal otwarte: zakładki z innej rozmowy w task modal, kolejne strony inbox w pickerze forward, Office, trzy izolowane sesje, pełne P0–P7. Publikacja pakietu nie zamyka całego celu.

## Aktualny stan — 2026-10-01, zakończony pakiet kodu

Poprawki są zaimplementowane i zweryfikowane lokalnie. Poniższy stan ma pierwszeństwo przed historycznymi wpisami o pracy agentów.

- Daty startu i terminu mają wspólne zachowanie w Liście, Kanbanie, modalu i szablonach: zmiana dnia zachowuje lokalny czas z pełną precyzją, nowa data używa lokalnej północy przeliczonej na UTC, wyczyszczenie daje null. Pola date-only i reguły powtarzania zachowują odrębny kontrakt.
- Prawa kolumna modalu przy 200% skali układa etykiety i wartości pionowo. Świeży render został obejrzany; test geometrii i golden bez aktualizacji przeszły. Kolory i kontrolki korzystają z istniejących tokenów Tasks, zgodnych z Listą i Kanbanem.
- Front: pełny analyzer bez uwag; pełne testy 2212 PASS, 0 FAIL. Osobne testy stref: Los Angeles 9/9, Warszawa 9/9, UTC 9/9 PASS.
- Backend: pełny zestaw 1469 PASS, 4 SKIP, 0 FAIL. Po późniejszym dodaniu testu HTTP dat i poprawieniu testowej migracji Identity dodatkowy zestaw TaskHttpOperationMatrixTests + ProjectSetupHttpIntegrationTests zakończył się 40 PASS, 0 SKIP, 0 FAIL (exit 0, 1 min 37 s). Pełny zestaw nie był ponawiany po tej zmianie wyłącznie testowej.
- Kompilacja Web, rzeczywistego Web Wasm oraz macOS debug: PASS. Są to dowody kompilacji, bez odbioru GUI i wydania podpisanej aplikacji.
- Agenci zakończyli pracę. Nie ma uruchomionych przez nich testów ani buildów. Nie powtarzać poprawnych bramek bez nowej zmiany lub konkretnej regresji.

Do odbioru pozostają rzeczywiste scenariusze uwierzytelnione w aplikacji: pełne Chat/Storage, klawiatura i focus PL/EN, wszystkie otwarte powierzchnie oraz porównanie UX z Asaną. Brakuje też odbioru platform Windows/Linux, wydania desktopowego i pominiętych testów między hostami/Redis. Nie zamykać P0–P7 na podstawie samych lokalnych testów i renderów.

Zgodnie z ostatnim poleceniem użytkownika nie kontynuować prób SSH, logowania ani wdrożenia. Bez commitowania i pushowania. Szczegóły oraz historyczne wyniki znajdują się poniżej.

---

## Bieżąca kontynuacja — 2026-10-01, po zielonych bramkach Front

Nie uznawać wcześniejszego zielonego builda/testów za odbiór nowych zmian opisanych tutaj. Cel P0–P7 pozostaje aktywny; polecenie użytkownika wyklucza dalsze próby SSH/login/deploy, praca dotyczy kodu.

1. Surface: poprawia realny defekt etykiet/value prawej kolumny przy200%/1280. PropertyRow przechodzi na pionowy label/value w ciasnym panelu lub dużym TextScaler; test geometrii i świeży fallback capture wymagają root review. Bez clamp tekstu; neutralne TasksTheme. Agent zachowuje production<400LOC i wydziela ordinary widget PropertyRow.
2. Navigation: potwierdził rozbieżność task start/due pomiędzy Listą (UTCmidnight), Kanbanem (localmidnight→UTC) i modalem (preserve local clock). Transport potwierdził źródłowy Backend UTC instant, KindUTC validation i brak DateOnly/tasktimezone. Przyjęta zgodna z API polityka UI: zmiana istniejącego dnia zachowuje lokalny clock/precision, nowa data to lokalna północ→UTC, clear=null, initial task picker lokalny dzień. Nie zmieniać custom Date/recurrence date-only. Navigation implementuje wspólny helper i testy actualJSON w zachodniej oraz warszawskiej strefie. Template start/due caller także wymaga weryfikacji kontraktu; nie zgadywać.
3. Transport: jeden final pełny Backend suite po dwóch poprzednich poprawkach fixture. Log /tmp/devplanner-final-backend-tests.log. Nie powtarza poprawnych restore/build/EF/format ani nie dotyka istniejącego BrowserHarness.

Poprzedni zamrożony Front: fulltest2207PASS, fullanalyze clean, WebbuildPASS88.3s, visual17/17+split6/6PASS. Nowe zmiany po tych dowodach wymagają scoped checks i końcowego odbioru. Wszystkie agenty mają scope/quality, root weryfikuje pliki, lifecycle, wire semantics i render. Bez commit/push.


## 2026-10-01 — domknięcie kodu bez dalszych prób serwera

Użytkownik polecił zakończyć próby dostępu/deploymentu i dokończyć kod. Nie wykonywać dalszego SSH, logowania ani wdrożenia w tym zakresie.

Root poprawił `WorkspaceCreationModalWrapper`: zamknięcie po async guard i post-frame sprawdza dokładną aktualną trasę; callbacki async mają jawne `unawaited`. `CreateTaskTemplateDialog` ma nazwany listener i nie zamyka innej trasy po opóźnionym sukcesie. Nowy `workspace_creation_modal_close_test.dart` potwierdza rzeczywisty push nowej trasy w trakcie guard. Flutter batch78576:3/3 PASS; final scoped analyzer31411:No issues found. Navigation final selektywny batch73/73 PASS i czysty analyzer. Surface domyka folder/Rename; Backend domyka Office lease/history no-store. Po stabilizacji źródeł pozostają końcowe bramki kodu. Odbiór wizualny/staging/E2E nie został wykonany i nie jest zastąpiony testami.
## 2026-10-01 — root: końcowe wyniki bieżącego małego review

- Navigation terminalny feature batch: 73/73 PASS, scoped analyze No issues found, diff-check czysto; agent zamknął swój pakiet i przekazał slot Surface. Poprawione zamykanie kolejki przed await dispose oraz odróżnienie własnego nieudanego quick-create reload od nowszej generacji.
- Root wrapper/template batch78576 terminal exit0 3/3 PASS: rzeczywisty late close guard po push nowej trasy jej nie zamyka, zachowanie błędów template PL/EN przy200% bez regresji. Final scoped analyzer31411 No issues found po mechanicznym usunięciu unnecessary_unawaited w teście. Nowy test workspace_creation_modal_close_test.dart.
- Surface16642 terminal 9PASS/5FAIL; agent diagnozuje route/harness (nie deklarować gotowości folder/Rename). Slot oddany mu po root batchu, żadnego równoległego Flutter root.
- Backend Office lease/history no-store pakiet i jego wybiórcze testy nadal trwają; nowa migracja AddOnlyOfficeObjectLeases. Nie wdrażać źródeł w trakcie zmian.
- Serwer dodatkowo odrzuca ls/read agent-login.env jako Permission denied. Hasło pozostaje nieodczytane. Czekamy na właściwy dostęp administracyjny/upload bezGitHub, zgodnie z wysłanym pytaniem. Nowe wersje jeszcze niewdrożone.

## 2026-10-01 — root: autoryzacja wdrożenia SSH bez GitHuba

- Użytkownik zezwolił na wdrożenie Backend + Front na serwer przez skrypt albo SSH, bez GitHuba. To zastępuje wcześniejsze ograniczenie „bez deploymentu”; commit/push nadal nie są zlecone.
- Zweryfikowany SSH `codex-staging@135.125.200.141` dedykowanym kluczem, BatchMode i StrictHostKeyChecking=yes. `devplanner-observe status`: API i zależności zdrowe, nginx active, readiness ready; działa stara wersja backendu sprzed 7 dni, nie nowe źródła.
- Faktyczny sudoers pozwala wyłącznie observe/deploy/deploy-local/seed-demo. Faktyczny deploy-local wymaga clean checkout i wykonuje `git pull --ff-only`; deploy pobiera GHCR. Nie uruchomiono żadnego z nich, bo nie spełniają polecenia bez GitHuba. `/opt/devplanner/repository` i `/srv/devplanner/frontend` są root-owned; `frontend/current` nie istnieje. Zwykły lokalny klucz nie daje root SSH. Bez prób obejścia ograniczeń.
- Instrukcja wskazuje chroniony `/etc/devplanner/agent-login.env`, ale codex-staging nie ma polecenia odczytu ani dostępu administracyjnego. Sekrety nie były odczytane, wypisane ani skopiowane. Zadano asynchronicznie pytanie o właściwy alias/użytkownika SSH lub instrukcję uploadu.
- Navigation ma domknąć aktualny selektywny batch (ostatnie wcześniejsze reruny miały błędy) i oddać serialny slot Surface; następny świeży Web build target https://devnote.flutter-dev.pl. Surface domyka folder i Rename route guards. Backend domyka istniejący Office lease/history no-store pakiet, bez dalszych audytów.
- Poprzedni cleanup/copy pakiet: agent final 31/31 PASS; root przejrzał advisory lock/fresh contexts/timeout/durable intent, atomowy Ready+Created outbox i retry idempotency. Nie jest to pełna bramka backendu.
- Root doprecyzował sprawdzenie exact route.isCurrent po async close guard w WorkspaceCreationModalWrapper, także w post-frame callback; TemplateSaved listener jest nazwanym handlerem i nie zamyka trasy, która przestała być current. Format PASS; analiza i selektywny test po serialnym slocie nadal wymagane.
- Nie wdrożono nowych źródeł, nie potwierdzono zalogowanego UI na stagingu. Brak wizualnej gotowości i brak pełnych końcowych bramek. Nie wracać do lokalnego starego builda z origin5072 jako dowodu nowego UI.


## 2026-10-01 — root: milestone, pełne błędy i neutralny picker

- TaskMilestoneCubit309 LOC: list/get/assign/unassign catches ApiError/Dio/unknown z pełnymi metadanymi, bez prywatnego message dla unknown Dio bez response. Zamknięcie/generation/busy/edit guard, RetryAfter blokuje odczyt i mutacje; timer jest własnością Cubita i odwołany na close. Udany retry czyści stary błąd.
- TaskDetailsMilestone271 LOC: owner key obejmuje task/workspace/project/assignedMilestone/repository/DetailsCubit; launcher captures Cubit przed route builderem. Picker używa aktualnego state.assigned, neutralnych Tasks canvas/border/controlRadius i jawnego Close; cały feedback/lista przewijalne. Błąd odczytu widoczny także w property panelu, bounded150px. Osobny widget choice ma nazwany handler z exactmounted/owner/route guard po await.
- Final Flutter81264 exit0:12/12PASS (Cubit10 + real pickerPLlight/ENdark420×600200%2): thrown load/mutation, fullDio422 fields/code/trace, unknown sanitization, required typedaccesslost przy fetched assigned, cooldown bez REST, close/late throw, successclearerror; picker actualtap i actualClose hitTestable,30fields/długie message i trace. Analyzer20081 terminal:1redundantargumentinfo w DioUnknownfixture; usunięty. Final88506 terminal No issues found dla4plików. Scoped Front diffcheck exit0. Bez zmian DTO/enumów.
- Serial gen-l10n77540 exit0 obejmuje nowe fallbacki Time/Recurrence; wcześniejszy78451 exit0 zawiera Milestone. Surface98925 terminal5/5PASS:Linux desktop target, PLlight/ENdark200%, reopen i2owner/scope. Root source review wymaga jeszcze inline empty-folder-name validation (obecnie silentreturn). Surface kontynuuje RenameFile owned resources/route close/fullApiError/cooldown/suffix.
- Root review Time/Recurrence po catches: metadane RetryAfter zachowane, ale rzeczywisty gate był nieobecny; potwierdzony Time response ignorowany przed GET, więc refreshfailure mógł pokazywać stary aktywny timer. Navigation poprawia gate/timer/disabledcontrols, stosuje returned entry poid przedGET i dodaje stop/create-success+GETfailure regresje. Jego61523 terminalexit3 z błędami/lintami fixture; brak aktualnego PASS nowych źródeł.
- Backend Luna zgłosiła selektywne11/11PASS durablecleanup/migration. Root odczytał nowe isolatedcontexts/advisorykeylock/rowclaim/60sdelete vs5minlease; HTTP już tylko atomowy commit. Cały packet nadal do review: Chat copy source reservation/lock/reread/ACL/idempotency concurrency. OnlyOffice presigned4h i registry bez version/objectKey pozostaje osobnym wymaganym packetem, nie zamkniętym samą notatką.
- Dodatkowy root seam: StorageFileMutationCubit.canMutate odczytuje closed/busy/najpóźniejszy RetryAfter; Surface ma użyć getter w RenameFile, zweryfikować w swoim analyze i istniejącym busy/cooldown teście. Getter nie dodaje automatycznego retry. Backend27/27PASS zgłoszony po Chat copylock; root znalazł completion commit przed outbox i brak Created na retry pending reservation, oraz wymaga legacy :vN idempotency policy. Te poprawki nadal w toku.
- P0–P7 pozostają otwarte. Realauthenticated UI, Office/chat realtime, side-by-side otwartychpopupów i benchmark oraz pełne końcowe bramki nie są potwierdzone.


## 2026-10-01 — root: review trwałego cleanup i granic sesji Kanbanu

- Root odczytał aktualne S3StorageService.DeleteObjectAsync, DeleteStorageFileVersionHandler, StorageObjectDeletionProcessor i testy HTTP. S3 używa własnego HttpClient; obsłużone InvalidOperationException nie pokrywa timeout TaskCanceledException bez anulowania requestu. Handler po SaveChanges nadal wywołuje processor: błąd claim/ref/finalize może dać 500 mimo zatwierdzenia usunięcia. Pakiet NIE zaakceptowany, wcześniejsze 7 PASS nie pokrywa tych scenariuszy.
- Zlecona poprawka: HTTP tylko atomowy metadata/outbox/intent commit, cleanup w workerze; izolowany context, bez Clear współdzielonego trackera. Testy timeout/restart, dwa processory, aktywny lease i odzyskanie wygasłego lease; bounded delete krótszy od lease lub renewal. Reference-check TOCTOU wymaga prześledzenia realnych writerów/restore i rozwiązania jeśli klucz można ponownie użyć. Nie dodawać unique object-key index bez obsługi współdzielonych historycznych keys.
- Root queue review: catch PUT/GET ustawia retry gate przed guardem scope; po udanym await reload brak guardu przed następnym PUT. Navigation dostała poprawki i testy stale throw+RetryAfter oraz scope change podczas reload. Aktualna kolejka 362 LOC. Nowe źródła nie mają jeszcze końcowej selektywnej walidacji.
- Serial gen-l10n: exit0, tasksBoardColumnLoadFailed PL/EN wygenerowany. Bez pełnej suite. TimeTracking276, Recurrence224, Milestone212 LOC: root potwierdził brak ochrony thrown repository failures w load i mutations; ryzyko pozostania Loading/Saving. Navigation ma po queue naprawić TimeTracking/Recurrence; Milestone pozostaje następny root packet.
- Surface folder diagnostyka 54543 terminal exit1: enabled Save/current dialog route, ale tap trafia w ModalBarrier; przyczyna jeszcze nieustalona. Nie traktować tego jako dowodu błędu produkcyjnego ani gotowości UI. Bez obejść hit-test. Po poprawce RenameFile lifecycle/full-error/neutral UI packet.
- Backend kolejny ustalony packet po cleanup: historyczny download ticket nie ma no-store w przeciwieństwie do current ticket; potrzebne actual HTTP ACL i scan tests. Nie ma dowodu cache w konkretnym proxy.
- UI UX Pro Max + Impeccable Operate stosowane; Material tylko baza techniczna. Otwarte dropdowny/menu/pickery/error surfaces muszą używać tokenów listy/Kanbanu. P0–P7 pozostają otwarte; authenticated runtime visual, Office/chat realtime i pełne końcowe bramki nadal wymagane.


## 2026-10-01 — root: zapis szablonu zadania

- TaskTemplateCubit137 LOC normalize thrown ApiError/Dio/unknownsafe localcode, releases Saving onfailure, canSubmitbusy/saved/closed/edit/cooldown gates, ownedRetryAftertimer/revision/closeinvalidate; fullApiError zachowany, accesslost callback także dla thrown403.
- CreateTaskTemplateDialog193 LOC: namedsubmit, localrequiredvalidation, szkic zachowany, submit/Enter disabled do końca429, globalmessage/fullmetadata oddzielone od namefields; neutralTaskscontroltokens, boundedscrollerror. Launcher canEdit odrzuca zamkniętego DetailsCubit. TaskDetailsModalError244 LOC dodaje optionallocalizedfallback dlaempty safeunknownmessage (default pozostałychwywołań zachowany).
- Serial gen-l10n exit0 (tasksTemplateSaveFailed PL/EN przez Nav). Flutter82120 exit0,9/9PASS: existing3+throwsAPI/accesslost,Dio429expiry,busy/close,safeunknown4 +realwidgetPLdark/ENlight420600200%2 (emptyvalidation,noREST,draftretained,localizedsafeerror,buttonhitTestable). Analyze79782 tylko1braceinfo naprawione; final50653 No issues found. Scoped diff0.
- Surface folder92499terminalexit1: error200%Save tap problem nadaldiagnozowany; owner/scope66836 2/2PASS, cubit4+shell12 wcześniejPASS; nie ma gotowości całegofolderpacket. Root wymaga rzeczywistego hit-test, nie tłumieniawarnings lub bezpośredniego onPressed w teścieUI.
- Navqueue/loaderfullerrors+RetryAfter+confirmedPOSTsuccessGETfailure WIP. Backend durabledeleteintent worker/migration/retry/reference-safety WIP. P0–P7 nadalotwarte, realruntimevisual+realtimeOffice/chat i fullfinalgates pozostają wymagane.


## 2026-10-01 — root: pełny błąd resolvera Chatu zadania

- Plan P0–P7 odczytany ponownie w zakresie checklisty. Root wrócił do core modala: TaskDetailConversationCubit spłaszczał throws do exception bez ApiError, UI ignorowało metadane i resolver mógł emitować po zamknięciu przy retry/resolve.
- Cubit175 LOC teraz normalizeApiError/Dio/unknown(safe localcode), neutraldenied dla403/401/404 także thrown, closed/currentgeneration/busy/same-scope guards, RetryAfter gate+ownedtimercancel; nowy scope nie dziedziczy deadline poprzedniego. State failure ma pełny ApiError i revision po cooldown.
- Slot261 LOC używa osobnego TaskDetailConversationFeedback67 LOC: wspólne tokeny, pełny TaskDetailsModalError w bounded/Flexible scroll, jawnym Retry z canRetry. Nie dodano oddzielnego komunikatora ani transportu. Nie zmieniono request/response DTO/enumów.
- Flutter24375 exit0,8/8PASS: poprzednia sesja/close/denied3, nowy Dio429metadata+retrygate/closednosend/throwsneutral-safe3, feedbackPLdark/ENlight420×600200% z30fields/długimmessage, ograniczony300pxpanel, Retry dostępny/disabled2. Analyze57583 No issues; scoped diff0; brak authenticatedruntimeacceptance.
- Surface folder32861 terminalexit1: Cubit4+shell12PASS, nowydialog3fail(harness/finder wgLuna), naprawa/rerunpending; analyze58950clean; po nim RenameFile lifecycle/UI packet. Nav queue/loadingthrows+RetryAfter/fullmetadata+confirmedcreateGETfailure nadal in progress. Backend durabledeleteintent/processorworker/migration/restarttests nadal in progress.
- Kolejne core taskgaps: TemplateCubit.createFromTask braktrycatch może zostaćSaving na thrown; root inventory wykonany, kolejny boundedpacket po reviewrunningLunas. P0–P7 nadal otwarte, finalfullgates i realvisualE2E wymagane.


## 2026-10-01 — root: CreateFolder i trwałe usuwanie obiektów

- Root CreateFolderDialog138 LOC: ModalHost, neutral Tasks canvas/ramka/tint/typografia/controlRadius, etykieta, inline required validation zamiast cichego braku akcji, named submit/cancel, owned controller/notifierdispose. Wywołujący chrome już captures browser/foldermutation/scope i currentowner po await (odczytany source).
- Analyze80517 No issues. Flutter40447 exit0,2/2PASS:420×600200%,ENlight/PLdark, emptyvalidation+trimresult oraz darkkeyboardDone. Nie jest to runtime visual acceptance.
- Root odczytał RenameFileDialog i przekazał Surface następny packet: controller/notifier dispose po closefuture zbyt wcześnie, dismiss handler używa origin context zamiast dialogroute; rawsurface i niepełne ApiError. Surface folderpacket WIP:78859analyze exit3, naprawy trwają, bez PASSclaim.
- Backend DeleteHistorical handler4HTTPPASS zgłoszony przez Luna; root source review ujawnił niedurable orphan cleanup. StorageOrphanManager nie zachowuje usuniętego key i nie sweepuje S3; trwały deleteintent jest wymagany, nie tylko komentarz. Zlecone encja/additivemigration/claimlease/boundedretry/worker, atomiccommit i HTTP204po poprawnymcommit mimo storagefailure, restart persistence tests. Processor musi chronić key nadal referenced current/pending/staging/retainedversions także innych plików. Packet jeszcze niezakończony.
- Nav queue/loader typed exceptions/RetryAfter/confirmedcreateGETfailure/pełnybanner in progress. Kolejne: review i selective testy tych packetów, runtime taskmodal/Office/chat, finalfullgates. P0–P7 nadal otwarte.


## 2026-10-01 — root: Versions refresh boundary zweryfikowane

- StorageVersionsAction jest normalną klasą42 LOC; FileContextMenu134 LOC deleguje nazwany handler. Capture browser/repository/transport/scope przed dialog await; exact mounted, closed, current dependencies i scope przed GET refresh.
- Nowy lifecycle test6 korzysta z rzeczywistych browser Cubitów i dialogu wersji; kontroluje wyłącznie wynik zamknięcia trasy (nie udaje restoreHTTP). PASS current ->GET, scope/browser/repository/transport replacement i cancel ->bez GET.
- Flutter16843 exit0,11/11PASS: Versions6 +Dismiss5. Analyzer76747 tylko2infos import-order/helper declaration w teście, naprawione; final58941 No issues found, scoped Backend/Front diff check exit0. Gen-l10n91900 exit0 po nowych NavARB.
- Root review kolejki preferencji i loadera: wyłapane uncaughtApiError/Dio/unknown, spłaszczanie fields/status/trace, brak RetryAfter gate; Nav poprawia plus testy. Confirmed create następnie throwGET ma zwracać success i pełny visible GET error, nie sugerować powtórzenia POST. Banner zachowuje backendCode/trace i bounded message/actions.
- Surface folder dialogs+mutationmetadata/busy/cooldown i persistentlistenerpass in progress. Backend DELETE historical version Application extraction in progress. P0–P7 i finalruntime/fullgates nadal otwarte.


## 2026-10-01 — root: menu pliku Dismiss i Versions ownership

- Surowy dialog Dismiss zastąpiony normalnym StorageDismissSharedConfirmation (79 LOC): wspólny ModalHost, neutral canvas/tint/ramka/typografia, scrollable, Cancel autofocus. StorageDismissSharedAction (27 LOC) przechwytuje browser/mutation/scope przed await i sprawdza exact mounted/current owner/closed/scope przed mutacją.
- File context menu uproszczone do162 LOC; Versions callback przeniesiony do nazwanej metody, captures browser/repository/transport/scope przed await i odrzuca nieaktualne odświeżenie. Ta granica Versions ma review źródła; dodatkowy interakcyjny regression test nadal następny krok.
- Dismiss test fixture początkowo nie skompilował się przez próbę mockowania final Cubitów, zastąpiony rzeczywistymi Cubitami i mock repository/transport.73872 5/5PASS;70606 5/5PASS po rozszerzeniu Cancel o klawiaturę Enter. Scenariusze current/scope/browser replacement/mutation replacement/cancel,420×600,200%, ENlight/PLdark.
- Analyzer65483 tylko info import-order w teście, naprawione; final49154 No issues found. Scoped Backend i Front diff check exit0. Brak zmian kontraktu lub enumów.
- Backend ListVersions Application handler/mapper reviewed root: canonical read ACL, autorzy batch po autoryzacji, aktualne JSON/OpenAPI; Luna PG HTTP3/3PASS, scoped format/diff0. Kolejny backend packet delete historycznej wersji. Nav focused13PASS/analyze9 clean; root source review kolejny. Surface folder typed feedback i lifecycle in progress.
- Cały plan P0–P7 nadal otwarty, runtime finalnego modala/Office/chat i pełne końcowe bramki niewykonane.


## 2026-10-01 — root review Sharing: właściciel i rozbudowane błędy

- Root znalazł brak resetu lokalnego właściciela po zmianie pliku/repo. Baseline85672: replacement2FAIL, ordinary rebuild1PASS; dwa wcześniejsze baseline runy nie skompilowały testu (import fixture), bez wniosku o zachowaniu.
- DesktopSharingDialog otrzymał klucz źródła dla BlocProvider, wspólny ModalHost, neutralny canvas/tint/elevation i ograniczony przewijalny feedback. Brak zmian transportu/enumów.
- 89331 exit0: owner3 + people5 =8/8 PASS. Dodatkowy długi błąd 30 pól przy420×600/200%: rerun48656 4/4 PASS (3 owner +1 error), analyze89557 No issues. Bez runtime wizualnego potwierdzenia.
- Review Cubita: granty zachowane po błędzie, ApiError/Dio metadane normalizowane, busy/generation/close oraz globalny RetryAfter blokują GET i mutacje; Luna wykonała wcześniej10/10 Sharing200% i scoped analyze16 clean.
- Następny Surface packet: neutralne folder rename/delete oraz capture owner/scope po await; folder Cubit typed metadata/busy/generation/RetryAfter. Nav QuickCreate poprawia generation i bounded diagnostics; Backend wydziela listę wersji do Application z HTTP ACL/JSON/OpenAPI tests. Root następny: dismiss/versions callback w file_context_menu.
- P0–P7 pozostają otwarte. Nie wykonano pełnej suite ani uwierzytelnionej wizualnej walidacji finalnego modala/Office/chat.


## 2026-10-01 — root: formularz dokumentu i domknięcie Move_UI

- Formularz tworzenia dokumentu korzysta z neutralnych tokenów Tasks (canvas, ramka, typografia, promienie), wspólnego ModalHost i jawnej walidacji pustej nazwy. Otwarty dropdown zachowuje formaty i nie zmienia HTTP serialization. Produkcja: 217 LOC, normalne klasy/nazwane handlery, kontrolery/notifiery zwalniane przez właściciela.
- `gen-l10n` handle48024 exit0. Test87169: Move_UI5 i Document lifecycle8 PASS; nowy dialogtest2 początkowo FAIL przez niewłaściwy finder niewyrenderowanej pozycji menu. Po rzeczywistym scrollUntilVisible otwartego menu rerun20960: 2/2 PASS, EN light/PL dark, 420×600, 200%, inline validation i wynik XLSX z trim nazwy.
- Backend Luna: security lifecycle PG HTTP1/1 PASS, scoped format/diff exit0. Root odczytał active/rejoin/concurrent role synchronization i asercje HTTP/DB: stale Owner demotowany do Observer; send/edit/reaction/attachment 403, brak zmian DB.
- Sharing Luna: 70569 10/10 PASS z 200% light/dark; final scoped analyze16 plików No issues. Root Document analyze12354 No issues; scoped diff check exit0. QuickCreate typed metadata/l10n gotowe; root review wymaga generation/scope guards i zawijanych akcji z ograniczoną przewijaną diagnostyką.
- Następne: review Sharing i QuickCreate, naturalne Application extraction Storage preview/version/share, runtime uwierzytelnionego modala/Office/chat oraz końcowe pełne bramki. Wszystkie zbiorcze P0–P7 nadal otwarte; testy widgetów nie potwierdzają wizualnej gotowości ani przewagi nad benchmarkiem.

## 2026-10-01 — root: potwierdzenie usunięcia wersji spójne z Tasks/Files

- Root zastosował aktualny UI UX Pro Max query `keyboard focus modal` oraz craft-floor Impeccable. Dotychczasowy nested AlertDialog używał domyślnej tonal akcji i nie miał jawnego początkowego focus na zamknięciu.
- Naturalny `StorageVersionDeleteConfirmation` (81 linii) korzysta z neutralnego Tasks canvas/border/radius/type/spacing, transparent surface tint, jawnych control styles i semantycznego koloru delete. Scrollable content i action overflow zachowują dostępność przy powiększeniu. Początkowy autofocus Close; Enter zwraca false. Wykonanie delete pozostaje poza widgetem po existing exact-mounted/cubit identity guards. `StorageVersionsDialog` po wydzieleniu ma302 linie.
- Final41048 **11/11 PASS**: dwa rzeczywiste widget tests 420×600, 200%, PL/dark+EN/light, hitTestable obu akcji, Enter Close i explicit confirm; dziewięć istniejących versions/preview regresji. Scoped analyzer50026 **No issues found**; scoped diff check exit0. Nie deklarować visual/runtime acceptance na podstawie widget testów.
- Flutter slot root zwolniony po41048. Navigation przygotowuje additive full ApiError w TasksViewError + typed QuickCreate failure/false i naturalny split; ARB `tasksQuickCreateFailed` jeszcze nieobecny podczas root rg, gen-l10n NIE URUCHOMIONY. Wykonać serialnie dopiero po confirmed source-ready od Nav, bez równoległego Flutter test/build.
- Sharing analyzer81120 wykazał błędy; Surface je poprawia oraz wdraża root review guards futureRetryAfter i thrown ApiError/Dio metadata. Root nie ma aktywnego Flutter test/build/generatora. Move UI5 nadal czeka na stable Sharing freeze. Backend currentObserver/storedOwner security+HTTP transitions nadal w toku. AgregatyP0–P7/runtime/benchmark/full końcowe bramki otwarte; bez commitu/pusha/deployu.

## 2026-10-01 — root: Versions dialog wymienia właściciela tylko po zmianie źródła

- Baseline88517 **2 FAIL**: wymiana repozytorium albo fileId nie zamykała starego VersionsCubita; jego odpowiedź wciąż zasilała dialog.
- Root dodał tani ValueKey do lokalnego MultiBlocProvider, oparty o fileId/version/name oraz tożsamość repository/downloadTransport przez ObjectKey. Stare lokalne Cubity zamykają się przy zmianie źródła; zwykły rebuild z tymi samymi parametrami zachowuje bieżącego właściciela. Lifecycle create/load pozostaje w tworzeniu lokalnego Cubita, bez efektów w builderach. Produkcyjny dialog ma 316 linii.
- Final60893 **12/12 PASS**: owner lifecycle3 (repo/file change i zwykły rebuild bez nowego GET) plus preview9 (wersja historyczna, prawidłowy ticket, ACL i trwałe błędy restore/delete). Scoped diff check exit0. Scoped analyzer33009 terminal **No issues found**, exit0.
- Navigation final99184 **6/6 PASS** QuickCreate po poprawnym dispose SemanticsHandle: Enter Cancel/templates/field, wymiana Cubita/kolumny, narrow200% trigger. Root source review potwierdza guards; naturalny split preferences/assignee/loader/QuickCreateCommands zaakceptowany jako następny pakiet. Do QuickCreateCommands dodać typed normalizację rzucanych błędów (obecne widget catch→rethrown w unawaited to luka), zachowując draft/error state, bez swallow catch.
- Root review Sharing wykazał brak guards futureRetryAfter w samym Cubicie oraz spłaszczenie rzucanych ApiError/Dio przez `on Object`; Surface otrzymał wymaganie poprawki przed finaltests. Sharing analyzer81120 rozpoczęty, jego final jeszcze nieodebrany. Move UI5 rerun czeka na stablegraph. Backend nadal domyka currentObserver/storedOwner dla active/rejoin/concurrent paths i rzeczywiste próby write; nie uznawać role etykiety za bieżący ACL.
- Root nie ma aktywnego Flutter test/build po60893. Nav99184 terminal, slot przekazany Surface; koordynować pojedynczy test/generator/build i freeze jego transitive graph. P0–P7/runtime/benchmark/pełne końcowe bramki nadal otwarte. Bez commitu/pusha/deployu.

## 2026-10-01 — root: Versions download busy/cancel jest jednoznaczny

- Baseline6508: **1 PASS / 2 FAIL**, istniejący busy restore PASS, nowe download feedback regresje potwierdziły null zarówno przy busy jak po close. Podgląd interpretuje null jako brak błędu, więc API feedback nie odróżniało niewykonanej operacji od powodzenia.
- Root poprawił `StorageVersionsCubit.downloadWithFeedback`: closed/stale zwraca `storage.action_canceled`, niedostępna operacja `storage.action_busy` (albo istniejący typed błąd/cooldown). Zachowany current error i guards generation; po zamknięciu pending ticket nie wywołuje DownloadTransport. Lokalny kod ma istniejące PL/EN mapowanie w PreviewActionErrorBanner; bez dodawania enuma HTTP/modelu API.
- Final5198 **10/10 PASS** (8 wcześniejszych +busy/cancel2), scoped analyzer91215 **No issues found**, diff check exit0. Root brak aktywnego Flutter test/build; slot przekazany Navigation dla izolowanego QuickCreate, następnie Surface.
- Root przygotował `storage_versions_owner_lifecycle_test.dart` z dwoma źródłami wymiany (repo lub fileId): stary owner ma się zamknąć, aktualny wykonać GET, nowy owner odpowiadać aktualnemu plikowi/repozytorium. Analyzer39590 final **No issues found**, exit0; baseline Flutter tych testów JESZCZE NIE URUCHOMIONY. `StorageVersionsDialog` keyed owner nadal niepoprawiony; następny root krok baseline → key/source ownership → selective widget/preview tests. Nie mylić przygotowanego testu z dowodem.
- Surface nadal kończy Sharing atomowy compileable slice/freeze; Move UI5 czeka na stabilny graf. Backend Transport pracuje nad roleObserver/currentACL i przejściem scope_revoked/rejoin; Nav QuickCreate focus/lifecycle. P0–P7/runtime/benchmark/full końcowe bramki pozostają otwarte. Bez commitu/pusha/deployu.

## 2026-10-01 — root: Versions typed exceptions i dalsze bramki P5

- Root baseline75735 **3 FAIL** w `storage_versions_vertical_test.dart` potwierdził nieobsłużone rzucane ApiError przy load/restore/delete; operacje nie wracały do typowanego stanu i pozostawiały loading/busy.
- `StorageVersionsCubit` (247 linii) normalizuje każde repository/DownloadTransport wywołanie do Either<ApiError,T>: ApiError zachowuje pełną diagnostykę; Dio normalizowany przez kanoniczny mapper; nieznany wyjątek daje bezpieczny typowany komunikat bez treści wyjątku. Istniejące guards generation/closed i zachowanie listy Ready/RetryAfter pozostają; żaden zapis nie jest automatycznie ponawiany.
- Final41981 **8/8 PASS**: wcześniejsze 5 wersji (ACL/download/cooldown/busy/close) oraz 3 nowe thrown regresje z odzyskaniem po load i zachowaniem wersji/fields/trace przy restore/delete. Scoped analyzer59407 **No issues found**, scoped diff check exit0. Jest to walidacja kodu, nie runtime/visual acceptance.
- Root review wskazuje następne luki do odtworzenia: `downloadWithFeedback` zwraca null także przy busy/closed/stale, co może wyglądać jak sukces podglądu; potrzebny typed busy/canceled oraz brak drugiego ticketu/transportu. `StorageVersionsDialog` MultiBlocProvider nie jest keyed po fileId/version/repository/downloadTransport, więc przy wymianie parametrów może zachować starego właściciela; wymagany widget lifecycle baseline i naturalne rozwiązanie. Nie deklarować tych punktów zamkniętych przez 8/8.
- Luny kontynuują: QuickCreate lifecycle/focus/200% i potem naturalny split Cubitów; Sharing typed errors/search/desktop responsive; backend Restore ACL role downgrade + rzeczywiste membership transition. Slot Flutter zwolniony przez root po41981; Surface i Navigation uzgadniają serialne testy/freeze grafu. Root brak aktywnego test/build/generatora. Move UI5 nadal czeka na stable Sharing compile graph.
- P0–P7, świeży uwierzytelniony runtime, benchmark §13 i pełne końcowe bramki nadal otwarte. Zachować uncommitted worktree; bez commitu/pusha/deployu.

## 2026-10-01 — root: BulkDelete zachowuje wynik po wyjątku

- Root nowe regresje per-file/per-folder oraz Dio receiveTimeout: pierwszy run30808 miał błąd fixture Right(null) zamiast Unit; po poprawieniu fixture baseline8952 **3 FAIL** odtworzył realną utratę wcześniejszych successes i diagnostyki przez ogólny catch Cubita.
- Poprawiony `StorageBulkDeleteCommands` (107 linii, zwykła klasa): normalizacja zwracanego i rzucanego ApiError, Dio oraz nieznanego wyjątku per pozycja. Zachowane `succeededIds`, `failedIds`, `notAttemptedIds`, pełne `apiErrorsById`; 429/futureRetryAfter oraz niepewny transport przerywają serię. Zwykły 409 nadal pozwala wykonać pozostałe pozycje. Brak automatycznego retry.
- Final81123 **21/21 PASS**: trzy nowe regresje plus osiemnaście istniejących mutacji/uploadu, w tym cooldown, ordinary conflict, busy/reset/close i idempotencja. Scoped analyzer7989 wskazał tylko prefer_const w trzech fixture; poprawiono wyłącznie const. Finalny scoped analyzer22336: **No issues found**, exit0. Root nie ma aktywnego Flutter test/build; slot Surface/Navigation, jeden proces naraz.
- Root review Restore: Source mapper canonical permissions i reconciliation po save są właściwym kierunkiem, ale test musi dowodzić pełnego przejścia członkostw. Transport dodaje baseline4active → real workspace revoke → delete4scope_revoked → restore3active/revokedleft; bez fałszywego finalOnlyContain. Dodatkowo root wykrył ryzyko zachowania historycznego Owner przy current `desiredRole=Observer`: StorageChatScopeProvider rozróżnia CanComment, a posting używa stored Role. Transport ma sprawdzić pełny auth path i dodać odmowę write dla byłego Owner po obniżeniu ACL, zanim uznamy Owner rejoin za poprawny. Canonical bieżące ACL ma pierwszeństwo przed zachowaniem etykiety roli.
- Navigation przygotował 4 focused QuickCreate lifecycle/focus/200% tests; scoped analyzer95162 był aktywny, wynik jeszcze nieodebrany przez root. Surface wciąż zmienia Sharing źródła; Move UI5 rerun czeka na stabilną kompilację wspólnego Shell grafu. Nie odtwarzać procesu na observation timeout. P0–P7/runtime/benchmark i full końcowe bramki nadal otwarte; bez commitu/pusha/deployu.

## 2026-10-01 — root: przenoszenie po zmianie scope i częściowy wynik przy wyjątku

- Baseline8051 rzeczywistego Shell UI wykazał niepożądany `createFilePlacement` po zmianie zakresu podczas otwartego pickera. Root przechwytuje Browser/Mutation/Repository/scope oraz niezmienną listę ID przed await i wymaga tych samych właścicieli/scope przed zapisem. Użycie kontekstu po await chroni dokładne `context.mounted`. Dotychczasowe globalne akcje zastąpiono klasą `StorageMoveAction` (103 linie); menu/wiersze/bulk/drag korzystają z jej metod.
- Rerun7332 testów Move UI zakończył się compile FAIL podczas równoległej podmiany Sharing Cubita przez Surface; **nie jest dowodem poprawności ani błędu nowej logiki**. Pełne 5 Move UI oczekuje stabilnego grafu Shell/Sharing i selektywnego rerun. Surface poinformowany o freeze podczas kompilacji.
- Baseline8616 wykazał utratę wcześniejszego sukcesu i typed diagnostyki przy rzucanym ApiError w drugim pliku batcha. Root dodał lokalną normalizację ApiError/Dio/nieznanego wyjątku per plik w `StorageFilePlacementMutations` (331 linie), więc batch zachowuje successes/failures/notAttempted i metadata. Niepewne błędy transportu zatrzymują kolejne żądania; brak automatycznego retry.
- Final27379 Placement **13/13 PASS**: rzeczywiste przenoszenie/create, wersja/idempotencja, konflikt, cooldown, częściowe wyniki i nowa regresja thrown503/RetryAfter/fullmetadata. Scoped diff check exit0. Analyzer29994 dla 6 plików produkcyjnych +2 testowych był uruchomiony; jego finalny wynik odnotować po terminalu.
- Analyzer29994 wskazał 3 linty; poprawiono kolejność importów, blok if i testową propagację `Future.error` bez wyciszeń. Final analyzer4928: **No issues found**. Targeted60060 regresji thrown API error po uporządkowaniu testu: **1/1 PASS**; produkcyjna semantyka niezmieniona po Placement13PASS. Root nie ma aktywnego Flutter test/build; slot Surface/Navigation, testy serialnie oraz freeze wspólnego grafu kompilacji.
- Transport raportuje final lifecycle **2/2 PASS** z canonical capabilities Owner/Editor i restore reconciliation. Root przejrzał źródła, lecz wymaga dodatkowej asercji przejścia członkostwa przed delete → scope_revoked → właściwy Rejoin oraz wykluczenia nieuprawnionych; samo final `OnlyContain(LeftAtUtc==null)` nie dowodzi revocation. Selective HTTP case po dodaniu tych asercji w toku. Nie zamykać jeszcze całego chat lifecycle gate.
- Root ma następny potwierdzony review gap w `StorageBulkDeleteCommands`: rzucany wyjątek w środku batcha nadal trafia do ogólnego catch Cubita i gubi wcześniej wykonane pozycje. Poprawić per-item typed normalizację i stop na niepewnym zapisie wraz z regresją zachowania sukcesów/pominiętych ID; nie uznawać istniejących testów zwracających Left za pokrycie wyjątku.
- Transport pracuje nad Restore capabilities/reconciliation `scope_revoked → Rejoin`; aktualnego testu88011 nie restartować na observation timeout. Surface: Sharing typed state/search/UI. Navigation: QuickCreate focus/owner/200% przed dalszym Cubit split. Agregaty P0–P7, runtime i benchmark pozostają otwarte. Bez full suites/commitu/pusha/deployu.

## 2026-10-01 — root: FolderPicker lifecycle poprawiony; feedback odebrany lokalnie

- Root baseline session28005: Shell mutations **12/12 PASS** po prawidłowym przewinięciu do bulk headers i asercjach `hitTestable`; FolderPicker **1 PASS / 2 FAIL** — wymiana repozytorium i spóźniona odpowiedź podfolderu nadpisywały aktualny widok.
- Root wydzielił naturalny `StorageFolderPickerCubit` (113 linii), `StorageFolderPickerContent` (120) i właściciela dialogu (210). Cubit kontroluje generation/close, przechowuje pełny ApiError, obsługuje rzucane ApiError/Dio oraz jawne retry blokowane Retry-After także przy próbie innej nawigacji. `didUpdateWidget` wymienia właściciela po zmianie repozytorium/scope; akcja potwierdzenia nie działa przy loading/error. Neutralna powierzchnia korzysta z Files/Tasks, bez domyślnego surface tint; lista/błąd przewijają się osobno od akcji.
- FolderPicker session17601 **3/3 PASS** po poprawce; final session50057 **5/5 PASS**, także zamknięcie właściciela i typed 429/cooldown bez dodatkowego requestu. Test 420×600/200% sprawdza widoczność Cancel/Confirm. To test widgetów, nie potwierdzenie wyglądu uruchomionej aplikacji.
- Finalny root scoped analyzer session47285 obejmujący trzy produkcyjne pliki FolderPicker i dwa pliki testowe: **No issues found**, scoped `git diff --check` exit0. Testowe importy uporządkowano po 5/5 PASS; logika bez kolejnej zmiany. Root nie ma aktywnego Flutter test/build/generatora; slot przekazany Surface, dalsza koordynacja z Navigation.
- Review Restore wykazał błędne capabilities w DTO: mapper `StorageEffectivePermissions.None` nie odzwierciedla uprawnień właściciela po przywróceniu. Transport ma poprawić przez kanoniczne `GetEffectivePermissionsAsync` i sprawdzić rzeczywisty JSON; nie traktować wcześniejszego 2/2 jako dowodu tej nowej poprawki.
- Surface: Document lifecycle + rzeczywisty bounded feedback **10/10 PASS**, idempotency **1/1 PASS**, scoped analyzer bez uwag i diff check czysty. Root Shell12 PASS rozwiązuje wcześniej zgłoszone ograniczenie przewinięcia `notAttempted`. Nowy pakiet: sharing dialog/search, typed errors, generacje, busy i desktop responsive.
- Navigation: batch11025 **72 PASS / 2 FAIL**; dwa seam defects poprawione rzeczywistym publicznym `KanbanQuickCreateTask` i finderem aktualnego panelu. Targeted60891 **3/3 PASS**, scoped analyzer/diff czysty. Route13 i date lifecycle4 PASS w batchu. Root review znalazł kolejne luki QuickCreate: Enter przechwytujący Cancel/templates, brak kontroli aktualnego Cubita/kolumny po await, trigger fixed34 przy200%. Ich poprawka ma pierwszeństwo przed ekstrakcją assignee/prefs Cubitów; pakiet nie jest ogólnie zamknięty przez te selektywne wyniki.
- Backend: odebrana ekstrakcja metadata/admin do naturalnych Application handlers i małych mapperów. Metadata HTTP **3/3 PASS**, admin OpenAPI **1 PASS**, scan enum/auth HTTP **1 PASS**, scoped format/diff czysty. Delete/Restore extraction i rzeczywiste ACL/DB/outbox testy trwają u Transport; final wynik odbioru jeszcze nieznany.
- Wszystkie fazy zbiorcze P0–P7 pozostają OTWARTE. Nie wykonano bieżących pełnych bramek, uwierzytelnionego Flutter runtime/E2E ani benchmarku §13. Dawny web bundle jest nieaktualny. Normalne logowanie do lokalnego TLS preview nadal wymaga użytkownika; nie używać cookie/token backdoor. Bez commitu/pusha/deployu.

# DevPlanner task modal — START HERE po restarcie Codexa

Checkpoint: 2026-10-01; ponowny zapis na wyraźne polecenie użytkownika przed restartem Codexa. Najnowszy stan poniżej i w checkpointach agentów. Cel pozostaje niezakończony.
Ten dokument jest punktem wznowienia; aktualny kod i nowe wyniki mają pierwszeństwo.




## 2026-10-01 — root: odbiór feedbacku odrzucony po rzeczywistym baseline

- Root źródłowo przyjął zakres Document lifecycle: operationId/scope/owner snapshot, capture Cubita przed dialog await, exact-state retained retry, pełny ApiError, cooldown create+retry i kontrola closed preview. Surface raportuje71529 8/8PASS oraz focused idempotency1/1PASS, scoped analyzer No issues; finalne dodatkowe open-dialog provider replacement/disposal testy jeszcze wymagane. To nie zamyka P5/UI.
- Root wykrył słaby dowód feedback200%: test umieszczał całą powierzchnię w zewnętrznym scrollu, którego produkcyjny StorageResponsiveContent nie ma. Nowy baseline35572 EXIT1 rzeczywiście reprodukuje **overflow618px** i niedostępne akcje przy420×600/200%. Surface dostała bounded wspólny error area z zachowaniem body oraz responsive banner actions, pełną diagnostyką i PLdark/ENlight. Nowy fix/tests pending. Nie utrzymywać dawnego twierdzenia o gotowości feedback200%.
- Navigation64108: agent raportuje route_page10/10 i route_scope3/3PASS po prawdziwym GoRouter harness (initState/dispose, stabilne ports). Batch nadal wymaga terminalnego wyniku; assignee tests6calls nie podają nowego wymaganego cardBuilder. Root wymaga rzeczywistego KanbanAssigneeTaskCard adaptera w testach, aby zachować sprawdzanie title/status/Draggable i nie ukryć regresji stubem. Search/date4/bulk końcowe wyniki pending. Nie uruchamiać równoległych Flutter commands.
- Transport rootreview odrzucił pomysł wydzielenia wyłącznie admin route mapping z delegacją do internal metod w godfile. Trzy admin operacje mają trafić wraz z własnymi HTTP adapters do zwykłego StorageAdminEndpoints, business ACL/load/save do Application. Request StorageScanStatus także wymaga pełnej klasyfikacji/wire audit. URLs/opIds/security mają pozostać zgodne. Pakiet w toku; wcześniejsze rename/description2/2PASS pozostaje aktualne.
- Wszystkie zbiorcze P0–P7 i odbiór aktualnego zalogowanego modala/Office pozostają otwarte. Brak pełnych gates, commit/push/deploy. Tab CUA3 zachowana; tylko wcześniejszy zwykły ekran logowania TLS został potwierdzony.

## 2026-10-01 — root: bezpieczny lifecycle komórki daty i review metadanych

- Root przygotował rzeczywiste widget regresje TaskCellDate. W batchu Navigation87706 dwa baseline FAIL: callback poprzedniej komórki wykonany po wymianie callbacku oraz po usunięciu komórki (actual1 zamiast0); kontrola dotychczasowego UTC calendar contract PASS. Root przeniósł async handler poza build, dodał mounted dla State i dokładnego cellContext, porównanie snapshotu wartości/callbacku oraz lokalny guard jednego otwartego pickera. Root8942 EXIT0 **3/3 PASS**. Source158linii; final scoped analyze19105 EXIT0 No issues. Czwarta regresja zmiany aktualnej daty podczas otwartego pickera dodana do następnego batcha Navigation, jeszcze bez wyniku. Nie zmieniono date-only/instant semantyki: cross-surface contract nadal otwarty.
- Navigation87706 końcowo15PASS/18FAIL: compile Storage import naprawiony root; część route tests nie używa prawdziwego GoRouter, nowy host go wymaga. Agent naprawia lifecycle harnessu i klasyfikuje wszystkie pozostałe failures przed poprawkami. Nie traktować tego przebiegu jako gotowości Kanbana. Search final clear handler również oczekuje tego powtórnego batcha.
- Surface Document source jest przygotowany, ale rootreview wymaga finalnych tests: op/scope/owner snapshot, retained callback guards, pełny ApiError w feedbackhost, RetryAfter w Cubit/UI, bounded diagnostics200% i jedna liveRegion głównego komunikatu. Surface ma następny serialny Flutter slot po root8942; Navigation czeka jej terminalnego wyniku. Brak równoległych Flutter build/test.
- Transport wydzielił rename/description do małych Application handlers; endpoint zostaje HTTP mapping, zachowuje ACL, expected xmin, realtime outbox i save/concurrency. Root źródłowo sprawdził DI, handler/token/helper i HTTP PostgreSQL test. Agent raportuje2/2PASS: owner/foreign DB unchanged, niepoprawne tokeny400, dwie concurrent próby jeden200+jeden typed409, DB zgodna z wygraną i tylko jeden nowy outbox. Końcowy przebieg także z5-byte token negative case2/2PASS; scopedformat Backend+Tests i diffcheck EXIT0. Handler/helper45/45/29linii; test202. Root source review przyjmuje pakiet; kolejny transport pakiet to naturalny podział HTTP mapping StorageEndpoints, bez zmiany kontraktów. Enum requestów brak, response Storage pełne zestawy objęte wcześniejszym audytem, brak zmiany wire shape.
- Wszystkie zbiorcze P0–P7 pozostają otwarte. Najnowsze common checklisty rozdzielają lokalne potwierdzone Search/File listener guards od niepotwierdzonego odbioru wizualnego i Document. Nie uruchomiono pełnych gates; brak commit/push/deploy. CUA tab3 zachowana do kolejnego odbioru; brak nowego dowodu zalogowania.

## 2026-10-01 — root: wyszukiwarka 200%, klawiatura i finalne guards Storage

- Root odtworzył regresję Enter na przycisku diagnostyki: baseline 62898 FAIL otwierał zaznaczone zadanie. Skróty Enter/strzałki ograniczono do osobnych, zwalnianych FocusNode pola zapytania i wyników; Escape nadal zamyka modal. Błąd z zachowanymi wynikami ma własny przewijany obszar, rozwijane diagnostyki są ograniczone wysokością, lista zachowuje osobny viewport. Jedna liveRegion przekazuje pełny komunikat bez powielania semantyki tekstów i bez ogłaszania co sekundę odliczania.
- Selektywne Search dialog + Cubit: 52493 EXIT0, **17/17 PASS**. Obejmuje PL/dark i EN/light przy 420×600/200%, długie pola błędów i traceId, zachowanie widoczności zaznaczenia po rozwinięciu szczegółów, Enter na diagnostyce, cooldown 429/503 i lifecycle timera. Scoped analyze 60728 EXIT0 No issues; po wydzieleniu nazwanego handlera clear i przywróceniu focusu zapytania także 87939 EXIT0 No issues. Powtórny test finalnego handlera w następnym selektywnym pakiecie Navigation. Produkcyjne pliki dialog/result widgets 355/350 linii. Testy jawnie zwalniają cooldown przed kontrolą pending timers; wcześniejsze niedokończone przebiegi nie są dowodem sukcesu.
- Root Storage listener końcowo: 63812 EXIT0 **17/17 PASS** (5 nowych scope/retry regresji + 12 Shell), analyze52071 No issues. Stary terminalny wynik nie odświeża nowego browsera ani nie pokazuje jego błędu; retained retry sprawdza exact failure state, właścicieli i scope. Aktualny retry nadal działa. Ten wpis zastępuje wcześniejsze pending retry guards.
- Review enumów: root odczytał rzeczywistą konfigurację HTTP i test pełnych zestawów przez IOptions<JsonOptions>, a także HTTP numeric400/tekstowe201 z typowanym błędem. Transport raportuje finalny selektywny7/7 PASS i scoped format; wartości persistence pozostają bez zmian. Front encode/decode bieżącej wersji wymaga jeszcze selektywnego przebiegu. Runtime Swagger przez proxy404; OpenAPI potwierdzają testy generatora, nie proxy.
- Kanban naturalny podział nadal WIP. Root Search launcher63132 wykrył błędy kompilacji ekstrakcji (imports services/typy, nullable public field, private constant); Navigation dostała poprawki i następny slot Flutter. Document packet Surface także WIP (naprawione StorageFileResponse import i BlocListener bloc); source analyze/test/review jeszcze wymagane. Nie uznawać format-only ani małych plików za compile/runtime proof.
- Sesja CUA tab3 nadal na zwykłym ekranie logowania lokalnego TLS; brak zalogowania, brak wizualnego odbioru modala/Office. Tab zachowana do kontynuacji. Build39631 pochodzi sprzed najnowszych zmian i wymaga odświeżenia po ustabilizowaniu pakietów. Wszystkie P0–P7 pozostają otwarte; pełne gates oraz rzeczywisty benchmark UI na końcu. Brak commit/push/deploy.

## 2026-10-01 — root: odrzucanie spóźnionych wyników Storage

- Nowe deferred widget tests odtworzyły dwie regresje: po wymianie browser/selection przy tym samym mutationCubit stary sukces wywoływał GET nowej listy, a stary failure publikował błąd w nowym zakresie. Baseline86441 oba FAIL (refreshes1 zamiast0 i niepusta errors).
- StorageFileMutationListener bierze jeden snapshot przy Loading; terminalny wynik jest obsługiwany wyłącznie gdy snapshot owners/scope nadal aktualne. Bez fallbacku do nazw nowego zaznaczenia. Root40863 14/14 PASS (2 nowe +shell12), analyzer31244 No issues. File259linii; diffcheck clean.
- Dodatkowo source-only zabezpieczono zachowany callback retryPlacementMove: dokładna failure state, mutationCubit, browser/selection owners, closed i scope. Repeated Loading nie nadpisuje snapshotu. Nowe trzy testy stale scope / inna operacja / valid current retry są dodane i scoped analyze91331 clean; ich uruchomienie czeka serialnego slotu po Search Surface. Wynik40863 poprzedza tę follow-up zmianę, nie uznawać całego retry packetu za zakończony.
- Surface rootreview: global Search cooldown musi przyjmować futureRetryAfter także ze starej query przed discard content. Luna dodała stale429/stale403, busyrelease i countdown lifecycle; selectiveCubit9/9 PASS. Widget diagnostics420x600200% odtworzył overflow129px i niedostępny wiersz, poprawka allocation/bounded open diagnostics w toku. Rootserialgen93297 EXIT0 dla Show/Hide diagnostics; wcześniejszy82298 EXIT0 dla title/countdown. Final Search UI/analyze pending.
- Transport cleanup/SRP: harness build0warnings/errors, BrowserHandoffStoreTests2/2, scoped format/diff clean. Existing collision file byte-identical; owned partialwrite usuwany, PFXbuffers zeroed. Root source review potwierdził naturalne SecureArtifact/TrustedLoader/HandoffStore. Następny pakiet Transport full flow enum coverage inventory, bez pełnej suite. Hold15458 nadal live według własnego poll/TLS200verify0.
- Navigation naturalnie wydziela switcher i assignee1017. Page527/42parts nadal niezgodne; root wymaga dalszego naturalnego splitu Page/ReadyContent poza parts przed deklaracją odbioru. Kanban selective checks czekają Surface slotu. Wszystkie P0–P7/runtime/full gates pozostają otwarte; bez commit/push/deploy.

## 2026-10-01 — root: neutralne potwierdzenie Delete i fresh web build

- Root zastąpił domyślne dziedziczenie stylu Storage delete confirmation tokenami Tasks/Files: canvas, border, scrim, radius, typografia i zwarte akcje. Material technicznie pozostaje, bez surface tint; maksymalna szerokość480 i scrollable treść. Domyślny focus Cancel; keyboard Enter nie usuwa danych. Zachowano capture owner/scope i guardy potwierdzenia. Plik162linii, nowy test89.
- Focused73453 14/14 PASS: PLdark/ENlight420x600200% bez overflow, widoczne akcje i Enter anuluje z zachowaniem zaznaczenia; shell12 regresji obejmuje current confirmation, cancel, provider replacement, delayed bulk/newselection i pełną diagnostykę. Final scoped analyze88368 No issues po const/import cleanup; rootdiffcheck clean. To widget/code validation, visual runtime tej ostatniej zmiany jeszcze niepotwierdzony.
- Fresh Front build39631 EXIT0: flutter build web --source-maps --no-tree-shake-icons (165.2s), Built build/web i Wasm dry run succeeded. Ten build poprzedza ROOT delete-dialog i bieżący Search/Kanban packet, więc nie jest dowodem ich runtime. Transport hold15458 udostępnia współdzielony build/web; po kolejnym buildzie zwykły browser reload. Pełny wasm build i wszystkie końcowe gates nadal wymagane.
- Navigation final columns/labels3/3 PASS i scoped analyze clean; mounted kontrolowane jawnie i tożsamość cubit/repository/scope zachowana. Agent przygotowuje naturalny Kanban split. Surface przygotowuje Search typed diagnostics+global cooldown i serialne2ARBkeys. Transport poprawia SecureArtifact collision cleanup (nie usuwać istniejącego cudzego pliku), zeroing PFX bytes i naturalny podział klasy poza Program.
- Root CUA karta3 na normalnym localhost login, markHandoff. Zwykłe logowanie wymagane przed authenticated visual acceptance; poproszono użytkownika o login bez przesyłania hasła do czatu. Brak bezpiecznego file→credential bridge w API CUA; nie dodawać auth backdoor ani cookie injection. Wszystkie P0–P7 nadal otwarte, brak commit/push/deploy.

## 2026-10-01 — root: PublicShare calendar i przygotowanie świeżego UI

- PublicShare expiry używa wspólnego zakotwiczonego TaskDatePicker zamiast showDatePicker. Handler przechwytuje kontekst przycisku, po await kontroluje oba mounted i busy; zachowuje koniec lokalnego dnia 23:59:59 zapisany UTC. Nie zmieniono API ani enumów. Test create/copy oraz compact calendar/manual date→footer Save→UTC expiry: 2/2 PASS9954. Scoped dart analyze60259 No issues po poprawce klamer; poprzedni analyze9228 wskazał tylko tę uwagę stylu.
- Surface końcowy placement12/12 i shell12/12 PASS, w tym wymiana providerów podczas confirmation i nowe zaznaczenie w czasie mutacji; scoped13files analyze No issues, diff clean. Root potwierdził capture owners/scope przed await i guards po nim. Potwierdzenie usunięcia nadal korzysta z domyślnego AlertDialog — otwarta luka wyglądu, kolejny pakiet root po świeżym buildzie. Typed per-item feedback pokazuje nazwy, UUID jako diagnostykę, code/trace/fields i osobne notAttempted.
- Trusted localhost hold15458 zweryfikowany przez agenta: TLS200/verify0, private handoff0600, 12 Ready/Clean dokumentów i120 wiadomości. Root CUA rzeczywiście otworzył stronę logowania przez normalny TLS, bez obejścia warning. To nie jest authenticated modal acceptance; istniejący Front build nadal starszy. Transport otrzyma slot freshFrontbuild po selective Navigation/Surface, bez pełnej suite.
- Root review Search ujawnił generic error surface i brak RetryAfter guard w retry/loadMore. Następny pakiet Surface po buildzie: pełna typed diagnostyka, deadline blokujący również zmianę query, owned timer cleanup, bez auto retry, zachowanie cursor/items. UI UX Pro Max i Impeccable Operate są aktywnie stosowane, nie tylko wpisane w AGENTS. Wszystkie P0–P7 oraz runtime/benchmark/full gates pozostają otwarte; bez commit/push/deploy.

## 2026-10-01 — root review po naturalnym podziale Listy

- Navigation źródła mają filelimit: TaskListCommandBar392, ColumnsButton59, MemberAvatar38, Labels78. Root review ColumnsButton ujawnił mounted bez owner/repository/scope identity po metadataGET. Navigation dodaje capture przed await, guard current/closed i typed unexpectedfailure oraz deferredGET replacement/disposal regression; l10n tasksListColumnsLoadFailed PL/EN dodany, generator/test jeszcze oczekują slotu. Kanban extraction wstrzymana do stabilizacji bieżących packetów i freshFrontbuild.
- Surface poprawiła listener callback widget.onError i subscribedprovider lifecycle. Root źródłowo potwierdził capture exact owners/browserScope przed confirmation oraz snapshot selection przy Loading; meaningful final tests still pending. PublicShare expiry nadal używa default Material showDatePicker — jawna otwarta luka stylistyczna z wcześniejszego audytu, do osobnego atomic packetu po stabilizacji aktualnego builda.
- Transport własny write_stdin5301 i ps/lsof potwierdziły LIVE hold+backend (rootsessionunknown nie oznaczało terminalu). Trustedlocalhost devcert mode scopedharnessbuild0warnings/errors; restart starego self-signed hold do nowego trustedlocalhost autorizowany, agent ma zweryfikować gracefulcleanup/terminal i nowy handle. Root source securityreview wymaga private0700 parenttempdirectory PRZED --no-password export, zamiast chmod pliku po eksporcie; poprawka w toku. SecureArtifact ma być osobnym normalnym plikiem poza wielkim Program, bez bypassTLS ani truststorechanges.
- Root/Navigation obecnie bez liveFluttercmd; Surface ma następny serial selectiveanalyze/testslot. FreshFrontbuild po stablecompile, authenticated UI niepotwierdzone. Wszystkie P0–P7 pozostają otwarte; brak commit/push/deploy oraz brak broadperformanceclaim bez profilemode.

## 2026-10-01 — root review Storage selection i przygotowanie UI runtime

- Root odczytał nowy Storage feedback/listener/delete-confirm packet i znalazł dwa rzeczywiste lifecycle problemy: owners pobierani dopiero po await confirmation oraz completion usuwające bieżące nowe zaznaczenie. Surface przeniosła capture owners+browserScope przed confirmation, dodała exact identity/closed/selection guards i normalną StorageDeleteConfirmation zamiast globalnej funkcji. Listener ma snapshot przy Loading i usuwa tylko faktycznie zakończone IDs. Testy nowych regresji jeszcze do wykonania; final source review wykrył też `onError` zamiast `widget.onError` i brak subskrybowanej provider dependency, przekazane do naprawy przed analyze. Nie deklarować pakietu gotowego.
- Root wymaga nazw plików/folderów w feedback z utrwalonego selection snapshot, UUID tylko jako diagnostyka, failed vs notAttempted oddzielne i bez automatycznego retry uncertain mutation. Surface podzieliła shell/listeners/responsive widget na zwykłe klasy; compile/import stabilizacja w toku. Globalny limit400 dotyczy całego pliku.
- Navigation labels test1/1 PASS99029 PL/EN i scoped analyzer5paths No issues. Root pomiar task_list_command_bar.dart458 +labelhelper78 ujawnił nadal przekroczony filelimit, mimo class396. Navigation wydziela naturalny avatar i przycisk kolumn; dalszy Kanban refactor po zamknięciu tego packetu. Szeroki row test NIE PASS po in-flight StorageKeyboardShortcuts missingimport; Surface import poprawiła, rerun nadal wymagany.
- Root CUA próba https://127.0.0.1:54791 zatrzymana ERR_CERT_AUTHORITY_INVALID. Nie omijano TLS warning. Transport potwierdził już system-trusted localhost devcert i przygotowuje opt-in użycie go w chronionym disposable harness (localhost SAN, secureBFF retained, no secrets output). Root poll5301 zwrócił Unknown process id; agent ma zweryfikować własny handle i actualprocess, nie restartować wyłącznie po root observationfailure. FreshFrontbuild czeka stablecompile/serialslot; obecne build/web stale30.09, nie używać jako dowodu obecnego UI.
- Całość P0–P7 otwarta. Brak commit/push/deploy; visual runtime i wszystkie końcowe bramki nadal wymagane. Source review nie jest profile-mode pomiarem wydajności.

## 2026-10-01 — root: search 200% i aktualny protokół Storage

- Root nowy test420x600/dark/PL/200% odtworzył horizontal RenderFlex overflow134px (FAIL5614). Podpowiedź klawiaturowa teraz zawija się w Expanded. Wspólna TasksGlobalSearchGeometry22 wylicza wysokość wyniku z Tasks typography i TextScaler; ListView i skok klawiatury używają identycznej wartości. Tytuł ma dwie linie i tooltip pełnej treści. Dialog314/result113, bez parts/helperów budujących fragmenty.
- Root review według flutter-state-management znalazł _load bez catch, pozostawiający Loading po thrown adapter error. Cubit136 zachowuje ApiError/Dio typed metadata, mapuje unknown na bezpieczny tasks.search_failed, kontroluje generation/closed po await i publikuje unmodifiable items. Regresja cursor throw zachowuje poprzednie wyniki i cursor, a retry odzyskuje dane. Nie zmieniono publicznego API ani enumów transportowych.
- Search final3files11/11 PASS65760: throw/retry cursor recovery i unmodifiable items, scale200%420x600,20skoków klawiaturą z selected item hitTestable, search launcher replacement/disposal/current. Scoped analyzer6paths53475 No issues. Poprzedni78576 miał8PASS i compilefailure launcher przez in-flight Storage imports i label/l10n; agenci poprawili brakujące imports/args/const i wygenerowali l10n przed rerunem. Analyzer77153 prefer_final_locals poprawione. Brak authenticated Search visual runtime; te dowody są widget/Cubit.
- Transport raportuje rzeczywisty lokalny authenticated Storage harness53390 EXIT0: DOCX/PNG ticket+PUT+Complete Ready/Clean, pending taskmetadata dostępne/content403, download/stream hash+size, Word/editable Office config, PNG inline hash/type, activeMember dostęp, foreign/revokedMember403 wszystkich content/Office paths, owner retained. Cleanup DB/browser/proxy/ownedobjects wykonany, brak liveprocess. Root nie uznaje tego za Flutter modal ani działający Office editor UI. Wcześniejsze PNG mismatch było błędną asercją undefined image.hash, foreign404 sprzeczne z obecnym Storage403 kontraktem; poprawiono testy, nie osłabiono ACL.
- Nowe AGENTS wymagają flutter-state-management; root przeczytał skill i lifecycle/async references oraz skille microsoft-docs/code-reference, przekazał wymagania Lunom. Obecny ALL_TOOLS nie udostępniał Sereny/Microsoft Learn; backend agent sprawdza właściwy fallback. CUA inventory działa, DevPlanner native nie jest uruchomiony; brak aktualnego authenticated UI capture. Następny Transport packet przygotowuje disposable hold/runtime dla Front review.
- Navigation nowa menu lifecycle regresja1/1 PASS +scoped analyzer No issues; PL/EN gen-l10n zakończony, etykiety w dalszym selektywnym review. Surface placement/per-file feedback w toku. Całość P0–P7 otwarta, pełne bramki na końcu, bez commit/push/deploy.

## 2026-10-01 — root: przerwanie bulk delete po ograniczeniu API

- Usuwanie zbiorcze nie wysyła dalszych żądań po HTTP429 (również bez deadline) ani po błędzie z przyszłym Retry-After. Zwykły per-item409 nie blokuje pozostałych elementów. Snapshot kolejki powstaje przed await; generation/closed kontrolowane przed i po każdym wywołaniu.
- Normalna klasa StorageBulkDeleteCommands78 linii wydziela sekwencję z Cubita316. Lokalne stany UI partial/failure212 mają notAttemptedIds (domyślnie puste), oddzielne od failedIds/apiErrorsById. Nie dodano API/DTO/transportowego enuma ani zmiany jego wartości przewodowych. Listy wyników i mapa errors są unmodifiable.
- Root storage_mutations_and_upload_test18/18 PASS73990: partial i failure zatrzymują się przed następnym plikiem, folder429 bez deadline oraz503 z deadline pomijają dalsze foldery/pliki, ordinary409 kontynuuje, późniejsze akcje respektują cooldown. Scoped analyze4paths No issues5348 po poprawce import-order; diff-check rootpaths clean. To kod/Cubit, nie odbiór UI.
- Następny pakiet Surface: ta sama reguła dla placement moveMany i UI per-item diagnostics. Zarówno Shell listener, jak i delete-confirm helper dotąd czyściły selection przy partial/unconditionally; muszą zachować failed+notAttempted. Nie oznaczać untouched jako faktycznie failed ani automatycznie powtarzać niepewnej mutacji.
- Surface raportuje timezone selective75/75 +picker2/2 i scoped analyzer14 No issues; Backend catalogue project-read/host-list1/1 PASS. Root odczytał immutable factory snapshot i guards przed selection/search/retry; authenticated runtime/visual acceptance nadal otwarte. Navigation wykonuje kolejną menu lifecycle regresję; Transport rzeczywisty DOCX/PNG/Office protokół. Całość P0–P7 otwarta, bez full suite/commit/push/deploy.

## 2026-10-01 — review task scope i aktualne dowody selektywne

- Root zakończył rerun nowoczesnych asercji semantic tree: task_error_announcement_test 3/3 PASS45485, wcześniej scoped analyzer No issues53036. To dowód widgetowy; native screen reader i authenticated visual runtime nadal otwarte.
- Root odczytał BulkCompleteTaskAttachmentsHandler: jedno zapytanie przed jakąkolwiek mutacją sprawdza wszystkie UUID, moduł Workspaces, resourceType Task, kanoniczny taskId D, workspace/project oraz undeleted. Niezgodność daje neutralne404. Test HTTP/PostgreSQL mixed valid+otherTask+otherProject+Private sprawdza brak CompletionClaimId/PendingStorageObjectKey/Ready we wszystkich czterech plikach. Transport raportuje selektywne6/6 PASS; root źródłowo potwierdził zakres testu. CompleteStorageUploadHandler187, verifier98, bulk60, scoped facade55 — normalne klasy Application. Unexpected infra błędy propagują do wspólnego500, oczekiwane błędy per-file zachowują kod i bezpieczny powód. Pełne suite nieuruchamiane.
- Navigation raportuje świeży isolated root popup capture1/1 PASS (6s): message menu i reakcje namalowane nad modalem, route current/animation1. PNG fixture zaktualizowane; emoji tofu pozostaje luką. To nie authenticated runtime ani końcowy benchmark. Menu/layout14/14 PASS i scoped analyzer No issues dotyczą stanu przed kolejnym root review.
- Root review AppContextMenuPanel wymaga jeszcze didUpdateWidget dla row keys/highlight oraz exact mounted/source identity w deferred ensureVisible. Przekazano Navigation; wynik poprzednich testów nie zamyka tej luki.
- Root serial gen-l10n64366 EXIT0 dla taskRecurrenceTimeZoneLoadFailed PL/EN. Surface dopina guards parent/source/selectionScope i typed thrown failure + finally loadera. Root znalazł lazy factory odczytujące mutable widget scope oraz stale retry/search; wymagane immutable snapshot i source guards przed zapytaniem. Nowe testy/analyzer nadal oczekują finalnych poprawek.
- Wszystkie P0–P7 pozostają otwarte. Następne: domknąć powyższe lifecycle regresje, UI pełnych per-file błędów bulk, rzeczywisty DOCX/PNG/Office protokół i authenticated visual acceptance. Brak commit/push/deploy; końcowe pełne bramki dopiero po realizacji planu.

## 2026-10-01 — Impeccable Operate i semantyka komunikatów błędów

- Nowe instrukcje użytkownika wymagają UI UX Pro Max oraz Impeccable dla Web/desktop. Root przeczytał `impeccable/SKILL.md`, wybrany playbook Harden, kierunek Operate i craft-floor. `scripts/impeccable context --target lib/workspaces/presentation/tasks/detail/modal/task_details_modal_shell.dart` z cwd Front nie uruchomił się (permission denied, exit126); użytkownik został poinformowany przed następnym toolcall. Nie zmieniano uprawnień/installacji. Brak PRODUCT.md/DESIGN.md w repo; fallback to istniejący plan, Tasks tokens i aktualne źródła/captures. Nie zastępować dużego modalu inną architekturą z powodu domyślnych estetycznych preferencji skillu.
- Root dodał live-region do głównego błędu detalu i Preview/Office, oddzielając go od diagnostyki i przycisku Retry. MergeSemantics zachowuje read-only SelectableText oraz longPress. W Office ogłaszany jest jeden konkretny komunikat, nie osobno tytuł i treść. Źródła: TaskDetailsModalError240 linii, StoragePreviewFailureView175.
- Nowy `task_error_announcement_test.dart`: Preview, Office, zmiana błędu detalu, flaga isLiveRegion, rzeczywista treść value i osobny przycisk Retry — 3/3 PASS47800. Pierwsze próby miały błędny teardown semantics handle, następnie błędną asercję pustego label zamiast value. Root odczytał prawdziwe drzewo: SelectableText przechowuje komunikat w value, z isReadOnly/isFocusable/longPress. To NIE było potwierdzenie pustej treści w UI; wcześniejsze sformułowanie w commentary skorygowano. Po mechanicznym zastąpieniu deprecated hasFlag przez flagsCollection analiza3pathsNoissues53036; ponowny run nowych asercji jeszcze do wykonania. Native screen-reader ogłaszanie i visual runtime niepotwierdzone, test semantic tree nie zastępuje tego dowodu.
- Root serial `flutter gen-l10n` po sygnale Surface keysready EXIT0. Cztery klucze search/no-results/unlisted-current/schedule-hint wygenerowane. Surface zastąpiła niedostępny Symbols.info_outline_rounded przez Symbols.info_rounded. Jej picker nadal WIP: root wymaga source identity guards, Retry-After/busy, usunięcia kopii businessstate w setState, responsive/scrollable error view i plików<400. Nie deklarować stable compile przed jej sygnałem.
- Navigation raportuje AppContextMenu14/14 PASS29720 z painted panel margin12 przy420x320/200%. Popup capture62000 zatrzymał się na in-flight Surface l10n/icon compile, więc nie wykonany. Root zaakceptował final tworzenie animacji w route.install i dispose, zamiast lazy creation w buildTransitions. Naturalny podział wspólnego menu na normalne pliki235/151/191/376 w toku finalnej analizy/testów; bez partów/mixinów. Re-export nie powinien przypadkowo ujawniać wcześniejszego private entry model.
- Transport bulk packet: Application CompleteStorageUploadHandler283 +BulkCompleteStorageUploadsHandler60, endpointbusinesslogic przeniesiona do warstwy Application. Unexpected infrastructurefaults mają propagować do wspólnego500, expectedper-file błędy zachowują bezpieczny kontrakt; taskattachmentsroute injectujehandler i zachowuje TaskAccess.RequireWrite. Compile/fault-injection/recovery jeszcze w toku; root wymaga realnego sprawdzenia DB po durable steps i przydatnych bezpiecznych powodów walidacji zamiast generictext.
- Wszystkie P0–P7 nadal otwarte. Pełne suite i platform gates na końcu. Brak commit/push/deploy, brak twierdzenia o przewadze nad Asana/ClickUp/Jira bez benchmarku.

## 2026-10-01 — root bulk cooldown i dalszy review

- Root znalazł i odtworzył błąd: stan bulk przechowywał per-item429 z Retry-After, ale późniejszy409 jako apiError omijał cooldown. Dwie regresje dla failure i partial success FAIL29547. Guard wybiera teraz najpóźniejszy deadline ze wszystkich per-item API errors; download feedback zwraca właściwy blocking error, zachowując pełne dane. Mutations/upload + placement25/25 PASS91909, analyze2pathsNoissues6754, diff-check clean. StorageFileMutationCubit374 linii. To nie dowodzi jeszcze zatrzymania dalszych elementów wewnątrz rozpoczętej operacji zbiorczej po globalnym429.
- Root source review ujawnił, że Shell partial-error listener nadal pokazuje tylko ostatni tekst i ignoruje apiErrorsById oraz część diagnostics. Kolejny backlog Surface po timezone: osobny mały typed listener/panel z per-item diagnostics, zachowaniem failed selection i bezpiecznym retry; naturalny podział obecnego Shell>400. Stan per-item nie oznacza pełnej obsługi UI.
- Root drugi review backend testów potwierdził pełny named BrowserHandoff wire shape i pozytywny unread/count baseline dla wiadomości peer. Transport raportuje wspólny focusedrun TaskChatArchiveAclPostgresTests + BrowserHarnessContractTests2/2 PASS. Te testy nie są pełnym runtime/front E2E.
- Navigation popup suite46174 przerwano kontrolowanie po ograniczonej diagnostyce: runner/tester żyły, spały CPU0, ostatni event dark1440. Run NIEPASS/INCOMPLETE; edge finder błędnie mierzył cały host overlay, a dark1440 await/teardown jeszcze niezdiagnozowany. Isolated namalowane menu/reaction captures nadal są dowodem timing0→1, nie całej suite. Root review wymaga przeniesienia tworzenia CurvedAnimation z buildTransitions do install/lifecycle; lazy `??=` w build także narusza pure-builder rule.
- Aktywne Luny: Transport — Application completion/bulk handlers, expected exceptions i post-durable recovery; Surface — typed server timezone catalogue+searchable web picker; Navigation — pure animation lifecycle, poprawny panel geometry test i bounded fixture diagnostic. Root ma czekać na serialgen-l10n po sygnale Surface keysready. Nie współbiegać Flutter testów na tym samym build cache.
- UI UX Pro Max nadal wymagane i stosowane; root dodatkowo targeted UX error-summary/validation query. Końcowy visual/runtime/benchmark odbiór i P0–P7 pozostają otwarte. Daty: pytanie o semantykę nadal oczekuje odpowiedzi; nie zgadywać zgody na zmianę API.

## 2026-10-01 — root search review i potwierdzone piksele popupu

- Root odtworzył dwie regresje: callback starego Search dialogu nawigował po wymianie repozytorium i po dispose właściciela (39503, 2 FAIL). Launcher teraz porównuje captured Cubit z aktualnym właścicielem i mounted; śledzi oddzielnie Cubit dialogu, aby zamykać pośrednie repozytoria przy wielokrotnej wymianie. Stary wybór zamyka dialog bez nawigacji. Trzy testy launcher: replacement/disposal/current; aktualny zakres nadal otwiera poprawny canonical task query. Razem launcher/dialog/cubit8/8 PASS21878, analyze2pathsNoissues41620, diff-check clean. Pierwsza próba24395 miała błąd brakującego NativeAssetsManifest przy współbieżnych komendach Flutter; po terminalnym zakończeniu innych testów powtórzono zakres bez czyszczenia build. Koordynować Flutter testy w jednym wspólnym cache.
- Root obejrzał oba nowe RenderView PNG message-menu/reactions. Popup jest namalowany. Navigation potwierdziła animation.value0 po pierwszym pump450, potem1 po dodatkowych150ms. Nie był to dowód błędu produkcyjnego z-order. Reaction emoji fixture nadal tofu; menu przy dolnym edge i light/dark/200% acceptance pozostają otwarte. Losowe legacy tło shellu nie jest stabilnym finalnym benchmarkiem UI.
- Transport raportuje batch archive ACL test PostgreSQL1/1 PASS. Root source review potwierdził poprawny predykat archived task, ale znalazł niepełną listę JSON pól w BrowserHarnessContractTests fixture oraz brak positive unread/count baseline w nowym teście. Przekazano Lunie do korekty i selektywnego rerunu obu klas. Bulk complete catch-all jest jej następnym pakietem.
- Surface doprecyzowuje recurrence zone catalogue zgodny z TimeZoneInfo serwera (typed API), zamiast przedstawiać lokalny hardcoded/IANA katalog jako pełne host support. Front picker i error/retry muszą być neutralne web Tasks i zgodne z UI UX Pro Max.
- Root zadał tekstowe pytanie o semantykę start/due: UTC instant data+godzina czy dzień kalendarzowy. Brak odpowiedzi nie jest zgodą na zmianę kontraktu; niezależne poprawki trwają. Całość P0–P7 pozostaje otwarta.

## 2026-10-01 — NAJNOWSZY STAN: Office scope, audyty i kolejne pakiety Lun

Ten wpis zastępuje starsze opisy otwartych luk ownership oraz stan poprzednich pakietów.

- Root: kontroler OnlyOffice anuluje oczekujący export/close po detach; stary close nie niszczy nowego delegata. Scope/generation, Future.any i anulowalny timeout mają jawnego właściciela. Port JS nie pozwala fizycznie anulować już wysłanego skryptu; wynik starego zakresu jest odrzucany. `storage_onlyoffice_controller.dart` 201 linii. Trzy regresje baseline FAIL, kontroler+Host 13/13 PASS (96228), scoped analyze bez problemów (15803).
- Root: wymiana odziedziczonego StorageRepository w OfficeDialog wcześniej pozostawiała stary Cubit otwarty. Nowa regresja FAIL65126 potwierdziła problem. Repozytorium jest teraz rozwiązywane i obserwowane w lifecycle, nie w build; zmiana zakresu zamyka stare Cubity, wymienia host i odrzuca opóźniony wynik. Dialog 139 linii. EditorDialog + controller lifecycle 11/11 PASS (81535); `flutter analyze` dwóch dotkniętych plików bez problemów (4020), diff-check clean. To test widgetowy, nie rzeczywista sesja OnlyOffice.
- Surface zakończyła lokalny pakiet typed busy/canceled/failure, Retry-After i per-item bulk errors. Raportowane selektywne wyniki: mutations/upload13/13, placement10/10, versions5/5, preview9/9; analyze i diff-check clean. Root będzie sprawdzał finalny diff; pełny odbiór pozostaje otwarty.
- Navigation zakończyła atomic search: raportowane5/5 i scoped analyze clean, normalne małe klasy. Root review i pełne back/refresh/E2E nadal potrzebne.
- Trzy raporty read-only: backend, cross-stack i front-ui w `docs/task-modal-*-audit-2026-10-01.md` (front-ui może być jeszcze w przygotowaniu). Root potwierdził batch TaskChatScopeProvider pomijający archived task; Luna Transport naprawia ACL i dodaje inbox/search regresje. Navigation poprawia lifecycle animacji AppContextMenu oraz capture otwartych popupów. Surface przygotowuje searchable timezone picker, bez edycji globalnej semantyki dat.
- Korekta Pending: GET storage file details jest content gated; metadane statusu Pending należy odzyskać przez GET task attachments. W DOCX/PNG run83925 upload osiągnął Ready/Clean, lecz asercja Pending file-details403 zatrzymała weryfikację dalszych wyników. Nie oznacza to potwierdzonej regresji ACL. Download/stream/Office/preview wymagają poprawnego kolejnego protokołu.
- Obowiązkowe UI UX Pro Max zapisano w AGENTS obu repo. Skill przeczytany i używany: root Flutter state/lifecycle query; Surface UX focus/overlay + Flutter. Wyniki muszą respektować webowe tokeny List/Kanban. Brak kompletnego wizualnego odbioru light/dark/200%, authenticated Front E2E i benchmarku konkurencji.
- Due/start semantyka nadal niespójna: List UTC midnight, Kanban local midnight→UTC, detail zachowuje local time. Root nie zmienia kontraktu na date-only bez rozstrzygnięcia domenowej semantyki. Całość P0–P7 otwarta. Pełne bramki dopiero na końcu; bez commit/push/deploy.

## 2026-10-01 — NAJNOWSZY STAN: host lifecycle, daty i korekta dowodów DOCX

Ten wpis ma pierwszeństwo przed poprzednimi checkpointami i twierdzeniami o DOCX.

- Root Host: dwie realne regresje old callbacks po replacement/dispose FAIL43881
  (5 oraz1 nieuprawnionych callbacków). Po source/generation guard Host8/8 PASS40689.
  Dodano także delayed initialization/load-error i ochronę nowego timeoutu:2/2 PASS91051.
  Host279 linii +pureSurface142, żadnych partów ani global functions. Scope/session/
  factory/hostController change tworzy nową generację; callbacks i async catch ignorują
  stare źródło przed zmianą timerów/stanu. UI surface wydzielony normalnie.
- Root calendarUTCdate: test TZ=America/Los_Angeles baselineFAIL59709 (UTC1.10 pokazało
  30.9). Picker zachowuje komponenty dnia kalendarzowego; timestamp musi zostać
  przeliczony przez caller PRZED przekazaniem, co opisano w API widgetu. Cały picker
  w tej strefie7/7 PASS56258, scoped pickers+Office+tests analyze38151Noissues;
  diff-check rootpaths clean. Nie zmieniono transportenum/DTO.
- OTWARTE: audyt semantyki due/start dat end-to-end List/Kanban/modal (część callers
  zachowujeUTCcalendarDate, część .toLocal i godziny). Nie usuwać konwersji instantów
  globalnie bez contract audit. Pending close/export HostController ownership przy
  detach nadal wymaga dopracowania; callback guards nie zastępują anulowania zasobów.
- KOREKTA TRANSPORT: dawniej opisane DOCX/PNG CompleteCleanReady/download/stream oraz
  Office404 NIE SĄ POTWIERDZONE. Harness używał stage=complete dla sukcesu i porażki;
  docx.fileId było undefined i stąd bodyless404 na błędnej ścieżce. Nie jest to dowód
  backendowego braku route ani ACL. Właściwe source routes istnieją. Nowy storage-only
  run81748: DOCX ticket+PUT PASS, CompleteHTTP400, zatrzymanie przed dalszymi requestami.
  PNG/Office config/download/foreign/revoke tego pakietu nie wykonane; przyczyna400
  jest kolejnym zadaniem Transport. Reserved MinIO DOCX object cleanup PASS. Brak
  aktywnego harness procesu. Wcześniejszy realTXT Chat run75634 EXIT0 pozostaje ważny.
- Surface raportuje versions/placement/preview29/29, mutation/upload8/8 PASS, scope
  analyzer16pathsNoissues przed dalszym review. Root znalazł historypreview fallback
  na currentfile — poprawione przezSurface, regression9/9previewPASS. Root potem
  wykrył missinginitialclosed/busy/generationguard w Mutation i Versions.load;
  Surface teraz domyka lease/RetryAfter/resetlateanswer, więc pakiet NIEZAKOŃCZONY.
- Navigation roundtrip draft po Conversation→Work→Split potwierdzony focused1/1;
  rootPopup capture dalej niepotwierdzone pomimo routecurrent i hitTest. Nowy search
  UI consumer w toku normalnymi klasami, opened controls muszą być Tasks desktop.
- Root procesy terminal: wszystkie wskazane powyżej. Trzy Luny nadal pracują;
  ich aktywne handles sprawdzać w ich checkpointach/statusach. Pełne P0–P7 nadal
  otwarte, full gates na końcu, bez commitu/pusha/deployu.

## 2026-10-01 — root review kalendarza i sesji Office (po zapisie restartowym)

- Calendar: manual field sync po selectedDate (wcześniej FAIL1.10 zamiast15.10),
  właściwa kolumna tygodnia (PL/EN dwie regresje FAIL→PASS), strict month bounds,
  global date/month helpery zastąpione normalnymi klasami. Focused picker+custom
  lifecycle8/8 PASS session66517. Scoped analyzer calendar/recurrence/Office test
  siedem plików No issues found32508. Recapture kontrolki Navigation w toku.
- OfficeCubit: closed guard, busy guard, generation po closeSession/close i po await;
  pełny ApiError +RetryAfter respektowany. Trzy regresje lifecycle baselineFAIL13407,
  po poprawcePASS. Nowy fullApiError/earlyRetry test i widoczna diagnostyka w real
  EditorDialog2/2 PASS85758. Nie zmieniono publicznego DTO ani transportowego enuma;
  statefailure to lokalny UI, wcześniejszy pełny wire audit pozostaje wymagany.
- Duży OfficeEditorView podzielony na normalne biblioteki view196/body72/banners162/
  toolbar215. Neutralna Tasks paleta toolbar/canvas/badges/close dialogs, wysokość44.
  Close confirmation to normalna klasa+widget, bez globalnej funkcji; po await exact
  mounted i aktualność actions Cubita, nie maskuje stale scope. Wspólny FailureView
  dostał opcjonalny title dla pełnej Office diagnostyki.
- Office host/controller dotychczasowy part usunięty: normalne controller137 i
  WebView adapter213, kompatybilne exports hosta. Usunięto logowanie pełnych signed
  export/saveAs URL i raw export payload. Nie ma nowych logów sekretów.
- Focused Office+preview35/35 PASS95926 przed nowymi2testami; nowe2PASS85758;
  po usunięciu part Host+EditorDialog13/13 PASS94362. Scoped Office/host analyze
  No issues found86258; wcześniejszy szerszy Office+3testy+FailureView70347Noissues.
  Nie uruchomiono pełnych suites/buildów ani deploymentu.
- NADAL OTWARTE: Host initialize/load/bridgecallbacks potrzebuje generation/source
  guards i jawnego ownership pending close/export po replacement/dispose (root
  review odkrył brakguard przed callbackami docReady/state/download/saveAs/print).
  Nie uważać part extraction za rozwiązanie tych wyścigów. W OfficeDialog fallback
  inheritedrepository replacement wymaga review; testpokrywa explicitrepository.
  Pełne action error/draft audit i real Office runtime także niepotwierdzone.
- Luny aktywne: Surface recovery/bulk/placement typederrors i testy; Navigation root
  popup capture/identity/search; Transport actual404 route shape diagnostics, nie
  osłabiaACL. Obecny backendOffice404 pozostaje niewyjaśniony. P0–P7 nadal otwarte.

## AKTUALNY CHECKPOINT PRZED RESTARTEM — 2026-10-01T08:50:47+02:00

Ten wpis MA PIERWSZEŃSTWO przed starszymi sekcjami tego dokumentu i dawnymi handles.
Użytkownik prosi o zapis stanu przed restartem. Nie zaczynać od ponownej implementacji
naprawionych luk. Żadna zbiorcza faza P0–P7 nie jest zaakceptowana jako zakończona.
Nie wykonano commitu, pusha ani deployu. Wszystkie zmiany pozostają na dysku w obu repo.

### Zrobione i sprawdzone od poprzedniego checkpointu

- Shared Storage preview: generation/closed guards, pełny ApiError, retry tego samego
  pliku/historycznej wersji z Retry-After, osobne normalne widgety body/failure,
  lifecycle tekstowego transportu. Root focused 18/18 PASS (session10053).
- Pobieranie historycznej wersji przestało pobierać aktualny plik. Rzeczywista regresja
  FAIL→fix; versions + error view 10/10 PASS (session20305). Surface obecnie rozszerza
  ten callback o asynchroniczny ApiError widoczny NAD aktywnym preview; patrz poniżej.
- Office editor dialog: host controller jest stabilny przy przebudowie; zmiana repo
  zamyka stary lokalny Cubit i odrzuca spóźniony wynik. Root 5/5 PASS (49301) plus
  osobny repository replacement 1/1 PASS (85805). Dialog 123 linie. Host/View nadal
  wymagają review i naturalnego podziału; nie oznaczać całego Office jako gotowe.
- Recurrence: zapis nie tworzy nowej reguły podczas GET istniejącej lub po jego błędzie;
  zachowuje strefę reguły i przelicza lokalnie wybraną godzinę na ten sam moment UTC.
  Osobny TaskRecurrencePayloadComposer 58 linii, Cubit 377. Root recurrence + pełny
  Dart task enum roundtrip 12/12 PASS (83876). Po analizie usunięto import i dodano
  braces; analyzer po tej ostatniej kosmetyce jeszcze NIE powtórzony.
- Backend root focused Chat scope revoke + Comment ticket HTTP 12/12 PASS (66741).
  Comment ticket korzysta z aktywnej własnej temp-session i kanonicznego task scope;
  GUID N normalizowany do D, cancel usuwa rezerwacje. Transport harness75634 EXIT0:
  real private TXT ticket→MinIO PUT→actual Clean/Ready→copy→Chat message→owner/member
  metadata i revoke. To HTTP/protokół, NIE dowód gotowego Flutter UI ani Office GUI.
- Navigation: stabilny pojedynczy slot pełnego Chat przy przełączaniu split; task-only
  desktopWebComposer (globalnie default false), prostokątny przycisk wysyłki. Root
  obejrzał dark1920, compact date i file menu. Kotwiczenie file menu przy wierszu jest
  poprawione. Cały benchmark/keyboard/200%/otwarte menu nadal niezaakceptowane.
- Preview scoped analyzer59548 był terminal No issues found przed kolejnymi zmianami
  Surface. Nie traktować go jako analizy późniejszego callbacku/download refactoru.

### Konkretne otwarte zadania i bieżąca własność

1. ROOT — data: nowy test `calendar selection updates manual date and cannot be
   reverted by apply` w `test/workspaces/presentation/tasks/list/task_date_picker_test.dart`
   zakończył się FAIL (session50736 terminal exit1): po kliknięciu 15 października pole
   ręczne nadal pokazuje 1.10.2026 zamiast 15.10.2026. Produkcja JESZCZE NIE NAPRAWIONA.
   W TaskDatePickerManualEntry `_syncDateText` wraca za wcześnie, bo locale bez zmian.
   Następny krok: wymusić sync po zmianie selectedDate w didUpdateWidget, zachowując
   ręczny szkic przy zwykłej przebudowie; w TaskDatePickerContent zastąpić dwa globalne
   helpery normalną klasą polityki miesięcy i poprawić strict granice prev/next.
   Własność root: task_date_picker_manual_entry.dart i task_date_picker_content.dart.
2. SURFACE — Storage download/versions feedback i naturalny split 632-line
   StorageFileMutationCubit. Root przekazał tylko seam PreviewDialog/Body onDownload,
   docelowo `Future<ApiError?> Function()?`, lokalny lifecycle-owned ActionCubit i
   inline błąd nad aktywnym preview. PreviewCubit/State/FailureView pozostają root.
   Ostatnio zgłoszone przejściowe błędy: BlocProvider.maybeOf niedostępne i void
   history callback zamiast Future<ApiError?>. Sprawdzić NAJNOWSZY checkpoint Surface;
   nie zakładać, że te błędy nadal istnieją. Publicznych ścieżek nie usuwać przejściowo.
3. NAVIGATION — realne capture otwartego Chat reaction menu. Test dotąd fotografował
   boundary buildera bez root Navigator popup route; hit-test wskazuje action rect
   na ekranie, więc NIE potwierdzono runtime ukrycia menu. Następny krok: capture pełnej
   RenderView root layer, obejrzeć obraz i dopiero wtedy zdecydować o produkcyjnej fix.
   Plik testu: task_detail_split_layout_harness_test.dart. Ostatni selektywny test1/1
   PASS, ale PNG nadal nie zawiera root popup. Brak aktywnego procesu Navigation.
   Potem tab→Work→Split draft
   identity, pełne 1280/1440/1920 light/dark/200%, keyboard/focus, task search consumer.
4. TRANSPORT — BrowserStorageDocumentScenario: nowy rzeczywisty DOCX/protected stream/
   OnlyOffice config packet W TOKU, NIE PASS. Source build 0 warnings/errors. Najnowsze
   run97909 i20334: realne DOCX+PNG ticket/PUT/Complete Clean/Ready oraz pobieranie i
   protected stream przechodzą, następnie OnlyOffice session HTTP404. Szczegółowe
   safe code/capability diagnostics są w źródle, ale output ucięty; przyczyna ACL vs
   not-found NIEUSTALONA. Brak aktywnego harness procesu. Następny krok: przechwycić
   safe stage/status/code/canRead/canEdit, prześledzić RequireWrite i scope; nie zmieniać
   polityki bez dowodu. PNG preview/foreign/revoke jeszcze NIEPASS w tym pakiecie.
   Bounded cleanup proxy/database/browser i MinIO object cleanup pozostają do audytu.
   Config endpoint nie dowodzi GUI edytora.
5. Dalej: pełny przegląd P3/P4, timezone UI/selector i DST, naturalne splity Office
   View/Host, Board/GlobalPanels, global task search, Chat drafts/errors/lease;
   końcowa macierz API/ACL/enum, real runtime i mierzalny benchmark plan §13.
6. Dopiero po implementacji pełne końcowe gates Backend/Front, generatory, buildy
   i authenticated E2E. Selektywne dowody powyżej nie zastępują odbioru P0–P7.

### Start po restarcie

Przeczytać TEN najnowszy wpis, trzy agent checkpointy, AGENTS obu repo i stan git.
Agent checkpointy są w Backend/docs/task-modal-{navigation,surface,transport}-checkpoint-2026-10-01.md.
Nie polegać na przeżyciu sesji narzędzi/agentów po restarcie; najpierw sprawdzić stan.
Odtworzyć podział tylko zgodnie z zachowaną zgodą użytkownika na GPT-6 Luna i aktualnymi
instrukcjami. Nie tworzyć nowych chatów. Nie resetować/cleanować/stashować zmian.
Najpierw domknąć FAIL daty i spójność callbacku Surface, potem niezależny review root.
Aktualny root nie ma aktywnego testu: 50736 zakończył się FAIL, pozostałe opisane terminal.
Aktywne sesje agentów — odczytać z ich świeżych checkpointów, nie z dawnych sekcji.

OpenViking: resolver zwrócił Backend projectUri
`viking://user/codex/peers/github.com-przemyslawpluszowy-devplannerbackend/memories`
i Front projectUri
`viking://user/codex/peers/github.com-przemyslawpluszowy-devplannerfront/memories`;
sharedUri `viking://user/codex/memories`. Scoped lookup nie zwrócił trafnych ustaleń.
Tool write opisuje managed `peers/` jako read-only i remember nie ma target URI:
nie zapisywać projektowych faktów do przypadkowego globalnego zakresu. Lokalne
checkpointy są trwałym źródłem wznowienia; aktualna konfiguracja VPS viking.flutter-dev.pl.


### Końcowe potwierdzenie agentów przed restartem

Wszystkie trzy checkpointy agentów zapisane. Navigation i Transport zakończyli zapis;
Surface zgłosił brak aktywnych sesji. Root też bez aktywnych sesji testowych.
Surface: zakres12 Storage plików analyzer No issues found po splitcie; MutationCubit
368 linii. Versions preview6/6 PASS PRZED końcowym splittem, więc po restarcie rerun.
Callback i ActionCubit/banner już zintegrowane; przejściowe compile blockers naprawione.
Pakiet pozostaje incomplete: bulk/placement partial errors pełny ApiError, restore/delete
regresje, mutation tests, retry/recovery i niezależny root review (w tym callback w build).
Nie mylić nowego scoped analyze z pełnym analyzerem aplikacji ani odbiorem Storage.

### Uzupełnienie root: najnowsze pliki Surface na dysku przed końcowym statusem agenta

Async callback PreviewDialog jest już `Future<ApiError?> Function()?`; stary
`BlocProvider.maybeOf` nie występuje w odczytanym pliku. Pojawiły się normalne pliki
`preview/cubit/storage_preview_action_cubit.dart`, `storage_preview_action_state.dart`,
`preview/widgets/storage_preview_action_error_banner.dart`,
`browser/mutations/cubit/storage_file_download_commands.dart` i
`storage_file_placement_mutations.dart`. To dowód zapisanych plików, NIE wynik analizy
czy akceptacja root. Świeży checkpoint Surface poniżej ma pierwszeństwo dla wyników.
Root review ma sprawdzić rozbudowany async callback zadeklarowany wewnątrz build
StoragePreviewDialog (wydzielić named handler/lifecycle port zgodnie z AGENTS),
aktualność źródła po await, retry/conflict/unknown POST i wszystkie consumers callbacku.

## Najnowszy pakiet po checkpoint — podgląd i rzeczywiste pliki Chat

2026-10-01: root wspólny preview generation/closed/error/retry/failed-version/body oraz
tekstowy transport lifecycle ZROBIONE. 3 regresje FAIL→PASS, scoped18/18 PASS;
potem history download FAIL→fix i versions+error UI10/10 PASS. Pliki preview123–213linii.
Wymieniona niżej dawna luka StoragePreview generation/ApiError/body jest zastąpiona
tym wynikiem; nie implementować jej ponownie. Kolejne luki: download/versions feedback
w aktywnym preview, OfficeDialog controller w build, naturalny split632lineMutationCubit
oraz OnlyOffice part. Transport nowy realprivateTXT/PUT/completeCleanReady/copy/send/
metadata i revoke harness69699 EXIT0; enum audit/latest source test w jegocheckpoint.
Navigation pierwszy splitlight1440 root obejrzał; nadal wymagany desktop composer polish,
dark/1920/1280/200 i calendar/file controls review. Agenty nadal pracują; root new
analyzer59548/backend66741 uruchomione, terminalstatus zapisze handoff.
Aktualne AGENTS użytkownika: OpenViking na wspólnym VPS https://viking.flutter-dev.pl;
nie używać starego localhost jako obecnej konfiguracji. MCP find działa, ale zwrócił
jedynie registry overview, bez trafnych decyzji DevPlanner.

## 1. Polecenie użytkownika i twarde wymagania

Przebudować szczegół zadania Flutter z route/mobilnego panelu na duży desktopowy modal,
spójny z Listą i Kanbanem, obsługujący całą dostępną logikę backendu, wszystkie błędy,
pełny Storage i współdzielony Resource Chat. Jakość UI/UX ma być lepsza od
Asany/ClickUp/Jiry, potwierdzona scenariuszami, a nie deklaracją.
Material jest podstawą techniczną, lecz otwarte/ zamknięte dropdowny, menu, popovery,
kalendarze i dialogi muszą mieć neutralną webową stylistykę Tasks. Domyślny mobilny
Material blokuje odbiór. Oba motywy, PL/EN, 1280/1440/1920 i skala do 200%.

Root prowadzi code review, deleguje stale kolejne pakiety GPT-6 Luna i sam poprawia
wykryte luki. Nie uznaje testów agentów za akceptację kodu ani testu widgetu za runtime.
Pełne testy/buildy na końcu; podczas pracy tylko odpowiednie selektywne zestawy.
Nie commitować, nie pushować, nie deployować bez polecenia. Pracujemy w Backend + Front.
Produkcja <400 linii/pliki, normalne klasy/widgety, żadnych parts/mixins omijających limit.
AGENTS: pure build, bez helperów fragmentów widoku, efektów i tworzonych zasobów;
lifecycle/dispose, dokładne mounted i tożsamość źródła/generacja po await; brak empty catch.

## 2. Stan repozytoriów i zasady bezpieczeństwa wznowienia

Backend: /Users/przemyslawnowak/Desktop/dev/DevNote/Backend
Front: /Users/przemyslawnowak/Desktop/dev/DevNote/Front
Oba branch main; dużo zmian lokalnych i nowych plików, również wcześniejsze.
NIE resetować, nie cleanować, nie stashować ani nie regenerować bez sprawdzenia zakresu.
Usunięte stare generated task_models.* są zamierzone: modele mają nowe normalne biblioteki.
Zmiany są zapisane na dysku; restart Codexa nie wymaga commitu.
SDK: /Users/Shared/flutter_sdk/flutter/bin/flutter oraz dart.
OpenViking MCP działa po instalacji; find nie zwrócił trafnych wcześniejszych decyzji DevPlanner.
Przechowywać tylko wybrane zweryfikowane informacje, bez sekretów i pełnych rozmów.

Przed dalszymi zmianami przeczytać AGENTS w obu repo oraz cały
Backend/docs/devplanner-standalone-refactor-plan.md zgodnie z jego wymaganiem.
Nie powtarzać dużych testów jedynie dlatego, że nastąpił restart.
Po każdym pakiecie aktualizować oba standalone plany i oba handoffy.

## 3. Dokumenty źródłowe — kolejność czytania

1. Ten checkpoint i trzy checkpointy agentów wymienione poniżej.
2. Backend/docs/task-detail-desktop-modal-plan-2026-09-30.md — pełne P0–P7,
   §3.3 styl wszystkich otwartych kontrolek, §5 macierz operacji, §13 benchmark.
3. Backend/docs/task-detail-contract-audit-2026-09-30.md — API/ACL/enum wire matrix.
4. Backend i Front/docs/devplanner-standalone-refactor-handoff.md — najnowsze wpisy od góry.
Starsze wpisy historyczne zawierają już rozwiązane błędy OIDC, fontów i file capture.
Nie traktować ich jako bieżących blokad.

Checkpointy agentów w Backend/docs:
- task-modal-navigation-checkpoint-2026-10-01.md
- task-modal-surface-checkpoint-2026-10-01.md
- task-modal-transport-checkpoint-2026-10-01.md
Te pliki uzupełniają dokładne aktualne komendy, pliki i procesy agentów.

## 4. Co jest zaimplementowane i ma częściowe dowody

### Modal, wejścia i lifecycle

- Jeden duży modal, pięć zakładek, neutralne TasksTheme, własne scroll i odwiedzone zakładki.
- Kanoniczny task UUID w query, legacy route redirect, zachowanie view/filter/MyTasks return,
  guard draft/scope/logout, Escape/barrier/focus, podzadania przez typed open intent.
- Root rzeczywista regresja usuniętego taskReturn FAIL -> poprawka: router nie odtwarza
  celowo usuniętego celu powrotu. Tab/subtask 9/9 PASS; osobne tab/file-row 5/5 PASS.
- Model routingu wydzielony do normalnych bibliotek; modal navigation host 389 linii.
- Root naprawił ink ListTile w Subtasks/Attachments przez neutralny lokalny Material;
  nie wyciszono asercji Fluttera.
- Repozytoria profili i schedule przechodzą przez root dialogs dzięki typed InheritedTheme.
  Najnowszy root rzeczywisty profiles/schedule scope + replacement test: 4/4 PASS.
  Scoped analyze sześciu plików bez uwag.

### Edycja, domena i błędy

- Status systemowy/własny w jednej osi, typed katalog, lifecycle/source guard.
- Inline priority bez otwierania Basics, wspólne menu/helper Listy; zapis zachowuje
  aktualny title/status/version. Root testy priority 3/3 PASS; dwa UI przypadki ponownie PASS.
- Błędy edytorów widoczne wewnątrz dialogu; 409 zachowuje szkic i aktualny stan.
- Guards i błędy dla custom fields, labels, assignees, basics/description,
  zależności, recurrence/template, time, planning/cascade; pełny audyt nadal otwarty.
- Time capabilities, własny stop w archiwum, autostop revoke, Serializable start/revoke
  i konflikty transakcji są podłączone. Milestone scope/active checks, custom status DTO.
- Modele task podzielone na cztery biblioteki; barrel + wygenerowane nowe pliki,
  serialny build_runner wcześniej exit0. Nie zakładać, że wystarczy zwykły build enumów.
- PL/EN dodane, ostatni serialny gen-l10n exit0; root dodawał także 4 klucze assignees.

### Storage i upload

- Zakładka plików używa pełnych kanonicznych Storage capabilities i menu akcji.
- Wspólny batch resolver ACL: Shared mixed roles, folder ancestors, external workspace
  shares/null file scope, archiwum, scan clean/comment; root selektywne 32/32 PASS.
- UUID Idempotency-Key i durable ordered batch fingerprint; replay/race 409, processing
  bez ponownego PUT, additive migration 20260930170428_AddTaskUploadTicketBatchIdempotency.
  Real PostgreSQL migration/rollback i selektywne testy wcześniej PASS.
- Upload transport presigned PUT bez BFF/auth cookies, frozen batch, partial completion,
  bounded GET recovery, selection/read error, explicit cancel/draft ownership.
- Attachments production body/section po split 370/49; root lifecycle/profiles 6/6 PASS.
- Storage runtime Office/preview/scan/upload/revoke nadal nieodebrany całościowo.

### Chat/BFF/realtime

- Task Resource Chat reużywa istniejącego pełnego ChatPanelConversation i lease/lifecycle,
  provider tasks/resourceType task/UUID N lower. Nie tworzyć drugiego ChatCubita.
- REST Web BFF niezależny od opcjonalnego realtime, PKCE dwa konta sesje w lokalnym harnessie.
- YARP public Host/Proto + trusted forwarded headers; root middleware 5/5 PASS,
  metadata/JWKS 200. Dawny discovery/callback blocker rozwiązany.
- HTTP/2 Extended CONNECT ochrona Origin/CSRF: UseWebSockets po auth, exact allowed origin,
  bypass tylko rzeczywisty protected hub handshake. Root 34/34 PASS, w tym malformed
  same-host origin i null/whitespace. Pełne auth suite jeszcze końcowe.
- W harnessie działają trwałe sockety Task+Chat dwóch oddzielnych browser contexts.
  Po naprawie inbox ACL wcześniejszy lokalny harness zakończył się exit0: Owner send200
  po revoke, Member task/files404, brak nowych inbox/message eventów dla Membera.
  Następnie filtr poszerzono z Resource do wszystkich conversation scopes; najnowszy
  rerun i szczegóły mają być sprawdzone w checkpoint Transport. Pełne P6 nadal otwarte.

## 5. Najświeższy stan agentów i review — ważniejsze od starych wpisów

### Navigation /root/task_modal_navigation

Agent GPT-6 Luna; reaktywowany po restarcie, pracował nad drugim wariantem.
Aktualne procesy/testy odczytać z jego świeżego checkpointu, nie ze starszych wpisów.
Status/priority/assignees light/dark fixture captures. NOWE file menu light/dark
wyizolowane testy PASS; menu rzeczywiście hit-testowane nad modalem. Wcześniejszy problem
scrim/capture nie jest już aktualną blokadą. Obrazy:
Front/docs/recovery/visual-captures/task-detail-2026-09-30/open-file-{light,dark}-1920.png.
Root obejrzał dark file image i odrzucił kotwiczenie menu do całego AttachmentsReady. Naprawił przez TaskAttachmentMenuButton; geometry/theme2/2 PASS. Navigation ma recapture oba obrazy.
Drugi realny wariant Work+pełny Chat side pane jest w implementacji: stabilny jeden
conversationSlot w TaskDetailsWorkspaceLayout, zmienna szerokość/Offstage, bez drugiego
Cubita i lease. Root serialny gen-l10n exit0 dla split/tabbed layout keys. Fixture z 100 wiadomościami/10 plikami/długim opisem oraz realnym Chat w global
panel host NIE JEST JESZCZE gotowy: trwa jego podłączanie. Nowy layout test i analyzer
po ostatnich poprawkach nie zostały ponowione. Brak świeżych split captures/lease proof.
Task global search ma typed TaskViewRepository.searchTasks, ale zero UI consumerów:
trzeba zrobić prawdziwy desktop search z błędem/retry/cursor/source guard i tym samym open intent.
Legacy BoardPage/GlobalPanelsHost natural split nadal pozostaje w zakresie jakości.

### Surface /root/task_modal_surface

Agent GPT-6 Luna. Typed picker osób: trwałe GET/page errors + retry tego samego cursor,
source/generation/closed guard; raportowane 29/29 picker/list tests PASS, analyzer czysty.
Trzy part pliki ListRow usunięte, normalne cell widgets. Root zakończył review:
TaskListRow129 linii, RowBody246, TaskListRowInteraction bez helpera _rowContents,
drag-copy nie współdzieli FocusNode. Faktyczne rows+picker30/30 PASS i analyze czysty.
Kalendarz root odrzucił jako mobile DatePickerDialog. Surface przebudował wspólny
kompaktowy picker na 5 normalnych plików <300 linii, Listenable.merge w initState,
bez helperów/IIFE w build. Podłączył task planning/recurrence/manual time/custom fields,
dodał manual date PL/EN i guards source/value. Root gen-l10n exit0.
Agent potwierdził: date picker2/2 PASS (manual save/invalid), custom fields lifecycle2/2
PASS (stale date), time entry dialog PASS. Końcowy targeted analyzer12 plików: No issues found.
Manual time dialog1/1 PASS.
Root wizualny odbiór nadal wymagany. Brak aktywnego procesu Surface.
Po tym pełny P3/P4 audyt wszystkich realnych widocznych akcji: 400/401/403/404/409/429
Retry-After/5xx, szkic, busy/duplicate-save/lost access. Selektywne regresje konkretnych luk.
Ustalić seam detail shell/content dla Navigation Work+Chat, nie blokować równoległej pracy.

### Transport /root/task_contract_transport

Agent GPT-6 Luna. Root znalazł przyczynę Owner Chat POST404 po revoke Member:
ChatNotificationService/Reconciler reautoryzują pozostałego odbiorcę przez Task provider;
Workspace/Project expected-denial exceptions nie były objęte catch, blokowały autora.
POPRAWKA JEST NA DYSKU; lokalny harness po naprawie zakończył się exit0:
PKCE/JWKS/discovery200, 2 sesje BFF i 4 trwałe sockety Task+Chat, Owner revoke200,
Owner task/send200, revoked Member task/files404, inbox before2/after2.
Następnie root zażądał reautoryzacji inbox wszystkich conversation scopes, nie tylko
Resource. ChatRealtimeOutboxWorker oraz local/remote broadcasts używają kanonicznego
ChatService.EnsureRealtimeAccessAsync, łapią tylko expected access denial.
Jawne member.left/removed/access_revoked mogą wysłać celową invalidację czyszczącą
cache cofniętego uczestnika; nowa wiadomość po revoke nie może nic mu ujawniać.
Agent raportował selektywne Chat11/11 PASS. Najnowszy rozszerzony BrowserHarness session84947 zakończył się EXIT0. Po quiet-drain
16 wcześniej zakolejkowanych eventów nowa wiadomość Ownera dała 0 eventów revoked Membera.
Rzeczywiste scenariusze PASS: edit, reaction create/list/remove, read receipt, thread
reply/list, soft-delete/list omission, attachment session create/cancel, Chat close/
reconnect+send; Task/Chat H2 CONNECT200. To wynik protokołu/HTTP, nie Flutter UI.
P6 nadal wymaga rzeczywistego upload+attach file i pozostałych scenariuszy/odbioru.
Następny Transport: private TXT → temp session copy → message attachment metadata.
Nie potwierdzono scan/download/Office. Session84947 terminal, niepollować ani niepowtarzać.

### Root — najnowszy pakiet podglądu załącznika

- Wspólny TaskAttachmentPreviewLauncher obsługuje otwarcie z wiersza i menu.
- Przed i po dialogu kontroluje mounted, closed i tożsamość repository/attachments.
  Właściciel zamyka lokalne StoragePreviewCubit i StorageFileMutationCubit w finally.
- Rzeczywiste regresje wymiany repozytorium oraz zamknięcia task Cubita przy wciąż
  zamontowanym BuildContext najpierw FAIL (otwarty spóźniony dialog), potem PASS.
- Najnowszy focused task_attachment_preview_lifecycle_test.dart: 3/3 PASS, w tym
  prawidłowy scope otwiera dialog z widocznym błędem i oba lokalne Cubity zamykają się.
  Wcześniejszy łączny run stale cases + row actions:3/3 PASS. Scoped analyze bez uwag
  przed dodaniem końcowych asercji zasobów; ostatni test kompilował te asercje poprawnie.
- Pliki Front/lib/workspaces/presentation/tasks/detail: task_attachment_preview_launcher.dart,
  task_attachment_file_actions.dart, task_attachment_file_mutations.dart;
  test/workspaces/presentation/tasks/detail/task_attachment_preview_lifecycle_test.dart.
- ZIDENTYFIKOWANE, ALE JESZCZE NIE ZMIENIONE: wspólny StoragePreviewCubit nie ma
  generation guard dla nakładających się preview/version/retry; StoragePreviewFailure
  gubi ApiError/code/fields/trace/Retry-After; StoragePreviewDialog nie ma retry i nadal
  buduje fragment helperem _buildPreviewBody. Naprawić normalnymi widgetami i zachować
  właściwy failed version przy GET retry. To konkretne kolejne zadanie root lub Surface;
  uzgodnić ownership, by nie nadpisać równoległych zmian.

## 6. Czego nie wolno oznaczać jako gotowe

Wszystkie zbiorcze P0–P7 pozostają OTWARTE.
P0: komplet aktualnej macierzy akcji/API/ACL/enum + authenticated baseline Web/macOS.
P1: dwa realne warianty, 100+ messages, oba themes/PLEN/sizes/scale, opened controls
side by side z Listą/Kanbanem, keyboard/focus i benchmark rzeczywistych scenariuszy.
P2: real Browser back/forward/refresh/clipboard/scroll/focus/draft/session i wszystkie entrypoints.
P3: wszystkie błędy, konflikty wersji i dwa równoczesne okna, uncertain POST.
P4: każdy wiersz §5 z modala w każdej roli i archiwum, workflow custom/WIP.
P5: rzeczywisty partial upload, unknown, scan pending/infected/skipped, expired tickets,
preview/Office/versions/share/revoke, Web/macOS.
P6: send/edit/delete/reaction/thread/read/attachment/reconnect/replay z dwoma klientami,
notifications/global chat lease/drafts oraz zero eventów/cache po revoke.
P7: końcowe full suites, generated API/enums, production limits/lifecycle review,
świeży runtime aktualnego kodu i osobny staging E2E; deploy nadal wymaga polecenia.
Nie deklarować wyższości nad Asaną bez danych benchmarku §13.

## 7. Plan wznowienia po restarcie

1. Read ten plik + trzy agent checkpoints + aktualne AGENTS/status; zweryfikować żywe
   procesy według dokładnych handles. Restart aplikacji nie jest dowodem, że proces zakończył się.
   Nie restartować joba tylko po observation timeout ani na podstawie starego logu.
2. Odtworzyć trzy zadania GPT-6 Luna, jeśli stare agenty nie istnieją; bez nowych chatów.
   Przy spawning model override użyć fork_turns none i wstrzyknąć scope/wymagania/checkpoint.
   Root code reviews pozostaje nadrzędny. Nie delegować na inny model bez zgody.
3. Transport: review final all-scope inbox ACL + nowe regresje i rerun aktualnego
   persistent peer harness, potem pozostałe operacje P6.
4. Surface: potwierdzić selektywne wyniki desktop calendar i root render review,
   następnie P3/P4 errors audit. RowBody jest po root review.
5. Navigation: obejrzeć file menu, recapture desktop calendar, drugi realny Work+Chat
   wariant, global task search, natural split Board/GlobalPanels zgodnie ze stanem kodu.
6. Root: wspólny StoragePreview ApiError/retry/generation i naturalny body widget;
   niezależny review plików/linii/lifecycle/real render i proporcjonalne testy,
   aktualizacja macierzy i handoffów; nowe błędy najpierw odtworzyć, potem naprawić.
7. Dopiero po domknięciu implementacji i odbiorze uruchomić pełne końcowe bramki.

## 8. Weryfikacja i komendy końcowe (nie uruchomione jako pełny odbiór)

Backend: dotnet restore; dotnet build veloryn-workspaces.csproj --no-restore;
dotnet test Tests/Veloryn.Workspaces.Tests/Veloryn.Workspaces.Tests.csproj;
dotnet ef migrations script --idempotent --project veloryn-workspaces.csproj;
drugi projekt/migration script wg AGENTS i standalone plan;
dotnet format --verify-no-changes; git diff --check.
Front: flutter pub get; serialny build_runner i gen-l10n; analyze; pełny flutter test;
Web Wasm/macOS oraz Windows/Linux na odpowiednich hostach; git diff --check.
Audyt wszystkich dotkniętych enumów: C# converter, generated OpenAPI, real HTTP JSON,
Dart encode/decode każdej wartości, unknown/aliases/defaults. Brak dowodu zapisać jawnie.
Nie zakładać poprawności na podstawie zgodnych nazw enumów.

Root nie ma aktywnego testu/generatora; ostatni preview test zakończył się exit0.
Trzy agenty zapisały świeże checkpointy przed restartem. Navigation/Surface bez
aktywnych testów; Transport rozszerzony harness session84947 terminal EXIT0.
Ich konkretne procesy i ostatnie wyniki odczytać z tych plików; nie zakładać, że wcześniejsze idle
lub wcześniejszy harness exit134 są nadal aktualne. Snapshoty git mają datę zapisu.
Starszy GUI był blokowany przez Mac locked, a stary web bundle nie jest dowodem nowego UI.
Po restarcie odczytać rzeczywisty stan zamiast powielać dawną blokadę.


## 2026-10-01 — końcowe bramki: stan przed ostatnim rerunem Front

Obowiązuje polecenie użytkownika: dokończyć kod, bez dalszego SSH, logowania i deploymentu. Nie commitowano ani nie pushowano.

Backend: restore i build zakończone sukcesem (0 warnings/0 errors); oba idempotentne skrypty migracji oraz dotnet format --verify-no-changes PASS. Pełny test zakończył się wynikiem 1467 PASS / 4 SKIP / 2 FAIL (1473 łącznie). Dwa błędy dotyczyły fixture: kompletny zestaw StorageShareAccessLevel ma sześć wartości, a request OKR musi serializować tekstowy enum skonfigurowanymi JsonOptions. Po korektach dokładne dwa testy PASS 2/2. Pełnego backendowego suite po tych testowych korektach nie powtarzano.

Front: pełny analyze PASS. Pierwszy pełny flutter test przerwano po 2158 sukcesach i 27 błędach, po dwóch rzeczywistych dziesięciominutowych timeoutach harnessów; exit 130, brak pełnego sukcesu suite. Naprawiono route lookup hosta (focused 12/12), scenariusze nawigacji (9/9), realne ładowanie fontów harnessów poza fake async oraz kontekst loadera TaskListRow poza build. Domknięcie popup route i remaining visual/storage cases prowadzi Surface.

Root naprawił realną animację ukrytego panelu Chat: Offstage zachowuje stan i draft, ale teraz TickerMode wyłącza ticker niewidocznej kolumny. Test task_details_workspace_layout_test.dart: 1/1 PASS; sprawdza brak zaplanowanych klatek po ukryciu, wznowienie animacji po odsłonięciu i zachowanie tej samej instancji State. Scoped analyze PASS.

Następny krok: ostatnie regresje Surface, następnie serialnie pełny analyze, flutter test i jeden Web build z DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl. Lokalny golden review nie jest zalogowanym runtime ani staging E2E. Odbiór P0–P7, wieloklientowy Chat, prawdziwy Office, platformy desktop i benchmark Asana pozostają osobnymi niepotwierdzonymi bramkami.


### Root: finalny review popup i przyczyny golden drift

TaskListRow przechowuje loader w State, synchronizuje go w didChangeDependencies i używa parametrów GoRouterState na PageRoute, a konfiguracji routerDelegate w popupie. Nowy realny test GoRouter + root Dialog + repository PASS 1/1, folder rename PASS 1/1 po poprawnym pump po enterText. Pełny analyze ponownie PASS (13.4s); diff-check obu repozytoriów PASS.

Root obejrzał wszystkie 21 actual PNG. Dwadzieścia wariantów zostało zaakceptowanych warunkowo po stabilizacji ładowania assetów; fallback dark1280 przy 200% odrzucono, ponieważ modal był przejrzysty na zrzucie. Potwierdzono asynchroniczne obrazy shellu bg.jpeg/logo-small.png jako źródło różnicy między izolowanym testem a pełnym harness runem. Surface domyka deterministyczny preload oraz zakończenie animacji konkretnej trasy. Nie aktualizować baseline przezroczystego wariantu. Produkcyjny kod zamrożony; pozostają końcowe harnessy, pełny test i Web build.


### Końcowy Web build

Jedyny końcowy build: flutter build web --no-tree-shake-icons --dart-define=DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl — EXIT 0, 88.3s, Built build/web. Navigation sprawdził obecność docelowego URL w main.dart.js. Log /tmp/devplanner-final-flutter-web-build.log. Wasm dry run przeszedł; nie jest to osobny build ani test runtime Wasm. Full analyze EXIT0 (13.4s), log /tmp/devplanner-final-flutter-analyze.log. Brak deploymentu i runtime claim. Pozostaje terminalny pełny test Front po stabilizacji visual fixtures.


### Visual harnessy — terminalny wynik po naprawie deterministyczności

Potwierdzone przyczyny driftu: capture przed załadowaniem AssetImage bg.jpeg/logo-small.png oraz przed zakończeniem ModalRoute.animation w fallback przy 200%. Oba harnessy mają jawny preload (deadline30s), fallback bounded wait na animation.completed (20×50ms). Root obejrzał actuale, w tym nowy nieprzezroczysty fallback, i zaakceptował konkretne baseline. Bez-update pełny visual harness PASS17/17, split-layout PASS6/6; scoped analyzer i diff-check PASS. Baselines: Front/docs/recovery/visual-captures/task-detail-2026-09-30/. Kod produkcji nie zmieniał się po udanym final Web build. Navigation uruchamia jeden końcowy pełny flutter test. To lokalny widget/render dowód, nie uwierzytelniony staging ani rzeczywisty wieloklientowy odbiór.


## 2026-10-01 — końcowe domknięcie bieżącego kodu modala

- [x] Końcowy pełny flutter test: EXIT0, 2207 PASS, All tests passed (3:09); log /tmp/devplanner-final-flutter-test-final.log. Root zweryfikował terminalną linię.
- [x] Pełny flutter analyze: No issues found, EXIT0; po ostatnich zmianach testowych dodatkowy scoped analyzer obu harnessów PASS.
- [x] Jeden build Web: EXIT0, 88.3s, build/web; docelowy DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl potwierdzony w main.dart.js.
- [x] Pełne harnessy bez update: visual17/17 i split-layout6/6 PASS; root review wszystkich actuali, neutralne menu/pickery oraz light/dark i fallback200. To widget render, nie runtime staging.
- [x] Backend restore/build (0 warnings/errors), format oraz oba idempotentne migration scripts PASS. Pełny backend suite 1467 PASS/4 SKIP/2 FAIL; dwa testowe błędy fixture naprawione, exact rerun2/2 PASS. Nie deklarować powtórnego zielonego pełnego backend suite po tych korektach.
- [x] git diff --check obu repozytoriów PASS. Bez commitu, pusha, deploymentu i dalszych prób SSH/login.

Pozostały odbiór poza bieżącym domknięciem kodu: uwierzytelniony browser/staging aktualnego builda, realny dwuklientowy Chat/revoke/reconnect, rzeczywiste upload/scan/Office oraz platformy desktop. Benchmark przewagi nad Asaną nie został wykonany. P0–P7 pozostają niezamknięte jako pełny odbiór end-to-end; checklisty sukcesów powyżej opisują dokładnie wykonane bramki kodu. Bieżący stan i wszystkie agent checkpoints zachowano do wznowienia. Nie uruchamiać ponownie pełnych bramek bez nowej zmiany/failure ani nie wracać do SSH bez nowego polecenia użytkownika.


## 2026-10-01 — root: daty UTC i poprawka reflow200

Potwierdzono źródłowo: task StartAtUtc/DueAtUtc są UTC instants (request/response DTO, ProjectTask.ValidateScheduleDates KindUTC i pełne porównanie, handlery bez transformacji). Poprzedni Front stosował trzy różne mapowania kalendarza w List/Kanban/modal. Przyjęto wspólne zgodne z API zachowanie: zmiana dnia zachowuje existing local hour/minute/second/millisecond/microsecond, nowa data to lokalna północ przeliczona na UTC, clear pozostaje null. Nowy osobny TaskDatePicker.asUtcTaskInstant nie zmienia custom Date/asUtcCalendarDate ani recurrence. Task picker seeding używa lokalnej daty, także menu wiersza i template task dates. Navigation domyka realDTOJSON, pełne enumvalues i testy stref LA/Warsaw/DST; root poprawił portabletest guardy, aby inne strefy nie były błędnie rozpoznawane jako LA/Warsaw. Transport dodaje non-null UTC HTTP fixture (test-only).

PropertyRow wydzielony do zwykłego widgetu81LOC; shared331LOC. Tani LayoutBuilder przełącza label/value na pionowy układ przy ciasnym panelu/dużym TextScaler, bez clamp tekstu i efektów w build. Root freshfallback200 renderreview PASS: wszystkie etykiety czytelne, wartości poniżej, naturalne łamanie długiej wartości. Exact100%test1/1PASS, exact200%no-update1/1PASS, scopedanalyzer/diffPASS. UIUXProMax zastosowane Text Reflow and Spacing + Impeccable Operate, istniejące TasksTheme.

Backend final full po poprzednich fixture corrections: EXIT0,1469PASS/4SKIP/0FAIL,1473total,10m28s, log /tmp/devplanner-final-backend-tests.log (root terminalverify). To zastępuje poprzednie full2FAIL; bez nowego backendproduction. Navigation finalfullanalyze PASS, finalfullFronttest trwa. Surface po terminalnym finalWebbuild ma wykonać tylko realWasm i macOSdebugcompile; brak runtime/deploy/login. Wszystkie release/E2E/benchmark bramki zachowują jawne granice.


## 2026-10-01 — finalne dowody po pakiecie UTC/reflow200

- Front final full: 2212 PASS/0FAIL, EXIT0, 3:21, log /tmp/devplanner-final-flutter-test.log (rootterminalverify). Fullanalyze Noissues. Same-frozenfile selectiveTZ: LA9/9, Warsaw9/9, UTC9/9 PASS; test sprawdza realny offset/PST→PDT i CET→CEST tylko dla jawnie zadanych stref, dla innych nie narzuca ich nazw/offsetów.
- Final zwykły Webbuild EXIT0,87.6s, docelowy https://devnote.flutter-dev.pl potwierdzony w main.dart.js. Real WebWasm EXIT0,103.5s, main.dart.wasm istnieje; log /tmp/devplanner-p7-web-wasm-build.log. macOSdebug EXIT0, DevPlanner.app istnieje; log /tmp/devplanner-p7-macos-debug-build.log. Root zweryfikował końcówki logów i artefakty. macOS ostrzeżenia staleDerivedData/SPM, bez faila. To compileonly, nie signed/runtime/release.
- Backend full: 1469PASS/4SKIP/0FAIL,1473total,10m28s; sourceproduction zamrożony. Nowy test-only rawUTC HTTP create→GETdetail→PATCH→GETdetail zachowuje Start/Due ISO z6cyframimikrosekund:1/1PASS. PierwszeGETdetail500 było Npgsql.PostgresException: sharedTaskPostgresFixture migrowała tylko WorkspaceDbContext; LocalUserProfileQuery wGetProjectTaskHandler czytaLocalIdentityDbContext.Users. Dodano identitymigrations w osobnym devplanner_identity/__IdentityMigrationsHistory zgodnie zproductionfactory; nie usunięto/maskowano profili wproduction. Zmiany wyłącznie test+fixture. Proporcjonalny batch TaskHttpOperationMatrixTests+ProjectSetupHttpIntegrationTests po fixturechange jeszcze wymaga terminalu; fullsuite nie jest powtarzana.
- Wciąż brak authenticatedstaging/E2E, Windows/Linuxbuildów na właściwychhostach, signedMacruntime, realOffice i dwuklientowegoChat oraz benchmarku przewagi nadAsaną. Nie uznawać całegoP0–P7 zaDONE przez powyższe zielone codegates. Bez SSH/login/deploy/commit/push.


## 2026-10-01 — zakończenie dodatkowej walidacji fixture dat

TaskHttpOperationMatrixTests + ProjectSetupHttpIntegrationTests: exit 0, 40 PASS, 0 SKIP, 0 FAIL, 1 min 37 s. Log: /tmp/devplanner-task-date-fixture-batch.log. Wynik potwierdzony z terminalnego podsumowania. Zastępuje wcześniejszą informację o oczekiwaniu na ten batch. Źródła nie zmieniły się po teście; pełnego zestawu backendu nie powtarzano po zmianie wyłącznie testowej.


## Końcowy wynik — Front i Backend opublikowane

Po wykonaniu przez administratora zmiany właściciela katalogu Frontu skrypt publikacji przeszedł pełny przebieg (exit 0). Aktywna wersja Frontu: b234a98438ed22e40049d4c38f2ff1c40d6b3f34.

Pierwszy render ujawnił brak MIME dla .mjs w Nginx. Publisher zachowuje treść modułu Wasm, nadaje mu rozszerzenie main.dart.wasm.js i aktualizuje jego ścieżkę w loaderze. Adres bootstrapu w index.html jest wersjonowany SHA wydania, aby uniknąć starej kopii przeglądarkowej. Nie wymaga to zmiany konfiguracji Nginx ani ponownej kompilacji aplikacji.

Potwierdzono HTTP 200 i sumy SHA-256 zgodne z lokalnym buildem dla main.dart.wasm oraz modułu wsparcia. MIME: application/wasm i application/javascript. /workspaces zwraca dokładnie opublikowany index.html (SPA fallback). Backend /health/ready: HTTP 200 Healthy, kontener obrazu 5d84079745a95978fc2047a774ba8b3a27e1401c healthy.

Rzeczywisty render w przeglądarce na stagingu zakończył się ekranem logowania DevPlanner pod /login?returnTo=/workspaces. Nie wykonano w tej publikacji uwierzytelnionych scenariuszy modalu, Chat i Storage; nie jest to ich pełny odbiór. Wcześniejsza blokada publikacji Frontu jest rozwiązana.


## 2026-10-01 — regresje ze stagingu po uruchomieniu aplikacji

- Wcześniejszy pakiet logowania wdrożony: Backend `6f1e38c`, Front `3737c5e`.
  Discovery wskazuje `/connect/jwks`, JWKS zwraca JSON/200; rzeczywiste logowanie
  przeszło callback i wyrenderowało workspace. Konta/secrets nie są dokumentowane.
- Naprawa w bieżącym pakiecie: seeder inicjalizuje sześć statusów, zachowuje
  istniejące nazwy/kolory/pozycje i status początkowy. Addytywna migracja
  `BackfillMissingProjectWorkflows` naprawia wyłącznie projekty bez workflow.
  Rollback aplikacji zachowuje naprawione dane, aby nie odtwarzać awarii odczytu.
- Front: `/me` korzysta z rozwiązanego adaptera HTTP zamiast pustego argumentu
  konstruktora routera. Suwak poziomy tabeli Listy jest stale widoczny i interaktywny.
- Walidacja kodu: Backend batch initializer/ProjectTaskHandler/enum wire: 58 PASS,
  0 FAIL/0 SKIP; Front router: 15 PASS; pełny analyzer Front: brak problemów.
  Wyniki nie zastępują manualnej akceptacji na stagingu. Wasm/deploy bieżącego
  pakietu jeszcze w toku.
- UI UX Pro Max: zastosowano zalecenie `Content Jumping` (stabilna geometria
  stanów asynchronicznych). Impeccable Operate/craft floor: zachowanie tokenów,
  interaktywnych suwaków i dotychczasowej stylistyki Listy/Kanbana.
- Do dokończenia na stagingu: Kanban drop i stabilność nagłówka, List scroll,
  profil, wszystkie projekty workflow, sesja konkretnego pliku OnlyOffice,
  obecność aplikacji i prawy panel osób. Audyt potwierdził, że dotychczas Tasks
  presence obejmuje wyłącznie otwarty projekt, a nie całą zalogowaną sesję.
- Nowa jawna dyspozycja użytkownika: manualne przejście aplikacji i poprawianie
  znalezionych błędów, następnie czat na trzech kontach w niezależnych sesjach
  (wysyłanie/odczyt/presence/pliki/reconnect). Trzy karty z tym samym cookie
  nie są dowodem testu trzech użytkowników.


### Weryfikacja po wdrożeniu — 2026-10-01, pakiet regresji

- Backend `0ec294b05ff9ac6d7f28de65ed39cf1a8a8819b9`: skrypt deploy-local
  EXIT 0, readiness Healthy, zapytanie na potwierdzonej bazie stagingowej
  wykazało ZERO projektów bez workflow (przed naprawą dwa).
- Front Wasm: build EXIT 0, 112.5 s. Publikacja `d272f47` ujawniła w manualnym
  teście starą wersję aplikacji mimo nowego bootstrapu. Przyczyną był stały
  version.json używany przez custom bootstrap do wersjonowania Wasm/JS.
- Poprawiono skrypt deploy_staging_wasm.sh: build_number w publikowanym
  version.json = SHA wdrożenia. Publikacja `1f8fd3c1d02c974bc94a78ed840fce44eb640daa`
  EXIT 0; ponowne ładowanie w tej samej sesji przeglądarki pokazało naprawiony
  profil z danymi API. To dowód runtime, nie wyłącznie testu routera.
- Manualnie staging, viewport 1280x800: profil załadowany; List projektu Migracja
  infrastruktury wyrenderowana (34 zadania); suwak poziomy widoczny, przeciągnięcie
  przesunęło kolumny tabeli. Dowód: /tmp/devplanner-staging-list-scroll-2026-10-01.png.
  Kanban tego projektu renderuje statusy, bez błędu brakującego workflow.
- Dwie próby drag w CUA nie zmieniły położenia zadania. Nie stanowią dowodu
  poprawnego dropa ani stabilności nagłówka podczas mutacji; ta akceptacja jest
  nadal otwarta. Nie oznaczono Kanbana/presence/OnlyOffice/czatu jako zaliczonych.
- Testy czatu na trzech niezależnych kontach pozostają do wykonania zgodnie z
  dyspozycją użytkownika. Pozostały też panel osób z globalną obecnością oraz
  manualne przejście reszty aplikacji i usuwanie znalezionych regresji.


## Następny pakiet zbiorczy — praca robocza, jeszcze niewdrożona

- Odtworzenie OnlyOffice: office-session HTTP 200, api.js i documenteditor 200,
  ale host iframe ma srcdoc; DOM dziecka pokazuje parentOrigin=null. Deployed
  DocsAPI 8.2.3 ustawia parentOrigin=window.location.origin przed stworzeniem
  dziecka. Brak otwarcia dokumentu, po czasie timeout aplikacji. W źródle
  przygotowano host Blob na Web (origin aplikacji), dokładne sprawdzenie własnego
  URL w delegate i revoke przy wymianie/dispose. Native zachowuje dotychczasową
  ścieżkę loadHtmlString. Zgodność semantyki Blob origin potwierdzona w MDN:
  https://developer.mozilla.org/en-US/docs/Web/API/Location/origin.
  Efekt w Wasm i rzeczywistym OnlyOffice nadal wymaga weryfikacji po wspólnym deploy.
- Źródło skoku kontrolek: KanbanBoardGroupingBar wstawiał 24px loader przed
  segmentami przy isAssigneeBoardLoading. Przygotowano loader w stałym slocie
  ikony segmentu osoby, bez zmiany szerokości. Regresja mierzy szerokość paska
  i pozycję następnego filtra w loaded/loading. Test PASS.
- Konta QA: katalog seedera rozszerzony o qa.chat01/02/03 (wyłącznie zwykła rola
  User i Member w danych demo). SeedChat dodaje wydzieloną grupę QA — czat
  trzech kont, tylko QA plus właściciel. Nie uruchomiono seedera tego kodu i
  konta nie są jeszcze potwierdzone na serwerze. Po wspólnym deploy uruchomić
  sudo /usr/local/sbin/devplanner-seed-demo (bez zmiany haseł istniejących kont).
- Native CUA ma dostęp do Chrome, Edge i Firefox jako aplikacji. Tylko IAB jest
  wystawiony jako kontrolowany browser. Dla izolacji trzech kont można użyć
  trzech różnych native przeglądarek, nowych kart, nie wspólnego cookie IAB.
- Manualny czat: globalny panel ładuje historię rozmowy Wydanie i testy;
  początkowy banner łączenia znika. Panel uczestników pokazuje role i członków,
  lecz nie pokazuje statusu online (brak claimu o działającym realtime/E2E).
- Próba Escape w panelu uczestników: capture przestał działać; AX nadal widzi
  kartę 6, lecz Flutter canvas nie daje stanu panelu. Nie uznawać Escape za
  zaliczony ani za potwierdzony błąd. Karta nadal ta sama, nie resetowano sesji.
- Walidacja zmian roboczych: Front analyzer clean (13.1 s); grouping/OnlyOffice
  lifecycle/host: 15 PASS; Backend build 0 warning/0 error (26.41 s).
  Wasm build nowej poprawki i runtime akceptacja jeszcze niewykonane.
- Jeszcze do pakietu: globalna obecność + prawy panel osób, dalszy manualny
  przegląd task modal i menu, trzy sesje czatu po utworzeniu QA. Nie wdrażać
  pojedynczo kolejnych drobnych poprawek; przygotować i sprawdzić wspólny pakiet.


## Pakiet zbiorczy — obecność aplikacji i blokada statusów (robocze, bez wdrożenia)

- Użytkownik potwierdził: online/offline musi być widoczne już na Liście; awatary mają otwierać prawy panel osób. W obu AGENTS.md dopisano wdrażanie pakietami, bez publikacji każdej drobnej poprawki.
- Backend: nowy ApplicationPresenceLease + ApplicationPresenceStore, rejestracja całego połączenia ChatEventsHub bez rozmowy, HeartbeatApplicationPresence bez argumentu UserId, cleanup na disconnect, TTL 45 s, wspólna tabela między instancjami. Worker usuwa wygasłe rekordy. Query dostaje wyłącznie wcześniej autoryzowane UserId; profile projektu dodają IsOnline po dotychczasowym ACL i filtracji Identity.
- Addytywna migracja 20261001190507_AddApplicationPresenceLeases wygenerowana; idempotentny skrypt EF wygenerowany do /tmp/devplanner-presence-migrations.sql. Rollback usuwa wyłącznie nową tabelę efemerycznych lease'ów. Migracja NIE została zastosowana na VPS. Gałąź SQL upsert PostgreSQL nadal wymaga walidacji runtime; testy store w tym pakiecie używają InMemory.
- Front: sesyjny kanał inbox utrzymuje heartbeat co 15 s także przy zamkniętym czacie; zatrzymuje timer przy disconnect/dispose i odrzuca spóźnione błędy. Profile przenoszą isOnline, a koordynator tablicy odświeża profile co 15 s, bez nakładających się zapytań. Błąd odczytu oznacza nieaktualny stan, nie offline. Facepile korzysta z obecności aplikacji zamiast listy subskrybentów projektu; sortowanie przeniesione z build do lifecycle. Znaczniki i tooltipy rozróżniają online/offline/nieznany; kolory semantyczne aplikacji.
- Rzeczywisty dodatkowy błąd QA: w projekcie Migracja infrastruktury menu statusu TASK-64 zawiera tylko Backlog. Observer SQL potwierdził 0 wpisów project_task_status_transitions dla tego projektu. Backend EnsureTransitionAsync jawnie dopuszcza wszystkie przejścia, gdy lista jest pusta; frontend traktował pustą listę jako blokadę. Poprawiono canMoveTaskTo, TaskWorkflowStatusOptions, changeSystemStatus i edytor podstawowy. Test ograniczonego workflow otrzymał rzeczywistą niepustą konfigurację, zamiast utrwalać błędną semantykę pustej listy. Screenshot: /tmp/devplanner-staging-workflow-status-menu-2026-10-01.png.
- Walidacja: presence/profile/header Front 34 PASS; workflow/board/details 82 PASS; Backend presence/hub/role contract 13 PASS po dodaniu testu connect/heartbeat/disconnect bez rozmowy. Szerszy wcześniejszy zestaw Backend directory/access/presence/role: 34 PASS (przed ostatnim dodatkowym testem huba). Front analyzer clean 12.1 s przed ostatnią poprawką workflow; końcowy analyzer uruchomiony osobno. Oba diff --check clean przed końcowym dopisaniem dokumentacji.
- Enumy dotkniętego profilu: ProjectRole transport response, pełne Owner/Admin/Member/Observer pozostają bez zmian; serialize/deserialize C# i decode/encode Flutter sprawdzone w testach. Dodane bool isOnline nie jest enumem. Weryfikacja wygenerowanego OpenAPI i rzeczywistego JSON po wdrożeniu pozostaje bramką pakietu. W workflow zachowano wartości ProjectTaskStatus; istniejący audyt przewodowy trzeba dołączyć do końcowych bramek, semantyka pustej listy jest poprawką klienta.
- DO ZROBIENIA: prawy panel osób, obsługa błędów heartbeat w sesyjnym UI, testy odświeżania rosteru i jego zamknięcia, OpenAPI/JSON oraz PostgreSQL runtime, zbiorczy Wasm build i pozostałe bramki, jeden deploy obu komponentów, QA seed, trzy izolowane sesje czatu. Następnie odtworzyć dokładnie zmianę statusu i DnD, loader, OnlyOffice, online poza projektem i po zamknięciu ostatniej sesji. Nie deklarować odbioru wizualnego nowego kodu ani pełnego sukcesu modala.
- Bieżąca sesja CUA: karta 6 nadal istnieje, screenshot ponownie działa. Staging nie zmieniono; otwarty modal TASK-64 z menu statusu, sesja zachowana markHandoff. Cel pozostaje aktywny.
- Końcowa walidacja tego kroku: Front analyzer clean (11.7 s) po poprawce workflow; oba git diff --check EXIT 0. Brak aktywnych buildów/testów/deployów. Następny krok: prawy panel osób.


## Panel osób i status wykonawców — pakiet zbiorczy 2026-10-01

- [x] Prawy panel osób zastępuje poprzedni modal po kliknięciu avatarów Listy/Kanbana. Wspólny host paneli zachowuje trasę i jej stan, obsługuje Escape/focus/resize oraz zamyka i usuwa dane osób po zmianie sesji.
- [x] ProjectPeopleCubit pobiera wyłącznie profile autoryzowanego projektu, odświeża co 15 s bez nakładania zapytań, sortuje i filtruje poza build. Błąd odczytu zachowuje dane z nieznanym statusem i daje retry; utrata uprawnień usuwa dane i cache. Zamknięcie zatrzymuje timer i odrzuca późny wynik.
- [x] Obecność widoczna również przy wykonawcach w komórkach Listy oraz nagłówkach kolumn Kanbana po osobach. Online: pełna zielona kropka; offline: neutralna pusta; nieznany: neutralna z punktem. Tooltip i Semantics podają status. Błąd odczytu rosteru usuwa aktualność statusu również z profili używanych przez komórki.
- [x] Zastosowano UI UX Pro Max i Impeccable Operate: wspólne tokeny aplikacji, zwarta desktopowa powierzchnia, dostępne etykiety, status niezależny od samego koloru, zachowanie focus/klawiatury. Bez zmiany globalnego motywu.
- [x] Front: 97 testów widget/state/route/host/wierszy PASS, komenda zakończona EXIT 0. Końcowy flutter analyze clean, 13.1 s. Test wiersza sprawdza osobne online/offline, stan nieznany i brak overflow przy długich nazwach w komórce 160 px.
- [x] Backend: 14 testów presence/hub/role PASS, w tym nowy ApplicationPresenceStorePostgresTests na izolowanej bazie PostgreSQL. Potwierdzono atomowy upsert, brak duplikowania heartbeat, dwie instancje, ochronę właściciela connectionId i offline dopiero po ostatnim disconnect. dotnet format --verify-no-changes EXIT 0.
- [ ] Nowy kod nie jest jeszcze potwierdzony wizualnie na stagingu. Front Wasm build PASS (99.2 s, --wasm --no-tree-shake-icons). Pełne testy backendu trwają przed jednym wspólnym wdrożeniem. Pozostają aktualny OpenAPI/JSON, trzy izolowane konta QA, globalna obecność poza projektem i po zamknięciu ostatniej sesji, dokładny retest workflow/DnD/loader/OnlyOffice. Obsługa błędów heartbeat w sesyjnym UI nadal osobnym punktem odbioru.

- Pełny przebieg backendu wykrył w KanbanEndpointTests niezgodną tabelę historii Identity (__EFMigrationsHistory zamiast obowiązującej __IdentityMigrationsHistory), co powodowało próbę ponownego CREATE tabel Permissions. Konfigurację testu ujednolicono z fixture i produkcyjnym DI; ponowiony zestaw Kanban HTTP: 12 PASS (30 s). Błąd nie dotyczy migracji globalnej obecności.


## Zbiorcze wdrożenie i obecność — potwierdzenie runtime 2026-10-01

- Backend 35481464fa6eb1825bc18e6ed8a0eaa9afa7ae27 i Front Wasm b79b73d550fe3c2848a9b091263af162d6c37183 zostały zakomitowane, wypchnięte i opublikowane skryptami SSH. Backend deploy-local EXIT 0, migracja ApplicationPresenceLeases zastosowana, readiness Healthy. Front deploy_staging_wasm.sh --no-build EXIT 0; użyto artefaktu ostatniego udanego builda bieżącego kodu, symlink i publiczny Wasm zweryfikowane przez skrypt.
- Pełny przebieg Backend: 1469 PASS, 12 FAIL, 4 SKIP, 9m46s. Wszystkie 12 FAIL dotyczyły niezgodnej historii migracji w KanbanEndpointTests; po poprawce dokładnie ten zestaw 12 PASS, 30s. Nie wykonano drugiego pełnego przebiegu. Oddzielny zestaw presence/hub/role zawiera 14 PASS i rzeczywisty PostgreSQL upsert. Pominięte scenariusze Redis/two-host pozostają niepotwierdzone.
- Rzeczywisty staging: po reload nowego Wasm Lista pokazuje kropki obecności osobno przy wykonawcach. Kliknięcie avatarów otwiera prawy panel 420 px, bez utraty trasy Listy. Panel pokazuje 1 osobę online (bieżąca sesja) i widoczne osoby offline wraz z nazwą i rolą. Screenshot: /tmp/devplanner-staging-people-panel-2026-10-01.png. Nie potwierdzono jeszcze przełączania statusu między trzema niezależnymi kontami ani ostatniego disconnect w UI.
- Seeder uruchomiony po deployu, ale EXIT 139: SingleOrDefaultAsync dla ProjectTask.Title w DemoSeedService.cs:153 trafia na kilka istniejących zadań o tym samym tytule. Nie resetowano bazy i nie usuwano duplikatów. Konta mogły powstać przed błędem, lecz kompletność membershipów i grupy QA wymaga osobnego potwierdzenia; nie deklarować udanego seedowania.
- Nowa usterka wizualna do zbiorczego pakietu: licznik nadmiarowych avatarów +23 zawija się w stałym chipie 24 px. Poprawić dopasowanie tekstu/licznika i sprawdzić duże liczby, bez kolejnego osobnego deployu.
- DO KONTYNUACJI: poprawka seedera bez usuwania legalnych duplikatów, licznik avatarów, odbiór błędów heartbeat w UI, OpenAPI/JSON contract (Swagger jest tylko Development), dalszy ręczny przegląd i jeden kolejny pakiet. Dokładny retest status/DnD/loader/OnlyOffice i trzy sesje QA pozostają otwarte. Karta CUA 6 zachowana markHandoff, aktualny widok Lista projektu po zamknięciu panelu Escape. Cel szerokiego audytu pozostaje niezakończony.

## Kolejny pakiet manualnego QA — 2026-10-01

- [x] Staging: TASK-64 zmienił status przez menu na W toku (UI/SQL InProgress, Version 4), a następnie został przywrócony do Backlogu. DnD Backlog → W toku również zadziałał (liczniki 3/5); po teście DnD przywrócono przez UI Backlog (liczniki 4/4).
- [x] Wykryto podczas DnD odziedziczenie licznika podzadań przez kolejną kartę. Korzeń elementu listy i sekcja podzadań mają teraz klucz workspace/project/task; findChildIndexCallback zachowuje stan właściwej karty podczas zmiany kolejności. Dwa testy regresji sprawdzają usunięcie pierwszej karty i zachowanie rozwinięcia oraz zapytania dla właściwego rodzica po przestawieniu.
- [x] Obecność: heartbeat publikuje zdrowie połączenia; panel osób pokazuje komunikat i ponowienie przy awarii. Powrót połączenia usuwa komunikat. Profile pozostałych osób zachowują status potwierdzony przez API. Zamknięcie sesji anuluje subskrypcje/notifier.
- [x] Badge +N nie zawija cyfr (FittedBox scaleDown, jedna linia); testy także dla 124 i 1000 członków.
- [x] Backend seeder używa AnyAsync zamiast SingleOrDefault dla tytułu zadania: legalne duplikaty nie blokują kolejnego seedowania i nie są kasowane. Build backendu PASS, 0 warnings/errors.
- [x] OnlyOffice: rzeczywisty Blob iframe nadal osiągał timeout; potwierdzono instalowanie kanałów webview po onLoad. HTML kolejkuje wcześniejsze zdarzenia do dostępności kanału, ogranicza kolejkę do 64, kończy polling po 30 s lub pagehide. 4 testy Node VM PASS; to dowód protokołu JS, nie działającego edytora na serwerze.
- [x] Front: 50 testów PASS (karty/realtime/panel osób/globalny host/OnlyOffice/facepile); flutter analyze PASS (13.3 s). Pierwsze uruchomienia wykryły błędny finder licznika oraz błędną ścieżkę pliku testowego; poprawiono i uruchomiono cały ten zestaw ponownie.
- [ ] Publikacja tego pakietu Front Wasm + Backend jednym wdrożeniem, retry seeda, rzeczywisty retest edytora i DnD/liczników po publikacji.
- [ ] Trzy izolowane sesje QA czatu/online/offline. SQL potwierdził 3 konta QA, ale wcześniejszy seed nie doszedł do grupy rozmowy; dane logowania pobrano do chronionego pliku /tmp (bez publikowania wartości). Native Chrome był zablokowany blokadą Maca; wysłano jedno pytanie o odblokowanie, QA w IAB trwa dalej.
- [ ] Pozostają pełna akceptacja czatu/plików, obsługa awarii, motyw systemowy oraz końcowy przegląd szerokiego modala. Nie oznaczać całości jako gotowej na podstawie analizatora lub tej porcji testów.

Zastosowane UI UX Pro Max / Impeccable Operate: wspólne neutralne tokeny, kompaktowy panel desktop, jawny stan połączenia i retry, czytelny licznik bez przesunięć. Proof błędu kart: /tmp/devplanner-staging-kanban-card-state-leak-2026-10-01.png. Logi: /tmp/devplanner-final-batch-tests-v3.log, /tmp/devplanner-final-batch-analyze-v2.log, /tmp/devplanner-seed-duplicates-build.log.

## Odbiór stagingu — trzy izolowane konta, 2026-10-01

- [x] Backend `45cc0eb` i Front Wasm `a4828653dc1c5110a05624d4073280cfbdf6d07c` wypchnięte na main z `[skip ci]` i opublikowane skryptami SSH. Oba deploye EXIT 0, backend readiness Healthy, Wasm build PASS (96.6 s). Nie publikowano osobno drobnych zmian.
- [x] Ponowiony `devplanner-seed-demo` EXIT 0; SQL potwierdził jedną grupę `demo:global:qa-chat`. Istniejące powtarzające się tytuły zadań nie blokują seedera; nie czyszczono bazy.
- [x] Native Chrome / Safari / Firefox: osobne sesje QA Czat 01 / 02 / 03, rzeczywiste logowanie OIDC. Panel Listy pokazał wszystkie trzy QA online (łącznie 4 z istniejącą sesją). Po zamknięciu wyłącznie testowej karty Firefox panel bez reload pokazał QA 03 Offline, QA 01 i QA 02 Online. Aktualizacja profili co 15 s; wygasanie lease przy urwanym połączeniu 45 s, bez obietnicy natychmiastowego offline.
- [x] Czat grupowy: każde konto wysłało własną wiadomość; oba pozostałe odebrały ją bez odświeżania. Chrome i Safari pokazały Odczytano: 2 dla własnych wiadomości. To potwierdza wymianę tekstu i odczyty, nie pełną akceptację wszystkich funkcji czatu.
- [x] Retest rzeczywistego DnD TASK-64 Backlog → W toku: TASK-64 nadal 0 podzadań, TASK-115 zachowuje 1/1; brak przeniesienia stanu między kartami. Przywrócono TASK-64 do Backlogu, końcowy SQL `Backlog|9`. Badge +N pozostaje jednoliniowy.
- [ ] OnlyOffice na opublikowanym Wasm nadal osiąga timeout. Odczyt DOM iframe po retry wskazał about:blank i puste body/head; przyczyna nie jest jeszcze potwierdzona. Cztery testy JS kolejki kanału nie dowodzą działającego edytora. Wymaga dalszej diagnozy i osobnego retestu po rzeczywistej naprawie.
- [ ] Nadal otwarte: pełny zestaw funkcji czatu/plików, awarie, motyw systemowy i szeroki modal, OpenAPI/JSON/enumy end-to-end oraz pozostałe bramki planu. Nie oznaczać całości jako zakończonej.

Dowody: `/tmp/devplanner-staging-three-qa-online-2026-10-01.png`, `/tmp/devplanner-staging-qa03-offline-2026-10-01.png`, `/tmp/devplanner-staging-three-qa-chat-2026-10-01.png`, `/tmp/devplanner-staging-kanban-card-state-fixed-2026-10-01.png`, `/tmp/devplanner-staging-onlyoffice-final-batch-timeout-2026-10-01.png`. Logi testów pozostają wskazane w poprzednim pakiecie. Kolejny krok: diagnoza OnlyOffice i dalszy manualny QA w kolejnej zbiorczej paczce. Chrome/Safari QA pozostają otwarte do kontynuacji; testowa karta Firefox została zamknięta, IAB 6 zachowany do kontynuacji.

## OnlyOffice — odbiór Chrome/Safari i naprawa eksportu, 2026-10-01

- [x] Ten sam istniejący DOCX z plików workspace otworzył się w native Chrome (QA 01) i Safari (QA 02) na opublikowanym Wasm a482865. Oba pokazały Połączono, treść dokumentu i dwóch współredaktorów. Chrome console potwierdziła apiLoaded/editorCreated/appReady/ready. W tym kroku nie edytowano treści źródłowego pliku.
- [x] Zdiagnozowano osobną usterkę: onDownloadAs wystawiał eksport, ale XHR z X-OnlyOffice-JWT trafiał na odrzucony preflight CORS. Poprawiono wersjonowaną konfigurację Nginx wyłącznie dla /cache/files/: dokładny origin aplikacji, GET/HEAD/OPTIONS, X-OnlyOffice-JWT; bez wildcard i credentials. Upstream nadal weryfikuje podpis URL.
- [x] Konfigurację zainstalowano przez SSH po backupie; nginx -t PASS, reload EXIT 0. HTTP: właściwy origin OPTIONS 204 z dokładnym Allow-Origin; obcy origin bez Allow-Origin; niepodpisany/missing eksport nadal HTTP 403. Backend/Frontend binarki bez zmian, nie przebudowywano Wasm.
- [x] Dokładny retest przycisku Pobierz: Chrome download panel DOCX 28,5 kB, Gotowe. Przycisk Zapisz kopię uruchomiony raz; SQL potwierdził nowy załącznik-zadania (kopia) (kopia).docx, 29187 B, Ready/Clean, created 2026-10-01 21:15:14 UTC. Mac zablokował się przed sprawdzeniem kopii w katalogu; potwierdzono mutację serwerową, nie odbiór wizualny nowego wiersza.
- [ ] Timeout w IAB Codexa pozostaje odtworzony oddzielnie. Brak dowodu, że root cause jest wspólny z native Chrome/Safari; nie zmieniać hosta na podstawie samego pustego iframe w IAB. Wydruk, zapis zmian i reopen, zamknięcie, pełne funkcje czatu i pozostałe wymagania nadal otwarte. Mac aktualnie zablokowany; kontynuować niezależną pracę nad kodem/serwerem, runtime native wymaga odblokowania.

Dowody: /tmp/devplanner-staging-onlyoffice-chrome-ready-2026-10-01.png, /tmp/devplanner-staging-onlyoffice-safari-ready-2026-10-01.png, /tmp/devplanner-staging-onlyoffice-export-ready-2026-10-01.png. Konfiguracja: Backend/deployment/staging/nginx/devplanner-staging.conf. Backup serwera: /etc/nginx/sites-available/devplanner-staging.before-office-export. Następne manualne kroki: otworzyć nową kopię, wydruk do PDF bez fizycznego drukowania, zmiana+zapis+reopen na kopii QA, pozostałe funkcje czatu. Cel całości pozostaje niezakończony.


## Obecność — kontrakt końcowy i motyw systemowy, 2026-10-01

- [x] Pełny backend: 1481 PASS, 0 FAIL, 4 SKIP (Redis/two-host), 10 m 25 s. Snapshot testów sprzed dodania nowej bramki OpenAPI; nowa bramka uruchomiona osobno: 5 PASS. Logi /tmp/devplanner-final-full-backend-2026-10-01.log i /tmp/devplanner-presence-openapi-contract-2026-10-01.log.
- [x] ProjectMemberPresenceContractTests używa rzeczywistej konfiguracji HTTP JsonOptions, sprawdza wszystkie Owner/Admin/Member/Observer i true/false oraz wygenerowany swagger: enumy, isOnline, opis TTL i DTO elementu strony cursorowej. Front pełne task/chat/storage wire oraz profile repository: 9 PASS. ProjectRole to transport response; wartości bez zmian.
- [x] Wykryto domyślny jasny motyw Fluttera pomimo wymagania systemowego. Brak/nieznany zapis teraz oznacza Systemowy; istniejący jawny light/dark zachowany. Belka używa wspólnego AppContextMenu z Systemowy/Jasny/Ciemny zamiast dwustanowego toggle. Nie zmieniono tokenów ani frameworka. Lokalny enum motywu jest UI/persistence, nie kontraktem API.
- [x] Zapis nieudany nie publikuje wyboru i pokazuje lokalizowany komunikat; późny odczyt storage nie nadpisuje nowszego wyboru. UI UX Pro Max i Impeccable Operate: wspólne menu desktop, wybrana opcja, tooltip, istniejąca obsługa focus/klawiatury i neutralne tokeny. Detector scoped Dart: 0 findings, bez deklaracji wizualnego odbioru Flutter canvas.
- [x] Theme/Cubit/persistence/root + shared context menu: 22 PASS, w tym rzeczywista zmiana platformBrightness w widget teście i powrót do systemu. Log /tmp/devplanner-system-theme-tests-2026-10-01.log.
- [ ] Publikacja Wasm tego pakietu i wizualny odbiór motywu na stagingu. Mac zablokowany, pytanie o odblokowanie wysłane; nie zastępować testami widgetowymi odbioru przeglądarkowego.
- [ ] Dalszy manualny QA: kopia OnlyOffice / zapis-reopen / wydruk do PDF, pozostałe funkcje czatu, task modal i awarie. Obecność trzech kont, offline po zamknięciu i czat tekst/odczyty potwierdzone wcześniej na stagingu; całość nadal niezakończona.


### Publikacja i odbiór pakietu motywu

- Front main 7eed5681957f4a4aa166609ab87b1f3e97fa6f41 push oraz scripts/deploy_staging_wasm.sh EXIT 0. Opublikowany rzeczywisty Wasm, HTTP zasobów i tras PASS. Analyzer końcowy clean (10.5 s), diff --check clean. Backend main a3f8d64 to testy/dokumentacja, bez zmiany binarki/kontraktu runtime; backend 45cc0eb oraz konfiguracja Nginx 66893a7 pozostają aktualne.
- IAB staging /me/files: po reload menu Systemowy/Jasny/Ciemny z zaznaczonym Systemowy; wybrano Ciemny, obejrzano prawidłową ciemną powierzchnię i menu. Reload zachował Ciemny i zaznaczenie. Następnie przywrócono Systemowy i widoczny jasny motyw wynikający z bieżącego ustawienia przeglądarki. Zmianę ustawienia platformy w trakcie sesji potwierdza test widgetowy, nie ręczna zmiana macOS.
- Dowody: /tmp/devplanner-staging-system-theme-menu-2026-10-01.png, /tmp/devplanner-staging-theme-dark-2026-10-01.png, /tmp/devplanner-staging-theme-system-restored-2026-10-01.png. Log publikacji /tmp/devplanner-system-theme-wasm-deploy-2026-10-01.log. Native Chrome/Safari/Firefox wymagają odblokowania Maca; IAB działa i karta 6 zachowana markHandoff.
- Nadal niezamknięta całość: pozostałe funkcje czatu, pełny task modal, awarie i OnlyOffice zapis/reopen/print. IAB timeout OnlyOffice nadal otwarty oddzielnie od udanego Chrome/Safari.
