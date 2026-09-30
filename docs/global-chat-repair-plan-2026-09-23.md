# Globalny czat — przegląd i plan naprawy (23.09.2026)

## Zakres i stan dowodów

Repozytoria: Front `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`, Backend `/Users/przemyslawnowak/Desktop/dev/DevNote/Backend`. Punktem odniesienia jest zgłoszenie użytkownika i zrzut z 23.09.2026. To jest przegląd statyczny aktualnego drzewa, bez uruchamiania dodatkowej instancji aplikacji. „Potwierdzone” oznacza zachowanie wynikające wprost z kodu; „do odtworzenia” oznacza, że objaw zgłoszono, ale przyczyny nie można uczciwie rozstrzygnąć bez scenariusza runtime i odpowiedzi API. Nie uznawać istniejących testów jednostkowych za dowód działania interakcji w aplikacji.

## Usterki i braki — kolejność naprawy

| ID | Priorytet | Stan | Usterka i dowód | Oczekiwana naprawa |
| --- | --- | --- | --- | --- |
| C01 | P0 | Naprawione w kodzie; runtime odbiór otwarty | `ChatMessageActionMenu._handle` wywoływał `onPinnedChanged(!isPinned)` po `togglePin`, choć metoda zwracała `Future<void>` i Cubit mógł zapisać błąd bez wyniku dla wywołującego. | `togglePin` zwraca teraz jawny outcome `succeeded/failed/ignored`; menu odświeża przypięcia tylko po `succeeded`. Wspólny `_run` zawsze czyści pending w `finally`, także po wyjątku. Testy Cubita 8/8 PASS; analyze dotkniętych plików i `git diff --check` PASS. Widgetów nie uruchamiano. |
| C02 | P0 | Naprawione kodowo; odbiór staging/runtime otwarty | Read ACK wymaga widoczności najnowszej cudzej wiadomości. Front ponawia `failed` do trzech razy; audyt wykazał dodatkowo, że odpowiedź historii Backend jest newest-first, a Front wskazywał `messages.last` jako najnowszą bez normalizacji. Przejście aplikacji w tło mogło też zostawić ID jako już zgłoszone. | Tracker zachowuje monotoniczny kursor; Cubit sortuje wszystkie wiadomości chronologicznie po `(createdAtUtc, id)`. Lista próbuje ponownie po 1/2/4 s wyłącznie przy widoczności, czyści retry poza `resumed` i po wznowieniu mierzy wiadomość ponownie. Po ACK odświeża inbox i badge. Testy Cubit/read visibility 18/18 PASS; analyzer PASS. Ręczny odbiór tło→powrót i dwóch sesji/stagingu nadal otwarty. |
| C03 | P0 | Naprawione w kodzie; runtime odbiór otwarty | `_handlePaste` przechwytywał wklejenie, ale po rozpoznaniu progu zatrzymywał treść na karcie i czekał na ręczny wybór wysłania jako pliku. | Po przekroczeniu progu polityki Front automatycznie przygotowuje i uploaduje dokładny oryginał jako TXT do szkicu. Brak `ChatSnippetRepository` lub błąd przygotowania przechodzi na pełny upload Storage; tekst zostaje w karcie do retry/zachowania po błędzie. Decyzja progów 9/9 PASS, analyze PASS; runtime wklejenia desktop/mobile pozostaje otwarty. |
| C04 | P0 | Naprawione w kodzie; runtime odbiór otwarty | `ChatComposerCubit.updateRichText` emituje stan dla każdej zmiany Delta, a `BlocBuilder` bez `buildWhen` przebudowywał całą powierzchnię composera przy każdym znaku. To niepotrzebnie odtwarzało drzewo aktywnego edytora i mogło opóźniać/zakłócać widoczność wpisywanego tekstu. | `ChatComposerState.shouldRebuildComparedTo` ogranicza rebuild do zmiany trybu, przejścia pusty/niepusty, odpowiedzi, załączników lub wzmianek; kontrolery nadal renderują tekst/Delta bezpośrednio. Test polityki 2/2 PASS, analyze PASS. Odbiór IME/desktop/mobile na żywo pozostaje otwarty; testów widgetowych nie uruchamiano. |
| C05 | P0 | Naprawione w kodzie; runtime odbiór otwarty | Ostatni Owner dostawał 400, a UI pokazywało ogólny błąd; menu zmian ról ukrywało Ownera, więc nie było widocznej ścieżki przekazania własności. Po opuszczeniu sheetu wynik `true` nie czyścił aktywnej rozmowy. Backend już wspiera transakcyjne przekazanie roli Owner i democję dotychczasowego Ownera do Moderator. | Owner może wybrać „Przekaż własność” na członku; jeśli jest jedynym Ownerem, akcja opuszczenia jest zablokowana i wyjaśniona. Po potwierdzonym leave panel wraca do inboxa. Front zachowuje typ błędu i pokazuje osobne wskazówki dla 403, konfliktu, walidacji i braku połączenia; ostatni Owner dostaje dedykowaną informację. Testy members/search 15/15 PASS, analyze PASS; runtime wielosesyjny otwarty. |
| C06 | P1 | Naprawione kodowo; runtime odbiór otwarty | Reakcja z menu otwierała `showBottomSheet`, a forward centralny `showDialog`. | Reakcje, pełny picker `+` i wyszukiwalny wybór rozmowy forward otwierają się przez wspólne menu kontekstowe zakotwiczone przy dymku. Dostęp do cubitów jest zachowany z kontekstu wywołującego. Analyze i diff check PASS; bez testów widgetowych. Pozycjonowanie przy krawędziach i wygląd wymagają odbioru runtime. |
| C07 | P1 | Naprawione kodowo; runtime odbiór otwarty | Dymek i nadrzędne `SelectionArea` mogły otworzyć własne menu dla tego samego prawego kliknięcia. | Historia rozmowy i wątek śledzą `onSelectionChanged`; przy zaznaczonym tekście wyłączają prawy klik menu dymka, zostawiając menu selekcji. Bez zaznaczenia działają akcje dymka. Analyze i diff check PASS; widgetów nie uruchamiano. Ręczny test zaznaczenia/prawego kliknięcia pozostaje otwarty. |
| C08 | P1 | Naprawione kodowo; runtime odbiór otwarty | Karty wyboru pokazywały ikonę dokumentu bez lokalnej miniatury, a historia wyświetlała autoryzowany obraz w polu 36×36 px. | Composer pokazuje wybrane zdjęcie w 64×64 px. Historia pokazuje obraz w podglądzie do 280×210 px ograniczonym szerokością dymka; dekoder dostaje docelowy rozmiar cache. Pozostaje sprawdzić picker, wysyłkę, błędny obraz i jasny/ciemny motyw w aplikacji. |
| C09 | P1 | Naprawione w kodzie; runtime odbiór otwarty | Composer oferował platformowy picker, lecz nie istniała ścieżka dołączenia prywatnego pliku. | Menu `+` ma „Z Moich plików”; picker ChatTheme przegląda foldery, szuka i zaznacza wielokrotnie wyłącznie prywatne pliki `Clean + Ready`. Front przekazuje identyfikator źródłowego pliku przez kolejkę załączników. Backend kopiuje obiekt do aktywnej sesji Chat, egzekwuje członkostwo i prawo publikacji, własność, prywatny zakres, statusy i limity; oryginał pozostaje w Storage. Endpoint i DTO są opisane/testowane w OpenAPI. |
| C10 | P1 | Naprawione kodowo; runtime odbiór otwarty | Picker używał interaktywnego dziecka wyłączonego `PopupMenuItem`, kropek zamiast próbek emoji, a modyfikator tonu był doklejany na końcu klastra. | Picker używa własnego ChatTheme i menu kontekstowego, próbki tonu pokazują emoji, a odcień jest wstawiany po właściwej bazie przed ZWJ; istniejący odcień jest zastępowany. Testy katalogu/Unicode 14/14 PASS, pełny analyze i diff check PASS. Test wzrokowy w aplikacji pozostaje otwarty. |
| C11 | P1 | Naprawione kodowo; odbiór wizualny otwarty | W aktywnym panelu potwierdziłem, że sekcje Czaty/Grupy/Kanały są osobnymi pozycjami nawigacji, a Pliki i Zadania mają własne przygotowane sekcje. Aktywny widok nadal używał Material `FilterChip`, a repo zawierało nieużywany drugi `ChatInboxList` z poziomym przewijaniem i siedmioma `ChoiceChip`. | Filtry Czaty są własnymi pillami `ChatPanelFilterPill` w `ChatTheme`, zawijają się w dostępnej szerokości; sekcje Grupy/Kanały mają własny nagłówek, Pliki/Zadania pozostają osobne. Usunięto martwy duplikat. Odbiór 320/360/420 px, skalowania tekstu i pełnego widoku pozostaje otwarty; widget/golden odroczone do akceptacji UI. |
| C12 | P2 | Hipoteza odrzucona w aktualnym kodzie; runtime objawu nie odtworzono | `ChatMessageActionMenu.showAt` odczytuje `pinnedMessageIds` i `bookmarkedMessageIds` bezpośrednio z bieżącego Cubita przy każdym otwarciu. Po udanej mutacji Cubit emituje nowy zbiór; `isPinned`/`isBookmarked` przekazane przy budowie widgetu nie sterują pozycjami menu. Wcześniejszy opis o nieaktualnym snapshotcie był błędny. | Nie wprowadzać dublowanego lokalnego stanu. Jeśli problem pin/bookmark wróci w runtime, zebrać outcome API i stan po ponownym otwarciu menu; obecny kod nie potwierdza tej usterki. |
| C13 | P2 | Naprawione w kodzie; runtime otwarty | Backend generuje JPEG miniaturę załącznika Chat w finalizacji uploadu (maks. 640 px, twardy limit źródła 50 MP), zapisuje ją jako zarządzany obiekt i publikuje przez endpoint z kontrolą aktywnego członkostwa, relacji załącznika i statusu Clean. Front pobiera małe bajty przez Chat dla listy; pełny plik pobiera dopiero po jawnym otwarciu podglądu. | Sprawdzić w stagingu obrazy PNG/JPEG/WebP/GIF i błędne/duże pliki; potwierdzić mały transfer w liście, pełną rozdzielczość po otwarciu, ACL po leave/revoke i cleanup klucza miniatury. |
| C14 | P1 | Naprawione w kodzie; runtime odbiór otwarty | `ChatStatusMenuButton` pobiera status przy montowaniu i ponownym otwarciu, a trigger pokazuje zapisane emoji zamiast stale rysować `widget.icon`; po zapisie/wyczyszczeniu stan jest aktualizowany przez setState. Backend wygasły status zwraca jako null. | Kod ładuje status przy montowaniu i po otwarciu, pokazuje emoji, tooltip z tekstem, a po czyszczeniu wraca do ikony bazowej. Backend wygasły status mapuje na null. Runtime odbiór zmiany/wyczyszczenia na belce pozostaje otwarty. |
| C15 | P1 | Wyszukiwanie podstawowej frazy potwierdzone runtime; podgląd Delta naprawiony kodowo; zgłoszenie „nic nie zwraca” nadal wymaga reprodukcji | Front wysyła parametr `q`, backend wiąże go do `ChatSearchQuery.Q`; oba wymagają min. 2 znaków. Cubit wyszukuje po 300 ms i odrzuca spóźnione odpowiedzi. PostgreSQL używa indeksu GIN. Backend wcześniej szukał w bezpiecznym `SearchText`, ale `Highlight` tworzył tylko z `Text`, więc nie wyświetlał fraz będących wyłącznie w Quill Delta. | `Highlight` w FTS i fallback korzysta teraz z ograniczonego, zredagowanego `SearchText`. Backend `ChatFoundationTests` oraz testy PostgreSQL **70/70 PASS**; format verify i diff check PASS. Staging/runtime nadal ma potwierdzić wysyłanie frazy, `items.length`, zwykły tekst i Delta/kod dla DM/grupy oraz historycznych wpisów. |
| C16 | P0 | Poprawione w kodzie; czeka na weryfikację runtime | Przyczyna `ProviderNotFoundException` była potwierdzona: `ChatThreadSidePanel` czyta `ChatConversationRepository` i `ChatDraftRepository`, ale rootowy sheet dostarczał tylko `ChatThreadRepository`. `ChatThreadSheet.showThread` przyjmuje teraz wszystkie trzy zależności, tworzy dla nich `RepositoryProvider`, a wywołanie w `chat_drawer.dart` przekazuje conversation repository (z fallbackiem do `ChatRepository`, którego implementacja spełnia ten port) i draft repository. Pozostaje sprawdzić ręcznie otwarcie wątku w działającej aplikacji; testów nie uruchamiano zgodnie z ustalonym zakresem weryfikacji. | Audytować każdy `context.read` w root modalach. Przy braku wymaganej kompozycji pokazać jawny stan błędu zamiast bezgłośnie ignorować otwarcie. Sprawdzić AuthSessionPort i pozostałe opcjonalne zależności. |
| C17 | P1 | Naprawione kodowo; runtime odbiór otwarty | Odpowiedź pokazuje cytat oryginalnego posta. W pełnym ekranie klik cytatu ustawia target, wywołuje `ensureTargetLoaded`, a lista przewija do klucza celu i podświetla dymek. Panel globalny robi to samo przez `onEnsureTargetLoaded`; backend ma bezpieczne API okna wiadomości. | Ręcznie sprawdzić cytat, którego cel jest na bieżącej stronie oraz starszy/poza aktualną stroną, w pełnym ekranie i panelu. Widgetów/goldenów nie uruchamiać przed akceptacją UI. |
| C18 | P0 | Naprawione kodowo; odbiór runtime otwarty | Renderer ma ciemny kafelek, kolorowanie składni dla popularnych języków i kopiowanie. Audyt ujawnił też, że „Wstaw kod” w trybie zwykłego tekstu dodawało Markdown z widocznymi fence’ami, których historia nie renderuje jako blok kodu. | Wstawienie kodu przełącza teraz composer na Quill, zachowuje tekst i zaznaczenie, a do wiadomości wysyła `code-block` Delta. Codec rozdziela wcześniejszy akapit, jeśli kursor był w jego środku. Renderer scala sąsiadujące linie tego samego języka w jeden ciemny kafelek z tokenizacją składni. Testy czystego codec/renderera 8/8 PASS; analyze zakresu i pełny analyzer PASS. Odbiór UI/runtime pozostaje otwarty. |
| C19 | P0 | Naprawione Front + Backend; runtime odbiór otwarty | Composer już ma bezpieczny fallback etykiety, ale po odpowiedzi API wiadomość wraca z kanonicznym `@UUID`. Backend zwraca mapę etykiet tylko dla zapisanych relacji wzmianki tej wiadomości i aktywnych profili; Front renderuje etykietę w tekście i Delta, a nieznaną/dezaktywowaną osobę jako lokalizowany fallback. Użytkownik zgłosił `@a8878671-6c43-40bd-bbcd-c95654c3f90e`. | Naprawa dodana: `ChatMessageResponse.mentionLabels` łączy zapisane wzmianki z aktywnymi profilami; Front renderuje token jako czytelną nazwę, a brak profilu jako lokalizowany placeholder. Nie ujawnia UUID w UI. |
| C20 | P1 | Naprawione w kodzie; runtime odbiór otwarty | `ChatConversationManagementRepository.updateDetails` i backendowy `PATCH /conversations/{id}` istniały, ale menu nie udostępniało akcji nazwy. | Menu nagłówka udostępnia edytor ChatTheme Ownerowi/Moderatorowi dla grup; zapis korzysta z `updateDetails`, zachowuje politykę publikacji, odświeża snapshot i inbox. Direct, wątki i Resource Chat są wykluczone. |
| C21 | P1 | Naprawione kodowo; zwykły tekst potwierdzony runtime, rich text nadal otwarty | Użytkownik sprostował, że problemem nie był ucięty awatar: własna wiadomość renderowała się biała i po lewej. Przyczyna w ścieżkach optymistycznych została opisana w C22. | Pełny ekran i panel wątku przekazują bieżący `currentUserId` do kolejki; renderer porównuje `authorUserId` i stosuje wyrównanie oraz kolor nadawcy. Testy Cubita rozmowy 10/10, wątku/historii 16/16 PASS. W działającej aplikacji zwykła wiadomość własna była zielona i po prawej, przychodzące białe i po lewej. Sprawdzić jeszcze rich composer, błąd wysyłki i potwierdzenie API. |
| C22 | P0 | Naprawione kodowo; runtime UI otwarty | Autor optymistycznej wiadomości jest `userId` kolejki. Audyt ścieżek znalazł jednak dwa miejsca, które nie przekazywały go: pełna strona deep link tworzyła `ChatConversationCubit` z pustym domyślnym ID, a `ChatThreadCubit` budował własną kolejkę bez ID. | Pełny ekran przekazuje ID z `AuthSessionPort`; subpanel odpowiedzi przekazuje to samo ID do swojej kolejki. Test wątku sprawdza własnego autora natychmiast po optimistic enqueue i po potwierdzeniu. Potwierdzić runtime na pełnym ekranie i w panelu wątku. |
| C23 | P1 | Naprawione w kodzie; odbiór dwóch kont/runtime otwarty | `readByCount` liczył tylko jawne delivery-state rekordy dla tej konkretnej wiadomości. Gdy widoczna najnowsza wiadomość była własna, Front dodatkowo ignorował ACK, więc kursor rozmowy użytkownika nie przechodził przez wcześniejsze wiadomości. | Front oznacza odczytem każdą rzeczywiście widoczną wiadomość serwerową, także własną; Backend liczy odbiorców po ich monotonicznym kursorze rozmowy, więc przeczytanie późniejszej wiadomości obejmuje wcześniejsze. Autor nie jest liczony jako odbiorca własnej wiadomości. Test Front widoczności **7/7 PASS**; integracyjny Backend sprawdza wcześniejszą wiadomość po odczytaniu własnej nowszej **1/1 PASS**; build Backend PASS (0 ostrzeżeń), analyzer Front PASS. Potwierdzić jeszcze realtime i stan po ponownym wejściu w DM/grupie na dwóch kontach stagingowych. |
| C24 | P1 | Naprawione w kodzie; odbiór runtime otwarty | `chat_message_composer.dart` przekraczał limit 400 linii i łączył lifecycle, edytor, wklejanie, załączniki i prezentację. | Wydzielono kontrolery edytora, wzmianek i wklejania oraz `ChatMessageComposerView`. Właściciel composera ma teraz 357 linii; pozostałe nowe pliki mają 254, 367, 89 i 295 linii. Zachowano publiczny kontrakt i odpowiedzialność za lifecycle. |
| C25 | P0 | Przyczyna Front potwierdzona; poprawka i test jednostkowy PASS; staging do sprawdzenia | Pięć kolejnych `POST /api/v1/chat/conversations/{id}/messages` zakończyło się `400 validation.failed` z treścią „Wartość atrybutu Delta wiadomości Chat musi być wartością prostą JSON.” Trace ID: `0HNOPHJ6073M9:00000001` oraz `0HNOPHJ6073MA:00000001`–`0HNOPHJ6073MD:00000001` (23.09.2026). `ChatLineFormatCommands.toggledValue` oraz `applyLineFormatCommand` serializowały atrybut `list` jako tablicę `['bullet']`/`['ordered']`, mimo że backend `ChatMessage.ValidateDelta` odrzuca tablice, a renderer historii oczekuje wartości tekstowej. Pozostałe operacje formatowania composera tworzą wartość logiczną albo tekstową; `ChatCodeBlockCodec` tworzy skalarne atrybuty bloku. | Wysyłać wartości `list` jako skalarne `'bullet'`/`'ordered'`, zgodne z Quill, backendową walidacją i rendererem; zachować formatowanie po odczycie i edycji. Potwierdzić stagingowym wysłaniem wiadomości z listą oraz odczytem delty. Nie logować tekstu ani pełnej treści delty użytkownika. |
| C26 | P1 | Naprawa markerów w kodzie; runtime odbiór otwarty | Quill pobiera styl kropek i numerów z `DefaultStyles.leading`; Front wcześniej definiował `lists`, ale nie `leading`, więc markery dziedziczyły styl ogólnego `ThemeData`. Renderer historii miał jawnie stałe 24 px dla markera, co ucinało numery wielocyfrowe (np. `123.`). Kolory/czcionki nie są osobnymi kontrolkami aktywnego toolbaru. | Nadawać Quill markerom jawny tekstowy styl z `ChatTheme`; w historii użyć tego samego koloru i wagi, a szerokość wyznaczać z treści numeru. Potwierdzić w runtime kropki i numery podczas pisania oraz po wysłaniu. |
| C27 | P1 | Naprawione kodowo; odbiór wizualny runtime otwarty | Toolbar zapisuje `bold:true`, a kod Quill pobiera `DefaultStyles.bold`. Audyt wykazał, że oba renderery żądały niezałączonej wagi 900, choć Inter zawiera jedynie warianty 300/400/600/700. Quill i historia używają teraz wagi 700. Cytat nadal ma osobny blok z zieloną szyną i tłem. | Ręcznie sprawdzić pogrubienie i cytat podczas pisania oraz po wysłaniu, w jasnym i ciemnym motywie. Nie dodawać widget/golden przed akceptacją UI. |
| C28 | P0 | Naprawione w Backend i wdrożone na staging; request-level POST nie został sztucznie odtworzony, aby nie pisać do cudzej rozmowy. | Trace `0HNOPHJ607482:00000001` i `0HNOPHJ607483:00000001` pokazały, że Quill wysyła `attributes.code`, a allowlista Backend nie dopuszczała tego atrybutu. `ChatMentionParser` i Front renderer już go obsługiwały. | Dodano `code` do allowlisty oraz test dokładnej delty z wszystkimi formatami obecnego composera. Testy Delta 7/7 PASS; pełna suite Backend przed dodaniem samego testu zbiorczego 1307 PASS / 4 SKIP / 0 FAIL. Commit `446116a` zawiera poprawkę; staging wdrożono jako `537b92ad36bbd6f5f107ff968f564f4c2eed3849`. API healthy, readiness ready, migracje no-op. |
| C29 | P1 | Naprawione kodowo; pełny skan wykazał 0 plików ponad limit | Podzielono composera i wszystkie później wykryte duże odpowiedzialności; ostatni plik `chat_message_list_sheets.dart` rozbito na listę przypiętych, zakładek i wspólne komponenty listy. Skan wszystkich plików `.dart` w `presentation/chat` wykazał 0 plików powyżej 400 linii. | Zachować limit 400 linii dla klas/widgetów produkcyjnych i ponawiać statyczny skan po większych zmianach Chat. Nie używać `part`/mixin do ukrywania rozmiaru. Każdy nowy wyjątek wymaga osobnej, uzasadnionej decyzji w dokumentacji. |
| C30 | P1 | Naprawione kodowo; odbiór wizualny otwarty | Blok kodu dziedziczył rozmiar zwykłej treści; zwykły profil nie rozpoznawał wklejonego Dart bez etykiety, a zmienne i argumenty nazwane miały słaby kontrast. Lexer regex nie rozpoznawał poprawnie raw/triple strings, zagnieżdżonych komentarzy ani wieloznakowych operatorów. | Blok używa 12 px monospace, mniejszej od treści wiadomości, ale czytelnej w historii. Osobny lexer Darta rozpoznaje raw/triple strings, komentarze zagnieżdżone, liczby i operatory; highlighter rozpoznaje Flutter/Dart również bez etykiety oraz odróżnia typy, metody, deklaracje/odwołania do zmiennych, argumenty nazwane i właściwości. Parser TextMate odrzucono z powodu konfliktu zależności. Testy highlightera/codec **33/33 PASS**; odbiór wizualny aplikacji nadal otwarty. |
| C31 | P1 | Naprawione kodowo; runtime/staging otwarty | Kontrakt wyszukiwania wymagał respektowania HTTP `Retry-After`, lecz `ApiError`/`ChatApiErrorMapper` gubiły nagłówek, a przy 429 UI oferował natychmiastowe ponowienie. | `Retry-After` w sekundach i formacie HTTP-date jest przenoszony przez mapper. Wyszukiwarka pokazuje odliczanie i blokuje retry do terminu backendu. Testy parsera, mappera i Cubita 30/30 PASS; analyzer zakresu i `git diff --check` PASS. Runtime/backend bez zmian. |
| C32 | P1 | Naprawione w kodzie i kontrakcie; odbiór runtime otwarty | Odpowiedź przechowywała tylko `replyToMessageId`. W full-screen brakowało autora, a gdy oryginalny post nie należał do załadowanej strony, UI pokazywało „oryginał niedostępny”. | Backend zwraca `replyPreview` ograniczony do wiadomości z tej samej rozmowy: autora, do 240 znaków tekstu, wzmianki z zapisanych relacji, informację o załączniku/usunięciu. Treść usuniętego posta jest redagowana; Front czyści cytat przy realtime delete także w oknie historii, gdy cel nie jest załadowany. Front pokazuje autora i cytat poza bieżącą stroną oraz neutralny nagłówek bez profilu. Backend PostgreSQL + OpenAPI/JSON **13/13 PASS**; Front adapter/JSON oraz realtime reducer i koordynator **28/28 PASS**, analyzer i format PASS. Nie uruchamiano widgetów/goldenów; odbiór wyglądu w runtime otwarty. |

## Pakiety implementacyjne dla kolejnego agenta

### A. Stabilność i stan serwera

1. Odtworzyć C01/C02/C05 na jednym koncie oraz na dwóch kontach, zapisać request, status, `code`, traceId bez sekretów. Sprawdzić DM, grupę, kanał, Ownera, Moderatora, członka i osobę bez ACL.
2. Naprawić przepływ read w `ChatPanelMessageList`, `ChatConversationCubit`, `ChatInboxCubit`, `ChatUnreadCubit`; potwierdzenie serwera musi aktualizować licznik oraz listę bez ponownego otwierania. Backend zmieniać tylko, gdy scenariusz pokaże wadę `MarkReadAsync`/inbox query.
3. Zmienić kontrakt Cubita akcji z `Future<void>` na jawny wynik dla pin/unpin/bookmark/forward/reaction; callbacki tylko po sukcesie. Zablokować duplikaty w trakcie żądania; zachować realny `code` błędu.
4. Po udanym leave wykonać jeden przepływ wyjścia przez właściciela panelu, odłączyć subskrypcje i wyczyścić historię z pamięci. Obsłużyć odmowę ostatniego Ownera i utratę ACL w locie.
5. Bramka po pakiecie: testy logiki Cubit i kontraktu REST dla read/pin/leave (sukces, błąd, race, ACL). Jeden ręczny przebieg w aplikacji; bez serii testów przy każdym pliku.

### B. Composer i załączniki

1. Ujednolicić paste z klawiatury, kontekstowego menu i Quill. Próg TXT z serwerowej `ChatLinkPolicy`; zachować dokładne bajty tekstu, limit pliku i rozsądny komunikat o przygotowaniu. Scenariusze: krótkie, długie, multiline, Unicode, wklejenie przy zaznaczeniu, tryb plain/rich, nieudany upload i retry.
2. Usunąć wymianę kontrolera podczas aktywnej edycji albo wymusić natychmiastowe przepięcie Quill; sprawdzić wpisywanie w czasie rzeczywistym, formatowanie, undo/redo, `@mention`, kod i draft po powrocie.
3. Dodać lokalny podgląd zdjęcia w karcie composera; po wysyłce sprawdzić ticket, odpowiedź i renderer. Dostęp do obrazów przez ACL Storage; nie utrwalać presigned URL w szkicu.
4. Dodać picker prywatnych plików i dopiero po audycie backendowego `AttachAsync` zdecydować, czy istniejący kontrakt wystarczy. Jawnie porównać źródło pliku, uprawnienia do odczytu, ACL rozmowy, status skanowania, deduplikację i lifecycle po usunięciu.
5. Bramka po pakiecie: testy logiki paste/Quill/upload oraz pojedynczy przebieg desktop + web z jednym małym i dużym obrazem. Testy widgetowe dopiero po zatwierdzeniu UI przez użytkownika; testów golden nie tworzyć.

### C. Powierzchnie interakcji i wygląd

1. Zbudować jeden system zakotwiczonych popoverów czatu dla reakcji, forward, emoji, filtrów i menu wiadomości. Użyć tokenów `ChatTheme`; nie pozwolić Material na domyślne kolory/tint ani przezroczyste ikony. Pozycjonowanie sprawdzić po lewej/prawej krawędzi i przy dolnej krawędzi panelu.
2. Rozwiązać konflikt `SelectionArea`/dymek przez jedno menu kontekstowe. Pierwszy prawy klik na zaznaczeniu nie może otwierać dwóch nakładek; skróty kopiowania i zaznaczania muszą nadal działać.
3. Przeprojektować filtr inboxa na wąskiej szerokości zgodnie ze zrzutem użytkownika. Zachować osobne wejścia dla rozmów bezpośrednich, grup, kanałów oraz planowanych kanałów plików i zadań; nie eksponować nieaktywnych funkcji jako działających.
4. Picker emoji: zamienić próbki odcieni na rzeczywiste emoji, naprawić generowanie wariantów Unicode, kontrast i opacity, dostępność, klawiaturę oraz ostatnio używane. Przetestować quick reactions i status.
5. Bramka po pakiecie: ocena wizualna prawdziwej aplikacji przez użytkownika przed pisaniem testów widgetowych. Nie tworzyć goldenów. Potem jedna zbiorcza seria testów widgetowych dla zaakceptowanego UI.

## Kontrola dodatkowych błędów podczas pakietów

Przejść cały cykl: utworzenie DM/grupy/kanału, dodanie/usunięcie osoby, rola i Owner, wiadomość/reply/thread/mention, edycja/usunięcie, reakcja, pin/bookmark, forward, draft, załącznik lokalny i prywatny, plik duży, wyszukiwanie, unread/read, archiwum, mute, realtime offline/reconnect, utrata ACL. Dla każdej akcji zweryfikować loading, sukces, błąd, powtórzenie, nawigację i stan po restarcie. Odkryte usterki dopisać do tabeli z plikiem, linią i reprodukcją przed implementacją. Nie deklarować „wszystkich błędów” bez przejścia tych ścieżek.

Przy każdej zmianie DTO/API wykonać audyt wszystkich enumów dotkniętego przepływu: klasyfikacja request/response/persistence/UI, dokładne wartości JSON w C#, OpenAPI, odpowiedzi i kliencie Flutter wraz z `.g.dart`, test encode/decode każdej wartości i fallback. To wymaganie obowiązuje również wtedy, gdy sam enum się nie zmienia. Backend wdrażać na staging tylko gdy pakiet rzeczywiście zmieni backend i po przejściu bramek; nie uruchamiać wielu instancji aplikacji. Nie commitować ani pushować bez polecenia.

## Kryterium zakończenia

Dla funkcjonalnych usterek C01–C28 wymagane są dowód reprodukcji lub odrzucenia, zmiana z potwierdzonym wynikiem i ręczny odbiór w aplikacji, a plan/handoff muszą być aktualne. C29 jest wymaganiem strukturalnym i zamyka go pełny skan plików oraz analiza statyczna; nie wymaga osobnego ręcznego odbioru UI. Nie wystarczy zielony build dla błędów funkcjonalnych. Widgety uruchomić zbiorczo dopiero po akceptacji UI; goldeny pozostają wyłączone.

## Postęp napraw

### CHAT-R92 — widoczne miniatury zdjęć (24.09.2026)

Wybór załączników pokazywał dla obrazu tę samą ikonę co dla dokumentu; zdjęcie
nie miało lokalnego podglądu. Teraz composer używa bajtów (Web/drop) albo
bezpośrednio ścieżki pliku na desktopie, z dekodowaniem do cache 128 px. W
historii obraz był renderowany zaledwie w 36×36 px; teraz podgląd ma do
280×210 px i jest ograniczony szerokością dymka. Usterka transferu pełnych
bajtów historii pozostaje osobną pozycją C13.

Weryfikacja: `flutter analyze --no-pub` dla trzech dotkniętych komponentów —
PASS bez uwag; `git diff --check` — PASS. Widget/goldenów nie uruchamiano;
odbiór rzeczywistego wyboru, wysyłki i historii pozostaje otwarty.

### Audyt kontraktu Quill ↔ Backend (2026-09-23)

Źródła sprawdzone bezpośrednio: Front `chat_composer_rich_toolbar.dart`,
`chat_format_commands.dart`, `chat_format_actions.dart`,
`chat_message_composer_fields.dart`, `chat_rich_text_codec.dart` i
`chat_code_block_codec.dart`; Flutter `flutter_quill 11.5.1` (zależność
`pubspec.lock`, API atrybutów z `.pub-cache`); Backend
`Domain/Entities/ChatMessage.cs` oraz `Application/Chat/ChatMentionParser.cs`.
Flutter Quill jest edytorem/modellem dokumentu, a nie kontraktem API: jego
możliwości nie oznaczają, że Chat UI pokazuje te formaty, że własny renderer je
wyświetli ani że serwer zaakceptuje ich wartości.

Backend przyjmuje tablicę operacji z tekstowym `insert` i opcjonalnymi
`attributes`; ogranicza liczbę operacji do 10 000 i JSON do 200 000 znaków.
Dozwolone atrybuty są ograniczone do formatów rozumianych przez Chat:
`bold`/`italic`/`underline`/`strike`/`code`/`blockquote` jako `true`, `link`
jako bezpieczny absolutny HTTP(S), `code-block` jako `true` albo nazwa języka
do 32 znaków oraz `list` jako `bullet`/`ordered`. Nieznane lub powtórzone pola,
atrybuty, embed-y oraz wartości spoza schematu są odrzucane. Obrazy i pliki mają
osobny kontrakt załączników Storage, nie Quill embed.

Pakiet `flutter_quill 11.5.1` zna znacząco szerszy zestaw atrybutów: inline
`bold`, `italic`, `underline`, `strike`, `code`, `font`, `size`, `link`,
`color`, `background`, `script`; blokowe `header`, `align`, `direction`,
`list`, `code-block`, `blockquote`, `indent`, `line-height`; oraz atrybuty
embeds/rozszerzeń m.in. `image`, `video`, `width`, `height`, `style`, `token`,
`placeholder`. Standardowe wartości obejmują m.in. `list: bullet|ordered|checked|unchecked`,
`align: left|center|right|justify`, `direction: rtl`, nagłówki 1–6,
`script: sub|super`, `indent` poziomy całkowite. Formuła jest embedem/rozszerzeniem
zależnym od konfiguracji; nie jest bezpiecznie obsługiwana samym allowlistowaniem
atrybutu `formula`.

| Format/wartość Delta | Toolbar Quill | Backend | Renderer historii Front | Ocena |
|---|---|---|---|---|
| `bold: true`, `italic: true`, `strike: true`, `code: true` | Tak; `code` to Quill `inlineCode` | Dozwolone (`code` dodane w CHAT-R78) | Wszystkie renderowane; kod dostaje styl monospace/tło | Zgodne na poziomie klucza i wartości |
| `link: URL` | Nowy link tylko absolutne HTTP/HTTPS, bez hostless URL/userinfo; ścieżki `/` odrzucane | Dozwolone, backend wymaga absolutnego HTTP/HTTPS bez userinfo | Renderowany i klikalny dla bezpiecznego URL HTTP/HTTPS; renderer zachowuje też obsługę starszych ścieżek `/` | Nowe linki Front/Backend zgodne; historyczne ścieżki można odczytać, ale UI nie tworzy już payloadu odrzucanego przez serwer |
| Listy Quill `ul`/`ol` | Tak; `Attribute.ul`/`Attribute.ol` zapisują standardowe klucze `list: bullet` / `list: ordered` | `list` dozwolone; wartość skalarna przechodzi | Renderer rozpoznaje dokładnie `bullet` i `ordered` | Zgodne; nie mapować na literalne `ul`/`ol` w JSON |
| `blockquote: true`, `code-block: true` lub język tekstowy | Tak; cytat/blok kodu; osobny „Wstaw kod” zapisuje język | Dozwolone; wartości są skalarne | Cytat i code block renderowane; code block zachowuje opcjonalny język | Zgodne |
| `underline: true` | Brak przycisku w bieżącym toolbarze | Dozwolone | Renderer obsługuje | Backend/history wspierają, ale użytkownik nie może włączyć tego przez aktywne UI |
| `header`, `indent`, `align`, `direction`, `color`, `background`, `font`, `size`, `script`, `line-height`, `width`, `height`, `style`, `token`, `placeholder`, `formula` | Brak w aktywnym chat toolbarze (Quill library ma własne kontrolki, ale Chat używa własnego toolbara) | Odrzucane jako nieobsługiwane formaty Chat | Renderer nie prezentuje ich | Wcześniej Backend przyjmował część z nich bez walidacji typu, a Front gubił je w historii; teraz są jawnie odrzucane |
| Embed `insert: {image|video|link: ...}` lub inny obiekt | Composer nie tworzy Quill embedów; obrazy/pliki idą przez załączniki Storage | Odrzucane; `insert` musi być tekstem | Stare historyczne embedy pozostają widocznym placeholderem | Nowe wiadomości nie mogą zapisać treści, której historia nie renderuje |
| `emoji` | Emoji są wstawiane jako tekst Unicode przez osobny picker/menu, nie jako format Quill | Zwykły tekst; nie wymaga atrybutu Delta | Renderer prezentuje tekst Unicode | Emoji nie jest formatem Delta. Warianty skóry wymagają poprawnych sekwencji Unicode, ale nie zmiany kontraktu Quill |

Wnioski: (1) zatwierdzony zestaw formatów produktowych jest walidowany przez
Backend, a renderer ma odpowiadające mu ścieżki; (2) renderer historii zachowuje
bezpieczne odczytanie istniejących danych nieobsługiwanych, nie gubiąc reszty
treści; (3) zdecydować, czy `underline` ma dostać przycisk; (4) osobno
zdecydować o nagłówkach/kolorach/
rozmiarze i innych opcjach Quill, nie włączając ich przypadkiem przez domyślne
toolbary pakietu. Linki nowo tworzone przez Front zostały dopasowane do
walidatora HTTP/HTTPS; stary renderer nadal obsłuży bezpieczne ścieżki zachowane
w istniejącej historii. Testy Frontu formatowania/rendererów **21/21 PASS**,
a testy Backend dokładnej delty formatowania, bezpiecznych linków i błędnych
wartości przechodzą. Nadal brakuje jednego uruchamianego automatycznie,
międzywarstwowego fixture Front JSON → Backend walidacja → renderer historii
dla każdej opcji; ręczna wysyłka na stagingu również pozostaje otwarta.
W szczególności bieżący kod `code: true` jest
dozwolony przez obecny kod Backendu (CHAT-R78); zgłoszony HTTP 400
`Atrybut ... 'code' nie jest dozwolony` z trace `0HNOPHJ607482:00000001`
oznacza, że instancja staging obsługująca ten request nie miała tej wersji
walidatora albo była uruchomiona przed wdrożeniem. `code-block` jest osobnym,
również dozwolonym kluczem. Nie należy mapować ich zamiennie.

- C05: backend role update już obsługiwał transakcyjne przekazanie własności. Front pokazuje „Przekaż własność” właścicielowi, blokuje leave jedynego Ownera z czytelnym wyjaśnieniem i obsługuje potwierdzony wynik opuszczenia: wraca do inboxa oraz odświeża liczniki. Testy `g5_search_and_members_test.dart` 15/15 PASS, analyze zakresu PASS, diff check PASS. Ręczny scenariusz Owner → transfer → leave na dwóch sesjach nadal otwarty.
- C03: długie wklejenie po przekroczeniu polityki samo uruchamia dołączenie TXT; oryginał pozostaje w stanie karty, a brak/błąd Snippet API korzysta z pełnego Storage upload. Krótkie wklejenie nadal wstawia tekst normalnie. `chat_long_paste_decision_test.dart` 9/9 PASS, analyze dotkniętego zakresu PASS, `git diff --check` PASS. Test/widget runtime clipboard pozostaje otwarty.
- C04: potwierdzono, że każda zmiana rich text emitowała Cubit state i przebudowywała całe drzewo composera. Dodano `buildWhen` przez politykę stanu: rebuild tylko po zmianie trybu, dostępności treści, odpowiedzi, listy załączników lub wzmianek. Test `chat_composer_state_test.dart` 2/2 PASS, `dart analyze` dotkniętych plików PASS, `git diff --check` PASS. Widget/runtime odbiór pozostaje otwarty.
- C02: read ACK jest powiązany z widocznością i lokalnym monotonicznym kursorem `(CreatedAtUtc, Id)`. Wcześniejsza reguła ignorowała wiadomość własną; CHAT-R143 ją usuwa, bo serwerowy kursor rozmowy musi objąć widoczną najnowszą wiadomość i wcześniejsze wpisy. Test `chat_conversation_read_visibility_test.dart` 7/7 PASS, analyzer dotkniętych plików i diff check PASS. Odświeżenie inboxa/globalnego badge po sukcesie jest już w kodzie; odbiór dwóch sesji i runtime pozostaje otwarty.
- C16: brakujące providery rozmowy i draftów przekazywane są jawnie do rootowego sheetu wątku. Brak testów i ręcznej weryfikacji runtime.
- C18: dodano ciemną powierzchnię i tokenizację składni; codec generuje format bloku dla każdej linii. Brak testów i walidacji wizualnej w runtime.
- C17: dymek renderuje teraz cytat odpowiedzi; lokalizacje PL/EN wygenerowano. `dart analyze` zmienionych widgetów przechodzi; brak testów i ręcznej walidacji wizualnej.
- C19: potwierdzono ścieżkę transportową, która może pokazać UUID zamiast czytelnej etykiety. Naprawa etykiety i renderowania wzmianki jest do wykonania.
- C20: istnieje kontrakt zmiany nazwy w backendzie i repozytorium Front; brak akcji/formularza UI.
- C21: użytkownik sprostował pierwotną obserwację; ucięty awatar na zrzucie nie jest zgłoszonym błędem i nie należy go diagnozować w ramach C21.
- C21: użytkownik sprostował, że istotny problem na zrzucie to biała, lewa wiadomość napisana przez siebie; plan skorygowano i poprzednia hipoteza o awatarze cofnięta.
- C22: wykryto potwierdzoną przyczynę białych optymistycznych wiadomości: puste `authorUserId` w obu ścieżkach tworzenia kolejki.
- C23: backend emituje `chat.message.read` i `chat.message.delivered`, ale Front wcześniej klasyfikował je jako `unsupported` (pełny resync), a przy oknie starej wiadomości pomijał wszystkie eventy. Dodano typowany event zmiany dostarczenia/odczytu; reducer zleca pobranie autorytatywnego okna tej samej wiadomości, a Cubit scala rekord również w historii okienkowej. Testy mappera/reducera **14/14 PASS**, `dart analyze` dotkniętych eventów, reducera, mappera, Cubita i testów PASS; odbiór dwukontowy pozostaje otwarty.
- C24: podział composera wykonano bez plików `part`/mixin. Pełny `flutter analyze --no-pub` i testy jednostkowe powiązanych polityk composera przechodzą; widgetów/goldenów nie uruchamiano przed akceptacją UI. Ręczny runtime nadal otwarty.
- C25: pięć stagingowych 400-ek miało wspólną przyczynę w formacie listy Quill: Front wysyłał `attributes.list` jako tablicę. Zmieniono wartość modelu i wywołanie Quill na jego skalarne atrybuty `ul`/`ol`; renderer już rozumiał tekstowe `'bullet'`/`'ordered'`. Przejrzane pozostałe operacje formatowania nie tworzą zagnieżdżonych atrybutów. Test `chat_format_commands_test.dart` **12/12 PASS**, `dart analyze` zakresu PASS, `git diff --check` PASS. Backend/API nie wymaga zmiany. Potwierdzenie wysyłki i odczytu na stagingu pozostaje otwarte.
- C26: dodatkowy audyt wykazał, że Quill rysuje markery z `DefaultStyles.leading`, a nie wyłącznie z `lists`. Ustawiono leading jawnie z `ChatTheme`; renderer historii daje markerom kontrastowy styl i naturalną szerokość, więc `123.` nie jest ograniczone do 24 px. Analiza i czyste testy domenowego codec/code block PASS; widgetów/goldenów i runtime nie uruchamiano. Opcje koloru/tła/rodziny/rozmiaru fontu pozostają nierozstrzygnięte; nie są obecnie eksponowane.

- C27: użytkownik zgłasza ponownie niewidoczne bold i markery `123.`/kropek. C26 nie ma jeszcze odbioru wizualnego; font bazowy to 14 px bez jawnej rodziny, a toolbar nie zawiera wyboru fontu/koloru/rozmiaru. Weryfikacja musi objąć jasny/ciemny motyw, edycję na żywo, stan aktywnego formatowania i treść po wysłaniu. Nie dodawać formatów, które nie przechodzą walidacji backendu i renderera historii.

- C28: błąd stagingowy `attributes.code` wynikał z nieaktualnej wersji walidatora. Backend dopuszcza Quill inline code od commita `446116a`; testy walidacji Delta 7/7 PASS. 24.09.2026 wdrożono `537b92ad36bbd6f5f107ff968f564f4c2eed3849` skryptem ręcznym; API healthy, readiness ready, obie migracje no-op. Po wdrożeniu nie wysłano sztucznej wiadomości do cudzej rozmowy. Szczegóły CHAT-R91.

- C01: menu przypięcia reaguje callbackiem tylko na ACK. Cubit zwraca wynik typowany `succeeded/failed/ignored`; wyjątek nie pozostawia wiadomości w pending. Testy `chat_message_secondary_actions_test.dart` 8/8 PASS, `dart analyze` zakresu PASS. Runtime UI nie sprawdzono; brak widget testu zgodnie z decyzją użytkownika.


## CHAT-R88 — zmiana nazwy grupy z nagłówka (24.09.2026)

C20 naprawione we Froncie przez dodanie „Zmień nazwę rozmowy” do menu
nagłówka. Akcja jest dostępna dla Ownera/Moderatora w rozmowach grupowych,
wyklucza Direct, wątki i Resource Chat, a backend nadal egzekwuje ACL. Edytor
ChatTheme ogranicza nazwę do 240 znaków i zapisuje przez istniejące
`updateDetails`, zachowując `postingPermission`. Po sukcesie aktywna selekcja
przyjmuje odpowiedź serwera, a inbox jest odświeżany. Porównanie selekcji
uwzględnia teraz cały snapshot rozmowy, więc zmiana nazwy tej samej rozmowy nie
jest pomijana.

Weryfikacja: `flutter analyze --no-pub` dotkniętego zakresu PASS;
`chat_panel_selection_role_test.dart` **6/6 PASS** (w tym aktualizacja nazwy);
`git diff --check` PASS. Testów widgetowych/goldenów nie
uruchamiano przed akceptacją UI. Ręczny odbiór i zachowanie po otwarciu na
stagingu pozostają otwarte.


## CHAT-R89 — czytelne etykiety wzmianek po wysłaniu (24.09.2026)

C19 naprawione end-to-end. Kontrakt `ChatMessageResponse` zawiera teraz
`mentionLabels`; Backend buduje je wyłącznie z relacji `ChatMessageMention` tej
strony wiadomości (w tym wierszy dodanych w bieżącej transakcji) i aktywnych
profili katalogu. Nie wykorzystuje surowych tokenów tekstu do rozszerzania
odbiorców. Front mapuje etykiety w historii, oknie wiadomości, edycji i wątku;
renderer podmienia `@UUID` także wewnątrz Delta. Nieznany/dezaktywowany profil
ma lokalizowany fallback, więc UUID nie jest prezentowany.

Audyt enumów: DTO `ChatMessageResponse` i `mentionLabels` nie dodają ani nie
zmieniają enumów transportowych. `ChatMessageDeliveryState` pozostaje lokalnym
UI. Weryfikacja: backendowe testy historii wzmianki + OpenAPI **10/10 PASS**;
pełna suite Backend: **1316 PASS / 4 SKIP / 0 FAIL** (uruchomiona przed ostatnim, zawężającym filtrem etykiet; finalny filtr pokrywa ponownie zestaw 10 testów). pełny `flutter analyze --no-pub` PASS; codec, kontrakt JSON, mapowanie repozytorium i selekcja **31/31 PASS**. Widgetów
i goldenów nie uruchamiano przed akceptacją wyglądu.


## CHAT-R90 — scalanie wielowierszowego bloku kodu (24.09.2026)

W rendererze historia była dzielona na osobne bloki, gdy Delta zawierała
poprawne terminatory Quilla z atrybutem `code-block` dla kolejnych linii. Parser
zbiera teraz sąsiadujące linie tego samego języka do jednego
`ChatRichTextBlock`; zmiana języka lub zwykły akapit zamyka blok. Kafelek
zachowuje znaki nowej linii, wcięcia i istniejące kolorowanie składni/ciemny
wygląd.

Weryfikacja: pełny `flutter analyze --no-pub` PASS; testy powiązane (codec, wzmianki,
kontrakt, mapowanie, selekcja) **40/40 PASS**, w tym
`chat_rich_text_codec_test.dart` **9/9 PASS**, w tym Delta zbudowana przez
`ChatCodeBlockCodec` dla dwuliniowego Python. Testów widgetowych/goldenów nie
uruchamiano przed akceptacją UI. Manualne sprawdzenie w Quill podczas pisania
i po odczycie API pozostaje otwarte.


## CHAT-R93 — pliki prywatne i zapis odebranych załączników (24.09.2026)

Menu `+` otwiera ChatTheme picker prywatnego Storage z nawigacją po folderach,
wyszukiwaniem, paginacją i wielokrotnym wyborem. UI pokazuje wyłącznie pliki
`Private`, `Clean`, `Ready`, czytelne dla bieżącego użytkownika. Zaznaczenie
przechodzi przez wspólną kolejkę załączników, ale nie pobiera danych na klienta:
backend tworzy niezależny plik `Comment` w aktywnej sesji i kopiuje obiekt
Storage po stronie serwera. Backend sprawdza członkostwo/prawo publikacji,
właściciela źródła, scope i limity.

Odebrany załącznik ma w menu kontekstowym „Zapisz w Moich plikach”. Backend
tworzy idempotentną prywatną kopię użytkownika. Dla formatu obsługiwanego przez
politykę OnlyOffice dostępne jest też „Zapisz i otwórz w OnlyOffice”; Front
ponownie pobiera szczegóły kopii i otwiera istniejący, autoryzowany edytor.
Formaty, których `canEditOnline` jest false, nie dostają tej akcji. Nie
zmieniono enumów ani schematu bazy danych.

Weryfikacja: backend `ChatAttachmentLifecycleTests` + `ChatOpenApiContractTests`
**20/20 PASS**; Front `chat_attachment_upload_cubit_test.dart` **5/5 PASS**
(kopia serwerowa bez uploadu binarnego), test sesji/repozytorium **4/4 PASS** i
adapter uploadu **9/9 PASS**; `flutter analyze --no-pub` PASS.
Widgetów/goldenów nie uruchamiano zgodnie z decyzją użytkownika. Runtime
Storage/OnlyOffice i przegląd UI w aplikacji pozostają otwarte.


## CHAT-R95 — menu kontekstowe reakcji, forward i emoji (24.09.2026)

Reakcje, pełny picker wywołany przyciskiem `+` oraz wyszukiwalny wybór rozmowy
docelowej dla forward otwierają się w zakotwiczonym `AppContextMenu`. Forward
zachowuje istniejący Cubit i idempotency key. Brak rozmów docelowych jest
pokazywany w małym menu zamiast centralnego dialogu. Próbki odcieni są
prawdziwymi emoji, a modyfikator jest poprawnie wstawiany przed ZWJ i zastępuje
istniejący ton.

Weryfikacja: pełny `flutter analyze --no-pub` PASS, test katalogu/tonu
**14/14 PASS**, `git diff --check` PASS. Widgetów/goldenów nie uruchamiano.
Ręczny odbiór UI, pozycjonowania przy krawędziach i obsługi klawiatury pozostaje
otwarty.


## CHAT-R96 — arbiter prawego kliknięcia przy zaznaczonym tekście (24.09.2026)

Historia rozmowy i panel wątku reagują na zmianę zaznaczenia tekstu. Jeśli
zaznaczenie jest aktywne, handler prawego kliknięcia dymka jest wyłączony i
pozostaje menu wyboru tekstu. Po skasowaniu zaznaczenia prawy klik na dymku
ponownie otwiera jego menu akcji.

Weryfikacja: pełny `flutter analyze --no-pub` PASS i `git diff --check` PASS.
Widgetów nie uruchamiano. Odtworzenie prawego kliknięcia z zaznaczeniem w
runtime pozostaje otwarte.


## CHAT-R97 — audyt stanu przypięć i zakładek (24.09.2026)

Weryfikacja C12 odrzuciła wcześniejszą hipotezę: każdorazowe otwarcie menu
pobiera bieżące zbiory z Cubita, a udana mutacja emituje nowe zbiory. Parametry
przekazane przy budowie `ChatMessageActionMenu` nie sterują etykietami menu.
Nie dodano lokalnego stanu. Zgłoszony objaw runtime nie został odtworzony i
wymaga danych API, jeśli powróci.


## CHAT-R98 — audyt podwójnego znacznika odczytu (24.09.2026)

Backend dostarcza serwerowe liczniki potwierdzeń, Front dekoduje je w każdej
ścieżce mapowania wiadomości, a `ChatMessageMetadata` wybiera `done_all` tylko
dla własnej wiadomości po read ACK. Event read/delivery odświeża autorytatywny
rekord, w tym gdy wiadomość jest w oknie starszej historii. Zaktualizowano C23;
nie dodawano lokalnego zgadywania stanu.

Weryfikacja: testy event mappera, reducera i conversation realtime **20/20
PASS**; pełny `flutter analyze --no-pub` PASS. Pozostaje end-to-end odbiór dwóch
kont na stagingu dla DM/grupy i ponownego wejścia. W działającej 9-osobowej
grupie własna starsza wiadomość pokazała jeden check „Wysłano”; odpowiedź
serwera z jej `readByCount` nie była dostępna w tym odbiorze, więc UI i brak
potwierdzenia backendu pozostają nierozróżnione.


## CHAT-R99 — zapis odebranego pliku w prywatnym Storage (24.09.2026)

Załącznik rozmowy ma menu „Zapisz w Moich plikach”. „Zapisz i otwórz w
OnlyOffice” pojawia się tylko dla formatu z `isOfficeDocument`; po zapisaniu
Front ponownie pobiera prywatne szczegóły i sprawdza `canEditOnline` przed
otwarciem istniejącego edytora. Backend autoryzuje aktywne członkostwo i relację
załącznika z wiadomością, wymaga czystego pliku oraz tworzy idempotentną kopię
Private użytkownika. Audyt wykrył zależność detekcji retry od angielskiego
tekstu wyjątku bazy. Oba kierunki kopiowania Chat rozpoznają teraz wyłącznie
PostgreSQL unique violation na indeksie `SourceIdempotencyKey`.

Ta sama opcja dotyczy dokumentu dodanego do wiadomości przez wklejenie lub
upuszczenie pliku: po zakończeniu wysyłania i pojawieniu się dostępnego
załącznika akcje wynikają z jego możliwości, a zapis tworzy prywatną kopię w
Storage odbiorcy. „Zapisz i otwórz” jest dostępne tylko dla dokumentów
obsługiwanych przez konfigurację OnlyOffice; inne załączniki można zapisać,
lecz nie są kierowane do edytora.

Weryfikacja: adapter Front **7/7 PASS**; powiązany zestaw nie-widgetowy composera
i adaptera **35/35 PASS**; `flutter analyze --no-pub` PASS. Backend lifecycle
**10/10 PASS**, OpenAPI **10/10 PASS**, `dotnet format --verify-no-changes` i
`git diff --check` PASS. Bez zmian schematu ani enumów. Widgety/goldeny i runtime
Storage/OnlyOffice pozostają otwarte; nie wdrożono zmian na staging.


## CHAT-R100 — zgodna waga pogrubienia (24.09.2026)

Quill i renderer historii żądały font-weight 900 dla `bold:true`, mimo że
aplikacja dostarcza wariant Inter Bold 700. Oba miejsca korzystają teraz z
faktycznie dostępnej wagi 700. Kontrakt Delta i backend bez zmian.

Weryfikacja: codec rich text i komendy formatowania **21/21 PASS**; pełny
`flutter analyze --no-pub` PASS; `git diff --check` PASS. Widgetów/goldenów nie
uruchamiano. Odbiór wizualny w edytorze i po wysłaniu, w obu motywach, pozostaje
otwarty.


## CHAT-R101 — rozdzielenie renderera rich text (24.09.2026)

Plik renderera historii miał 816 linii: łączył parser już przygotowanej treści,
obsługę linków, markery list oraz pełną implementację podświetlania składni.
Wydzielono `ChatRichTextCodeBlock` i niezależny `ChatCodeSyntaxHighlighter`;
`ChatRichTextBody` ma 339 linii, kafelek kodu 115, a highlighter 380. Kod
kolorowania zachowuje treść źródłową i nie interpretuje jej.

Weryfikacja: pełny `flutter analyze --no-pub` PASS; codec rich text i testy
highlightera **12/12 PASS**; `dart format` i `git diff --check` PASS. Widgetów i
goldenów nie uruchamiano. Pozostałe duże pliki presentation/chat są osobnym,
otwartym pakietem C29.


## CHAT-R102 — podział panelu historii rozmowy (24.09.2026)

Wydzielono banner połączenia, nagłówek, menu akcji rozmowy, właściciela
listy historii i jej widok. Nowe pliki mają 74, 206, 302, 272 i 340 linii.
Usunięty `chat_panel_conversation_parts.dart` miał 1110 linii; nie użyto
`part` ani mixinów. W trakcie podziału poprawiono importy i zachowano istniejące
kontrakty callbacków.

Weryfikacja: pełny `flutter analyze --no-pub` PASS; `dart format` i
`git diff --check` PASS. Testów widgetowych nie uruchamiano zgodnie z decyzją
użytkownika. Pozostałe duże pliki są nadal ujęte w C29. Backend/API bez zmian.


## CHAT-R103 — rozdzielenie kompozycji panelu rozmowy (24.09.2026)

Widget panelu rozmowy miał 753 linie i łączył dzierżawę realtime, mapowanie
profilu rozmowy, wysyłkę oraz potwierdzanie odczytu widocznej wiadomości.
Wydzielono host Cubitów (251 linii), zawartość rozmowy (335), projekcję danych
inboxa (83) i komponent odczytu z lifecycle (120). Projekcja jest teraz
sprawdzalna jako czysta jednostka: testuje nazwy/awatar DM, autorów i liczbę
uczestników grupy, brak profilu oraz role wzmianek `@all`.

Weryfikacja: `flutter analyze --no-pub` PASS; test prezentacji **4/4 PASS**;
`dart format` i `git diff --check` PASS. Testów widgetowych nie uruchamiano.
C29 trwa; pozostałe duże pliki są w tabeli. Bez zmian backendu/API.


## CHAT-R104 — podział widoku dymka wiadomości (24.09.2026)

`chat_message_bubble.dart` łączył renderowanie treści z cytatem, stopką statusu,
serią nadawcy i awatarem obecności. Wydzielono osobne klasy: główny dymek
(327 linii), stopka/dostarczenie (114), cytat odpowiedzi (84) oraz układ serii
i awatar (185). Przekazanie statusów i callbacków pozostaje typowane, bez
zmiany zachowania.

Weryfikacja: pełny `flutter analyze --no-pub` PASS; `dart format` i
`git diff --check` PASS. Testów widgetowych nie uruchamiano. Istniejące testy
widgetowe dymka pozostają odroczone do akceptacji UI. C29 kontynuuje pozostałe
pliki ponad 400 linii; Backend/API bez zmian.


## CHAT-R105 — wydzielenie listy uczestników (24.09.2026)

chat_members_sheet.dart łączył modal, dodawanie osób, listę, statusy i akcje
członków w 638 liniach. Wydzielono listę uczestników wraz z jej lifecycle i
ładowaniem statusów do chat_members_list.dart (356 linii); host arkusza ma
295 linii. Pozostały interfejs publiczny i kontrakty Cubita bez zmian.

Weryfikacja: pełny flutter analyze --no-pub PASS; dart format i
git diff --check PASS. Testów widgetowych nie uruchamiano. Zachowanie dodawania,
usuwania i opuszczania grupy wymaga nadal odbioru w zalogowanej aplikacji.
Backend/API bez zmian. C29 pozostaje otwarte dla pozostałych plików.


## CHAT-R106 — rozdzielenie karty statusu i wyścigi odświeżenia (24.09.2026)

Menu własnego statusu (621 linii) dzieliło pobieranie/zapis z całym formularzem.
Wydzielono kontroler operacji (286), kartę edycji (318) i części nagłówka oraz
presetów (121). Audyt async wykrył również nakładające się pobrania przy
wejściu i otwarciu menu oraz możliwość pokazania statusu poprzedniego konta po
zmianie właściciela widgetu. Żądania mają teraz rewizję; zmiana użytkownika lub
repozytorium czyści stan i pobiera go ponownie, a stara odpowiedź nie nadpisuje
nowej sesji ani zapisu. Zachowano zakotwiczone menu terminu i dotychczasową kartę.

Weryfikacja: pełny `flutter analyze --no-pub` PASS; testy czystych presetów i
terminów **5/5 PASS**; `dart format` i `git diff --check` PASS. Widgetów/goldenów
nie uruchamiano. Ręczny odbiór statusu w belce nadal otwarty; Backend/API bez
zmian. C29 pozostaje otwarte dla pozostałych dużych plików.


## CHAT-R107 — podział hosta globalnego panelu (24.09.2026)

`chat_drawer.dart` miał 590 linii i łączył kompozycję panelu, nawigację wyników,
akcje profilu oraz synchronizację filtrów. Wydzielono host panelu (128),
zawartość/nawigację (384), synchronizację filtra sekcji (66) i akcje hosta
(48). Dotychczasowy `chat_drawer.dart` jest kompatybilnym re-eksportem
`AppGlobalChatPanel`, z którego nadal korzystają shell i barrel Chat.

Weryfikacja: pełny `flutter analyze --no-pub` PASS; formatowanie i
`git diff --check` PASS. Testy widgetowe nie były uruchamiane. Zachowano ścieżki
ACL-owanego otwierania wyników wyszukiwania i zapisanych wiadomości. C29 trwa;
pozostałe duże pliki są w tabeli. Backend/API bez zmian.


## CHAT-R108 — wymuszenie zastąpienia historii przy skoku do najnowszych

load(replaceHistory: true) scalał się bezwarunkowo z dowolnym już trwającym
load(). Jeśli realtime uruchomił resynchronizację podczas przeglądania okna
starszej historii, wyjście z okna dostawało stary request bez flagi
replaceHistory i mogło zostawić fragment historii. Zastąpienie historii
uruchamia teraz osobną generację, unieważniając starszy wynik. finally starego
requestu czyści uchwyt tylko wtedy, gdy nadal jest jego właścicielem; tylko
najnowsza generacja wznawia oczekujące wysyłki.

Dodano regresję: starszy request jest w locie, startuje zastąpienie historii,
najnowszy fragment wygrywa także po spóźnionej odpowiedzi starszego requestu.
Weryfikacja: conversation cubit 10/10 PASS; pełny analyzer i
git diff --check PASS. Widgetów/goldenów nie uruchamiano. Backend/API bez
zmian. C29 pozostaje otwarte; podział Cubita opisuje późniejszy pakiet CHAT-R109.


## CHAT-R109 — rozdzielenie koordynacji odczytu i realtime (24.09.2026)

`ChatConversationCubit` zmniejszono do 399 linii, wydzielając śledzenie
przeczytania (75 linii) i koordynację SignalR/realtime (168 linii). Koordynator
obsługuje subskrypcje, redukcję zdarzeń, potwierdzenia dostawy oraz start/stop;
Cubit zachowuje zarządzanie stanem i deleguje mu aktualizacje.

Weryfikacja po podziale: testy Cubita i realtime **16/16 PASS**, pełny
`flutter analyze --no-pub`, formatowanie i `git diff --check` PASS. Nie
uruchamiano widgetów/goldenów. Backend/API/OpenAPI/enumy/schemat bez zmian.
C29 pozostaje otwarte dla pięciu pozostałych plików z tabeli; runtime i ręczny
odbiór Chat nadal są wymagane.


## CHAT-R110 — wydzielenie listy i akcji wierszy inboxa (24.09.2026)

Z `chat_panel_list_pane.dart` wydzielono kompletny widok inboxa: ładowanie,
stronicowanie, wiersze i ich menu kontekstowe do
`chat_panel_inbox_view.dart`. Pliki mają odpowiednio 353 i 232 linie.
Zachowano ten sam cubit, porty, filtrowanie i akcje.

Weryfikacja: pełny `flutter analyze --no-pub` PASS, formatowanie i
`git diff --check` PASS. Widgetów/goldenów nie uruchamiano zgodnie z decyzją
użytkownika. C29 pozostaje otwarte dla czterech dużych plików wymienionych w
tabeli. Backend/API/OpenAPI/enumy/schemat bez zmian.


## CHAT-R111 — wydzielenie katalogu osób z popovera nowej rozmowy (24.09.2026)

Stan katalogu, ostatnich rozmów, wyników wyszukiwania, retry i wyboru osoby
przeniesiono do `chat_compose_directory_section.dart` (191 linii). Host
popovera z kontrolkami i wyborem typu rozmowy ma 347 linii. Zachowano debounce,
Cubit tworzenia, obsługę błędów, klucze elementów i zakotwiczenie popovera.

Weryfikacja: pełny `flutter analyze --no-pub` PASS; formatowanie i
`git diff --check` PASS. Widgetów/goldenów nie uruchamiano. C29 pozostaje otwarte
dla trzech plików wymienionych w tabeli. Backend/API/OpenAPI/enumy/schemat bez
zmian.


## CHAT-R112 — blok kodu z trybu zwykłego edytora (24.09.2026)

Przycisk „Wstaw kod” w trybie plain text owijał treść w Markdown fences, ale
wiadomość bez Delta była renderowana jako zwykły tekst. Teraz akcja przełącza
composer na Quill, przenosi dotychczasowy tekst oraz zaznaczenie/kursor, a kod
wstawia jako rzeczywiste `code-block` Delta. Wstawka w środku akapitu dostaje
separator, który nie formatuje tekstu stojącego przed blokiem. Po wysłaniu
historia może użyć istniejącego ciemnego kafelka i kolorowania składni.

Weryfikacja: testy codec + renderer **8/8 PASS**, analyze dotkniętego zakresu i
pełny `flutter analyze --no-pub` PASS, `git diff --check` PASS. Widgetów/goldenów
nie uruchamiano. Backend/API/OpenAPI/enumy/schemat bez zmian; odbiór podczas
wpisywania i po wysłaniu na żywej aplikacji pozostaje otwarty.


## CHAT-R113 — wydzielenie historii odpowiedzi wątku (24.09.2026)

`chat_thread_side_panel.dart` mieszał lifecycle panelu i providerów z dużym
renderowaniem historii wiadomości. Historia, paginacja, selekcja tekstu oraz
menu akcji trafiły do `chat_thread_message_list.dart`. Host ma 226 linii, a
nowy widok listy 242; przekazuje jawnie stan wątku, bieżące ID, selekcję i
porty akcji.

Weryfikacja: pełny `flutter analyze --no-pub` PASS, formatowanie i
`git diff --check` PASS. Testów widgetowych nie uruchamiano. C29 pozostaje
otwarte dla dwóch plików w tabeli. Backend/API/OpenAPI/enumy/schemat bez zmian.


## CHAT-R114 — podział widoku wyników wyszukiwania (24.09.2026)

Wynik wyszukiwania i pusty/error/loading state wydzielono z
`chat_search_view.dart` do `chat_search_view_components.dart`; pliki mają 228 i
207 linii. Równolegle porównano rzeczywisty parametr `q` w Retrofit z
`ChatSearchQuery.Q` i `ChatSearchService`: kontrakt, minimalna długość i
mapowanie strony są zgodne, przyczyna zgłoszonego braku wyników pozostaje do
odtworzenia z odpowiedzią API oraz stanem `SearchText`/indeksu.

Weryfikacja: pełny `flutter analyze --no-pub` PASS, formatowanie i
`git diff --check` PASS. Widgetów/goldenów nie uruchamiano. C29 obejmuje już
jeden plik ponad limit. Backend/API/OpenAPI/enumy/schemat bez zmian.


## CHAT-R115 — podział list przypiętych i zakładek (24.09.2026)

`chat_message_list_sheets.dart` łączył listy przypiętych wiadomości i zakładek
oraz współdzielone elementy listy. Rozdzielono host przypięć (183 linie), host
zakładek (176), wspólne wiersze/stany (106) i zachowano dawną ścieżkę jako
re-eksport kompatybilności.

Weryfikacja: pełny `flutter analyze --no-pub` PASS, formatowanie i
`git diff --check` PASS. Ponowny skan całego `presentation/chat` wykazał
**0 plików ponad 400 linii**. Widgetów/goldenów nie uruchamiano. Bez zmian
Backend/API/OpenAPI/enumów/schematu. C29 zamknięte; pozostałe zgłoszenia
funkcjonalne i odbiór runtime pozostają otwarte.


## CHAT-R116 — miniatury załączników bez pobierania oryginału (24.09.2026)

Backend generuje JPEG miniaturę obrazów podczas finalizacji załącznika Chat
(dłuższy bok maks. 640 px, wejście ograniczone polityką Chat do 50 MP), zapisuje
ją jako osobny obiekt pod kluczem śledzonym przez istniejący
`ThumbnailStorageKeysJson`, a autoryzowany endpoint sprawdza aktywne członkostwo,
relację z wiadomością i status skanu `Clean`. Front pobiera miniaturę przez
endpoint Chat; nie wydaje ticketu ani nie ściąga oryginału dla każdej karty.
Pełny obraz jest pobierany przez Storage dopiero po otwarciu podglądu.

Weryfikacja: pełna suite Backend **1325 PASS / 4 SKIP / 0 FAIL**; po późniejszym
dodaniu best-effort obsługi błędu generatora: build PASS oraz testy media i ACL
miniatur **4/4 PASS**. Skrypt migracji idempotentnych generuje się poprawnie;
pełny `dotnet format --verify-no-changes` PASS. Front: pełny
`flutter analyze --no-pub` PASS i test adaptera **8/8 PASS**. `git diff --check`
obu repozytoriów PASS. Widgetów/goldenów nie uruchamiano. Staging i rzeczywiste
transfery/ACL/cleanup pozostają do odbioru.


## CHAT-R117 — własny wygląd filtrów i usunięcie martwej listy (24.09.2026)

Audyt aktualnego drzewa sprostował stary wpis C11: aktywny panel miał już
zawijane filtry i osobne sekcje Czaty, Grupy, Kanały, Pliki oraz Zadania;
pozostały w nim jednak Material `FilterChip`, a nieużywany
`inbox/components/chat_inbox_list.dart` nadal zawierał poziomy pasek siedmiu
`ChoiceChip`. Aktywne filtry zastąpiłem pillami opartymi na `ChatTheme`
(powierzchnia zaznaczenia, zieleń focus, separator, hover i semantyka dla
technologii asystujących). Usunąłem osieroconą listę i dodałem test
czystej sekcji potwierdzający, że Pliki/Zadania nie dziedziczą filtrów skrzynki.

Weryfikacja: sekcja/panel Cubit **6/6 PASS**, pełny `flutter analyze --no-pub`
PASS, `git diff --check` PASS; `chat_panel_list_pane.dart` 335 linii, nowy
komponent 78 linii. Nie uruchamiałem widgetów/goldenów zgodnie z decyzją
użytkownika. Odbiór wizualny i pomiary 320/360/420 px pozostają otwarte.


## CHAT-R118 — ponowny audyt wyszukiwarki (24.09.2026)

Prześledzono ścieżkę od pola wyszukiwania do PostgreSQL. Retrofit przekazuje
`q`, adapter mapuje listę `items`, Cubit unieważnia starsze zapytania i czyści
poprzednie wyniki przy zmianie frazy. Backend wiąże `q` do `ChatSearchQuery.Q`,
sprawdza dostęp do rozmowy i wyszukuje w `SearchText`; migracja backfilluje
starsze wiadomości. Testy PostgreSQL obejmujące dostęp/facety, polskie znaki i
historię zmian **3/3 PASS**; test Cubita **7/7 PASS**, test adaptera **2/2 PASS**.
Kodowa przyczyna wcześniejszego zgłoszenia nie została potwierdzona. Pozostaje
reprodukcja w zalogowanym runtime, bo testy nie dowodzą zachowania stagingu.
Ręczna próba w istniejącej zalogowanej sesji potwierdziła podstawowy przypadek:
`planowanie` zwróciło osiem wpisów pasujących do znanej wiadomości. Nie
otwierano wyników, a licznik nieprzeczytanych nie uległ zmianie. To nie
potwierdza wyszukiwania kodu, Delta ani każdego historycznego wpisu.


## CHAT-R119 — status własnego autora w dymku (24.09.2026)

Ponowna kontrola C21 potwierdziła, że naprawa jest już w kodzie: pełny ekran i
panel wątku przekazują bieżący identyfikator do kolejki, optymistyczna wiadomość
zachowuje go, a renderer porównuje `authorUserId` z `currentUserId` przy
wyrównaniu i wyborze kolorów dymka. Uaktualniono status C21, który pozostał
„Zgłoszone” mimo naprawy opisanej w C22.

Weryfikacja: testy Cubita rozmowy **10/10 PASS**, Cubita wątku i grupowania
historii **16/16 PASS**. Ręczny odbiór plain/rich i odpowiedzi API pozostaje
otwarty częściowo: w istniejącej aplikacji zwykły tekst własny był zielony i
wyrównany do prawej, a tekst innych uczestników biały i po lewej. Licznik
nieprzeczytanych pozostał bez zmiany. Rich composer i ACK API pozostają do
sprawdzenia; nie uruchamiano testów widgetowych.


## CHAT-R120 — zapis załącznika czatu w prywatnym Storage (24.09.2026)

Wymaganie: odbiorca wiadomości może zachować załącznik jako własną kopię w
„Moich plikach”, niezależną od cyklu życia wiadomości/rozmowy. Dla dokumentu
obsługiwanego przez OnlyOffice menu kontekstowe udostępnia także „Zapisz i
otwórz”; pozostałe formaty nie mogą pokazywać tej akcji. Tożsamość, członkostwo,
stan skanu i format weryfikuje backend; Front po zapisie pobiera szczegóły
prywatnej kopii i otwiera edytor wyłącznie, gdy API Storage potwierdza
`canEditOnline`.

Implementacja jest już obecna w bieżących zmianach obu repozytoriów: endpoint
`POST /api/v1/chat/messages/{messageId}/attachments/{storageFileId}/save-to-storage`
tworzy idempotentną kopię w prywatnym Storage zalogowanego użytkownika i
odpowiada też flagą `canEditOnline`; menu załącznika ma akcje „Zapisz w Moich
plikach” i warunkową „Zapisz i otwórz w OnlyOffice”.

Weryfikacja tej rundy: backendowe `ChatAttachmentLifecycleTests` **13/13 PASS**;
adapter Frontu załączników **8/8 PASS**. Nie uruchamiano testów widgetowych ani
goldenów. Pozostaje sprawdzić w zalogowanym runtime kopię w „Moich plikach”,
powtórne kliknięcie (bez duplikatu), dostęp po opuszczeniu/utracie rozmowy oraz
otwarcie wspieranych formatów przez OnlyOffice. Nie wykonano deployu.

Code review wykryło dwie brakujące konsekwencje zapisu: odświeżenie otwartego
Storage oraz ponowną akcję po usunięciu kopii. Backend emituje teraz do outboxa
zdarzenie `Created` dla prywatnego scope użytkownika; retry po usunięciu
przywraca istniejącą kopię, emituje `Restored` i nie kopiuje bajtów drugi raz.
Regresja Backend potwierdza te zdarzenia i scope; adapter Front **8/8 PASS**,
kontrakt OpenAPI **1/1 PASS**. Runtime tych interakcji nadal wymaga ręcznego
odbioru.


## CHAT-R121 — ścisły kontrakt Quill Delta (24.09.2026)

Audyt backendowego `ChatMessage.ValidateDelta` ujawnił, że serwer przyjmował
część atrybutów niewyświetlanych przez historię, nie sprawdzał ich dokładnych
typów/wartości i przepuszczał dowolne obiekty embed. Wiadomość mogła więc
zostać zapisana bez formatowania widocznego po odczycie. Uzgodniono walidację z
aktywnym Frontem: tekstowe operacje `insert`; `bold`, `italic`, `underline`,
`strike`, `code`, `blockquote` jako `true`; bezpieczny HTTP(S) `link`;
`code-block` jako `true` albo język 1–32 znaków; `list` tylko `bullet` albo
`ordered`. Nieznane/powtórzone pola, nieobsługiwane atrybuty i embed-y są
odrzucane. Obrazy i dokumenty pozostają załącznikami Storage.

Backendowa dokumentacja kontraktu OpenAPI została doprecyzowana dla tworzenia,
edycji, rewizji i szkicu. Testy `ChatFoundationTests` Backend **68/68 PASS**
(w tym Delta **8/8**), testy OpenAPI Chat **11/11 PASS**; Front testy komend formatowania i rendererów
**21/21 PASS**. Widgetów/goldenów nie
uruchamiano. Pozostaje zautomatyzowany wspólny fixture przekazujący JSON
generowany przez Quill między warstwami oraz odbiór wysyłki/odczytu na stagingu.

Front sanitizuje teraz także bogaty tekst wklejany ze schowka przed dodaniem do
Quilla. Nieobsługiwane atrybuty są usuwane, niebezpieczne linki nie są
zachowywane, a osadzone obiekty zmieniają się w czytelną wskazówkę dodania
załącznika. Starsze szkice przechodzą tę samą normalizację przy odtwarzaniu i
zapisują oczyszczony Delta, dzięki czemu backendowa walidacja nie odrzuci ich
przez historyczne formaty. Test sanitizera/normalizacji **4/4 PASS**; analyzer
zakresu zmian przechodzi. Widgetów nie uruchamiano.

## CHAT-R122 — czytelność i kolorowanie bloków kodu (24.09.2026)

Wklejony kod i kod wstawiany narzędziem Quilla renderują się w ciemnym bloku
monospace mniejszą czcionką 12,5 px, z odstępem linii 1,5. Reguły Darta są
osobnym profilem poniżej 100 linii, dzięki czemu renderer nie przekracza
projektowego limitu 400 linii. Kolorowanie rozróżnia słowa kluczowe i adnotacje,
typy języka oraz Fluttera, wywołania funkcji, liczby, teksty, komentarze,
operatory i stonowaną interpunkcję; nieznane języki nie są fałszywie
klasyfikowane jako funkcje.

Test składni Python/Dart/nieznanego języka oraz test sanitizera Delta **7/7
PASS**; analiza zmienionych plików PASS; pełny `flutter analyze --no-pub` PASS;
skan `presentation/chat` wykazał 0 plików ponad 400 linii. Nie uruchamiano
widgetów ani goldenów zgodnie z decyzją użytkownika. Wygląd końcowy czeka na
odbiór użytkownika; Backend i API bez zmian.

Uzupełnienie po zgłoszeniu, że Dart nadal jest słabo kolorowany: profil zawiera
teraz również współczesne modyfikatory i słowa kontekstowe Darta oraz częste
typy Fluttera (m.in. `FutureOr`, `BuildContext`, `Scaffold`, `EdgeInsets`).
Regresja sprawdza te kolory i zachowanie źródła; highlighter **4/4 PASS**,
zakresowy analyzer PASS, format i `git diff --check` PASS. Nie zmieniano UI
widgetów ani nie uruchamiano widget/goldenów.

Weryfikacja po rozszerzeniu profilu Dart: pełny `flutter analyze --no-pub`
aktualnego Front zakończył się bez uwag. Nie uruchamiano testów widgetowych ani
goldenów; test highlightera pozostaje **4/4 PASS**.

Regresja własnego nadawcy po zgłoszeniu problemu z bogatym edytorem: test
kolejki wysyłki odtwarza teraz wiadomość z formatowaną Deltą i retry jako
zalogowany `user-1`, a następnie sprawdza `authorUserId` oraz Delta zarówno
przed ACK, jak i po potwierdzeniu serwera. Test kolejki **1/1 PASS**, analiza
zakresu i diff check PASS. Nie zastępuje to ręcznego sprawdzenia kolorów i
wyrównania w runtime; C21/C22 pozostają otwarte dla potwierdzenia rich text.

Weryfikacja backendowego cyklu „zapisz załącznik w prywatnym Storage”:
`ChatAttachmentLifecycleTests` **13/13 PASS**. Zakres obejmuje idempotencję,
przywrócenie usuniętej kopii i odmowę dla osoby bez członkostwa. Nie potwierdza
to jeszcze otwierania kopii z poziomu UI ani integracji z OnlyOffice na stagingu.

## CHAT-R125 — ponawianie ACK odczytu po błędzie API (24.09.2026)

`ChatConversationReadTracker` zwraca teraz lokalny wynik `marked`, `ignored` albo
`failed`. `ChatPanelMessageList` ponawia wynik `failed` po 1, 2 i 4 sekundach,
wyłącznie po ponownym potwierdzeniu widoczności najnowszej wiadomości; po
schowaniu, zmianie trasy, usunięciu wpisu lub unmount anuluje timer. Próby są
ograniczone, własne/stare/usunięte/local wpisy nie są retryowane. Po ACK nadal
odświeżane są inbox i globalny badge.

Audyt enuma: `ChatReadMarkOutcome` jest **lokalnym stanem UI/application**,
używanym tylko w Cubicie i widoku. Nie jest DTO request/response, enumem
persistence ani wartością JSON; nie zmienia API, OpenAPI, Backend ani kodowania
Flutter. Test read visibility **7/7 PASS**, test Cubita rozmowy **10/10 PASS**,
pełny `flutter analyze --no-pub` PASS, `git diff --check` PASS. Widget/runtime
testów nie uruchamiano. Scenariusz przejściowego błędu API ma test automatyczny;
widok dwóch kont i serwerowy stan odczytu nadal wymagają odbioru runtime.

## CHAT-R126 — lexer składni Darta (24.09.2026)

Ręczny tokenizator zastąpił regex wyłącznie dla Dart. Rozpoznaje raw stringi,
pojedyncze/podwójne i potrójne delimitery, escape sequences, zagnieżdżone
komentarze blokowe, komentarze liniowe, liczby i wieloznakowe operatory; mapuje
tokeny do ChatTheme palety bez zmiany oryginalnego tekstu. Inne języki zachowały
poprzednią ścieżkę. Test highlightera **5/5 PASS**, pełny analyzer PASS,
`git diff --check` PASS; pliki highlightera/tokenizatora 350/196/192 linii.
Parser `syntax_highlight` sprawdzono, ale solver odrzucił go z powodu konfliktu
transitive `win32 <6` z `talker_flutter`/`share_plus` `win32 ^6`; nie dodano
zależności. Widgety/goldeny/runtime nieuruchomione, odbiór wyglądu otwarty.

## CHAT-R127 — mniejszy blok i rozpoznawanie członów Dart (24.09.2026)

Po uwadze, że duży kod nadal zajmuje zbyt dużo miejsca, rozmiar monospace
zmniejszono z 12,5 do 11,5 px. Wysokość linii 1,55 zachowuje odstęp między
wierszami. Profil Darta rozpoznaje więcej popularnych typów Fluttera,
wyróżnia człony dostępu po kropce turkusowym kolorem, a wywołania pozostają
fioletowe. Regresja sprawdza `Theme.of(context).textTheme.titleMedium`,
`Colors.blue` i typowe widgety. Test highlightera **6/6 PASS**, analyzer
zmienionych plików PASS, `git diff --check` PASS. Widgetów i goldenów nie
uruchamiano bez akceptacji UI. Odbiór końcowego wyglądu pozostaje otwarty.

## CHAT-R128 — snippet trafienia wyszukiwania z Quill Delta (24.09.2026)

Backend wyszukiwał tekst z Delta, lecz budował pole `Highlight` wyłącznie z
`Text`. Wynik, którego fraza występowała tylko w formacie Quill, miał więc
podgląd bez dopasowania. Obie gałęzie Backend (PostgreSQL FTS i fallback)
tworzą ograniczony snippet z tego samego, bezpiecznego `SearchText` co indeks.
Testy Backend **70/70 PASS**, format verify i diff check PASS. Kontrakt i enumy
bez zmian. Nie wdrożono; zalogowana reprodukcja wyszukiwania w stagingu
pozostaje otwarta.

## CHAT-R129 — stylowanie trafienia w podglądzie wyszukiwarki (24.09.2026)

Front interpretował delimitery snippetu `⟦…⟧` jako zwykłe znaki. Renderer
zamienia je teraz na pogrubione wyróżnienie z palety ChatTheme i pokazuje tekst
bez delimiterów; błędny snippet pozostaje czytelny. Test parsera **2/2 PASS**,
analyzer zmienionego zakresu i `git diff --check` PASS. Nie uruchamiano widgetów;
odbiór w działającym runtime nadal otwarty.

## CHAT-R130 — rozpoznawanie wklejonego Darta bez etykiety i mniejszy blok (24.09.2026)

Część bloków kodu nie ma metadanych języka, przez co renderer pomijał
profil Darta i pokazywał identyfikatory prawie wyłącznie kolorem tekstu.
Highlighter rozpoznaje teraz charakterystyczne importy `package:`/`dart:`,
deklaracje Fluttera z dziedziczeniem oraz typowe adnotacje i stosuje lexer
Darta także bez etykiety. Kod ma teraz 10,5 px i interlinię 1,45. Test
highlightera **7/7 PASS**, analyzer wskazanego zakresu PASS, `git diff --check`
PASS. Nie uruchamiano widgetów/goldenów; wizualny odbiór na ekranie pozostaje
otwarty.

## CHAT-R131 — kursor odczytu a kolejność strony historii (24.09.2026)

Backend zwraca strony historii w kolejności malejącej `(CreatedAtUtc, Id)`,
a UI traktuje `messages.last` jako najnowszą widoczną wiadomość. Cubit nie
normalizował odpowiedzi i zostawiał najstarszą wiadomość na końcu; ACK odczytu
nie przesuwał więc kursora do najnowszej wiadomości. `_mergeMessages` sortuje
teraz chronologicznie po `(createdAtUtc, id)` dla pierwszego pobrania, starszych
stron, okien historii i aktualizacji realtime/wysyłki. Test regresji potwierdza,
że po odpowiedzi newest-first lista jest chronologiczna, najnowszy ID dostaje
ACK, a starszy jest odrzucony przez monotoniczny tracker. Testy Cubita i
widoczności odczytu **18/18 PASS**, analyzer wskazanego zakresu PASS,
`git diff --check` PASS. Bez zmian API/enumów. Rzeczywisty ACK backendu/stagingu
nie był tutaj uruchamiany.

## CHAT-R132 — czytelniejsze zmienne w kolorowaniu Darta (24.09.2026)

Przegląd reguł wykazał, że deklaracje zmiennych i argumenty nazwane w Dart
pozostawały w kolorze bazowym. Highlighter rozpoznaje teraz typowane i
`final`/`const`/`var`/`late` deklaracje, koloruje ich odwołania oraz argumenty
nazwane osobnym turkusowym kolorem. Kolejność klasyfikacji zachowuje fioletowe
wywołania metod, w tym `build`. Testy highlightera **8/8 PASS**, analyzer
zakresu PASS, `git diff --check` PASS. Bez testów widgetowych/goldenów; odbiór
wizualny w aplikacji pozostaje otwarty.

## CHAT-R133 — odczyt po wznowieniu aplikacji (24.09.2026)

Audyt retry ujawnił wyścig lifecycle: odczyt mógł zostać zgłoszony w chwili,
gdy aplikacja przechodziła w tło. Callback zwracał `ignored`, ale lista
zapamiętywała wiadomość jako już zgłoszoną, więc po powrocie nie ponawiała ACK.
Stan lifecycle jest teraz przekazywany do listy. Przy przejściu poza `resumed`
lista kasuje zapamiętane ID i retry timer; po wznowieniu sprawdza ponownie
widoczność i wykonuje ACK. Analyzer dwóch plików PASS; formatowanie i
`git diff --check` PASS. Nie uruchamiano widgetów/goldenów; scenariusz tło →
powrót wymaga ręcznego odbioru po akceptacji UI.

## CHAT-R134 — komunikaty błędów członkostwa z dalszym krokiem (24.09.2026)

`ChatMembersCubit` zachowywał wyłącznie ogólny kod akcji (`chat.members.change_failed`),
przez co panel nie rozróżniał braku uprawnień, konfliktu, walidacji i zerwanego
połączenia. Stan zachowuje teraz `ApiErrorType` i status HTTP. To istotne, bo
wspólny mapper klasyfikuje backendową walidację HTTP 400 jako `badResponse`,
nie jako `validation`. Panel mapuje 400/422, 403, 409 i błędy połączenia na
polskie i angielskie wskazówki.
Szczególny błąd ostatniego Ownera nadal pokazuje precyzyjną instrukcję przekazania
własności. `ApiErrorType` pozostaje typem klasyfikacji błędu lokalnym dla
aplikacji; nie zmienia wartości przewodowych ani serializacji enumów. Testy
Cubita wyszukiwania/członków **15/15 PASS**, `flutter gen-l10n`, analyzer zakresu
i `git diff --check` PASS. Bez widgetów/goldenów; komunikaty w runtime nadal
wymagają odbioru.

## CHAT-R135 — mniejsza czcionka i wyraźniejszy Dart (24.09.2026)

Blok kodu zmniejszono z 10,5 do 9,5 px. Paleta Darta na ciemnym kafelku
rozróżnia teraz czytelniej typy Flutter/Dart, słowa kluczowe, adnotacje,
wywołania, nazwy lokalne i argumenty, napisy, liczby, komentarze oraz operatory.
Zaktualizowano testy tokenów: **8/8 PASS**; analyzer trzech dotkniętych plików
PASS; `git diff --check` PASS. Nie uruchamiano testów widgetowych ani goldenów.
Wygląd po ponownym zbudowaniu aplikacji wymaga odbioru w runtime.

## CHAT-R136 — retry pobrania polityki długiego wklejenia (24.09.2026)

Nieudane pierwsze pobranie polityki limitów było zapamiętywane jako załadowany
wynik z `null`, więc kolejne wklejenia omijały backend i nie rozpoznawały
automatycznie długiego tekstu. Cache zapisuje teraz wyłącznie sukces; błąd
połączenia zostawia cache otwarty do ponowienia. Gdy serwer nie zwróci polityki,
tekst nie trafia do composera i użytkownik dostaje lokalizowany komunikat.
Testy cache i progów **11/11 PASS**, analyzer zakresu PASS, `flutter gen-l10n`
PASS, `git diff --check` PASS. Widgetów/goldenów nie uruchamiano.

## CHAT-R137 — Cubit historii rozmowy poniżej limitu 400 linii (24.09.2026)

`chat_conversation_cubit.dart` miał 405 linii. Scalanie stron, dostaw i zdarzeń
realtime wraz z porządkowaniem chronologicznym wydzielono do
`ChatConversationMessageMerger` (30 linii); Cubit ma teraz 389 linii. Zachowuje
deduplikację po ID wiadomości/klienta i porządek `(createdAtUtc, id)`. Testy
Cubita **11/11 PASS**, analyzer wskazanego zakresu PASS, formatowanie i
`git diff --check` PASS. Bez zmian API/backendu; widgetów/goldenów nie
uruchamiano.

## CHAT-R138 — zachowanie okna historii przy zmianach dostawy (24.09.2026)

Aktualizacje wiadomości, błędy realtime i stronicowanie odtwarzały stan
`ChatConversationReady` bez `jumpAnchorMessageId`, przez co tryb okna historii
mógł znikać po ACK-u lub doładowaniu. Przejścia używają teraz `copyWith`, które
zachowuje kotwicę i resztę stanu. Jawne wyczyszczenie `nextCursor` zapobiega
odziedziczeniu kursora najnowszej strony przy oknie bez starszych wyników i
pozwala terminalnej stronie zakończyć paginację. Po błędzie loadMore spinner
gaśnie, a kursor pozostaje dostępny do retry. Regresje Cubita/realtime **18/18
PASS**, analyzer **PASS**, `git diff --check` PASS. Backend/API bez zmian;
widgetów/goldenów nie uruchamiano.

## CHAT-R139 — aktywny stan formatowania Quilla (24.09.2026)

`QuillController.getSelectionStyle().attributes` zwracał obiekty `Attribute`,
podczas gdy logika toolbaru porównywała surowe wartości. Przez to aktywne bold,
listy i cytat nie były rozpoznawane: przyciski nie wskazywały stanu, a ponowne
kliknięcie nie zdejmowało formatowania. Dodano wspólną normalizację wartości
Quilla i podłączono ją do renderowania stanu oraz komend przełączania.
Regresja na rzeczywistych `Attribute` i testy komend **13/13 PASS**, analyzer
czterech plików PASS, `git diff --check` PASS. Widgetów/goldenów nie
uruchamiano; wizualne aktywne stany wymagają odbioru runtime.

## CHAT-R140 — mniejszy blok kodu i poprawione kolorowanie Darta (24.09.2026)

Zgłoszono, że wklejony kod zajmuje za dużo miejsca, a Dart jest słabo
kolorowany. Zmniejszono font bloku z 9,5 do 8,5 px i poprawiono kolejność
rozpoznawania słów kluczowych względem wywołań (np. `if` nie jest już
kolorowane jak funkcja). Rozszerzono rozpoznawanie typów i deklaracji oraz
dodano regresję dla klas, typów Flutter, metod i instrukcji sterujących.
Test highlightera **9/9 PASS**, analyzer trzech zmienionych plików PASS,
`git diff --check` PASS. Bez widgetów/goldenów; odbiór wyglądu w runtime
pozostaje otwarty.

## CHAT-R141 — escapowanie tekstu w snippetach wyszukiwania (24.09.2026)

Wiadomości zawierające dosłowne `⟦`, `⟧` lub ukośnik odwrotny mogły kolidować
ze znacznikami trafienia `⟦…⟧`. Backend escapuje teraz znaki literalne w
snippetach trafionych i fallbackowych, także wewnątrz frazy; Front odtwarza
oryginalny tekst i wyróżnia wyłącznie nieescapowane znaczniki. Opis pola
`Highlight` w OpenAPI dokumentuje kodowanie. Audyt enuma `ChatConversationType` potwierdził pełny zestaw pięciu wartości oraz zgodny casing C#/OpenAPI/JSON/Flutter. Test Front **4/4 PASS**, analyzer
zakresu PASS; testy helpera Backend **3/3 PASS**, `ChatOpenApiContractTests` **11/11 PASS**,
Front parser **4/4 PASS**, enum wire contract **1/1 PASS**, build Backend PASS
(0 ostrzeżeń), format PASS, idempotentny skrypt WorkspaceDbContext PASS.
Pełna suite Backend **1333 PASS / 4 SKIP / 0 FAIL** przed rozszerzeniem
istniejącej asercji DTO; po zmianie klasa kontraktów **11/11 PASS**. Brak
nowych enumów i migracji. Backend nie został
wdrożony; do odbioru runtime wymaga zgodnych wersji Front/Backend.

## CHAT-R142 — mniejszy kod i wyraźniejsze kolory Darta (24.09.2026)

Po ponownym zgłoszeniu zmniejszono czcionkę w bloku z 8,5 do 8 px i nieco
ściśnięto interlinię. Rozdzielono kolor nazwanych argumentów od deklaracji i
referencji zmiennych, zwiększono czytelność typu/adnotacji oraz uzupełniono
zestaw często używanych typów Dart/Flutter. Sprawdzono, że wcześniejsze
usprawnienie highlightera nie wróciło do kopiowania prefiksów/sufiksów źródła.
Test highlightera **9/9 PASS**, analyzer zakresu PASS, formatowanie i
`git diff --check` PASS. Widgetów/goldenów nie uruchamiano; odbiór wyglądu w
runtime pozostaje otwarty.

## CHAT-R143 — kursor odczytu obejmuje własną wiadomość i wcześniejszą historię (24.09.2026)

Przegląd ścieżki C23 wykazał, że Front pomijał read ACK, gdy widoczna
najnowsza wiadomość należała do bieżącego użytkownika. Backend przechowywał
kursor rozmowy, ale `readByCount` wyliczał wyłącznie z jawnych rekordów
`ChatMessageDeliveryState` dla tej konkretnej wiadomości. W efekcie wcześniejsze
wiadomości mogły pozostać bez podwójnego znacznika, mimo że odbiorca doszedł do
nowszej własnej wiadomości. Front teraz wysyła ACK dla każdej rzeczywiście
widocznej wiadomości serwerowej, także własnej. Backend wylicza odczyt na
podstawie kursorów członków względem każdej wiadomości; autor nie jest odbiorcą
własnej wiadomości. Porządek identyfikatorów przy jednakowym czasie zachowuje
porządek UUID PostgreSQL.

Weryfikacja: test Front widoczności **7/7 PASS**, analyzer dotkniętych plików
PASS; integracyjny test PostgreSQL wcześniejszej wiadomości po odczytaniu
własnej nowszej **1/1 PASS**, build Backend **0 ostrzeżeń / 0 błędów**.
`chat.message.read` i `chat.message.delivered` były mapowane, ale nie były
podpięte do handlerów SignalR. Zarejestrowano je; zdarzenie odczytu oznacza
teraz typowany `isReadReceipt` i odświeża wcześniej załadowane wiadomości w
oknach maksymalnie 101 rekordów, bo ACK późniejszego wpisu zmienia ich liczniki.
Testy mappera/koordynatora realtime **14/14 PASS**, test widoczności ACK **7/7
PASS**, analyzer dotkniętego zakresu i `git diff --check` PASS. Backend pełna
suite **1333 PASS / 4 SKIP / 0 FAIL**, build bez ostrzeżeń, format i skrypt
migracji idempotentny PASS. Pozostaje runtime dwóch kont w DM i grupie, w tym
stan po ponownym wejściu. Bez zmian kształtu API, enumów i schematu bazy.

## CHAT-R144 — cytat odpowiedzi zachowuje autora i treść (24.09.2026)

Historia przenosiła `replyToMessageId`, ale bez cytatu. Full-screen nie miał
mapy nazw uczestników dla preview, a wpis spoza załadowanej strony był
prezentowany jako niedostępny. Backend dodaje `ChatMessageResponse.replyPreview`
z autorem, skrótem tekstu (maksymalnie 240 znaków), etykietami wyłącznie
zapisanych wzmianek i flagą załącznika. Cel jest pobierany wyłącznie z tej samej
rozmowy; tekst usuniętej wiadomości pozostaje pusty. Front mapuje preview we
wspólnym mapperze dla historii, wątku i akcji; renderer pokazuje nazwę autora
i cytat, także gdy cel nie jest załadowany. Dodano neutralny nagłówek, gdy
profil autora nie jest dostępny. Nie dodano enumów ani migracji. Zmiana DTO jest
addytywna; aktualizuje Backend/OpenAPI i Front dekoder. Backend test PostgreSQL
oraz kontrakty OpenAPI/JSON **13/13 PASS**; Front adapter/JSON **12/12 PASS**.
Reducer i koordynator usuwają cytat po delete celu poza stroną, również w trybie
okna historii. Adapter, kontrakt i realtime **28/28 PASS**, analyzer i format
PASS. Widgetów/goldenów nie uruchamiano zgodnie z zakresem odbioru UI. Staging
i wizualny odbiór odpowiedzi pozostają otwarte; Backend nie
został wdrożony, bo checkout zawiera także niezależne zmiany Storage.

## CHAT-R145 — sanitizacja Quill Delta przed wysłaniem (24.09.2026)

Przegląd ścieżki publikacji wykazał, że sanitizer obsługiwał odtwarzanie
szkicu, ale repozytorium wysyłało surową Deltę. Wklejony HTML mógł więc
przenieść atrybuty spoza kontraktu (np. `color` lub `header`) i zakończyć POST
błędem 400. `ChatRepositoryImpl` sanitizuje teraz JSON Delty na granicy API:
zachowuje dozwolone formatowanie i tekst, usuwa obce atrybuty, zamienia
nieobsługiwane embedy na jawne placeholdery, a niepoprawną/pustą Deltę pomija,
pozostawiając pole tekstowe. Regresja repozytorium potwierdza dokładny payload
po sanitizacji. Front odrzuca też Deltę przekraczającą Backendowe limity
200 000 znaków / 10 000 operacji i wysyła zachowany tekst bez formatowania.
Repository + sanitizer **17/17 PASS**, analyzer dotkniętych plików i
`git diff --check` PASS. Test kontraktowy pokrywa wszystkie atrybuty z allowlisty
Backend. Bez zmiany backendu, DTO lub enumów; runtime
stagingowy dla wklejonego HTML pozostaje do sprawdzenia.

## CHAT-R146 — kompletne mapowanie wiadomości realtime (24.09.2026)

Audyt `chat.message.created/updated` wykazał, że deserializer przyjmował pełny
`ChatMessageResponse`, ale ręcznie kopiował tylko podstawowe pola. W rezultacie
odpowiedź widoczna od razu przez SignalR traciła m.in. cytat, wzmianki, reakcje,
liczniki odczytu/dostawy i załączniki; historia po odświeżeniu mapowała je
poprawnie. Wydzielono wspólny `ChatMessageResponseMapper` używany przez
repozytorium HTTP i realtime, więc oba transporty tworzą ten sam model domenowy.
Test fixture odpowiada pełnemu payloadowi Backend i sprawdza cytat, etykiety,
reakcje, liczniki oraz dokument OnlyOffice. Mapper realtime + repozytorium +
kontrakt **20/20 PASS**, analyzer i `git diff --check` PASS. Bez zmian API,
Backendu i enumów. Do ręcznego potwierdzenia pozostaje przyjście nowej odpowiedzi
z drugiego konta bez odświeżania historii.

## CHAT-R147 — walidacja maksymalnej długości wyszukiwania (24.09.2026)

Backend odrzuca frazy wyszukiwania dłuższe niż 160 znaków, ale Front pilnował
wyłącznie minimum 2 znaków i wysyłał długą frazę, otrzymując błąd HTTP 400.
Cubit ma teraz limit zgodny z API i nie wysyła zapytania ani facetów po jego
przekroczeniu; widok wyświetla lokalizowaną informację z maksymalną długością.
Granice 160/161 i brak requestu przy nadmiarowej frazie sprawdzają testy
wyszukiwarki; klasa search/members **18/18 PASS**, analyzer oraz `git diff
--check` PASS. Bez zmian Backend/API/enumów; runtime wyszukiwarki nadal wymaga
odbioru.

## CHAT-R148 — jawny callback otwierania DM z karty osoby (24.09.2026)

Audyt providerów rootowych modalów wykazał, że karta osoby czytała
`DevPlannerPanelsScope` wewnątrz rootowego dialogu. Scope należy do treści
bazowej aplikacji i nie jest przodkiem nowej trasy dialogowej, więc po
rozwiązaniu DM akcja „Napisz” mogła nie otworzyć rozmowy. `ChatMembersSheet`
przechwytuje teraz callback z kontekstu panelu przed otwarciem i przekazuje go
przez listę do karty osoby; bez callbacku akcja nie jest oferowana. Analyzer
trzech zmienionych plików i formatowanie PASS, `git diff --check` PASS.
Widget/runtime nie uruchamiano zgodnie z ustaleniem odroczenia testów UI.
Należy zweryfikować „Napisz” z karty uczestnika w aktywnym panelu.


## CHAT-R149 — odświeżanie reakcji z realtime (24.09.2026)

Backend emituje `chat.reaction.changed` i `chat.reaction.removed`, ale Front nie
subskrybował tych metod. Dodano obie do subskrypcji i mapowania domenowego.
Zamiast lokalnie inkrementować zagregowane liczniki (co jest podatne na
wyścigi z historią i innymi użytkownikami), otwarta rozmowa pobiera
autorytatywne podsumowanie reakcji dla konkretnej wiadomości przez
`loadMessageWindow`. Świeży model zawiera liczbę i `reactedByCurrentUser`.
Obsłużono też zdarzenia w historii okienkowej; brak `messageId` powoduje pełny
resync. Testy mappera, odbioru SignalR i cubita przechodzą **26/26 PASS**, analyzer 8 plików PASS oraz pełny `flutter analyze` PASS (0 issues), formatowanie i `git diff --check` PASS. Bez zmiany API, backendu ani
transportowych enumów. Ręczny odbiór dwóch kont pozostaje otwarty.


## CHAT-R150 — wynik wszystkich akcji wiadomości (24.09.2026)

Audyt wykazał, że tylko pin zwracał jawny wynik `succeeded/failed/ignored`;
zakładki, reakcje i forward zwracały `Future<void>`, mimo że wspólny `_run`
rozróżniał już ACK, błąd API i duplikat w toku. Wszystkie akcje drugorzędne
zwracają teraz ten sam outcome, zachowując update stanu wyłącznie po ACK.
Callback reakcji w liście jawnie konsumuje wynik asynchronicznie. Regresje
dla success/failure/ignored i braku podwójnego requestu: Cubit **8/8 PASS**;
Realtime + akcje **17/17 PASS**; analyzer wskazanego zakresu i pełny `flutter analyze` (0 issues), formatowanie
i `git diff --check` PASS. Bez API/backendu/enumów. UI nadal sygnalizuje błąd przez stan błędu przy
wiadomości; ręczny odbiór interakcji w aplikacji pozostaje otwarty.


## CHAT-R151 — widoczny błąd akcji wiadomości (24.09.2026)

Uzupełniono CHAT-R150: failure z `ChatMessageSecondaryActionsCubit` było
przechowywane w stanie i zmieniało ikonę menu, ale przy reakcjach, zakładkach,
pin i forward brakowało natychmiastowego, czytelnego komunikatu. UI pokazuje
teraz error toast po nieudanym API dla akcji uruchamianych z menu kontekstowego,
paska reakcji i pickera forward. Toast pojawia się tylko dla `failed`, nie dla
`ignored`; callback pin nadal działa wyłącznie po sukcesie. Testy Cubita i
realtime **17/17 PASS** (regresje outcome z R150); analyzer wskazanych 4 plików
PASS, formatowanie i `git diff --check` PASS. Nie uruchamiano widgetów. Odbiór
komunikatu błędu w aplikacji pozostaje otwarty.


## CHAT-R152 — pełny odbiór zdarzeń realtime Backend–Front (24.09.2026)

Porównanie literalnych nazw zdarzeń emitowanych przez `Application/Chat` z
subskrypcją/mapowaniem Flutter wykazało brak obsługi `chat.attachment.added`,
`chat.attachment.removed`, `chat.message.pinned/unpinned` oraz
`chat.conversation.updated/archived/restored`. Dodano subskrypcję i typowanie.
Zmiana załącznika odświeża snapshot wiadomości z API. Zdarzenie przypięcia
odświeża zbiór pinów w aktywnym panelu oraz w wątku pełnego ekranu/root sheeta
przez jawnie przekazany strumień z dzierżawy realtime. Aktualizacja lub
archiwizacja rozmowy ponownie pobiera autorytatywne metadane i aktualizuje stan;
403/401 odłącza scope. Wyjątkiem w audycie jest `chat.mentioned`, które jest
typem powiadomienia, nie eventem huba. Zestaw mappera/usługi/reducera/Cubitów
**46/46 PASS**, pełny `flutter analyze` 0 issues, formatowanie i
`git diff --check` PASS. Nie zmieniono kontraktu API, danych ani transportowych
enumów.
Ręczny odbiór synchronizacji kilku klientów pozostaje otwarty.


## CHAT-R153 — obsługa `chat.attachment_ready` (25.09.2026)

Pełny audyt 22 nazw zdarzeń emitowanych przez Chat i endpoint Storage wykazał
brak `chat.attachment_ready`, emitowanego po wyniku skanowania załącznika. Front wcześniej nie
subskrybował tej nazwy. Dodano ją do listy SignalR i mapowania jako zmianę
snapshotu wiadomości, aby renderer pobrał autorytatywne załączniki po
przetworzeniu pliku. Regresja mappera i live-subskrypcji jest częścią zestawu
**46/46 PASS**; analyzer zakresu i pełny `flutter analyze` (0 issues),
formatowanie oraz `git diff --check` PASS. Brak zmian Backend/API i transportowych
enumów. Pozostał ręczny odbiór uploadu/scanu na dwóch klientach.


### CHAT-R154 — zachowanie oryginału przy błędzie przygotowania długiego wklejenia (25.09.2026)

Przygotowanie pliku przez endpoint snippetów jest optymalizacją. Błąd API, wynik bez treści lub odpowiedź oznaczona jako skrócona przechodzi teraz na oryginalny tekst i ścieżkę uploadu Storage; nie wysyłamy pustego ani uciętego pliku. Dodano testy decyzji dla fallbacku, pustej/skróconej odpowiedzi oraz kompletnej odpowiedzi API. Testy logiki długiego wklejenia i cache polityki **14/14 PASS**; `flutter analyze` trzech dotkniętych plików bez uwag; `dart format` i `git diff --check` PASS. Zmiana Front-only: bez zmian endpointów, DTO, OpenAPI, enumów i Backend. Ręczny odbiór w aplikacji (wklejenie → przygotowanie/upload → wysłanie i pobranie TXT) pozostaje otwarty; widgetów/goldenów nie uruchamiano.


### CHAT-R155 — pusty string snippet-u także uruchamia fallback (25.09.2026)

Ponowny przegląd CHAT-R154 wykrył, że `content: ""` przechodziło jako poprawna odpowiedź, mimo że fallback obsługiwał `null` i truncation. Teraz pusty string również powoduje upload oryginalnego tekstu. Regresja rozszerza przypadek odpowiedzi null/pustej/skróconej. Testy długiego wklejenia i cache polityki **14/14 PASS**; analyzer trzech dotkniętych plików bez uwag; formatowanie i `git diff --check` PASS. Front-only, bez zmian kontraktu/API/enumów. Runtime nadal niezweryfikowany; aplikacja DevPlanner nie była uruchomiona.


### CHAT-R156 — widoczny błąd przy niekompletnej kompozycji wątku (25.09.2026)

Audyt C16 potwierdził jawne przekazanie wymaganych repozytoriów do rootowego side sheeta, ale wykazał cichy `return`, gdy któregokolwiek brakuje. Dodano lokalizowany komunikat błędu PL/EN przed wyjściem, aby kliknięcie „Otwórz wątek” nie wyglądało na martwe. `flutter gen-l10n`, analyzer czterech dotkniętych plików i `git diff --check` PASS. Brak zmian API/DTO/enumów/Backend. Testów widgetowych i runtime nie uruchamiano.


### CHAT-QA-R157 — statyczny przegląd kontraktu wyszukiwania Front–Backend (25.09.2026)

Przejrzano aktualny łańcuch wyszukiwania bez uruchamiania aplikacji: pole Front wysyła parametr `q`, adapter zachowuje limit/kursor i mapuje elementy odpowiedzi; Backend wiąże `q` do `ChatSearchQuery.Q`, filtruje dostępne rozmowy oraz wyszukuje w `ChatMessage.SearchText`, które domena przebudowuje przy utworzeniu i edycji. Nie znaleziono brakującego mapowania ani oczywistego rozjazdu requestu. To nie dowodzi działania w środowisku użytkownika: zgłoszenie „nic nie zwraca” nadal wymaga reprodukcji z rzeczywistym requestem/odpowiedzią i stanem indeksu. Tylko przegląd statyczny; bez zmian kodu, API, enumów i bez deklaracji wyników testów.


### CHAT-R158 — nie pokazuj wyszukiwarki bez repozytorium (25.09.2026)

Przegląd C15 ujawnił martwy przycisk w niepełnej kompozycji: `ChatPanelListPane` zawsze dostawał callback, który używał `context.read<ChatSearchCubit?>()?.open()`. Gdy `ChatSearchRepository` nie było dostępne, lupa pozostawała widoczna i kliknięcie nic nie robiło. Callback jest teraz null, jeśli Cubita/repozytorium brakuje, więc kontrolka jest ukryta przez istniejącą regułę widoku. Analyzer zmienionego pliku i `git diff --check` PASS. Zmiana Front-only; bez API, DTO i enumów. Nie uruchamiano testów widgetowych; zgłoszenie „brak wyników” dla dostępnej, działającej wyszukiwarki nadal wymaga reprodukcji runtime.


### CHAT-QA-R159 — ponowny pełny skan limitu plików Chat (25.09.2026)

Po ostatnich poprawkach wykonano ponownie skan wszystkich `*.dart` w `lib/workspaces/presentation/chat`; wynik: **0 plików powyżej 400 linii**. Bez zmian kodu.


### CHAT-QA-R160 — code review akcji załączników Storage i OnlyOffice (25.09.2026)

Sprawdzono akcje karty załącznika i pełny przepływ Front–Backend: zwykły zapis wywołuje endpoint kopiujący do prywatnego Storage; akcja „Zapisz i otwórz” pojawia się dla obsługiwanych typów Office, ale otwarcie wymaga `canEditOnline` z odpowiedzi zapisu i ponownie po `getFileDetails`. Backend ponownie sprawdza członkostwo rozmowy i relację pliku do nieusuniętej wiadomości; `ChatAttachmentPolicy` wymaga ResourceType `Comment`, stanu Ready oraz dozwolonego typu i limitów, a kopia ma zakres Private i właściciela bieżącego użytkownika. Zapis wymaga też statusu skanowania `Clean` i jest idempotentny dla użytkownika, wiadomości i pliku. W tym przeglądzie nie znaleziono błędu kodowego. Jest to code review, bez uruchamiania transferu lub runtime; weryfikacja zachowania w aplikacji nadal otwarta.


### CHAT-R161 — odśwież liczniki po udanym read ACK mimo zmiany trasy (25.09.2026)

C02 code review wykrył wyścig: ACK rozpoczęty przy widocznej wiadomości, ale zakończony po zmianie trasy/lifecycle, zwracał sukces serwera, po czym widget pomijał refresh inbox/global unread z powodu ponownego sprawdzenia widoczności. Widoczność jest teraz sprawdzana przed requestem, a po potwierdzonym ACK refresh wykonuje się, jeśli widget nadal jest zamontowany. Testy Cubita odczytu i historii **19/19 PASS**; analyzer pliku read-aware listy bez uwag; `git diff --check` PASS. Bez zmian Backend/API/DTO/enumów. Widget/runtime dwóch sesji pozostają do odbioru.


### CHAT-QA-R162 — ścieżka identyfikacji własnych wiadomości (25.09.2026)

Statycznie przejrzano panel rozmowy, pełny ekran, panel wątku, konstrukcję kolejki optimistic i grupowanie serii. Każda powierzchnia pobiera `userId` z `AuthSessionPort`; to samo ID trafia do `ChatMessageDeliveryQueue` i `ChatMessageGrouping` (porównanie z `authorUserId`), co steruje stroną dymka, kolorem i wyświetlaniem awatara/autora. Nie znaleziono statycznego rozjazdu. To nie weryfikuje rzeczywistej wartości profilu z API ani obrazu w aplikacji; zgłoszony wygląd własnych wiadomości pozostaje do reprodukcji runtime. Bez zmian kodu i bez testów/widgetów w tym przeglądzie.


### CHAT-R163 — odśwież miniaturę po przejściu załącznika do Ready (25.09.2026)

Code review C08 znalazło, że `_AttachmentCard.didUpdateWidget` odświeżało miniaturę wyłącznie po zmianie `storageFileId`. Jeśli realtime zmienił ten sam załącznik z Pending/unavailable na Clean/available, karta pozostawała bez obrazu. Reload obejmuje teraz zmianę `messageId`, `storageFileId`, `isAvailable` i `isImage`; każda zmiana unieważnia poprzednie Future i jego późny wynik. Analyzer pliku i `git diff --check` PASS; nie uruchamiano testów widgetowych zgodnie z dyspozycją przed akceptacją UI. Front-only; API, DTO i enumy bez zmian. Runtime upload → scan → miniatura nadal do odbioru.


### CHAT-R164 — trigger statusu czyści emoji po wygaśnięciu (25.09.2026)

C14 code review wykazał, że `ChatStatusMenuButton` odświeżał status przy montowaniu i otwarciu, lecz nie planował obsługi `expiresAtUtc`; otwarty przez długi czas panel mógł pokazywać wygasłe emoji/DND. Po odczycie i zapisie statusu Front planuje timer do wygaśnięcia, usuwa wygasły stan z triggera/formularza, toleruje długie terminy przez dobowe odświeżanie i anuluje timer przy zmianie konta oraz dispose. Analyzer pliku i `git diff --check` PASS. Nie uruchamiano widgetów ani runtime. Front-only; Backend/API/DTO/enumy bez zmian.


### CHAT-R165 — błędy otwierania załącznika nie blokują karty (25.09.2026)

Audyt wykazał, że implementacja stub dla platform bez transportu rzucała
UnsupportedError, a adapter otwierania nie chronił kontraktu wyniku; ponadto
karta i podgląd resetowały wskaźnik dopiero po await bez finally. Adapter
normalizuje nieoczekiwane wyjątki do stabilnego kodu błędu, oba widoki pokazują
lokalizowany komunikat i zawsze kończą ładowanie także po wyjątku lub dispose.
Dodano testy adaptera dla wyjątku transportu i repozytorium. `flutter analyze`
zakresu bez uwag, test adaptera **10/10 PASS**, `flutter gen-l10n` i
`git diff --check` PASS. Front-only; bez zmian Backend/API/DTO/enumów.
Nie uruchamiano widgetów ani aplikacji.


### CHAT-R166 — czytelniejsza czcionka bloków kodu (25.09.2026)

Code review potwierdził, że renderowanie już używało tokenizera Dart i palety
kolorów składni, ale rozmiar `fontSize: 8` był za mały do czytania.
Zmieniono rozmiar na 12, zachowując ciemne tło, monospace, przewijanie poziome
i istniejące kolory. Analyzer trzech plików highlightera bez uwag; testy
highlightera, RichTextCodec, CodeBlockCodec i Delta sanitizer **33/33 PASS**;
formatowanie i `git diff --check` PASS. Nie uruchamiano testu widgetowego ani
aplikacji; odbiór wizualny nadal otwarty.


### CHAT-QA-R167 — stan stagingu i próba kontroli macOS (25.09.2026)

Odczyt statusu przez zatwierdzony operator stagingu potwierdził obraz API
`d8527fabaaf98859ede403eba9ec2d6c017f7ae8`, kontener healthy oraz
readiness ready. Commit jest potomkiem wdrożenia CHAT-R91 dopuszczającego
`attributes.code`; logi błędu z 23.09 poprzedzają wdrożenie. Zbudowano i
uruchomiono jedną instancję macOS z bieżącego Frontu; ręczna kontrola widoku
była niemożliwa, bo systemowe okno autoryzacji zasłaniało aplikację. Nie
wprowadzano danych ani nie odblokowywano systemowego okna. Proces Flutter i
aplikacja zostały zakończone; kontrola procesów potwierdziła brak tej instancji.
Runtime Chat, pogrubienie/listy i załączniki nadal OPEN. Bez zmian kodu w tym
pakiecie.


### CHAT-QA-R168 — zbiorcza walidacja aktualnego Frontu (25.09.2026)

Po zmianach w naprawach Chat uruchomiono pełny `flutter analyze`:
0 issue. Jeden zbiorczy pakiet 12 zestawów jednostkowych logiki Chat zakończył
się **96/96 PASS**; obejmował read visibility, delivery queue, Cubity rozmowy
i wątku, formatowanie/Delta, code highlighter, długie wklejenie, statusy i
adapter załączników. Testów widgetowych/goldenów nie uruchamiano zgodnie z
ustaleniem przed akceptacją UI. Powtórny skan `presentation/chat/**/*.dart`:
0 plików powyżej 400 linii. `git diff --check` PASS. Runtime i odbiór wizualny
nadal OPEN.


### CHAT-QA-R169 — pełny code review Front + Backend (25.09.2026)

Utworzono raport `docs/global-chat-code-review-2026-09-25.md`. Znaleziono
usterkę współbieżnej wysyłki z tym samym `clientMessageId` (test PostgreSQL
wykrył nieobsłużone `40001`), przekroczenie limitu snippet-u po escape oraz
brak testu pełnego zestawu `ChatInvitationStatus`. Odnotowano też przekroczenie
limitu 400 linii w `ChatApi` i monolityczny `ChatService`. `flutter analyze`
PASS; wybrane testy Front **41/41 PASS**; testy Chat Backend **99 PASS / 1
FAIL**. Widgetów/goldenów i runtime nie uruchamiano. Naprawy opisano w raporcie,
nie zmieniano w tym pakiecie kodu aplikacji.


### CHAT-QA-R170 — naprawa ustaleń z code review (25.09.2026)

Backend: `ChatService.SendAsync` rozpoznaje opakowany SQLSTATE `40001` i
naruszenie unikalności tylko dla idempotentnego wyścigu; snippet wyszukiwarki
mieści się w limicie po escapowaniu i nie przecina emoji. Wybrane testy
PostgreSQL, wyszukiwania i OpenAPI **17/17 PASS**. Front: podzielono klienta
Retrofit na odpowiedzialności, pozostawiając `ChatApi` w limicie **386 linii**;
runtime współdzieli istniejący transport. Build_runner, `flutter analyze` bez
uwag oraz wybrane testy repozytoriów i enum wire **37/37 PASS**.
`ChatInvitationStatus` okazał się typem wewnętrznym, nie jest używany przez
żadną trasę HTTP; usunięto nieużywany model Front zamiast rozszerzać OpenAPI.
Otwarte pozostają osobne refaktoryzacje 1008-liniowego pliku DTO i backendowego
`ChatService` (1885 linii). Nie uruchamiano widgetów/goldenów, aplikacji ani
runtime stagingu.
