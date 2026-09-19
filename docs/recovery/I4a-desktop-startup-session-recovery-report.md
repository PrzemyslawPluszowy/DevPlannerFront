# I4a — odzyskanie startu desktopowej sesji

## Problem wykryty ręcznie

Uruchomienie aplikacji macOS kończyło się czarnym oknem. Log procesu wskazał
nieobsłużony `DioException` HTTP 400 podczas odtwarzania sesji PKCE przed
`runApp`. W konsekwencji korzeń Fluttera nie był montowany.

## Zmiana

- Transport PKCE interpretuje odpowiedź `400` albo `401` dla żądania
  `grant_type=refresh_token` jako odrzucony refresh token i zwraca brak
  sesji. Nie dotyczy to błędów sieci, TLS ani 5xx.
- Adapter desktopowy usuwa wtedy przestarzały token z macOS Keychain.
- Bootstrap zawsze montuje korzeń Fluttera. Niespodziewany błąd odtwarzania
  sesji jest raportowany diagnostycznie, ale użytkownik dostaje ekran
  logowania zamiast pustego okna.
- Dodano test adaptera potwierdzający skasowanie odrzuconego poświadczenia.

## Kryterium odbioru

Po wygaśnięciu albo wycofaniu refresh tokenu aplikacja ma pokazać ekran
logowania, a następny start nie może zatrzymać się przed `runApp`.
