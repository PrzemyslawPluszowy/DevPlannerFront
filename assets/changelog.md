## 2026-08-10 | v1.7.3+37 | hotfix

- Poprawiono pobieranie changeloga w kompilacji WebAssembly, usuwając użycie nieobsługiwanego webowo klienta `dart:io`.
- Changelog jest pobierany przez natywne Web API z pominięciem cache przeglądarki.

## 2026-08-10 | v1.7.2+36 | patch

- Naprawiono niezależne cache'owanie pliku changeloga w przeglądarkach: na Web jego aktualna treść jest teraz pobierana z wersjonowanym adresem przy każdym otwarciu.

## 2026-08-10 | v1.7.1+35 | patch

- Poprawiono mechanizm aktualizacji aplikacji webowej: pliki startowe nie są już utrwalane w cache przeglądarki, dzięki czemu kolejne wdrożenia pobierają aktualną wersję automatycznie.

## 2026-08-10 | v1.7.0+34 | release

- Dodano synchronizację jednego pulpitu użytkownika z Veloryn Core, dzięki czemu ustawienia są dostępne na wszystkich urządzeniach.
- Zachowano lokalny cache i obsługę pracy offline, a przy konflikcie rewizji aplikacja przyjmuje najnowszą wersję pulpitu z Core.
- Dodano bezpieczne wersjonowanie dokumentu pulpitu, walidację kontraktu oraz migrację istniejących lokalnych ustawień.

## 2026-08-07 | v1.6.0+33 | release

- Przeniesiono logowanie do centralnego Veloryn Core. Aplikacja uwierzytelnia użytkownika danymi Ready, a następnie korzysta z bezpiecznego tokenu JWT wspólnego dla modułów.
- Dodano automatyczne odświeżanie sesji oraz spójne wylogowanie po wygaśnięciu lub unieważnieniu dostępu.
- Dostęp do BHP i Inwentaryzacji jest teraz kontrolowany uprawnieniami Ready: `RNext-bhp` oraz `RNext-inwentaryzacja`.
- Ukryto niedostępne moduły, skróty i widżety pulpitu, aby użytkownik widział wyłącznie funkcje, do których ma przydzielone uprawnienia.
- Uporządkowano konfigurację adresów API dla środowiska produkcyjnego oraz dodano testy obsługi nowego formatu sesji i odświeżania tokenu.

## 2026-08-04 | v1.5.8+32 | release

- Poprawiono dashboard BHP: sekcja wydań zbliżających się do terminu pokazuje pełną listę pozycji zwróconych przez API bez frontendowego limitu.
- Pogrupowano nadchodzące wydania po pracowniku, pokazując kilka pozycji wyposażenia w jednym kafelku wraz z liczbą dni do terminu.
- Doprecyzowano liczniki w dashboardzie BHP i widżecie głównego pulpitu, aby rozróżniały liczbę osób oraz liczbę pozycji.
- Zaktualizowano kompaktowy widżet BHP na głównym pulpicie, zachowując zwarty układ kafelków.

## 2026-07-31 | v1.5.7+31 | release

- Ujednolicono orientację wszystkich raportów PDF do A4 poziomo, także protokołu kasacji i pakietu zbiorczego.
- Wymuszono A4 poziomo podczas drukowania i w podglądzie PDF oraz wyłączono dynamiczne przeformatowywanie dokumentów.
- Zaktualizowano zależności projektu do najnowszych kompatybilnych wersji, w tym `printing` do `5.15.0` i `pdf` do `3.13.0`.
- Dodano obsługę nowego typu timeoutu transformacji w Dio.

## 2026-07-27 | v1.5.6+30 | release

- Poprawiono raport kompensat: po zmianie osoby odpowiedzialnej widoczna jest aktualnie wskazana osoba.
- Uporządkowano komplet dokumentów PDF rosnąco według numeru ewidencyjnego oraz dodano końcową sekcję ze składem komisji i miejscem na akcept kierownika jednostki.

## 2026-07-06 | v1.5.5+29 | release

- Uporządkowano obsługę wydań BHP pracownika: ponowne wydanie wielu pozycji działa teraz z aktywnej listy, a nie z historii.
- Dodano wygodniejsze zaznaczanie pozycji do ponownego wydania oraz poprawiono podpowiedzi dla elementów po terminie.
- Usunięto problem z dublowaniem tych samych pozycji podczas zbiorczego ponownego wydania.
- Rozszerzono obsługę ekwiwalentu: można już edytować datę i kwotę oraz usuwać zapisany ekwiwalent.
- Poprawiono walidacje biznesowe przy ponownym wydaniu, aby nie tworzyć nowych wydań dla pracowników, którzy nie powinni już otrzymywać wyposażenia.

## 2026-07-03 | v1.5.4+28 | release

- Poprawiono moduł BHP w sekcji stanowisk: liczba pracowników przy stanowisku pokazuje już wyłącznie aktywnych i niearchiwalnych pracowników.
- Dodano klikalny licznik pracowników w tabeli stanowisk oraz boczny panel z listą aktywnych pracowników przypisanych do wybranego stanowiska.
- Dodano numerację porządkową w tabeli pracowników otwieranej z poziomu stanowiska.
- Poprawiono filtry stanowisk w sekcji pracowników: dropdown korzysta z aktywnego słownika stanowisk i pokazuje liczbę aktywnych pracowników przy każdej pozycji.

## 2026-07-03 | v1.5.3+27 | release

- Ujednolicono prezentację nazw pracowników w module BHP: pełne nazwy są teraz formatowane spójnie w stylu `Nazwisko, Imię` w modelach danych i widokach UI.
- Dodano obsługę flagi `kartaAktywna` w modelach BHP, dzięki czemu filtrowanie i prezentacja wyposażenia lepiej rozróżniają aktywne oraz nieaktywne karty.
- Zaktualizowano ekrany dashboardu, operacji, statystyk i modali wydań w BHP pod nowy sposób prezentacji pracowników oraz stanów wyposażenia.
- Doprecyzowano modele statystyk i brakującego wyposażenia oraz powiązane renderowanie tabel, sekcji i liczników.
- Poprawiono eksport PDF raportu inwentaryzacji oraz wspólne widgety tabel/sekcji używane przez nowe widoki.

## 2026-07-02 | v1.5.0+25 | release

- Dodano widok postępu drzewa inwentaryzacji z kompaktową listą nieukończonych węzłów oraz rozwijany panel boczny o regulowanej szerokości.
- Rozszerzono szczegóły inwentaryzacji o nowe modele i logikę API dla postępu drzewa oraz aktualizacji dat inwentaryzacji.
- Dodano testy dla modeli postępu drzewa i cubita aktualizacji dat inwentaryzacji.
- Dodano raportowanie błędów API do Sentry, w tym obsługiwanych wyjątków `DioException` bez odpowiedzi HTTP oraz błędów parsowania odpowiedzi.
- Uzupełniono kontekst diagnostyczny dla zgłoszeń Sentry i doprecyzowano dokumentację buildu Web/Windows pod poprawną symbolikację błędów.
- Uporządkowano lokalizacje inwentaryzacji: usunięto nieużywane klucze ARB i doprecyzowano tłumaczenie `Company` na `Branch`.

## 2026-07-01 | v1.4.4+24 | release

- Poprawiono podpowiedzi numeru ewidencyjnego w arkuszu: exact-match jest teraz promowany ponad prefiksowe trafienia, dzięki czemu rekordy typu `S83` nie znikają za wynikami `S830...`.
- Zachowano limit 50 pozycji w dropdownie, jednocześnie zwiększając odporność listy na kolejność zwracaną przez backend.
- Dodano wybór podpisów osób odpowiedzialnych przed drukiem lub pobraniem PDF arkusza.
- Pominięto dodatkowy modal podpisów, gdy arkusz nie ma osób odpowiedzialnych do sekcji podpisów.

## 2026-06-24 | v1.4.1+21 | release

- Dodano moduł BHP (zarządzanie kartotekami pracowników, stanowiskami, wydanym wyposażeniem oraz statystykami).
- Dodano ogólny, w pełni konfigurowalny pulpit (Dashboard) z obsługą widżetów.

## 2026-06-23 | v1.3.1+20 | release


- Dodano listę duplikatów numerów ewidencyjnych w `stan_st` wraz z osobnym modalem diagnostycznym.
- Dodano lokalne filtrowanie duplikatów po numerze ewidencyjnym oraz po zaznaczonych firmach, z aktualizacją liczników widocznych grup i rekordów.
- Dodano obsługę konfliktów nadwyżek dla inwentaryzacji (endpoint, modele, repository i modal UI).
- Dodano usuwanie pojedynczego rekordu `stan_st` z poziomu szczegółów środka trwałego, z backendowym potwierdzeniem numeru ewidencyjnego i nazwy.
- Poprawiono etykiety i lokalizacje `pl`/`en` dla duplikatów `stan_st`, usunięto mylące nazewnictwo związane z nadwyżkami oraz ujednolicono komunikaty kopiowania numeru ewidencyjnego.
- Poprawiono odświeżanie danych po usunięciu rekordu `stan_st`, aby lista duplikatów nie trzymała nieaktualnego cache.

## 2026-06-15 | v1.3.0 | release

- Dodano wyszukiwanie elementów we wszystkich arkuszach inwentaryzacji (nowy endpoint API + modal UI) z obsługą frazy, sortowania i grupowania wyników.
- Dodano listę konfliktów obecności dla inwentaryzacji (endpoint + modal) — możliwość podejrzenia i otwarcia pozycji w arkuszach oraz podświetlenia elementu.
- Dodano modele, repository i testy dla nowych endpointów; wygenerowano pliki serializacji (`*.g.dart`).
- Zaktualizowano lokalizacje (`pl`/`en`) oraz wprowadzono UI: modale wyszukiwania i konfliktów, inicjalne podświetlanie elementów i akcje "Pokaż w arkuszu" / "Otwórz arkusz".
- Drobne poprawki: parametry sortowania w zapytaniach, obsługa inicjalnego focusu elementu w liście arkusza.

## 2026-06-12 | v1.2.1 | release

- Dodano deduplikację par w raporcie `Kompensaty`, aby UI i PDF pokazywały jeden wiersz na parę brak/nadwyżka.
- Włączono sortowanie kolumn w tabeli raportów inwentaryzacji.
- Poprawiono wyszukiwanie w raporcie `Kompensaty`, aby obejmowało dane renderowane z pola `compensation`.

## 2026-06-09 | v1.2.0 | release

- Dodano druk PDF tylko dla aktualnie widocznych, odfiltrowanych pozycji arkusza.
- Dodano kolumnę `Lp.` w tabeli szczegółów arkusza.
- Rozszerzono podpowiedzi numeru ewidencyjnego o firmy objęte inwentaryzacją.

## 2026-05-26 | v1.0.9 | release

- dodano nowe opcje filtrowania dla statusu ST.

## 2026-05-22 | v1.0.8 | release

- W sekcji tworzenia arkusza wymuszono scope `node` (bez automatycznego `subtree`)
- Zaktualizowano komunikaty UI i lokalizacje pod nowe zachowanie scope.
- Uaktualniono testy `create_arkusz` pod nowe zasady scope (`node`).
- Dodano dependency `flutter_markdown` do renderowania changeloga.
