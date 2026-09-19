# R2z — regresja wertykalna aktywnego pionu Plików

Data: 2026-09-18  
Status: **PASS w testach automatycznych; live desktop/staging nadal wymagany**

## Zakres dowodu

Pion Storage nie jest placeholderem. W testach wertykalnych potwierdzono:

- tworzenie i zmianę nazwy folderu, z obsługą 403/404/409/422;
- upload przez rezerwację, transfer i `completeUpload`, w tym anulowanie oraz
  błędy każdego etapu;
- pobieranie desktopowe oraz brak niebezpiecznej akcji w kompozycji BFF/read-only;
- udostępnianie workspace/public link, ACL i błąd 403 bez fałszywego sukcesu;
- ukrycie wersjonowania, gdy ACL lub BFF/read-only nie dają prawa zarządzania;
- potwierdzone usuwanie/przywracanie folderu i pliku, wraz z brakiem żądania po
  anulowaniu oraz mapowaniem błędów 403/404/409/422.

## Wyniki

Potwierdzony końcowy przebieg:

```text
flutter test storage_versions_vertical_test.dart storage_delete_vertical_test.dart
13/13 PASS
```

Poprzedni pakiet verticalli przeszedł do testów wersjonowania po potwierdzeniu
folderów, uploadu, downloadu i sharingu; jego końcowy strumień terminala nie
został zachowany. Dlatego tylko powyższe **13/13** jest zapisem pełnego,
jednoznacznego wyniku z tej sesji. Nie jest to dowód połączenia z prawdziwym
MinIO ani Backendem: wymagany pozostaje scenariusz desktop/staging.
